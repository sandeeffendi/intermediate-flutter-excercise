import 'dart:ui';

import 'package:flutter/foundation.dart';

class LocalizationProvider extends ChangeNotifier {
  Locale _locale = const Locale('id');
  Locale get locale => _locale;

  void setLocale(Locale locale) {
    _locale = locale;
    notifyListeners();
  }
}
