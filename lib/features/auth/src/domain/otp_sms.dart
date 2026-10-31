/// D-071: pure SMS code extraction. An ambiguous message returns null.
abstract interface class OtpSmsFormat {
  String? read(String message);
}
