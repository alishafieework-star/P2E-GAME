import 'dart:convert';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:p2e_design_system/design_system.dart'
    show BundledTypography, ElementIdentity;

import '../core/accessibility.dart';
import '../core/catalog.dart';
import '../core/device.dart';
import '../core/problems.dart';
import '../core/inspection.dart';
import '../core/performance.dart';
import '../core/report.dart';
import '../core/selection.dart';
import '../core/gorilla_stress.dart';
import '../core/sweep.dart';
import 'gorilla_panel.dart';
import 'device_toolbar.dart';
import 'summary.dart';
import 'tool_copy.dart';
export '../core/device.dart';

typedef HostAppBuilder = Widget Function(
  FrameSettings settings,
  GlobalKey appKey,
);

class InspectorHost extends StatefulWidget {
  const InspectorHost({
    super.key,
    required this.appBuilder,
    this.fill = false,
    this.controls,
    this.initialSettings = const FrameSettings(),
    this.device,
    this.scenarioCatalog,
    this.hostId = 'inspector',
    this.initialPanelWidth,
    this.inspectorLocale,
    this.sensorDriver,
  });
  final HostAppBuilder appBuilder;
  final bool fill;
  final Widget? controls;
  final FrameSettings initialSettings;
  final SimulatedDevice? device;
  final ScenarioCatalog? scenarioCatalog;
  final String hostId;
  final double? initialPanelWidth;
  final String? inspectorLocale;
  final InspectorSensorDriver? sensorDriver;
  @override
  State<InspectorHost> createState() => InspectorHostState();
}

