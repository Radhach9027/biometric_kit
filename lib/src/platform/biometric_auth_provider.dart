import '../enums.dart';
import '../models.dart';

abstract class BiometricAuthProvider {
  const BiometricAuthProvider();

  /// Basic support check: hardware / enrolled / etc.
  Future<BiometricSupportStatus> checkSupport();

  /// Detailed info: does this device have face / fingerprint?
  Future<BiometricCapabilities> getCapabilities();

  /// Runs a biometric auth prompt.
  Future<BiometricAuthResult> authenticate({
    required String reason,
    BiometricKind kind = BiometricKind.any,
    bool useErrorDialogs = true,
    bool stickyAuth = false,
  });
}
