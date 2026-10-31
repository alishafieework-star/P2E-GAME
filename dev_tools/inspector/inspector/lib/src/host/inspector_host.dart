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
import '../core/sweep.dart';
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
  });
  final HostAppBuilder appBuilder;
  final bool fill;
  final Widget? controls;
  final FrameSettings initialSettings;
  final SimulatedDevice? device;
  final ScenarioCatalog? scenarioCatalog;
  final String hostId;
  @override
  State<InspectorHost> createState() => InspectorHostState();
}

class InspectorHostState extends State<InspectorHost> {
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
  bool panelOpen = true;
  double zoom = 1;

  /// Width of the left pane, which shows only the hosted app. Null uses 62%.
  double? appPaneWidth;
  String appResult = '';
  @override
  void initState() {
    super.initState();
    if (widget.fill && widget.device == null) device.mode = FrameMode.fitWindow;
    session.watchBuilds();
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
    device.removeListener(changed);
    problems.dispose();
    accessibility.dispose();
    performance.dispose();
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
    WidgetsBinding.instance.addPostFrameCallback((_) => chooseKey(p.ownerKey));
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
    return '${width.toStringAsFixed(0)} × ${height.toStringAsFixed(0)} logical'
        ' · ${(width * ratio).toStringAsFixed(0)} × ${(height * ratio).toStringAsFixed(0)} px'
        ' · ${dpi.toStringAsFixed(0)} dpi'
        ' · ${(zoom * 100).toStringAsFixed(0)}%';
  }

  Widget panel() => DefaultTabController(
    length: 5,
    child: Column(
      children: [
        TabBar(
          isScrollable: true,
          tabs: [
            Tab(text: toolCopy('inspectTab')),
            Tab(text: toolCopy('problemsTab')),
            Tab(text: toolCopy('sweepTab')),
            Tab(text: toolCopy('accessibilityTab')),
            Tab(text: toolCopy('performanceTab')),
          ],
        ),
        Expanded(
          child: TabBarView(
            children: [
              InspectionPanel(session: session),
              ListenableBuilder(
                listenable: problems,
                builder: (context, _) => ListView(
                  children: [
                    Row(
                      children: [
                        IconButton(
                          key: const ValueKey('copy-problems'),
                          tooltip: toolCopy('copyProblems'),
                          onPressed: () => Clipboard.setData(
                            ClipboardData(
                              text: problemReport(problems.problems),
                            ),
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
              ),
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
              _AccessibilityPanel(host: this),
              _PerformancePanel(host: this),
            ],
          ),
        ),
      ],
    ),
  );
  @override
  Widget build(BuildContext context) => MaterialApp(
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
              ?widget.controls,
            ],
          ),
          body: LayoutBuilder(
            builder: (context, constraints) {
              final total = constraints.maxWidth;
              final pane = (appPaneWidth ?? total * .62)
                  .clamp(360.0, math.max(360.0, total - 320))
                  .toDouble();
              return Row(
                textDirection: TextDirection.ltr,
                children: [
                  // PHYSICAL: the app pane stays on the physical left.
                  SizedBox(width: panelOpen ? pane : total, child: viewport()),
                  if (panelOpen)
                    GestureDetector(
                      key: const ValueKey('resize-panel'),
                      onPanUpdate: (e) => setState(
                        () => appPaneWidth = (pane + e.delta.dx)
                            .clamp(360.0, math.max(360.0, total - 320))
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
                            _InspectorSection(
                              title: toolCopy('scenarioLabel'),
                              child: Padding(
                                padding: const EdgeInsetsDirectional.fromSTEB(
                                  12,
                                  0,
                                  12,
                                  8,
                                ),
                                child: DropdownButton<String>(
                                  key: const ValueKey('scenario'),
                                  isExpanded: true,
                                  value:
                                      widget.scenarioCatalog!.scenarios.any(
                                        (scenario) =>
                                            scenario.id ==
                                            widget.scenarioCatalog!.activeId,
                                      )
                                      ? widget.scenarioCatalog!.activeId
                                      : null,
                                  hint: Text(toolCopy('scenarioLabel')),
                                  items: [
                                    for (final scenario
                                        in widget.scenarioCatalog!.scenarios)
                                      DropdownMenuItem(
                                        value: scenario.id,
                                        child: Text(scenario.label),
                                      ),
                                  ],
                                  onChanged: (id) {
                                    if (id != null) {
                                      widget.scenarioCatalog!.activate(id);
                                    }
                                  },
                                ),
                              ),
                            ),
                          _InspectorSection(
                            title: toolCopy('pageSection'),
                            child: Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(
                                12,
                                0,
                                12,
                                8,
                              ),
                              child: Text(
                                pageSizeLabel(context),
                                key: const ValueKey('frame-readout'),
                              ),
                            ),
                          ),
                          _InspectorSection(
                            title: toolCopy('deviceGroup'),
                            child: SizedBox(
                              height: 148,
                              child: SingleChildScrollView(
                                child: DeviceToolbar(device: device),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(
                              12,
                              8,
                              12,
                              4,
                            ),
                            child: Text(
                              '${toolCopy('appResult')}: $appResult',
                              key: const ValueKey('app-result'),
                            ),
                          ),
                          const Divider(height: 1),
                          Expanded(child: panel()),
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
