import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:local_auth/local_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'auth_models.dart';

class AuthManager {
  AuthManager._();

  static final AuthManager instance = AuthManager._();

  static const _secureStorage = FlutterSecureStorage();
  static const _keyAccessToken = 'auth_access_token';
  static const _keyRefreshToken = 'auth_refresh_token';
  static const _keyBiometricEnabled = 'auth_biometric_enabled';

  static const String _baseUrl = String.fromEnvironment(
    'SEVIX_API_BASE_URL',
    defaultValue: 'http://10.0.2.2:8080/api',
  );

  final LocalAuthentication _localAuth = LocalAuthentication();

  Uri _uri(String path) {
    final normalizedBase = _baseUrl.endsWith('/')
        ? _baseUrl.substring(0, _baseUrl.length - 1)
        : _baseUrl;
    final normalizedPath = path.startsWith('/') ? path : '/$path';
    return Uri.parse('$normalizedBase$normalizedPath');
  }

  Future<AuthResult> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await http.post(
        _uri('/auth/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'password': password}),
      );

      final body = _parseBody(response.body);
      if (response.statusCode < 200 || response.statusCode >= 300) {
        return AuthResult.failure(_extractMessage(body, 'Login failed'));
      }

      if (_isOtpRequired(body)) {
        return AuthResult.otpRequired(
          otpSessionId: _extractOtpSessionId(body, fallback: email),
          message: _extractMessage(body, 'OTP verification required'),
        );
      }

      final saved = await _extractAndSaveTokens(body);
      if (!saved) {
        return AuthResult.failure(
          'Login succeeded but tokens were not found in response.',
        );
      }

      return AuthResult.success(
        message: _extractMessage(body, 'Login successful'),
      );
    } catch (_) {
      return AuthResult.failure(
        'Unable to connect to server. Check API base URL and network.',
      );
    }
  }

  Future<AuthResult> register({
    required String fullName,
    required String email,
    required String phone,
    required String password,
  }) async {
    try {
      final response = await http.post(
        _uri('/auth/register'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'fullName': fullName,
          'name': fullName,
          'email': email,
          'phone': phone,
          'password': password,
        }),
      );

      final body = _parseBody(response.body);
      if (response.statusCode < 200 || response.statusCode >= 300) {
        return AuthResult.failure(_extractMessage(body, 'Registration failed'));
      }

      if (_isOtpRequired(body)) {
        return AuthResult.otpRequired(
          otpSessionId: _extractOtpSessionId(body, fallback: email),
          message: _extractMessage(body, 'OTP verification required'),
        );
      }

      final saved = await _extractAndSaveTokens(body);
      if (saved) {
        return AuthResult.success(
          message: _extractMessage(body, 'Registration successful'),
        );
      }

      // Most systems require OTP after signup; fallback to OTP flow.
      return AuthResult.otpRequired(
        otpSessionId: _extractOtpSessionId(body, fallback: email),
        message: _extractMessage(body, 'Verify OTP to complete sign up'),
      );
    } catch (_) {
      return AuthResult.failure(
        'Unable to connect to server. Check API base URL and network.',
      );
    }
  }

  Future<AuthResult> verifyOtp({
    required String otpSessionId,
    required String otp,
  }) async {
    try {
      final response = await http.post(
        _uri('/auth/verify-otp'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'otpSessionId': otpSessionId, 'otp': otp}),
      );

      final body = _parseBody(response.body);
      if (response.statusCode < 200 || response.statusCode >= 300) {
        return AuthResult.failure(
          _extractMessage(body, 'OTP verification failed'),
        );
      }

      final saved = await _extractAndSaveTokens(body);
      if (!saved) {
        return AuthResult.failure(
          'OTP verified but tokens were not found in response.',
        );
      }

      return AuthResult.success(
        message: _extractMessage(body, 'OTP verified successfully'),
      );
    } catch (_) {
      return AuthResult.failure(
        'Unable to connect to server. Check API base URL and network.',
      );
    }
  }

  Future<AuthResult> resendOtp({required String otpSessionId}) async {
    try {
      final response = await http.post(
        _uri('/auth/resend-otp'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'otpSessionId': otpSessionId}),
      );

      final body = _parseBody(response.body);
      if (response.statusCode < 200 || response.statusCode >= 300) {
        return AuthResult.failure(
          _extractMessage(body, 'Failed to resend OTP'),
        );
      }

      return AuthResult.success(
        message: _extractMessage(body, 'OTP resent successfully'),
      );
    } catch (_) {
      return AuthResult.failure(
        'Unable to connect to server. Check API base URL and network.',
      );
    }
  }

  Future<void> logout() async {
    await _secureStorage.delete(key: _keyAccessToken);
    await _secureStorage.delete(key: _keyRefreshToken);
  }

  Future<bool> restoreSession({required bool requireBiometric}) async {
    final refreshToken = await _secureStorage.read(key: _keyRefreshToken);
    if (refreshToken == null || refreshToken.isEmpty) {
      return false;
    }

    if (requireBiometric) {
      final verified = await _authenticateWithBiometrics();
      if (!verified) {
        return false;
      }
    }

    try {
      final response = await http.post(
        _uri('/auth/refresh'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'refreshToken': refreshToken}),
      );

      final body = _parseBody(response.body);
      if (response.statusCode < 200 || response.statusCode >= 300) {
        await logout();
        return false;
      }

      final saved = await _extractAndSaveTokens(body);
      if (!saved) {
        await logout();
        return false;
      }

      return true;
    } catch (_) {
      return false;
    }
  }

  Future<bool> getBiometricEnabled() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keyBiometricEnabled) ?? false;
  }

  Future<bool> setBiometricEnabled(bool enabled) async {
    final prefs = await SharedPreferences.getInstance();
    if (!enabled) {
      await prefs.setBool(_keyBiometricEnabled, false);
      return false;
    }

    final canUse = await _canUseBiometrics();
    if (!canUse) {
      await prefs.setBool(_keyBiometricEnabled, false);
      return false;
    }

    final verified = await _authenticateWithBiometrics();
    await prefs.setBool(_keyBiometricEnabled, verified);
    return verified;
  }

  Future<bool> _canUseBiometrics() async {
    try {
      final canCheck = await _localAuth.canCheckBiometrics;
      final supported = await _localAuth.isDeviceSupported();
      final available = await _localAuth.getAvailableBiometrics();
      return canCheck && supported && available.isNotEmpty;
    } catch (_) {
      return false;
    }
  }

  Future<bool> _authenticateWithBiometrics() async {
    try {
      return await _localAuth.authenticate(
        localizedReason: 'Authenticate to unlock your Sevix account',
        options: const AuthenticationOptions(
          biometricOnly: true,
          stickyAuth: true,
        ),
      );
    } on PlatformException {
      return false;
    }
  }

  Map<String, dynamic> _parseBody(String responseBody) {
    if (responseBody.isEmpty) return {};
    try {
      final decoded = jsonDecode(responseBody);
      if (decoded is Map<String, dynamic>) {
        return decoded;
      }
      return {};
    } catch (_) {
      return {};
    }
  }

  bool _isOtpRequired(Map<String, dynamic> body) {
    final requiresOtp =
        body['requiresOtp'] == true ||
        body['otpRequired'] == true ||
        body['requires_otp'] == true;
    return requiresOtp;
  }

  String _extractOtpSessionId(
    Map<String, dynamic> body, {
    required String fallback,
  }) {
    final nested = body['data'];
    if (nested is Map<String, dynamic>) {
      final id = nested['otpSessionId'] ?? nested['verificationId'];
      if (id != null && id.toString().isNotEmpty) {
        return id.toString();
      }
    }

    final direct = body['otpSessionId'] ?? body['verificationId'];
    if (direct != null && direct.toString().isNotEmpty) {
      return direct.toString();
    }

    return fallback;
  }

  String _extractMessage(Map<String, dynamic> body, String fallback) {
    final nested = body['data'];
    if (nested is Map<String, dynamic> && nested['message'] != null) {
      return nested['message'].toString();
    }

    final msg = body['message'] ?? body['error'] ?? body['detail'];
    if (msg == null || msg.toString().trim().isEmpty) {
      return fallback;
    }
    return msg.toString();
  }

  String? _extractToken(Map<String, dynamic> body, List<String> keys) {
    for (final key in keys) {
      final value = body[key];
      if (value is String && value.isNotEmpty) {
        return value;
      }
    }

    final data = body['data'];
    if (data is Map<String, dynamic>) {
      for (final key in keys) {
        final value = data[key];
        if (value is String && value.isNotEmpty) {
          return value;
        }
      }
    }

    return null;
  }

  Future<bool> _extractAndSaveTokens(Map<String, dynamic> body) async {
    final accessToken = _extractToken(body, [
      'accessToken',
      'access_token',
      'token',
      'jwt',
    ]);
    final refreshToken = _extractToken(body, [
      'refreshToken',
      'refresh_token',
      'refresh',
    ]);

    if (accessToken == null || refreshToken == null) {
      return false;
    }

    await _secureStorage.write(key: _keyAccessToken, value: accessToken);
    await _secureStorage.write(key: _keyRefreshToken, value: refreshToken);
    return true;
  }
}
