import 'dart:ui';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class LanguagesConstant {
  static const localesPath = 'lib/assets/locales/';
  static const supportedLanguages = ['fr', 'en', 'br'];
  static const List<Locale> supportedLocales = [
    Locale('en', 'US'),
    Locale('fr', 'FR'),
    Locale('pt', 'BR'),
  ];
  static const Locale defaultLocale = Locale('en', 'US');
  static const localizationDelegates = [
    // TranslateService.delegate,
    AppLocalizations.delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
  ];
}