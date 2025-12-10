import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../biometric_preference_store.dart';

class SecureStorageBiometricPreferenceStore
    implements BiometricPreferenceStore {
  SecureStorageBiometricPreferenceStore({
    FlutterSecureStorage? storage,
    String prefix = 'biometric_pref_',
  })  : _storage = storage ?? const FlutterSecureStorage(),
        _prefix = prefix;

  final FlutterSecureStorage _storage;
  final String _prefix;

  String _keyForUser(String userId) => '$_prefix$userId';

  @override
  Future<bool> isEnabledForUser(String userId) async {
    final value = await _storage.read(key: _keyForUser(userId));
    return value == '1';
  }

  @override
  Future<void> setEnabledForUser(String userId, bool enabled) {
    if (enabled) {
      return _storage.write(key: _keyForUser(userId), value: '1');
    } else {
      return _storage.delete(key: _keyForUser(userId));
    }
  }
}
