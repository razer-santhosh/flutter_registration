// ignore_for_file: override_on_non_overriding_member, file_names

import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../constants.dart';

class ApplicationLocalizations {
  ApplicationLocalizations(this.locale);

  final Locale? locale;

  static ApplicationLocalizations? of(BuildContext context) {
    return Localizations.of<ApplicationLocalizations>(
        context, ApplicationLocalizations);
  }

  static const LocalizationsDelegate<ApplicationLocalizations> delegate =
      AppLocalizationsDelegate();
  Map<String, String>? _localizedStrings;

  Future<void> load() async {
    String jsonStringValues = await rootBundle
        .loadString('resources/language/${locale!.languageCode}.json');
    Map<String, dynamic> mappedJson = json.decode(jsonStringValues);
    _localizedStrings =
        mappedJson.map((key, value) => MapEntry(key, value.toString()));
  }

  // called from every widget which needs a localized text
  @override
  String translate(String? jsonKey) {
    return _localizedStrings![jsonKey]!;
  }
}

class AppLocalizationsDelegate
    extends LocalizationsDelegate<ApplicationLocalizations> {
  const AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    return ['ta', 'en'].contains(locale.languageCode);
  }

  @override
  Future<ApplicationLocalizations> load(Locale locale) async {
    ApplicationLocalizations localizations = ApplicationLocalizations(locale);
    await localizations.load();
    return localizations;
  }

  @override
  bool shouldReload(AppLocalizationsDelegate old) => false;
}

class AppLanguage extends ChangeNotifier {
  Locale? _appLocale = const Locale('en');

  Locale get appLocal => _appLocale ?? const Locale("en");

  fetchLocale() async {
    var prefs = await storage.read(key: 'language_code');
    if (prefs == null) {
      _appLocale = const Locale('en');
      return Null;
    }
    _appLocale = Locale(prefs.toString());
    return Null;
  }

  void changeLanguage(Locale type) async {
    await storage.write(key: 'language_code', value: 'ta');
    if (type == const Locale("ta")) {
      _appLocale = const Locale("ta");
      await storage.write(key: 'language_code', value: 'ta');
      await storage.write(key: 'countryCode', value: 'IN');
    } else {
      _appLocale = const Locale("en");
      await storage.write(key: 'language_code', value: 'en');
      await storage.write(key: 'countryCode', value: 'US');
    }
    notifyListeners();
    ApplicationLocalizations localizations = ApplicationLocalizations(type);
    await localizations.load();
  }
}
