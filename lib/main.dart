import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'view/businessProfile.dart';
import 'view/locationContact.dart';
import 'view/registration.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Registration',
      routes: {
        '/business': (context) => const BusinessProfile(),
        '/contact': (context) => const LocationContact(),
      },
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.white),
        useMaterial3: true,
        appBarTheme: const AppBarTheme(
          systemOverlayStyle: SystemUiOverlayStyle(
            systemStatusBarContrastEnforced: true,
            statusBarColor: Colors.white,
          ),
        ),
        inputDecorationTheme: const InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
        ),
      ),
      debugShowCheckedModeBanner: false,
      home: const Registration(),
    );
  }
}
