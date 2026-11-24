import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

enum AppEnvironment { development, staging, production }

class AppSettings {
  const AppSettings([this.environment = AppEnvironment.development]);

  final AppEnvironment environment;

  static const String _envBaseUrl = String.fromEnvironment('APEX_API_URL');
  static const String _apiKey = '';
  static const String _sessionSecretKey = 'apexgarage_session';
  static const String _defaultCountryCode = 'LK';
  static const List<String> _countryCodes = ['+94'];

  String get baseUrl {
    if (_envBaseUrl.isNotEmpty) return _envBaseUrl;
    switch (environment) {
      case AppEnvironment.production:
        return 'https://api.apexgarage.lk';
      case AppEnvironment.staging:
        return 'https://staging-api.apexgarage.lk';
      case AppEnvironment.development:
        return 'http://192.168.1.35:8000';
    }
  }

  String get apiKey => _apiKey;
  String get sessionSecretKey => _sessionSecretKey;
  String get defaultCountryCode => _defaultCountryCode;
  List<String> get countryCodes => _countryCodes;

  String getDevicePlatform() {
    if (kIsWeb) return 'web';
    if (Platform.isAndroid) return 'android';
    if (Platform.isIOS) return 'ios';
    if (Platform.isMacOS) return 'macos';
    return Platform.operatingSystem;
  }

  Future<String> getDeviceId() async {
    if (kIsWeb) return 'apexgarage-web';
    final deviceInfo = DeviceInfoPlugin();
    try {
      if (Platform.isAndroid) {
        final info = await deviceInfo.androidInfo;
        return info.id;
      }
      if (Platform.isIOS) {
        final info = await deviceInfo.iosInfo;
        return info.identifierForVendor ?? 'apexgarage-ios';
      }
    } catch (_) {}
    return 'apexgarage-mobile';
  }

  static const Color primaryColor = Color(0xFF009A5E);
  static const Color primaryColorDark = Color(0xFF007D4C);
  static const Color primaryColorLight = Color(0xFF10B981);
  static const Color accentColor = Color(0xFF009A5E);

  static const Color backgroundColor = Color(0xFFFFFFFF);
  static const Color surfaceColor = Color(0xFFF7F8FA);
  static const Color errorColor = Color(0xFFEF4444);

  static const Color textColor = Color(0xFF111827);
  static const Color secondaryTextColor = Color(0xFF6B7280);
  static const Color hintTextColor = Color(0xFF9CA3AF);

  static const Color darkBackgroundColor = Color(0xFF0F172A);
  static const Color darkSurfaceColor = Color(0xFF1E293B);
  static const Color darkTextColor = Color(0xFFF8FAFC);
  static const Color darkSecondaryTextColor = Color(0xFF94A3B8);
}
