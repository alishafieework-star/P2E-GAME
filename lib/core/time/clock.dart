import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'clock.g.dart';

/// Wall-clock seam. Tests replace it; the product reads the device clock.
abstract interface class Clock {
  DateTime now();
}

final class SystemClock implements Clock {
  const SystemClock();
  @override
  DateTime now() => DateTime.now();
}

@Riverpod(keepAlive: true)
Clock clock(Ref ref) => const SystemClock();

/// The current time, refreshed once per second while something watches it.
@riverpod
Stream<DateTime> secondTicker(Ref ref) async* {
  final clock = ref.watch(clockProvider);
  yield clock.now();
  yield* Stream.periodic(const Duration(seconds: 1), (_) => clock.now());
}
