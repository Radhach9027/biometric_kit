class BiometricException implements Exception {
  BiometricException(this.message, {this.cause});

  final String message;
  final Object? cause;

  @override
  String toString() => 'BiometricException($message, cause: $cause)';
}
