import 'package:flutter/foundation.dart';
import '../enums.dart';
import '../models.dart';

@immutable
abstract class BiometricAuthProvider {
  const BiometricAuthProvider();

  /// Check high-level support for biometrics.
  Future<BiometricSupportStatus> checkSupport();

  /// Perform biometric authentication.
  Future<BiometricAuthResult> authenticate(BiometricPromptConfig config);
}
