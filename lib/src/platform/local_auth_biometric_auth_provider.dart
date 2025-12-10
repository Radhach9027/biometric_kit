import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';
import '../enums.dart';
import '../exceptions.dart';
import '../models.dart';
import 'biometric_auth_provider.dart';

class LocalAuthBiometricAuthProvider extends BiometricAuthProvider {
  LocalAuthBiometricAuthProvider({LocalAuthentication? localAuth})
      : _localAuth = localAuth ?? LocalAuthentication();

  final LocalAuthentication _localAuth;

  @override
  Future<BiometricSupportStatus> checkSupport() async {
    try {
      final supported = await _localAuth.isDeviceSupported();
      if (!supported) {
        return BiometricSupportStatus.noHardware;
      }

      final canCheck = await _localAuth.canCheckBiometrics;
      if (!canCheck) {
        return BiometricSupportStatus.notEnrolled;
      }

      return BiometricSupportStatus.supported;
    } on PlatformException catch (e) {
      // Optionally inspect e.code for finer mapping
      return BiometricSupportStatus.unknown;
    }
  }

  @override
  Future<BiometricAuthResult> authenticate(
    BiometricPromptConfig config,
  ) async {
    try {
      final available = await _localAuth.getAvailableBiometrics();

      // Filter by requested kind
      final bool hasWantedType = switch (config.biometricKind) {
        BiometricKind.any => available.isNotEmpty,
        BiometricKind.face => available.contains(BiometricType.face),
        BiometricKind.fingerprint =>
          available.contains(BiometricType.fingerprint) ||
              available.contains(BiometricType.strong) ||
              available.contains(BiometricType.weak),
      };

      if (!hasWantedType) {
        throw BiometricException(
          'Requested biometric kind (${config.biometricKind}) not available',
        );
      }

      final bool success = await _localAuth.authenticate(
        localizedReason: config.reason,
        options: AuthenticationOptions(
          biometricOnly: true,
          useErrorDialogs: config.useErrorDialogs,
          stickyAuth: config.stickyAuth,
        ),
      );

      return BiometricAuthResult(
        success: success,
        biometricKind: config.biometricKind,
      );
    } on PlatformException catch (e) {
      throw BiometricException('Platform error while authenticating', cause: e);
    } catch (e) {
      throw BiometricException('Unknown error while authenticating', cause: e);
    }
  }
}
