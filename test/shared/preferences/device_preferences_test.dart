import 'package:flutter_test/flutter_test.dart';
import 'package:mygame_p2e/shared/preferences/device_preferences.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('SharedPrefsDevicePreferences', () {
    setUp(() {
      SharedPreferences.setMockInitialValues({});
    });

    test('reads defaults when empty', () async {
      final repo = SharedPrefsDevicePreferences();
      final prefs = await repo.read();

      expect(prefs.onboardingSeen, isFalse);
      expect(prefs.homeTourPending, isFalse);
      expect(prefs.notificationsAsked, isFalse);
      expect(prefs.smsAccessAsked, isFalse);
      expect(prefs.rememberedRaw, isEmpty);
      expect(prefs.rememberedLabel, isEmpty);
    });

    test('saves and reads updated preferences', () async {
      final repo = SharedPrefsDevicePreferences();
      const updated = DevicePreferences(
        onboardingSeen: true,
        homeTourPending: true,
        notificationsAsked: true,
        smsAccessAsked: true,
        rememberedRaw: '+989120000000',
        rememberedLabel: 'Ali',
      );

      await repo.save(updated);
      final readBack = await repo.read();

      expect(readBack.onboardingSeen, isTrue);
      expect(readBack.homeTourPending, isTrue);
      expect(readBack.notificationsAsked, isTrue);
      expect(readBack.smsAccessAsked, isTrue);
      expect(readBack.rememberedRaw, equals('+989120000000'));
      expect(readBack.rememberedLabel, equals('Ali'));
    });
  });
}
