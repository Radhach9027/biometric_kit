import 'enums.dart';
import 'exceptions.dart';
import 'models.dart';
import 'platform/biometric_auth_provider.dart';
import 'platform/local_auth_biometric_auth_provider.dart';

class BiometricKit {
  BiometricKit._(this._provider);

  static BiometricKit? _instance;

  final BiometricAuthProvider _provider;

  /// Initialize with default LocalAuth provider (for production).
  factory BiometricKit.localAuth() {
    _instance ??= BiometricKit._(LocalAuthBiometricAuthProvider());
    return _instance!;
  }

  /// Initialize with a custom provider (for tests or alternative impl).
  factory BiometricKit.custom(BiometricAuthProvider provider) {
    _instance ??= BiometricKit._(provider);
    return _instance!;
  }

  /// Access global instance; make sure to call `localAuth()` or `custom()` once.
  static BiometricKit get I {
    if (_instance == null) {
      throw BiometricException(
        'BiometricKit is not initialized. '
        'Call BiometricKit.localAuth() or BiometricKit.custom(...) first.',
      );
    }
    return _instance!;
  }

  Future<BiometricSupportStatus> checkSupport() => _provider.checkSupport();

  Future<BiometricAuthResult> authenticate({
    required String reason,
    BiometricKind kind = BiometricKind.any,
    bool useErrorDialogs = true,
    bool stickyAuth = false,
  }) =>
      _provider.authenticate(
        reason: reason,
        kind: kind,
        useErrorDialogs: useErrorDialogs,
        stickyAuth: stickyAuth,
      );
}
