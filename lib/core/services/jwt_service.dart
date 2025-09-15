import 'dart:convert';
import 'dart:math';
import 'package:injectable/injectable.dart';

@LazySingleton()
class JWTService {
  static const String _secret = 'kijumbe_secret_key_2024';
  static const int _accessTokenExpiryHours = 1;
  static const int _refreshTokenExpiryDays = 30;

  /// Generate a simulated JWT access token
  String generateAccessToken({
    required int userId,
    required String phone,
    required String name,
  }) {
    final now = DateTime.now();
    final expiry = now.add(Duration(hours: _accessTokenExpiryHours));

    final payload = {
      'sub': userId.toString(),
      'phone': phone,
      'name': name,
      'iat': now.millisecondsSinceEpoch ~/ 1000,
      'exp': expiry.millisecondsSinceEpoch ~/ 1000,
      'type': 'access',
    };

    return _encodeJWT(payload);
  }

  /// Generate a simulated JWT refresh token
  String generateRefreshToken({required int userId, required String phone}) {
    final now = DateTime.now();
    final expiry = now.add(Duration(days: _refreshTokenExpiryDays));

    final payload = {
      'sub': userId.toString(),
      'phone': phone,
      'iat': now.millisecondsSinceEpoch ~/ 1000,
      'exp': expiry.millisecondsSinceEpoch ~/ 1000,
      'type': 'refresh',
    };

    return _encodeJWT(payload);
  }

  /// Decode and validate a JWT token
  Map<String, dynamic>? decodeToken(String token) {
    try {
      final parts = token.split('.');
      if (parts.length != 3) return null;

      final payload = parts[1];
      final normalized = base64Url.normalize(payload);
      final decoded = utf8.decode(base64Url.decode(normalized));

      final payloadMap = jsonDecode(decoded) as Map<String, dynamic>;

      // Check if token is expired
      final exp = payloadMap['exp'] as int?;
      if (exp != null) {
        final expiryTime = DateTime.fromMillisecondsSinceEpoch(exp * 1000);
        if (DateTime.now().isAfter(expiryTime)) {
          return null; // Token expired
        }
      }

      return payloadMap;
    } catch (e) {
      return null;
    }
  }

  /// Check if a token is expired
  bool isTokenExpired(String token) {
    final payload = decodeToken(token);
    if (payload == null) return true;

    final exp = payload['exp'] as int?;
    if (exp == null) return true;

    final expiryTime = DateTime.fromMillisecondsSinceEpoch(exp * 1000);
    return DateTime.now().isAfter(expiryTime);
  }

  /// Generate a new access token from refresh token
  String? refreshAccessToken(String refreshToken) {
    final payload = decodeToken(refreshToken);
    if (payload == null) return null;

    final userId = int.tryParse(payload['sub']?.toString() ?? '');
    final phone = payload['phone']?.toString();

    if (userId == null || phone == null) return null;

    // Generate new access token with same user info
    return generateAccessToken(
      userId: userId,
      phone: phone,
      name: payload['name']?.toString() ?? 'User',
    );
  }

  /// Encode JWT token (simplified version)
  String _encodeJWT(Map<String, dynamic> payload) {
    final header = {'alg': 'HS256', 'typ': 'JWT'};

    final headerEncoded = base64Url.encode(utf8.encode(jsonEncode(header)));
    final payloadEncoded = base64Url.encode(utf8.encode(jsonEncode(payload)));

    // In a real implementation, you would sign with HMAC-SHA256
    // For simulation, we'll create a simple signature
    final signature = _generateSignature(headerEncoded, payloadEncoded);

    return '$headerEncoded.$payloadEncoded.$signature';
  }

  /// Generate a simple signature for simulation
  String _generateSignature(String header, String payload) {
    final data = '$header.$payload';
    final bytes = utf8.encode(data + _secret);

    // Simple hash simulation
    var hash = 0;
    for (final byte in bytes) {
      hash = ((hash << 5) - hash + byte) & 0xffffffff;
    }

    return base64Url.encode(hash.toString().codeUnits);
  }

  /// Generate a unique user ID
  int generateUserId() {
    final random = Random();
    return DateTime.now().millisecondsSinceEpoch + random.nextInt(1000);
  }
}
