class AuthResult {
  final bool success;
  final bool requiresOtp;
  final String message;
  final String? otpSessionId;

  const AuthResult({
    required this.success,
    required this.requiresOtp,
    required this.message,
    this.otpSessionId,
  });

  factory AuthResult.success({String message = 'Success'}) {
    return AuthResult(success: true, requiresOtp: false, message: message);
  }

  factory AuthResult.otpRequired({
    required String otpSessionId,
    String message = 'OTP verification required',
  }) {
    return AuthResult(
      success: true,
      requiresOtp: true,
      message: message,
      otpSessionId: otpSessionId,
    );
  }

  factory AuthResult.failure(String message) {
    return AuthResult(success: false, requiresOtp: false, message: message);
  }
}
