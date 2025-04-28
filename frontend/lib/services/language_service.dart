import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LanguageService {
  static const String prefKey = 'language_code';
  
  // Get the saved language code
  static Future<String> getLanguageCode() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString(prefKey) ?? 'mr'; // Default to Marathi
    } catch (e) {
      print('Error getting language code: $e');
      return 'mr'; // Default to Marathi on error
    }
  }
  
  // Save the language code
  static Future<bool> setLanguageCode(String languageCode) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return await prefs.setString(prefKey, languageCode);
    } catch (e) {
      print('Error setting language code: $e');
      return false;
    }
  }
  
  // Get the locale from language code
  static Locale getLocaleFromCode(String code) {
    switch (code) {
      case 'mr':
        return const Locale('mr');
      case 'hi':
        return const Locale('hi');
      case 'en':
        return const Locale('en');
      default:
        return const Locale('mr');
    }
  }
  
  // Get language name from code
  static String getLanguageName(String code, BuildContext context) {
    switch (code) {
      case 'mr':
        return 'मराठी';
      case 'hi':
        return 'हिंदी';
      case 'en':
        return 'English';
      default:
        return 'Unknown';
    }
  }
}
