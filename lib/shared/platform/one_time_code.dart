import 'package:flutter_riverpod/flutter_riverpod.dart';

/// D-071: one SMS event. The body is consumed by the parser and not retained.
sealed class OneTimeCodeEvent {
  const OneTimeCodeEvent();
}

final class OneTimeCodeMessage extends OneTimeCodeEvent {
  const OneTimeCodeMessage(this.body);
  final String body;
}

final class OneTimeCodeTimeout extends OneTimeCodeEvent {
  const OneTimeCodeTimeout();
}

final class OneTimeCodeUnavailable extends OneTimeCodeEvent {
  const OneTimeCodeUnavailable();
}

/// The player declined the one-message consent dialog (D-156).
final class OneTimeCodeConsentDenied extends OneTimeCodeEvent {
  const OneTimeCodeConsentDenied();
}

abstract interface class OneTimeCodePort {
  /// A new listen replaces the previous one. Cancelling the subscription
  /// stops the platform listener. [sender] is the Android consent filter.
  Stream<OneTimeCodeEvent> listen({String? sender});
}

/// Safe default so auth tests run without a platform adapter.
final class SilentOneTimeCode implements OneTimeCodePort {
  const SilentOneTimeCode();
  @override
  Stream<OneTimeCodeEvent> listen({String? sender}) => const Stream.empty();
}

final oneTimeCodePortProvider = Provider<OneTimeCodePort>(
  (_) => const SilentOneTimeCode(),
);

/// Runtime access to incoming one-time-code SMS. SMS User Consent needs no
/// inbox permission (PE-005).
abstract interface class OneTimeCodeAccess {
  Future<bool> granted();
  Future<bool> request();
}

final class AlwaysGrantedOneTimeCodeAccess implements OneTimeCodeAccess {
  const AlwaysGrantedOneTimeCodeAccess();
  @override
  Future<bool> granted() async => true;
  @override
  Future<bool> request() async => true;
}

final oneTimeCodeAccessProvider = Provider<OneTimeCodeAccess>(
  (_) => const AlwaysGrantedOneTimeCodeAccess(),
);
