import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mygame_p2e/core/storage/json_store.dart';

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

  Map<String, Object?> toJson() => {
    'onboardingSeen': onboardingSeen,
    'homeTourPending': homeTourPending,
    'notificationsAsked': notificationsAsked,
    'smsAccessAsked': smsAccessAsked,
    'rememberedRaw': rememberedRaw,
    'rememberedLabel': rememberedLabel,
  };

  factory DevicePreferences.fromJson(Map<String, Object?> json) =>
      DevicePreferences(
        onboardingSeen: json['onboardingSeen'] == true,
        homeTourPending: json['homeTourPending'] == true,
        notificationsAsked: json['notificationsAsked'] == true,
        smsAccessAsked: json['smsAccessAsked'] == true,
        rememberedRaw: json['rememberedRaw'] is String
            ? json['rememberedRaw'] as String
            : '',
        rememberedLabel: json['rememberedLabel'] is String
            ? json['rememberedLabel'] as String
            : '',
      );
}

abstract interface class DevicePreferencesRepository {
  Future<DevicePreferences> read();
  Future<void> save(DevicePreferences value);
}

final class JsonDevicePreferencesRepository
    implements DevicePreferencesRepository {
  JsonDevicePreferencesRepository(this.store);
  final JsonStore store;
  static const key = 'device/preferences';

  @override
  Future<DevicePreferences> read() async {
    try {
      final raw = await store
          .read(key)
          .timeout(const Duration(seconds: 2), onTimeout: () => null);
      if (raw == null || raw.isEmpty) return const DevicePreferences();
      final decoded = jsonDecode(raw);
      if (decoded is! Map) return const DevicePreferences();
      return DevicePreferences.fromJson(Map<String, Object?>.from(decoded));
    } catch (_) {
      // A failed read must not trap startup. The player can still sign in.
      return const DevicePreferences(onboardingSeen: true);
    }
  }

  @override
  Future<void> save(DevicePreferences value) =>
      store.write(key, jsonEncode(value.toJson()));
}

/// In-memory flags for hosts that do not install the file store.
/// Onboarding is already seen so widget tests reach Auth Entry.
/// Production bootstrap replaces this with the device file store (D-142).
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
