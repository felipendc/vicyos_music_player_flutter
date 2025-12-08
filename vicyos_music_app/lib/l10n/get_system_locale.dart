import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

Locale getAppLocale() {
  // Get the system locale
  final systemLocale = WidgetsBinding.instance.platformDispatcher.locale;
  final languageCode = systemLocale.languageCode;

  // If the user's device language is Portuguese,
  // set pt_BR as the app default language. Otherwise, set English as the app default language
  if (languageCode == 'pt') {
    return const Locale('pt', 'BR');
  } else {
    return const Locale('en');
  }
}
