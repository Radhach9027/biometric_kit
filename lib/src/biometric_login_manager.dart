import 'enums.dart';
import 'exceptions.dart';
import 'biometric_kit.dart';
import 'biometric_preference_store.dart';

/// Opinionated helper for login-like flows.
class BiometricLoginManager {
  BiometricLoginManager({
    required this.userId,
    required BiometricPreferenceStore preferenceStore,
    BiometricKit? kit,
  })  : _store = preferenceStore,
        _kit = kit ?? BiometricKit.I;

  final String userId;
  final BiometricPreferenceStore _store;
  final BiometricKit _kit;

  /// Check if device can support biometrics *and* user has opted in.
  Future<bool> isBiometricLoginEnabled() async {
    final support = await _kit.checkSupport();
    if (support != BiometricSupportStatus.supported) {
      return false;
    }
    return _store.isEnabledForUser(userId);
  }

  /// Called after a successful password/OTP login when user taps "Enable".
  /// This will:
  /// 1. Run one biometric auth.
  /// 2. If success -> remember preference for this user.
  Future<bool> enableBiometricLogin({
    required String reason,
    BiometricKind kind = BiometricKind.any,
  }) async {
    final support = await _kit.checkSupport();
    if (support != BiometricSupportStatus.supported) {
      throw BiometricException(
        'Biometrics not supported or not enrolled on this device.',
      );
    }

    final result = await _kit.authenticate(
      reason: reason,
      kind: kind,
    );

    if (result.success) {
      await _store.setEnabledForUser(userId, true);
      return true;
    }
    return false;
  }

  /// Disable biometric login for this user (e.g. from settings).
  Future<void> disableBiometricLogin() =>
      _store.setEnabledForUser(userId, false);

  /// Try to login using biometrics (typical "quick login" at app start).
  ///
  /// Returns:
  /// - `true` if biometric auth succeeded.
  /// - `false` if user cancelled / not enabled / not supported.
  /// Let your app decide when to show password fallback.
  Future<bool> tryBiometricLogin({
    required String reason,
    BiometricKind kind = BiometricKind.any,
  }) async {
    final enabled = await isBiometricLoginEnabled();
    if (!enabled) return false;

    try {
      final result = await _kit.authenticate(
        reason: reason,
        kind: kind,
      );
      return result.success;
    } on BiometricException {
      // You might inspect the message and decide to clear pref
      return false;
    }
  }
}
