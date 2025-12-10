abstract class BiometricPreferenceStore {
  const BiometricPreferenceStore();

  /// Return whether biometrics are enabled for a given user ID.
  Future<bool> isEnabledForUser(String userId);

  /// Set preference after a successful opt-in.
  Future<void> setEnabledForUser(String userId, bool enabled);
}
