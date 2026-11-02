import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart' show Override;
import 'package:mygame_p2e/app/app.dart';
import 'package:mygame_p2e/app/bootstrap.dart';
import 'package:mygame_p2e/app/config/app_config.dart';
import 'package:mygame_p2e/core/platform/device_inputs.dart';
import 'package:mygame_p2e/features/auth/auth_data.dart';
import 'package:mygame_p2e/l10n/generated/app_localizations.dart';
import 'package:p2e_design_system/design_system.dart';
import 'package:p2e_design_system/inspection.dart';
import 'package:p2e_dev_inspector/inspector.dart';

import 'product_asset_bridge.dart';

import 'package:mygame_p2e/core/sensors/device_tilt_service.dart';

import 'scenarios/product_scenarios.dart';

class ProductSensorDriver implements InspectorSensorDriver {
  const ProductSensorDriver();

  @override
  void setTilt(Offset offset) =>
      DeviceTiltService.instance.setSimulatedTilt(offset);

  @override
  void reset() {
    DeviceTiltService.instance.clearSimulation();
    DeviceTiltService.instance.reset();
  }
}

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const ProductInspectionHost());
}

class ProductInspectionHost extends StatefulWidget {
  const ProductInspectionHost({
    super.key,
    this.fixtures = false,
    this.device,
    this.initialScenario = 'auth.entry',
  });
  final bool fixtures;
  final SimulatedDevice? device;
  final String initialScenario;
  @override
  State<ProductInspectionHost> createState() => _ProductInspectionHostState();
}

class _ProductInspectionHostState extends State<ProductInspectionHost> {
  final _host = GlobalKey<InspectorHostState>();
  late bool fixtures = widget.fixtures;
  late String scenarioId = widget.initialScenario;
  FakeAuthScenario scenario = FakeAuthScenario.success;
  String _seeded = '';
  int _seedAttempts = 0;
  String _overrideKey = '';
  List<Override> _scenarioOverrides = const [];

  @override
  void initState() {
    super.initState();
    if (!fixtures) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _seed(scenarioId));
    }
  }

  List<Override> scenarioOverrides() {
    final key = '$scenarioId:${scenario.name}';
    if (key != _overrideKey) {
      _overrideKey = key;
      _scenarioOverrides = [
        fakeAuthScenarioProvider.overrideWith((_) => scenario),
        ...productScenarioById(scenarioId)
            .overrides(AppConfig.fromEnvironment()),
      ];
    }
    return _scenarioOverrides;
  }

  Future<void> openScenario(String id) {
    final scenario = productScenarioById(id);
    final done = Completer<void>();
    setState(() {
      scenarioId = id;
      fixtures = scenario.fixtures;
      _seeded = '';
      _seedAttempts = 0;
    });
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (!fixtures) await _seed(id);
      if (!done.isCompleted) done.complete();
    });
    return done.future;
  }

  Future<void> _seed(String id) async {
    if (_seeded == id || fixtures) return;
    final context = _host.currentState?.appKey.currentContext;
    if (context == null || !context.mounted) {
      if (_seedAttempts++ < 15) {
        WidgetsBinding.instance.addPostFrameCallback((_) => _seed(id));
      }
      return;
    }
    _seeded = id;
    _seedAttempts = 0;
    await seedProductScenario(
      ProviderScope.containerOf(context),
      productScenarioById(id),
    );
  }

  @override
  Widget build(BuildContext context) => InspectorHost(
    key: _host,
    device: widget.device,
    hostId: 'product_host',
    sensorDriver: const ProductSensorDriver(),
    initialPanelWidth: 760,
    scenarioCatalog: ScenarioCatalog(
      activeId: scenarioId,
      activate: openScenario,
      scenarios: [
        for (final item in productScenarios)
          InspectionScenarioRef(id: item.id, label: item.label),
      ],
    ),
    controls: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        TextButton(
          onPressed: () => setState(() => fixtures = !fixtures),
          child: Text(
            fixtures ? toolCopy('productMode') : toolCopy('fixtureMode'),
          ),
        ),
        DropdownButton<FakeAuthScenario>(
          value: scenario,
          items: [
            for (final value in FakeAuthScenario.values)
              DropdownMenuItem(value: value, child: Text(value.name)),
          ],
          onChanged: (value) {
            if (value != null) setState(() => scenario = value);
          },
        ),
      ],
    ),
    appBuilder: (settings, appKey) => composeApp(
      key: ValueKey(scenarioId),
      config: AppConfig.fromEnvironment(),
      includeHomeBindings: productScenarioById(scenarioId).home == null,
      providerOverrides: [
        ...scenarioOverrides(),
        deviceLocalesProvider.overrideWithBuild(
          (ref, notifier) => settings.locales,
        ),
        deviceTargetPlatformProvider.overrideWithValue(settings.platform),
        deviceMouseDragProvider.overrideWithValue(true),
        appSkinProvider.overrideWithValue(
          settings.testSkin ? testSkin : productSkin,
        ),
      ],
      rootWrapper: (root) => DefaultAssetBundle(
        bundle: ProductAssetBridge(rootBundle),
        child: MediaQuery(
          data: settings.media,
          child: SizedBox.expand(
            key: appKey,
            child: fixtures
                ? MaterialApp(
                    debugShowCheckedModeBanner: false,
                    locale: settings.locale,
                    supportedLocales: AppLocalizations.supportedLocales,
                    localizationsDelegates:
                        AppLocalizations.localizationsDelegates,
                    theme: AppThemeFactory.build(
                      brightness: settings.brightness,
                      skin: settings.testSkin ? testSkin : productSkin,
                    ).copyWith(platform: settings.platform),
                    builder: (context, child) => MediaQuery(
                      data: settings.media.copyWith(
                        textScaler: settings.media.textScaler.clamp(
                          maxScaleFactor: contentTextScaleCap,
                        ),
                      ),
                      child: child!,
                    ),
                    home: const InspectionFixtures(),
                  )
                : root,
          ),
        ),
      ),
    ),
  );
}
