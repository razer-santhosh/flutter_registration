import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../constants.dart';

int addOnData = 0,
    quizData = 0,
    referenceData = 0,
    selfvideoData = 0,
    syllabusData = 0,
    interviewData = 0;
double iconSize = 14.0;
int bottomIndex = 0;

Color noDataTitleShade = const Color(0xffabb8d6);
Color noDataSubTitleShade = const Color(0xffabb8d6);

class ThemeProvider extends ChangeNotifier {
  ThemeMode themeMode = ThemeMode.light;
  bool get isDrkMode => themeMode == ThemeMode.dark;



  set toggleTheme(bool isOn) {
    themeMode = isOn ? ThemeMode.dark : ThemeMode.light;
    //print("themeMode $themeMode");
    notifyListeners();
  }
}

class MyTheme {
  static final lightTheme = ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: const Color(0xFFEEEEEE),
      dialogBackgroundColor: Colors.white,
      appBarTheme: const AppBarTheme(
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: colorCode,
          statusBarBrightness: Brightness.light,
          statusBarIconBrightness: Brightness.light,
        ),
      ),
      splashColor: colorCode.withOpacity(0.3),
      primaryTextTheme:
          ThemeData.fallback().textTheme.apply(fontFamily: 'OpenSans'),
      fontFamily: 'OpenSans',
      textSelectionTheme: const TextSelectionThemeData(
          selectionHandleColor: Colors.blue,
          selectionColor: Colors.blue,
          cursorColor: Colors.blue),
      primarySwatch: Colors.blue,
      primaryColorLight: colorCode,
      primaryColor: Colors.white);


  static final darkTheme = ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: const Color(0xFF5E5E5E),
      dialogBackgroundColor: Colors.black,
      appBarTheme: const AppBarTheme(
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: colorCode,
          statusBarBrightness: Brightness.dark,
          statusBarIconBrightness: Brightness.dark,
        ),
      ),
      splashColor: colorCode.withOpacity(0.3),
      primaryTextTheme:
      ThemeData.fallback().textTheme.apply(fontFamily: 'OpenSans'),
      fontFamily: 'OpenSans',
      textSelectionTheme: const TextSelectionThemeData(
          selectionHandleColor: Colors.blue,
          selectionColor: Colors.blue,
          cursorColor: Colors.blue),
      primarySwatch: Colors.blue,
      primaryColorLight: colorCode,
      primaryColor: Colors.black);

  static const statusbarcolor = SystemUiOverlayStyle(
      statusBarColor: colorCode, statusBarIconBrightness: Brightness.light);

  static const statusbardark = SystemUiOverlayStyle(
      statusBarColor: colorCode, statusBarIconBrightness: Brightness.dark);
}