class InspectorHostState extends State<InspectorHost>
    with SingleTickerProviderStateMixin {
  final appKey = GlobalKey(debugLabel: 'inspected-app');
  late final device = widget.device ?? SimulatedDevice(widget.initialSettings);
  FrameSettings get settings => device.settings;
  late final session = InspectionSession(
    appKey,
    requestedScale: widget.fill ? null : settings.scale,
  );
  late final problems = ProblemRecorder(session, device);
  late final accessibility = AccessibilityAuditor();
  late final performance = PerformanceMonitor(session);
  late final sweep = SweepRunner(
    device,
    problems,
    auditor: accessibility,
    performance: performance,
  );
  late final gorilla = GorillaStressRunner(
    appKey: appKey,
    device: device,
    session: session,
    recorder: problems,
    performance: performance,
    sensorDriver: widget.sensorDriver,
  );
  bool panelOpen = true;
  double zoom = 1;
  double? appPaneWidth;
  double lastTotalWidth = 1280;

  double get defaultPanelWidth =>
      widget.initialPanelWidth ??
      (widget.scenarioCatalog != null ? 760.0 : 380.0);

  double get panelWidth =>
      (lastTotalWidth -
              (appPaneWidth ?? (lastTotalWidth - defaultPanelWidth - 8)) -
              8)
          .roundToDouble();

  String get effectiveInspectorLocale =>
      widget.inspectorLocale ??
      (widget.hostId == 'product_host' || widget.scenarioCatalog != null
          ? 'fa'
          : 'en');

  late String inspectorLocale = effectiveInspectorLocale;

  late final TabController tabController = TabController(
    length: 7,
    vsync: this,
  );
  bool _wasSelecting = false;
  InspectionNode? _lastSelected;
  String appResult = '';

  void _onSessionChanged() {
    if ((session.selecting && !_wasSelecting) ||
        (session.selected != null && session.selected != _lastSelected)) {
      if (mounted && tabController.index != 1) {
        tabController.animateTo(1);
      }
    }
    _wasSelecting = session.selecting;
    _lastSelected = session.selected;
  }

  @override
  void initState() {
    super.initState();
    if (widget.fill && widget.device == null) device.mode = FrameMode.fitWindow;
    session.watchBuilds();
    session.addListener(_onSessionChanged);
    device.addListener(changed);
    problems.attach();
    accessibility.attach();
    performance.attach();
  }

  void changed() {
    if (mounted) {
      setState(
        () => session.requestedScale = widget.fill ? null : settings.scale,
      );
    }
  }

  @override
  void dispose() {
    session.removeListener(_onSessionChanged);
    tabController.dispose();
    device.removeListener(changed);
    problems.dispose();
    accessibility.dispose();
    performance.dispose();
    gorilla.dispose();
    sweep.dispose();
    session.dispose();
    if (widget.device == null) device.dispose();
    super.dispose();
  }

  void update(FrameSettings value) => device.apply(value);
  Future<void> frame() async {
    WidgetsBinding.instance.scheduleFrame();
    await WidgetsBinding.instance.endOfFrame;
  }

  void chooseKey(String? key) {
    session.scan();
    final n = session.tree.where((n) => n.key == key).firstOrNull;
    if (n != null) session.choose(n);
  }

  void jump(InspectionProblem p) {
    update(p.device);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      chooseKey(p.ownerKey);
      if (mounted && tabController.index != 1) {
        tabController.animateTo(1);
      }
    });
  }

  Future<void> replay(FrameSettings settings, String? scenarioId) async {
    if (scenarioId != null) await widget.scenarioCatalog?.activate(scenarioId);
    update(settings);
    WidgetsBinding.instance.addPostFrameCallback((_) => setState(() {}));
  }

  String reportBundle() => exportReportBundle(
    buildReportBundle(
      host: widget.hostId,
      sweep: sweep,
      accessibility: accessibility,
      performance: performance,
      scenarioId: widget.scenarioCatalog?.activeId,
    ),
  );

  Set<String> _touchOwners() => {
    for (final problem in problems.problems)
      if (problem.kind == 'touch-target-below-minimum' &&
          problem.ownerKey != null)
        problem.ownerKey!,
  };

  Future<void> auditCurrent() async {
    accessibility.sample(
      appKey.currentContext as Element?,
      settings,
      scenarioId: widget.scenarioCatalog?.activeId,
      suppressedOwners: _touchOwners(),
    );
  }

  Future<void> auditAll() async {
    final catalog = widget.scenarioCatalog;
    if (catalog == null) {
      await auditCurrent();
      return;
    }
    for (final scenario in catalog.scenarios) {
      await catalog.activate(scenario.id);
      await frame();
      accessibility.sample(
        appKey.currentContext as Element?,
        settings,
        scenarioId: scenario.id,
        suppressedOwners: _touchOwners(),
      );
    }
  }

  void readResult() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      BuildContext? resolved;
      void visit(Element e) {
        if (resolved != null) return;
        if ((e.widget is ElementIdentity || e.widget is Scaffold) &&
            Localizations.maybeLocaleOf(e) != null) {
          resolved = e;
        }
        e.visitChildren(visit);
      }

      (appKey.currentContext as Element?)?.visitChildren(visit);
      final c = resolved;
      if (c != null) {
        final value = toolCopy(
          'resultValue',
          arguments: {
            'locale':
                Localizations.maybeLocaleOf(c)?.toLanguageTag() ??
                toolCopy('unavailable'),
            'direction': Directionality.of(c).name,
            'brightness': Theme.of(c).brightness.name,
            'device': settings.scale.toStringAsFixed(2),
            'effective': MediaQuery.textScalerOf(c).scale(16) / 16,
            'sizeClass': settings.sizeClass,
          },
        );
        if (value != appResult) setState(() => appResult = value);
      }
    });
  }

  Widget surface() {
    readResult();
    return ListenableBuilder(
      listenable: session,
      child: widget.appBuilder(settings, appKey),
      builder: (context, child) => Stack(
        fit: StackFit.expand,
        children: [
          child!,
          if (session.selecting)
            Positioned.fill(
              child: ExcludeSemantics(
                child: MouseRegion(
                  opaque: true,
                  child: Listener(
                    behavior: HitTestBehavior.opaque,
                    onPointerDown: (e) => session.pick(e.localPosition),
                    child: const ColoredBox(color: Colors.transparent),
                  ),
                ),
              ),
            ),
          Positioned.fill(
            child: IgnorePointer(
              child: ExcludeSemantics(
                child: CustomPaint(
                  painter: _Highlight(session.selected, session.snapshot),
                ),
              ),
            ),
          ),
          ListenableBuilder(
            listenable: gorilla,
            builder: (context, _) {
              final tap = gorilla.lastDispatchedTapLocal;
              if (!gorilla.running || tap == null) {
                return const SizedBox.shrink();
              }
              return Positioned(
                left: tap.dx,
                top: tap.dy,
                child: IgnorePointer(
                  child: _TapRippleIndicator(
                    key: ValueKey(gorilla.dispatchedEvents),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget viewport() => LayoutBuilder(
    builder: (context, c) {
      final available = Size(
        math.max(1, c.maxWidth - 40),
        math.max(1, c.maxHeight - 42),
      );
      if (device.mode == FrameMode.fitWindow) {
        final size = Size(
          available.width.clamp(200, 1400),
          available.height.clamp(300, 1400),
        );
        if (settings.size != size) {
          // Resolve the frame before mounting/layout, avoiding a transient old
          // narrow frame and spurious initial problems in Fit window mode.
          device.settings = settings.copyWith(size: size);
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted && device.mode == FrameMode.fitWindow) {
              device.apply(device.settings);
            }
          });
        }
      }
      zoom = device.zoomFor(available);
      final content = SizedBox(
        width: settings.size.width,
        height: settings.size.height,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Positioned.fill(child: surface()),
            Positioned.fill(
              child: IgnorePointer(child: CustomPaint(painter: _FrameGuides())),
            ),
            // PHYSICAL: handles track physical simulated-device display edges.
            Positioned(
              right: 0,
              top: 0,
              bottom: 0,
              width: 12,
              child: GestureDetector(
                key: const ValueKey('resize-width'),
                behavior: HitTestBehavior.opaque,
                onPanUpdate: (e) => device.resize(
                  settings.size.width + e.delta.dx,
                  settings.size.height,
                ),
                child: const MouseRegion(
                  cursor: SystemMouseCursors.resizeLeftRight,
                ),
              ),
            ),
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              height: 12,
              child: GestureDetector(
                key: const ValueKey('resize-height'),
                behavior: HitTestBehavior.opaque,
                onPanUpdate: (e) => device.resize(
                  settings.size.width,
                  settings.size.height + e.delta.dy,
                ),
                child: const MouseRegion(
                  cursor: SystemMouseCursors.resizeUpDown,
                ),
              ),
            ),
            Positioned(
              right: 0,
              bottom: 0,
              width: 20,
              height: 20,
              child: GestureDetector(
                key: const ValueKey('resize-both'),
                behavior: HitTestBehavior.opaque,
                onPanUpdate: (e) => device.resize(
                  settings.size.width + e.delta.dx,
                  settings.size.height + e.delta.dy,
                ),
                child: const ColoredBox(color: Colors.teal),
              ),
            ),
          ],
        ),
      );
      final scaled = SizedBox(
        width: settings.size.width * zoom + 16,
        height: settings.size.height * zoom + 16,
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: OverflowBox(
            alignment: Alignment.topLeft,
            minWidth: settings.size.width,
            maxWidth: settings.size.width,
            minHeight: settings.size.height,
            maxHeight: settings.size.height,
            child: Transform.scale(
              scale: zoom,
              alignment: Alignment.topLeft,
              child: content,
            ),
          ),
        ),
      );
      return ColoredBox(
        color: Colors.blueGrey.shade900,
        child: LayoutBuilder(
          builder: (context, box) => SingleChildScrollView(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minWidth: box.maxWidth,
                  minHeight: box.maxHeight,
                ),
                child: Center(child: scaled),
              ),
            ),
          ),
        ),
      );
    },
  );

  /// Host-window pixels of the simulated page. The simulated app itself
  /// reports a pixel ratio of 1; this uses the inspector window's ratio.
  String pageSizeLabel(BuildContext context) {
    final ratio = MediaQuery.devicePixelRatioOf(context);
    final width = settings.size.width, height = settings.size.height;
    final dpi = ratio * 96;
    return toolCopy(
      'pageSizeReadout',
      arguments: {
        'width': width.toStringAsFixed(0),
        'height': height.toStringAsFixed(0),
        'physicalWidth': (width * ratio).toStringAsFixed(0),
        'physicalHeight': (height * ratio).toStringAsFixed(0),
        'dpi': dpi.toStringAsFixed(0),
        'zoom': (zoom * 100).toStringAsFixed(0),
      },
    );
  }

  Widget _buildScenarioBar() {
    final catalog = widget.scenarioCatalog;
    if (catalog == null || catalog.scenarios.isEmpty) {
      return const SizedBox.shrink();
    }
    final sectionIds = <String>[];
    for (final scenario in catalog.scenarios) {
      if (!sectionIds.contains(scenario.sectionId)) {
        sectionIds.add(scenario.sectionId);
      }
    }
    final active = catalog.scenarios
        .where((scenario) => scenario.id == catalog.activeId)
        .firstOrNull;
    final sectionId = active?.sectionId ?? sectionIds.first;
    final states = [
      for (final scenario in catalog.scenarios)
        if (scenario.sectionId == sectionId) scenario,
    ];
    return Container(
      padding: const EdgeInsetsDirectional.fromSTEB(12, 6, 12, 6),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.white12, width: 1)),
      ),
      child: Column(
        children: [
          _scenarioMenu(
            label: toolCopy('scenarioSection'),
            menuKey: const ValueKey('scenario-section'),
            value: sectionId,
            entries: [for (final id in sectionIds) (id, _sectionLabel(id))],
            onChanged: (id) {
              if (id == null || id == sectionId) return;
              final first = catalog.scenarios.firstWhere(
                (scenario) => scenario.sectionId == id,
              );
              catalog.activate(first.id);
            },
          ),
          _scenarioMenu(
            label: toolCopy('scenarioState'),
            menuKey: const ValueKey('scenario'),
            value: states.any((scenario) => scenario.id == catalog.activeId)
                ? catalog.activeId
                : states.first.id,
            entries: [
              for (final scenario in states)
                (scenario.id, _stateLabel(scenario.label)),
            ],
            onChanged: (id) {
              if (id != null) catalog.activate(id);
            },
          ),
        ],
      ),
    );
  }

  Widget _scenarioMenu({
    required String label,
    required Key menuKey,
    required String? value,
    required List<(String, String)> entries,
    required ValueChanged<String?> onChanged,
  }) => Row(
    children: [
      SizedBox(
        width: 72,
        child: Text(
          label,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
        ),
      ),
      Expanded(
        child: DropdownButton<String>(
          key: menuKey,
          isExpanded: true,
          isDense: true,
          underline: const SizedBox.shrink(),
          value: value,
          items: [
            for (final entry in entries)
              DropdownMenuItem(
                value: entry.$1,
                child: Text(
                  entry.$2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 12),
                ),
              ),
          ],
          onChanged: onChanged,
        ),
      ),
    ],
  );

  String _sectionLabel(String id) => toolCopy(switch (id) {
    'startup' => 'sectionStartup',
    'onboarding' => 'sectionOnboarding',
    'auth' => 'sectionAuth',
    'home' => 'sectionHome',
    'missions' => 'sectionMissions',
    'games' => 'sectionGames',
    'leaderboard' => 'sectionLeaderboard',
    'shop' => 'sectionShop',
    'legal' => 'sectionLegal',
    'designSystem' => 'sectionDesignSystem',
    _ => throw ArgumentError.value(id, 'sectionId'),
  });

  String _stateLabel(String label) {
    final mark = label.indexOf('] ');
    return mark == -1 ? label : label.substring(mark + 2);
  }

  Widget _buildDevicePanel(BuildContext context) => SingleChildScrollView(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _InspectorSection(
          title: toolCopy('pageSection'),
          child: Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(12, 0, 12, 8),
            child: Text(
              pageSizeLabel(context),
              key: const ValueKey('frame-readout'),
            ),
          ),
        ),
        _InspectorSection(
          title: toolCopy('deviceGroup'),
          child: Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(12, 0, 12, 8),
            child: DeviceToolbar(device: device),
          ),
        ),
        Padding(
          padding: const EdgeInsetsDirectional.fromSTEB(12, 8, 12, 12),
          child: Text(
            '${toolCopy('appResult')}: $appResult',
            key: const ValueKey('app-result'),
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ),
      ],
    ),
  );

  Widget _buildProblemsPanel() => ListenableBuilder(
    listenable: problems,
    builder: (context, _) => ListView(
      children: [
        Row(
          children: [
            IconButton(
              key: const ValueKey('copy-problems'),
              tooltip: toolCopy('copyProblems'),
              onPressed: () => Clipboard.setData(
                ClipboardData(text: problemReport(problems.problems)),
              ),
              icon: const Icon(Icons.content_copy),
            ),
            IconButton(
              tooltip: toolCopy('clear'),
              onPressed: sweep.running ? null : problems.clear,
              icon: const Icon(Icons.delete_outline),
            ),
          ],
        ),
        for (final p in problems.problems)
          ListTile(
            title: Text(p.summary),
            subtitle: Text(
              '${p.kind} / ${p.elementId ?? toolCopy('unavailable')} / ${p.device.size}',
            ),
            onTap: () => jump(p),
          ),
      ],
    ),
  );

  Widget panel(BuildContext context) => TabBarView(
    controller: tabController,
    children: [
      _buildDevicePanel(context),
      InspectionPanel(session: session),
      _buildProblemsPanel(),
      SweepControls(
        device: device,
        runner: sweep,
        frame: frame,
        catalog: widget.scenarioCatalog,
        bundle: reportBundle,
        onReplay: replay,
        onJump: (r) {
          update(
            FrameSettings.fromJson(r['device'] as Map)
                .copyWith(testSkin: settings.testSkin),
          );
          final owner = r['ownerKey'];
          WidgetsBinding.instance.addPostFrameCallback(
            (_) => chooseKey(owner == null ? null : jsonEncode(owner)),
          );
        },
      ),
      GorillaStressPanel(runner: gorilla),
      _AccessibilityPanel(host: this),
      _PerformancePanel(host: this),
    ],
  );
  @override
  Widget build(BuildContext context) {
    activeToolLocale = inspectorLocale;
    return MaterialApp(
      title: inspectorBuildMarker,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        useMaterial3: true,
        fontFamily: BundledTypography.outfitFamily,
        fontFamilyFallback: BundledTypography.persianFallback,
      ),
      home: CallbackShortcuts(
        bindings: {
          const SingleActivator(LogicalKeyboardKey.escape): () =>
              session.setSelecting(false),
        },
        child: Focus(
          autofocus: true,
          child: Scaffold(
            appBar: AppBar(
              title: Text(toolCopy('inspectionTitle')),
              actions: [
                ListenableBuilder(
                  listenable: session,
                  builder: (context, _) => IconButton(
                    key: const ValueKey('select-mode'),
                    tooltip: session.selecting
                        ? toolCopy('exitSelect')
                        : toolCopy('select'),
                    onPressed: () => session.setSelecting(!session.selecting),
                    isSelected: session.selecting,
                    icon: Icon(
                      session.selecting ? Icons.highlight_alt : Icons.near_me,
                    ),
                  ),
                ),
                IconButton(
                  key: const ValueKey('toggle-panel'),
                  tooltip: toolCopy('panel'),
                  onPressed: () => setState(() => panelOpen = !panelOpen),
                  icon: const Icon(Icons.view_sidebar),
                ),
                TextButton(
                  key: const ValueKey('toggle-inspector-locale'),
                  onPressed: () => setState(() {
                    inspectorLocale = inspectorLocale == 'fa' ? 'en' : 'fa';
                    activeToolLocale = inspectorLocale;
                  }),
                  child: Text(
                    inspectorLocale == 'fa' ? 'EN' : 'فا',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                ?widget.controls,
              ],
            ),
            body: LayoutBuilder(
              builder: (context, constraints) {
                final total = constraints.maxWidth;
                lastTotalWidth = total;
                final pane = (appPaneWidth ?? (total - defaultPanelWidth - 8.0))
                    .clamp(360.0, math.max(360.0, total - 320.0))
                    .toDouble();
                return Row(
                  textDirection: TextDirection.ltr,
                  children: [
                    // PHYSICAL: the app pane stays on the physical left.
                    SizedBox(
                      width: panelOpen ? pane : total,
                      child: viewport(),
                    ),
                    if (panelOpen)
                      GestureDetector(
                        key: const ValueKey('resize-panel'),
                        onPanUpdate: (e) => setState(
                          () => appPaneWidth = (pane + e.delta.dx)
                              .clamp(360.0, math.max(360.0, total - 320.0))
                              .toDouble(),
                        ),
                        child: const MouseRegion(
                          cursor: SystemMouseCursors.resizeColumn,
                          child: SizedBox(
                            width: 8,
                            child: ColoredBox(color: Colors.teal),
                          ),
                        ),
                      ),
                    if (panelOpen)
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            if (widget.scenarioCatalog != null)
                              _buildScenarioBar(),
                            TabBar(
                              controller: tabController,
                              isScrollable: true,
                              tabAlignment: TabAlignment.start,
                              tabs: [
                                Tab(text: toolCopy('deviceTab')),
                                Tab(text: toolCopy('inspectTab')),
                                Tab(text: toolCopy('problemsTab')),
                                Tab(text: toolCopy('sweepTab')),
                                Tab(text: toolCopy('gorillaTab')),
                                Tab(text: toolCopy('accessibilityTab')),
                                Tab(text: toolCopy('performanceTab')),
                              ],
                            ),
                            const Divider(height: 1),
                            Expanded(child: panel(context)),
                          ],
                        ),
                      ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

class InspectionPanel extends StatelessWidget {
  const InspectionPanel({super.key, required this.session});
  final InspectionSession session;
  @override
  Widget build(BuildContext context) => Material(
    child: ListenableBuilder(
      listenable: session,
      builder: (context, _) {
        final selected = session.selected;
        final mounted = selected != null && selected.element.mounted;
        final snapshot = !mounted
            ? null
            : session.snapshot ??
                  selected.capture(requestedScale: session.requestedScale);
        final summary = snapshot == null ? null : comparisonSummary(snapshot);
        return SingleChildScrollView(
          padding: const EdgeInsetsDirectional.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  IconButton(
                    tooltip: toolCopy('treeRefresh'),
                    onPressed: session.refreshTree,
                    icon: const Icon(Icons.refresh),
                  ),
                  if (session.selected?.owner != null)
                    IconButton(
                      tooltip: toolCopy('parentOwner'),
                      onPressed: () => session.choose(session.selected!.owner!),
                      icon: const Icon(Icons.arrow_upward),
                    ),
                  if (session.selected?.figmaUrl != null)
                    IconButton(
                      tooltip: toolCopy('copyFigma'),
                      onPressed: () => Clipboard.setData(
                        ClipboardData(text: session.selected!.figmaUrl!),
                      ),
                      icon: const Icon(Icons.link),
                    ),
                  IconButton(
                    key: const ValueKey('copy-json'),
                    tooltip: toolCopy('copyJson'),
                    onPressed: snapshot == null
                        ? null
                        : () => Clipboard.setData(
                            ClipboardData(text: exportSnapshot(snapshot)),
                          ),
                    icon: const Icon(Icons.data_object),
                  ),
                ],
              ),
              if (mounted)
                _SelectedIdentity(
                  identity: selected.identity,
                  unavailable: toolCopy('unavailable'),
                ),
              if (session.notice != null) Text(session.notice!),
              if (summary != null) _ComparisonView(summary: summary),
              Text(
                toolCopy(
                  'mountedSummary',
                  arguments: {
                    'count': session.tree.length,
                    'traversals': session.traversals,
                  },
                ),
              ),
              Text(
                toolCopy(
                  'rebuildSummary',
                  arguments: {
                    'builds': session.buildSignals,
                    'refreshes': session.refreshes,
                  },
                ),
              ),
              if (session.candidates.length > 1) Text(toolCopy('candidates')),
              for (final n in session.candidates)
                TextButton(
                  onPressed: () => session.choose(n),
                  child: Text(
                    '${n.identity.componentId} / ${n.identity.runtimeLocator?.slotPath ?? toolCopy('owner')}',
                  ),
                ),
              for (final n in session.tree)
                TextButton(
                  key: n.key == session.selected?.key
                      ? const ValueKey('selected-tree-row')
                      : null,
                  style: n.key == session.selected?.key
                      ? TextButton.styleFrom(
                          backgroundColor: Colors.teal.withValues(alpha: .24),
                        )
                      : null,
                  onPressed: () => session.choose(n),
                  child: Text(
                    '${n.identity.elementId} ${n.identity.runtimeLocator?.slotPath ?? ''}${n.visible ? '' : toolCopy('offstage')}',
                  ),
                ),
              Text(
                toolCopy(
                  'colorNote',
                  arguments: {'tolerance': metricTolerance},
                ),
              ),
              if (snapshot != null)
                ExpansionTile(
                  title: Text(toolCopy('jsonSection')),
                  children: [
                    SelectableText(
                      const JsonEncoder.withIndent('  ').convert(snapshot),
                      style: const TextStyle(
                        fontFamily: BundledTypography.outfitFamily,
                        fontFamilyFallback: BundledTypography.persianFallback,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
            ],
          ),
        );
      },
    ),
  );
}

class _SelectedIdentity extends StatelessWidget {
  const _SelectedIdentity({required this.identity, required this.unavailable});
  final ElementIdentity identity;
  final String unavailable;

  @override
  Widget build(BuildContext context) {
    final idStyle = TextStyle(
      fontFamily: BundledTypography.outfitFamily,
      fontFamilyFallback: BundledTypography.persianFallback,
      fontWeight: FontWeight.w700,
      fontSize: 18,
      height: 1.2,
    );
    return Container(
      key: const ValueKey('selected-identity'),
      margin: const EdgeInsetsDirectional.only(bottom: 8),
      padding: const EdgeInsetsDirectional.fromSTEB(12, 10, 8, 10),
      decoration: BoxDecoration(
        color: Colors.teal.withValues(alpha: .22),
        border: Border.all(color: Colors.tealAccent, width: 2),
        borderRadius: const BorderRadius.all(Radius.circular(8)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            identity.elementId,
            key: const ValueKey('identity-element'),
            style: idStyle,
          ),
          Text(
            identity.componentId,
            key: const ValueKey('identity-component'),
            style: idStyle.copyWith(fontSize: 14, color: Colors.tealAccent),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: [
              for (final variant in identity.variants.entries)
                Chip(
                  visualDensity: VisualDensity.compact,
                  label: Text(
                    '${variant.key}: ${variant.value}',
                    style: const TextStyle(fontWeight: FontWeight.w700),
                  ),
                ),
              if (identity.rawVariantName.isNotEmpty)
                Chip(
                  key: const ValueKey('identity-variant'),
                  visualDensity: VisualDensity.compact,
                  label: Text(
                    identity.rawVariantName,
                    style: const TextStyle(fontWeight: FontWeight.w700),
                  ),
                ),
            ],
          ),
          _IdentityLine(
            id: 'identity-node',
            label: toolCopy('identityNode'),
            value: identity.variantId ?? unavailable,
          ),
          _IdentityLine(
            id: 'identity-set',
            label: toolCopy('identitySet'),
            value: identity.componentSetId ?? unavailable,
          ),
        ],
      ),
    );
  }
}

class _IdentityLine extends StatelessWidget {
  const _IdentityLine({
    required this.id,
    required this.label,
    required this.value,
  });
  final String id, label, value;

  @override
  Widget build(BuildContext context) => Row(
    children: [
      Expanded(
        child: Text.rich(
          TextSpan(
            children: [
              TextSpan(text: '$label  '),
              TextSpan(
                text: value,
                style: const TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 15,
                ),
              ),
            ],
          ),
          key: ValueKey(id),
        ),
      ),
      IconButton(
        key: ValueKey('copy-$id'),
        tooltip: toolCopy('copyJson'),
        onPressed: () => Clipboard.setData(ClipboardData(text: value)),
        icon: const Icon(Icons.copy, size: 16),
      ),
    ],
  );
}

class _ComparisonView extends StatelessWidget {
  const _ComparisonView({required this.summary});
  final ComparisonSummary summary;

  @override
  Widget build(BuildContext context) {
    final title = Theme.of(context).textTheme.titleSmall;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(summary.componentId, style: title),
        Text('${summary.elementId} · ${summary.status}'),
        Text(
          '${summary.differs} differs · ${summary.matches} match',
          key: const ValueKey('comparison-counts'),
        ),
        const SizedBox(height: 8),
        for (final row in summary.rows) ...[
          Text('${row.axis} · ${row.status}'),
          Text('source ${row.source}'),
          Text('measured ${row.measured}'),
          if (row.reason != null)
            Text(row.reason!, style: Theme.of(context).textTheme.bodySmall),
          const SizedBox(height: 6),
        ],
        const Divider(),
      ],
    );
  }
}

class _InspectorSection extends StatelessWidget {
  const _InspectorSection({required this.title, required this.child});
  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      Padding(
        padding: const EdgeInsetsDirectional.fromSTEB(12, 8, 12, 4),
        child: Text(title, style: Theme.of(context).textTheme.titleSmall),
      ),
      child,
      const Divider(height: 1),
    ],
  );
}

class _AccessibilityPanel extends StatelessWidget {
  const _AccessibilityPanel({required this.host});
  final InspectorHostState host;
  @override
  Widget build(BuildContext context) => ListenableBuilder(
    listenable: host.accessibility,
    builder: (context, _) => ListView(
      padding: const EdgeInsetsDirectional.all(12),
      children: [
        Text(toolCopy('a11yNote')),
        Wrap(
          spacing: 8,
          children: [
            TextButton(
              key: const ValueKey('audit-current'),
              onPressed: host.auditCurrent,
              child: Text(toolCopy('auditCurrent')),
            ),
            TextButton(
              key: const ValueKey('audit-all'),
              onPressed: host.widget.scenarioCatalog == null
                  ? null
                  : host.auditAll,
              child: Text(toolCopy('auditAll')),
            ),
            TextButton(
              key: const ValueKey('copy-audit'),
              onPressed: () => Clipboard.setData(
                ClipboardData(
                  text: const JsonEncoder.withIndent('  ')
                      .convert(host.accessibility.toJson()),
                ),
              ),
              child: Text(toolCopy('copyAudit')),
            ),
            TextButton(
              onPressed: host.accessibility.clear,
              child: Text(toolCopy('clear')),
            ),
          ],
        ),
        for (final finding in host.accessibility.findings)
          ListTile(
            title: Text(finding.summary),
            subtitle: Text(
              '${finding.kind} / ${finding.elementId ?? toolCopy('unavailable')}',
            ),
            onTap: () => host.jump(
              InspectionProblem(
                finding.kind,
                finding.summary,
                finding.ownerKey,
                finding.elementId,
                finding.device,
              ),
            ),
          ),
      ],
    ),
  );
}

class _PerformancePanel extends StatelessWidget {
  const _PerformancePanel({required this.host});
  final InspectorHostState host;
  @override
  Widget build(BuildContext context) => ListenableBuilder(
    listenable: host.performance,
    builder: (context, _) {
      final report = host.performance.toJson();
      return ListView(
        padding: const EdgeInsetsDirectional.all(12),
        children: [
          Text(toolCopy('perfNote')),
          Text(
            '${toolCopy('slowFrames')}: ${report['slowFrames']} / ${report['sampledFrames']}',
            key: const ValueKey('slow-frames'),
          ),
          Text(
            toolCopy(
              'rebuildSummary',
              arguments: {
                'builds': '${report['rebuildDelta']}',
                'refreshes': '${report['refreshDelta']}',
              },
            ),
          ),
          TextButton(
            key: const ValueKey('copy-performance'),
            onPressed: () => Clipboard.setData(
              ClipboardData(
                text: const JsonEncoder.withIndent('  ').convert(report),
              ),
            ),
            child: Text(toolCopy('copyBundle')),
          ),
        ],
      );
    },
  );
}

class _Highlight extends CustomPainter {
  _Highlight(this.node, this.snapshot);
  final InspectionNode? node;
  final Map<String, Object?>? snapshot;
  @override
  void paint(Canvas canvas, Size size) {
    if (node == null || !node!.visible) return;
    canvas.drawRect(
      node!.clipBounds,
      Paint()
        ..color = Colors.cyan
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2,
    );
    final resolved = snapshot?['resolved'] as Map?;
    final hit =
        ((resolved?['inspectionActual'] as Map?)?['value']
                as Map?)?['hitRegionInApp']
            as Map?;
    if (hit != null) {
      canvas.drawRect(
        Rect.fromLTWH(
          (hit['x'] as num).toDouble(),
          (hit['y'] as num).toDouble(),
          (hit['width'] as num).toDouble(),
          (hit['height'] as num).toDouble(),
        ),
        Paint()
          ..color = Colors.amber
          ..style = PaintingStyle.stroke,
      );
    }
  }

  @override
  bool shouldRepaint(_Highlight oldDelegate) =>
      oldDelegate.node != node || oldDelegate.snapshot != snapshot;
}

// PHYSICAL: ruler and cap guides use simulated display coordinates.
class _FrameGuides extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final p = Paint()
      ..color = Colors.white54
      ..style = PaintingStyle.stroke;
    canvas.drawRect(Offset.zero & size, p);
    for (final x in [252.0, 600.0, 840.0]) {
      if (x > size.width) continue;
      canvas.drawLine(Offset(x, 0), Offset(x, 12), p..color = Colors.white54);
      final text = TextPainter(
        text: TextSpan(
          text: x.toInt().toString(),
          style: const TextStyle(color: Colors.white70, fontSize: 10),
        ),
        textDirection: TextDirection.ltr,
      )..layout();
      text.paint(canvas, Offset(x - 24, 2));
    }
    if (size.width >= 600) {
      canvas.drawRect(
        Rect.fromLTWH((size.width - 600) / 2, 0, 600, size.height),
        Paint()
          ..color = Colors.white12
          ..style = PaintingStyle.stroke,
      );
    }
  }

  @override
  bool shouldRepaint(_FrameGuides oldDelegate) => false;
}

class _TapRippleIndicator extends StatelessWidget {
  const _TapRippleIndicator({super.key});

  @override
  Widget build(BuildContext context) => TweenAnimationBuilder<double>(
    tween: Tween(begin: 0.0, end: 1.0),
    duration: const Duration(milliseconds: 320),
    builder: (context, value, child) {
      final size = 16.0 + value * 34.0;
      final opacity = (1.0 - value).clamp(0.0, 1.0);
      return Transform.translate(
        offset: Offset(-size / 2, -size / 2),
        child: Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: Colors.cyanAccent.withValues(alpha: opacity),
              width: 2.5,
            ),
            color: Colors.cyanAccent.withValues(alpha: opacity * 0.35),
          ),
        ),
      );
    },
  );
}
