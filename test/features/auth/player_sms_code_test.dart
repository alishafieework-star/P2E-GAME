import 'package:flutter_test/flutter_test.dart';
import 'package:mygame_p2e/features/auth/auth.dart';
import 'package:mygame_p2e/features/auth/src/domain/player_sms_code.dart';

void main() {
  const sample = 'سلام، کد شما P-50069 است. اعتبار ۱۰ دقیقه. لغو=11';

  OtpChallenge challenge({String prefix = 'P-', int digits = 5}) =>
      OtpChallenge(
        challengeId: 'ch',
        codeLength: digits,
        codePrefix: prefix,
        resendAfter: Duration.zero,
        expiresAt: DateTime.utc(2026, 11, 10),
        maskedDestination: '09',
      );

  test('parser keeps one standalone five-digit code', () {
    expect(PlayerSmsCode.singleCode(sample), 'P50069');
    expect(PlayerSmsCode.singleCode('code\n\np-50069\n'), 'P50069');
    expect(PlayerSmsCode.singleCode('A-00007'), 'A00007');
    expect(PlayerSmsCode.singleCode('no code here 12345'), isNull);
    expect(PlayerSmsCode.singleCode('P-5006'), isNull);
    expect(PlayerSmsCode.singleCode('P-500690'), isNull);
    expect(PlayerSmsCode.singleCode('AP-50069'), isNull);
    expect(PlayerSmsCode.singleCode('P-50069 and P-11111'), isNull);
  });

  test('a mismatched or ambiguous code does not replace the field', () {
    final active = challenge();
    expect(PlayerSmsCode.fieldFor('P50069', active), 'P50069');
    expect(PlayerSmsCode.fieldFor('A00007', active), isNull);
    expect(PlayerSmsCode.fieldFor('P50069', challenge(prefix: 'Q-')), isNull);
  });

  test('editing uppercases the letter and keeps five digits', () {
    expect(PlayerSmsCode.edit('p', 'P'), 'P');
    expect(PlayerSmsCode.edit('P5006', 'P'), 'P5006');
    expect(PlayerSmsCode.edit('۵۰۰۶۹', 'P'), 'P50069');
    expect(PlayerSmsCode.edit('P-50069', 'P'), 'P50069');
    expect(PlayerSmsCode.edit('P-50069 Q-11111', 'P'), isNull);
    expect(PlayerSmsCode.wireDigits('P50069', challenge()), '50069');
    expect(PlayerSmsCode.wireDigits('Q50069', challenge()), isNull);
    expect(PlayerSmsCode.wireDigits('P5006', challenge()), isNull);
  });

  test('a prefix whose digit count is not five stays unsegmented', () {
    expect(PlayerSmsCode.isSegmented(challenge(digits: 4)), isFalse);
    final email = challenge(prefix: 'GAME-', digits: 13);
    expect(PlayerSmsCode.isSegmented(email), isFalse);
    expect(PlayerSmsCode.wireDigits('GAME-12345678', email), 'GAME-12345678');
  });
}
