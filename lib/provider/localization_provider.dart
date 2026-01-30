import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalizationProvider extends ChangeNotifier {
  late Locale _currentLocale;
  late SharedPreferences _prefs;

  LocalizationProvider() {
    _initializeLocale();
  }

  Future<void> _initializeLocale() async {
    _prefs = await SharedPreferences.getInstance();
    String? savedLocale = _prefs.getString('locale');
    _currentLocale = Locale(savedLocale ?? 'en');
    notifyListeners();
  }

  Locale get currentLocale => _currentLocale;

  bool get isArabic => _currentLocale.languageCode == 'ar';
  bool get isEnglish => _currentLocale.languageCode == 'en';

  Map<String, String> get translations {
    if (isArabic) {
      return _arabicTranslations;
    } else {
      return _englishTranslations;
    }
  }

  Future<void> setLocale(String languageCode) async {
    _currentLocale = Locale(languageCode);
    await _prefs.setString('locale', languageCode);
    notifyListeners();
  }

  String translate(String key) {
    return translations[key] ?? key;
  }

  static const Map<String, String> _englishTranslations = {
    'home': 'Home',
    'profile': 'Profile',
    'settings': 'Settings',
    'theme': 'Theme',
    'language': 'Language',
    'darkMode': 'Dark Mode',
    'lightMode': 'Light Mode',
    'english': 'English',
    'arabic': 'العربية',
    'currentLanguage': 'Current Language',
    'currentTheme': 'Current Theme',
    'about': 'About',
    'version': 'Version',
    'appName': 'News App',
  };

  static const Map<String, String> _arabicTranslations = {
    'home': 'الرئيسية',
    'profile': 'الملف الشخصي',
    'settings': 'الإعدادات',
    'theme': 'المظهر',
    'language': 'اللغة',
    'darkMode': 'المظهر الداكن',
    'lightMode': 'المظهر الفاتح',
    'english': 'English',
    'arabic': 'العربية',
    'currentLanguage': 'اللغة الحالية',
    'currentTheme': 'المظهر الحالي',
    'about': 'حول التطبيق',
    'version': 'الإصدار',
    'appName': 'تطبيق الأخبار',
  };
}
