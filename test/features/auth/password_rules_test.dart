import 'package:flutter_test/flutter_test.dart';
import 'package:mygame_p2e/features/auth/src/presentation/password/password_rules.dart';

void main() {
  test('empty password is level 0', () {
    expect(PasswordRules.level(''), 0);
  });

  test('any non-empty password is at least Weak', () {
    expect(PasswordRules.level('abc'), 1);
  });

  test('each met rule raises the level', () {
    expect(PasswordRules.level('abcdefghijk'), 1);
    expect(PasswordRules.level('abcdefghijk1'), 2);
    expect(PasswordRules.level('Abcdefghijk1'), 3);
    expect(PasswordRules.level('Abcdefghijk1!'), 4);
  });

  test('score and acceptable stay strict', () {
    expect(PasswordRules.score('abc'), 0);
    expect(PasswordRules.score('Abcdefghijk1'), 3);
    expect(PasswordRules.acceptable('Abcdefghijk1', 'Abcdefghijk1'), isFalse);
    expect(PasswordRules.acceptable('Abcdefghijk1!', 'Abcdefghijk1!'), isTrue);
    expect(PasswordRules.longEnough('abcdefghij'), isFalse);
    expect(PasswordRules.longEnough('a' * 129), isFalse);
  });
}
