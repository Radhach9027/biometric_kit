enum BiometricKind {
  any,
  strong,
  weak,
  face,
  fingerprint,
}

enum BiometricSupportStatus {
  supported,
  noHardware,
  notEnrolled,
  lockedOut,
  unknown,
}
