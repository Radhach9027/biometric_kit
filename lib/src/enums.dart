
/// High-level kind of biometric you want to require.
enum BiometricKind {
  /// Any biometric the OS considers strong enough.
  any,

  /// Explicitly FaceID / Face auth (where available).
  face,

  /// Explicitly fingerprint / TouchID (where available).
  fingerprint,
}

/// Status of biometric support on this device.
enum BiometricSupportStatus {
  supported,
  noHardware,
  hardwareUnavailable,
  notEnrolled,
  unknown,
}