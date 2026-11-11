import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../shared/session/session.dart';
import 'dev_otp_transport.dart';
import 'json_http_transport.dart';
import 'secure_session_cookie_store.dart';
import 'session_cookie_store.dart';

part 'transports.g.dart';

/// Long-lived HTTP clients for the composition root. Repository providers
/// rebuild freely; a fresh client per rebuild would abandon its keep-alive
/// sockets, so the transports outlive them and close on container teardown.
/// D-154: one store for the process. Tests override this with memory.
final sessionCookieStoreProvider = Provider<SessionCookieStore>(
  (ref) => const SecureSessionCookieStore(),
);

@Riverpod(keepAlive: true)
IoJsonTransport jsonHttpTransport(Ref ref) {
  final transport = IoJsonTransport(
    cookies: ref.watch(sessionCookieStoreProvider),
    onUnauthorized: () {
      ref
          .read(sessionControllerProvider.notifier)
          .update(SessionStatus.expired);
    },
  );
  ref.onDispose(transport.close);
  return transport;
}

@Riverpod(keepAlive: true)
IoDevOtpTransport devOtpTransport(Ref ref) {
  final transport = IoDevOtpTransport();
  ref.onDispose(transport.close);
  return transport;
}
