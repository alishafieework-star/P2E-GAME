import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Device flags that survive sign-out (D-142, Addendum A3.3).
final class DevicePreferences {
  const DevicePreferences({
    this.onboardingSeen = false,
    this.homeTourPending = false,
    this.notificationsAsked = false,
    this.smsAccessAsked = false,
    this.rememberedRaw = '',
    this.rememberedLabel = '',
  });

  final bool onboardingSeen;
  final bool homeTourPending;
  final bool notificationsAsked;

  /// The in-app SMS access explanation has been shown (PE-003).
  final bool smsAccessAsked;

  /// Local Continue-as record. Empty after Not You or sign-out (D-140).
  final String rememberedRaw;
  final String rememberedLabel;

  DevicePreferences copyWith({
    bool? onboardingSeen,
    bool? homeTourPending,
    bool? notificationsAsked,
    bool? smsAccessAsked,
    String? rememberedRaw,
    String? rememberedLabel,
  }) => DevicePreferences(
    onboardingSeen: onboardingSeen ?? this.onboardingSeen,
    homeTourPending: homeTourPending ?? this.homeTourPending,
    notificationsAsked: notificationsAsked ?? this.notificationsAsked,
    smsAccessAsked: smsAccessAsked ?? this.smsAccessAsked,
    rememberedRaw: rememberedRaw ?? this.rememberedRaw,
    rememberedLabel: rememberedLabel ?? this.rememberedLabel,
  );
}

abstract interface class DevicePreferencesRepository {
  Future<DevicePreferences> read();
  Future<void> save(DevicePreferences value);
}

/// Persistent device flags via shared_preferences (D-142, Addendum A3.3).
/// Replaces the previous JsonDevicePreferencesRepository / FileJsonStore.
final class SharedPrefsDevicePreferences
    implements DevicePreferencesRepository {
  static const _onboardingSeen = 'pref.onboardingSeen';
  static const _homeTourPending = 'pref.homeTourPending';
  static const _notificationsAsked = 'pref.notificationsAsked';
  static const _smsAccessAsked = 'pref.smsAccessAsked';
  static const _rememberedRaw = 'pref.rememberedRaw';
  static const _rememberedLabel = 'pref.rememberedLabel';

  @override
  Future<DevicePreferences> read() async {
    try {
      final p = await SharedPreferences.getInstance().timeout(
        const Duration(seconds: 2),
      );
      return DevicePreferences(
        onboardingSeen: p.getBool(_onboardingSeen) ?? false,
        homeTourPending: p.getBool(_homeTourPending) ?? false,
        notificationsAsked: p.getBool(_notificationsAsked) ?? false,
        smsAccessAsked: p.getBool(_smsAccessAsked) ?? false,
        rememberedRaw: p.getString(_rememberedRaw) ?? '',
        rememberedLabel: p.getString(_rememberedLabel) ?? '',
      );
    } catch (_) {
      // A failed read must not trap startup. The player can still sign in.
      return const DevicePreferences(onboardingSeen: true);
    }
  }

  @override
  Future<void> save(DevicePreferences v) async {
    final p = await SharedPreferences.getInstance();
    await Future.wait([
      p.setBool(_onboardingSeen, v.onboardingSeen),
      p.setBool(_homeTourPending, v.homeTourPending),
      p.setBool(_notificationsAsked, v.notificationsAsked),
      p.setBool(_smsAccessAsked, v.smsAccessAsked),
      p.setString(_rememberedRaw, v.rememberedRaw),
      p.setString(_rememberedLabel, v.rememberedLabel),
    ]);
  }
}

/// In-memory flags for hosts that do not install the file store.
/// Onboarding is already seen so widget tests reach Auth Entry.
/// Production bootstrap replaces this with SharedPrefsDevicePreferences (D-142).
final class EphemeralDevicePreferences implements DevicePreferencesRepository {
  DevicePreferences value = const DevicePreferences(onboardingSeen: true);

  @override
  Future<DevicePreferences> read() async => value;

  @override
  Future<void> save(DevicePreferences next) async => value = next;
}

final devicePreferencesRepositoryProvider =
    Provider<DevicePreferencesRepository>((_) => EphemeralDevicePreferences());

final class DevicePreferencesController
    extends AsyncNotifier<DevicePreferences> {
  @override
  Future<DevicePreferences> build() =>
      ref.watch(devicePreferencesRepositoryProvider).read();

  Future<void> save(DevicePreferences value) async {
    state = AsyncData(value);
    await ref.read(devicePreferencesRepositoryProvider).save(value);
  }
}

final devicePreferencesProvider =
    AsyncNotifierProvider<DevicePreferencesController, DevicePreferences>(
      DevicePreferencesController.new,
    );
