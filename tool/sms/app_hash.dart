import 'dart:convert';
import 'dart:io';

import 'package:crypto/crypto.dart';

/// Google SMS Retriever hash: base64(sha256(package + certificate)) first 11.
String smsAppHash(String packageName, List<int> certificate) {
  final digest = sha256.convert([...utf8.encode(packageName), ...certificate]);
  final encoded = base64.encode(digest.bytes.sublist(0, 9));
  return encoded.substring(0, 11);
}

/// Usage: dart run tool/sms/app_hash.dart keystore alias storepass
Future<void> main(List<String> args) async {
  if (args.length < 3) {
    stdout.writeln(
      'Usage: dart run tool/sms/app_hash.dart <keystore> <alias> <storepass>',
    );
    return;
  }
  final certificate = File(
    '${Directory.systemTemp.path}${Platform.pathSeparator}p2e-sms-cert.der',
  );
  final exported = await Process.run('keytool', [
    '-exportcert',
    '-alias',
    args[1],
    '-keystore',
    args[0],
    '-storepass',
    args[2],
    '-file',
    certificate.path,
  ]);
  if (exported.exitCode != 0) {
    stderr.writeln(exported.stderr);
    exitCode = exported.exitCode;
    return;
  }
  try {
    stdout.writeln(
      smsAppHash('ir.mci.mygame.p2e', certificate.readAsBytesSync()),
    );
  } finally {
    if (certificate.existsSync()) certificate.deleteSync();
  }
}
