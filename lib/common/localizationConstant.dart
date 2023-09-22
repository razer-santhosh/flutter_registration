// ignore_for_file: constant_identifier_names, file_names

import 'package:flutter/material.dart';
import '../constants.dart';
import 'applicationLocalizations.dart';

const String LAGUAGE_CODE = 'languageCode';

//languages code
const String ENGLISH = 'en';
const String TAMIL = 'ta';

Future<Locale> setLocale(String languageCode) async {
  await storage.write(key: LAGUAGE_CODE, value: languageCode);
  return _locale(languageCode);
}

Future<Locale> getLocale() async {
  var lang = await storage.read(key: LAGUAGE_CODE);
  String languageCode = lang != null ? lang.toString() : "en";
  return _locale(languageCode);
}

Locale _locale(String languageCode) {
  switch (languageCode) {
    case ENGLISH:
      return const Locale(ENGLISH, 'US');
    case TAMIL:
      return const Locale(TAMIL, "IN");
    default:
      return const Locale(ENGLISH, 'US');
  }
}

String getTranslated(BuildContext context, String key) {
  return ApplicationLocalizations.of(context)!.translate(key);
}
