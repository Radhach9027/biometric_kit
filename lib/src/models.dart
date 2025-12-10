import 'package:flutter/foundation.dart';
import 'enums.dart';

@immutable
class BiometricPromptConfig {
  const BiometricPromptConfig({
    required this.reason,
    this.useErrorDialogs = true,
    this.stickyAuth = false,
    this.biometricKind = BiometricKind.any,
  });

  /// Text shown by OS dialog: "Confirm it's you" etc.
  final String reason;

  /// Let OS show default dialogs for errors (e.g. "No fingerprints enrolled").
  final bool useErrorDialogs;

  /// On Android, keep auth active when app goes to background briefly.
  final bool stickyAuth;

  /// What kind of biometric are we asking for.
  final BiometricKind biometricKind;

  BiometricPromptConfig copyWith({
    String? reason,
    bool? useErrorDialogs,
    bool? stickyAuth,
    BiometricKind? biometricKind,
  }) {
    return BiometricPromptConfig(
      reason: reason ?? this.reason,
      useErrorDialogs: useErrorDialogs ?? this.useErrorDialogs,
      stickyAuth: stickyAuth ?? this.stickyAuth,
      biometricKind: biometricKind ?? this.biometricKind,
    );
  }
}

@immutable
class BiometricAuthResult {
  const BiometricAuthResult({
    required this.success,
    this.biometricKind,
  });

  final bool success;
  final BiometricKind? biometricKind;
}

class BiometricCapabilities {
  final BiometricSupportStatus status;
  final Set<BiometricKind> availableKinds;

  const BiometricCapabilities({
    required this.status,
    required this.availableKinds,
  });

  bool get hasFace => availableKinds.contains(BiometricKind.face);
  bool get hasFingerprint => availableKinds.contains(BiometricKind.fingerprint);

  String preferredLabel() {
    if (hasFace) return 'Face ID';
    if (hasFingerprint) return 'fingerprint';
    return 'biometrics';
  }
}
