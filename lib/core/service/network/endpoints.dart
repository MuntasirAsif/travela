class Endpoints {
  static const base = 'http://10.10.10.3:5000/api';
  static const searchBase = 'https://search.travela.xyz/api';

  /// Search (public, no auth)
  static const String popularLocations = '/popular-locations';
  static const String searchStream = '/search/stream';

  /// Authentication
  static const String register = '/auth/register/';
  static const String login = '/auth/login';
  static const String forgotPassword = '/auth/forgot_password/';
  static const String resetPassword = '/auth/reset_password/';
  static const String refreshToken = '/auth/refresh_token/';

  /// OTP
  static const String verifyOtp = '/otp/verify_otp/';
  static const String resendOtp = '/otp/resend_otp/';
}
