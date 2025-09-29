import 'package:flutter/material.dart';

class LocaleProvider extends ChangeNotifier {
  Locale _locale = const Locale('en'); // Default to English

  Locale get locale => _locale;

  void setLocale(Locale locale) {
    if (!L10n.all.contains(locale)) return;

    _locale = locale;
    notifyListeners();
  }
}

class L10n {
  static final all = [
    const Locale('en'), // English
    const Locale('hi'), // Hindi
    const Locale('bn'), // Bengali
    const Locale('ta'), // Tamil
    const Locale('te'), // Telugu
    const Locale('mr'), // Marathi
    const Locale('gu'), // Gujarati
    const Locale('kn'), // Kannada
  ];
}