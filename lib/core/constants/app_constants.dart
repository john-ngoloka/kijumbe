class AppConstants {
  // API Constants
  static const String baseUrl = 'https://api.kijumbe.com';
  static const String apiVersion = '/v1';
  static const String loginEndpoint = '/auth/login';
  static const String logoutEndpoint = '/auth/logout';
  static const String refreshTokenEndpoint = '/auth/refresh';

  // Storage Keys
  static const String accessTokenKey = 'access_token';
  static const String refreshTokenKey = 'refresh_token';
  static const String userDataKey = 'user_data';
  static const String isLoggedInKey = 'is_logged_in';

  // Database
  static const String databaseName = 'kijumbe_db';
  static const int databaseVersion = 1;

  // Timeouts
  static const int connectTimeout = 30000; // 30 seconds
  static const int receiveTimeout = 30000; // 30 seconds
  static const int sendTimeout = 30000; // 30 seconds

  // Validation
  static const int minPasswordLength = 6;
  static const int maxPasswordLength = 50;
  static const String phoneRegex = r'^\+?[1-9]\d{1,14}$';

  // Error Messages
  static const String networkErrorMessage =
      'Network error. Please check your connection.';
  static const String serverErrorMessage =
      'Server error. Please try again later.';
  static const String unknownErrorMessage = 'An unknown error occurred.';
  static const String invalidCredentialsMessage =
      'Invalid phone number or password.';
  static const String sessionExpiredMessage =
      'Your session has expired. Please login again.';
}
