import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'dev_otp_transport.dart';
import 'json_http_transport.dart';

part 'transports.g.dart';

/// Long-lived HTTP clients for the composition root. Repository providers
/// rebuild freely; a fresh client per rebuild would abandon its keep-alive
/// sockets, so the transports outlive them and close on container teardown.
@Riverpod(keepAlive: true)
IoJsonTransport jsonHttpTransport(Ref ref) {
  final transport = IoJsonTransport();
  ref.onDispose(transport.close);
  return transport;
}

@Riverpod(keepAlive: true)
IoDevOtpTransport devOtpTransport(Ref ref) {
  final transport = IoDevOtpTransport();
  ref.onDispose(transport.close);
  return transport;
}
