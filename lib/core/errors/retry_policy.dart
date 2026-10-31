import 'app_failure.dart';

/// Read-model retry policy: transient failures back off a few times; other
/// failures (business, validation, missing composition) surface at once.
Duration? retryTransient(int retryCount, Object error) {
  final transient =
      error is NetworkFailure ||
      error is TimeoutFailure ||
      error is OfflineFailure ||
      error is ServerFailure;
  if (!transient || retryCount >= 4) return null;
  return Duration(milliseconds: 200 * (1 << retryCount));
}
