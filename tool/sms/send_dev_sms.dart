import 'dart:io';

/// Places a development OTP SMS on a running emulator.
/// Usage: dart run tool/sms/send_dev_sms.dart [code] [11-char-hash] [serial]
Future<void> main(List<String> args) async {
  final code = args.isNotEmpty ? args.first : 'P12345';
  final hash = args.length > 1 ? args[1] : '00000000000';
  final serial = args.length > 2 ? args[2] : 'emulator-5554';
  final message = 'MyGame code: $code $hash';
  final result = await Process.run('adb', [
    '-s',
    serial,
    'emu',
    'sms',
    'send',
    '5551234',
    message,
  ]);
  stdout.write(result.stdout);
  stderr.write(result.stderr);
  exitCode = result.exitCode;
}
