import 'package:flutter/material.dart';

import '../core/gorilla_stress.dart';
import 'tool_copy.dart';

class GorillaStressPanel extends StatelessWidget {
  const GorillaStressPanel({super.key, required this.runner});

  final GorillaStressRunner runner;

  @override
  Widget build(BuildContext context) => ListenableBuilder(
    listenable: runner,
    builder: (context, _) => ListView(
      padding: const EdgeInsetsDirectional.all(16),
      children: [
        Text(
          toolCopy('gorillaHeader'),
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        const SizedBox(height: 4),
        Text(
          toolCopy('gorillaDescription'),
          style: TextStyle(
            fontSize: 12,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 16),
        Text(
          '${toolCopy('gorillaMode')}:',
          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            for (final m in GorillaMode.values)
              ChoiceChip(
                key: ValueKey('gorilla-mode-${m.name}'),
                avatar: Icon(_modeIcon(m), size: 16),
                label: Text(_modeLabel(m)),
                selected: runner.mode == m,
                onSelected: runner.running
                    ? null
                    : (_) => runner.configure(mode: m),
              ),
          ],
        ),
        if (runner.mode == GorillaMode.monkeyTap ||
            runner.mode == GorillaMode.fullChaos) ...[
          const SizedBox(height: 16),
          Text(
            '${toolCopy('tapTarget')}:',
            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final t in GorillaTapTarget.values)
                ChoiceChip(
                  key: ValueKey('gorilla-tap-target-${t.name}'),
                  avatar: Icon(_tapTargetIcon(t), size: 16),
                  label: Text(_tapTargetLabel(t)),
                  selected: runner.tapTarget == t,
                  onSelected: runner.running
                      ? null
                      : (_) => runner.configure(tapTarget: t),
                ),
            ],
          ),
        ],
        const SizedBox(height: 16),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${toolCopy('intensity')}:',
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(height: 8),
                  SegmentedButton<GorillaIntensity>(
                    segments: [
                      for (final i in GorillaIntensity.values)
                        ButtonSegment(
                          value: i,
                          label: Text(_intensityLabel(i)),
                        ),
                    ],
                    selected: {runner.intensity},
                    onSelectionChanged: runner.running
                        ? null
                        : (v) => runner.configure(intensity: v.first),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${toolCopy('duration')}:',
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(height: 8),
                  SegmentedButton<GorillaDuration>(
                    segments: [
                      ButtonSegment(
                        value: GorillaDuration.fiveSeconds,
                        label: Text(toolCopy('duration5s')),
                      ),
                      ButtonSegment(
                        value: GorillaDuration.tenSeconds,
                        label: Text(toolCopy('duration10s')),
                      ),
                      ButtonSegment(
                        value: GorillaDuration.continuous,
                        label: Text(toolCopy('durationContinuous')),
                      ),
                    ],
                    selected: {runner.duration},
                    onSelectionChanged: runner.running
                        ? null
                        : (v) => runner.configure(duration: v.first),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        SizedBox(
          height: 44,
          child: FilledButton.icon(
            key: const ValueKey('gorilla-start-stop'),
            style: FilledButton.styleFrom(
              backgroundColor: runner.running
                  ? Theme.of(context).colorScheme.error
                  : Theme.of(context).colorScheme.primary,
            ),
            onPressed: runner.running ? runner.stop : runner.start,
            icon: Icon(runner.running ? Icons.stop : Icons.play_arrow),
            label: Text(
              runner.running
                  ? '${toolCopy('stopGorilla')} (${runner.elapsedSeconds.toStringAsFixed(1)}s)'
                  : toolCopy('startGorilla'),
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ),
        const SizedBox(height: 24),
        const Divider(),
        const SizedBox(height: 12),
        _buildDashboard(context),
      ],
    ),
  );

  Widget _buildDashboard(BuildContext context) {
    final hasProblems = runner.problemsDuringRun > 0;
    final isRunning = runner.running;
    return Container(
      padding: const EdgeInsetsDirectional.all(14),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest
            .withValues(alpha: 0.4),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: isRunning
              ? Theme.of(context).colorScheme.primary.withValues(alpha: 0.6)
              : Colors.white12,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Chip(
                visualDensity: VisualDensity.compact,
                avatar: isRunning
                    ? const SizedBox(
                        width: 12,
                        height: 12,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.check_circle_outline, size: 14),
                label: Text(
                  isRunning
                      ? toolCopy('statusRunning')
                      : toolCopy('statusIdle'),
                  style: const TextStyle(fontSize: 12),
                ),
              ),
              const Spacer(),
              Text(
                '${runner.elapsedSeconds.toStringAsFixed(1)}s',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _metricRow(
            icon: Icons.touch_app_outlined,
            title: toolCopy('dispatchedEvents'),
            value: '${runner.dispatchedEvents}',
            keyId: 'gorilla-dispatched-events',
          ),
          const SizedBox(height: 8),
          _metricRow(
            icon: Icons.speed_outlined,
            title: toolCopy('slowFramesCount'),
            value: '${runner.slowFramesDuringRun}',
            keyId: 'gorilla-slow-frames',
            color: runner.slowFramesDuringRun > 0 ? Colors.amber : null,
          ),
          const SizedBox(height: 8),
          _metricRow(
            icon: hasProblems
                ? Icons.warning_amber_rounded
                : Icons.verified_outlined,
            title: toolCopy('problemsCount'),
            value: hasProblems
                ? '${runner.problemsDuringRun}'
                : toolCopy('noProblemsDetected'),
            keyId: 'gorilla-problems-count',
            color: hasProblems
                ? Theme.of(context).colorScheme.error
                : Colors.tealAccent,
          ),
        ],
      ),
    );
  }

  Widget _metricRow({
    required IconData icon,
    required String title,
    required String value,
    required String keyId,
    Color? color,
  }) => Row(
    children: [
      Icon(icon, size: 16, color: color),
      const SizedBox(width: 8),
      Text(title, style: const TextStyle(fontSize: 12)),
      const Spacer(),
      Text(
        value,
        key: ValueKey(keyId),
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 13,
          color: color,
        ),
      ),
    ],
  );

  static IconData _modeIcon(GorillaMode mode) => switch (mode) {
    GorillaMode.sensorShake => Icons.screen_rotation,
    GorillaMode.fastScroll => Icons.speed,
    GorillaMode.slowScroll => Icons.swipe_vertical,
    GorillaMode.monkeyTap => Icons.touch_app,
    GorillaMode.fullChaos => Icons.all_inclusive,
  };

  static String _modeLabel(GorillaMode mode) => switch (mode) {
    GorillaMode.sensorShake => toolCopy('sensorShake'),
    GorillaMode.fastScroll => toolCopy('fastScroll'),
    GorillaMode.slowScroll => toolCopy('slowScroll'),
    GorillaMode.monkeyTap => toolCopy('monkeyTap'),
    GorillaMode.fullChaos => toolCopy('fullChaos'),
  };

  static IconData _tapTargetIcon(GorillaTapTarget target) => switch (target) {
    GorillaTapTarget.selectedElement => Icons.highlight_alt,
    GorillaTapTarget.interactiveWidgets => Icons.smart_button,
    GorillaTapTarget.topZone => Icons.vertical_align_top,
    GorillaTapTarget.centerZone => Icons.center_focus_strong,
    GorillaTapTarget.bottomZone => Icons.vertical_align_bottom,
    GorillaTapTarget.customPoint => Icons.pin_drop,
  };

  static String _tapTargetLabel(GorillaTapTarget target) => switch (target) {
    GorillaTapTarget.selectedElement => toolCopy('tapTargetSelected'),
    GorillaTapTarget.interactiveWidgets => toolCopy('tapTargetInteractive'),
    GorillaTapTarget.topZone => toolCopy('tapTargetTop'),
    GorillaTapTarget.centerZone => toolCopy('tapTargetCenter'),
    GorillaTapTarget.bottomZone => toolCopy('tapTargetBottom'),
    GorillaTapTarget.customPoint => toolCopy('tapTargetCustom'),
  };

  static String _intensityLabel(GorillaIntensity intensity) =>
      switch (intensity) {
        GorillaIntensity.gentle => toolCopy('gentle'),
        GorillaIntensity.normal => toolCopy('normal'),
        GorillaIntensity.extreme => toolCopy('extreme'),
      };
}
