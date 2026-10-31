// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transports.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Long-lived HTTP clients for the composition root. Repository providers
/// rebuild freely; a fresh client per rebuild would abandon its keep-alive
/// sockets, so the transports outlive them and close on container teardown.

@ProviderFor(jsonHttpTransport)
final jsonHttpTransportProvider = JsonHttpTransportProvider._();

/// Long-lived HTTP clients for the composition root. Repository providers
/// rebuild freely; a fresh client per rebuild would abandon its keep-alive
/// sockets, so the transports outlive them and close on container teardown.

final class JsonHttpTransportProvider
    extends
        $FunctionalProvider<IoJsonTransport, IoJsonTransport, IoJsonTransport>
    with $Provider<IoJsonTransport> {
  /// Long-lived HTTP clients for the composition root. Repository providers
  /// rebuild freely; a fresh client per rebuild would abandon its keep-alive
  /// sockets, so the transports outlive them and close on container teardown.
  JsonHttpTransportProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'jsonHttpTransportProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$jsonHttpTransportHash();

  @$internal
  @override
  $ProviderElement<IoJsonTransport> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  IoJsonTransport create(Ref ref) {
    return jsonHttpTransport(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(IoJsonTransport value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<IoJsonTransport>(value),
    );
  }
}

String _$jsonHttpTransportHash() => r'c2efd6855ab1de2363bad2caee63a49b1144c6ab';

@ProviderFor(devOtpTransport)
final devOtpTransportProvider = DevOtpTransportProvider._();

final class DevOtpTransportProvider
    extends
        $FunctionalProvider<
          IoDevOtpTransport,
          IoDevOtpTransport,
          IoDevOtpTransport
        >
    with $Provider<IoDevOtpTransport> {
  DevOtpTransportProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'devOtpTransportProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$devOtpTransportHash();

  @$internal
  @override
  $ProviderElement<IoDevOtpTransport> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  IoDevOtpTransport create(Ref ref) {
    return devOtpTransport(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(IoDevOtpTransport value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<IoDevOtpTransport>(value),
    );
  }
}

String _$devOtpTransportHash() => r'bb5a63ff9f269bfbbcc38b51e4fd0c181c349f1e';
