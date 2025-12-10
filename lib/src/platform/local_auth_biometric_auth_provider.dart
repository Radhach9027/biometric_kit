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
      // 1) Is device capable of *any* biometrics?
      final bool isSupported = await _localAuth.isDeviceSupported();
      if (!isSupported) {
        return BiometricSupportStatus.noHardware;
      }

      // 2) Are biometrics enrolled?
      final bool canCheck = await _localAuth.canCheckBiometrics;
      if (!canCheck) {
        return BiometricSupportStatus.notEnrolled;
      }

      return BiometricSupportStatus.supported;
    } on PlatformException {
      return BiometricSupportStatus.unknown;
    }
  }

  @override
  Future<BiometricCapabilities> getCapabilities() async {
    try {
      final status = await checkSupport();

      if (status != BiometricSupportStatus.supported) {
        return BiometricCapabilities(
          status: status,
          availableKinds: const <BiometricKind>{},
        );
      }

      final List<BiometricType> available =
          await _localAuth.getAvailableBiometrics();

      final kinds = <BiometricKind>{};

      if (available.contains(BiometricType.face)) {
        kinds.add(BiometricKind.face);
      }

      if (available.contains(BiometricType.fingerprint) ||
          available.contains(BiometricType.strong) ||
          available.contains(BiometricType.weak)) {
        kinds.add(BiometricKind.fingerprint);
      }

      return BiometricCapabilities(
        status: status,
        availableKinds: kinds,
      );
    } on PlatformException {
      return const BiometricCapabilities(
        status: BiometricSupportStatus.unknown,
        availableKinds: <BiometricKind>{},
      );
    }
  }

  @override
  Future<BiometricAuthResult> authenticate({
    required String reason,
    BiometricKind kind = BiometricKind.any,
    bool useErrorDialogs = true,
    bool stickyAuth = false,
  }) async {
    try {
      final List<BiometricType> available =
          await _localAuth.getAvailableBiometrics();

      // Check if requested kind exists
      // Check if requested kind exists
      final bool hasWantedType = switch (kind) {
        BiometricKind.any => available.isNotEmpty,
        BiometricKind.face => available.contains(BiometricType.face),
        BiometricKind.fingerprint =>
          available.contains(BiometricType.fingerprint) ||
              available.contains(BiometricType.strong) ||
              available.contains(BiometricType.weak),
        BiometricKind.strong => available.contains(BiometricType.strong),
        BiometricKind.weak => available.contains(BiometricType.weak),
      };

      if (!hasWantedType) {
        throw BiometricException(
          'Requested biometric kind ($kind) not available',
        );
      }

      // For BiometricKind.any, report what we actually used.
      final BiometricKind effectiveKind = switch (kind) {
        BiometricKind.any => () {
            if (available.contains(BiometricType.face)) {
              return BiometricKind.face;
            }
            if (available.contains(BiometricType.strong)) {
              return BiometricKind.strong;
            }
            if (available.contains(BiometricType.weak)) {
              return BiometricKind.weak;
            }
            return BiometricKind.fingerprint;
          }(),
        _ => kind,
      };

      final bool success = await _localAuth.authenticate(
        localizedReason: reason,
        options: AuthenticationOptions(
          biometricOnly: true,
          useErrorDialogs: useErrorDialogs,
          stickyAuth: stickyAuth,
        ),
      );

      return BiometricAuthResult(
        success: success,
        biometricKind: effectiveKind,
      );
    } on PlatformException catch (e) {
      throw BiometricException(
        'Platform error while authenticating',
        cause: e,
      );
    } catch (e) {
      throw BiometricException(
        'Unknown error while authenticating',
        cause: e,
      );
    }
  }
}
