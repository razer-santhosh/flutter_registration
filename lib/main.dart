// ignore_for_file: prefer_const_constructors, use_build_context_synchronously
/*
 * Copyright (c) 2019-2022 Larry Aasen. All rights reserved.
 */
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_svg/svg.dart';
import 'package:http/http.dart' as http;
import 'package:lms/common/bottomNavBar.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_storage/shared_storage.dart';
import 'common/applicationLocalizations.dart';
import 'common/connection.dart';
import 'common/alertDialog.dart';
import 'common/appUpgrade.dart';
import 'package:flutter/material.dart';
import 'common/networkApi.dart';
import 'common/route.dart';
import 'common/theme.dart';
import 'common/toast.dart';
import 'constants.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'env/env.dart';
import 'src/controller/loginController.dart';
// import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
// import 'package:firebase_core/firebase_core.dart';
//firebase
// import 'package:firebase_core/firebase_core.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'firebase/firebase_options.dart';

//Global Variable Declaration Starts
List<UriPermission>? persistPermissionUris;
List<UriPermission>? get persistentPermissionUris {
  if (persistPermissionUris == null) return null;

  return List.from(persistPermissionUris!)
    ..sort((a, z) => z.persistedTime - a.persistedTime);
}

double vertical = 0.1,
    horizontal = 0.0,
    padding = 0.0,
    containerHeight = 0.0,
    containerWidth = 0.0,
    fullScreen = 0.0;
dynamic currentScreen = '';
int currentIndex = 1;
//Global Variable Declaration Ends

//Http Override Bad Certificate Class Starts
class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}
//Http Override Bad Certificate Class Ends

// //flutter local notification
FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();
// const AndroidInitializationSettings initializationSettingsAndroid =
//     AndroidInitializationSettings('@mipmap/ic_launcher_round');

// //firebase background notification
// @pragma('vm:entry-point')
// Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
//   await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
//   await setupFlutterNotifications();
// }

//to show background notification
// late AndroidNotificationChannel channel;
// bool isFlutterLocalNotificationsInitialized = false;
// Future<void> setupFlutterNotifications() async {
//   final InitializationSettings initializationSettings = InitializationSettings(
//     android: initializationSettingsAndroid,
//   );
//   await flutterLocalNotificationsPlugin.initialize(
//     initializationSettings,
//   );
//   if (isFlutterLocalNotificationsInitialized) {
//     return;
//   }
//   channel = const AndroidNotificationChannel(
//     'high_importance_channel', // id
//     'High Importance Notifications', // title
//     description:
//         'This channel is used for important notifications.', // description
//     importance: Importance.high,
//   );

//   // Create an Android Notification Channel.
//   // We use this channel in the `AndroidManifest.xml` file to override the
//   // default FCM channel to enable heads up notifications.
//   await flutterLocalNotificationsPlugin
//       .resolvePlatformSpecificImplementation<
//           AndroidFlutterLocalNotificationsPlugin>()
//       ?.createNotificationChannel(channel);
//   isFlutterLocalNotificationsInitialized = true;
//   //firebase background notification click functions
//   FirebaseMessaging.instance.getInitialMessage();
//   FirebaseMessaging.onMessage.listen(showFlutterNotification);
//   FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
//     //redirect to a page depend on notification payload here
//     print('Open desired page background ${message.data}');
//   });
// }

// //to show foreground notification
// void showFlutterNotification(RemoteMessage message) async {
//   var notification = message.notification!;
//   AndroidNotificationDetails androidPlatformChannelSpecifics =
//       const AndroidNotificationDetails('progress channel', 'progress channel',
//           channelShowBadge: false,
//           importance: Importance.max,
//           priority: Priority.high,
//           onlyAlertOnce: true,
//           showProgress: true);
//   NotificationDetails platformChannelSpecifics =
//       NotificationDetails(android: androidPlatformChannelSpecifics);
//   flutterLocalNotificationsPlugin.show(notification.hashCode,
//       notification.title, notification.body, platformChannelSpecifics,
//       payload: notification.body);
//   final InitializationSettings initializationSettings = InitializationSettings(
//     android: initializationSettingsAndroid,
//   );
//   await flutterLocalNotificationsPlugin.initialize(
//     initializationSettings,
//     onDidReceiveNotificationResponse:
//         (NotificationResponse notificationResponse) {
//       print('Open desired page foreground ${message.data}');
//     },
//   );
// }

//Main Function Starts
Future<void> main() async {
  //Initialize Global Data Starts
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  // await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  // final PendingDynamicLinkData? data =
  //     await FirebaseDynamicLinks.instance.getInitialLink();
  // if (data != null && data.link != null) {}
  // final String deepLink = jsonEncode(data?.link.queryParameters);
  // var temp = await storage.read(key: 'deep');
  // if (temp == null || temp == 'null') {
  //   await storage.write(key: 'deep', value: deepLink.toString());
  // }
  token = await storage.read(key: 'token');
  userName = await storage.read(key: 'username');
  baseSideMenu = [];
  bottomNavBar = [];
  profilePicture = await storage.read(key: 'profile_picture');
  await storage.write(key: 'app_first_time', value: '1');
  if (profilePicture != null) {
    String decodeProfile = profilePicture.split(',').last;
    final decodeString = base64.decode(decodeProfile.toString());
    encodedImage = decodeString;
  }
  if (Platform.isAndroid) {
    await releasePersistableUriPermission(Uri.parse(Env.kDownloadsFolder));
    persistPermissionUris = await persistedUriPermissions();
  }
  HttpOverrides.global = MyHttpOverrides();
  // bool jailbroken = await FlutterJailbreakDetection.jailbroken;
  // bool developerMode = false;
  // if(Platform.isAndroid) {
  //   developerMode = await FlutterJailbreakDetection
  //       .developerMode; // android only.
  // }
  /*  if(jailbroken || developerMode){
    await NetworkAPI().logCheckApi();
  }*/
  //Initialize Global Data Ends
  // //firebase initialization
  // await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  // final fcmToken = await FirebaseMessaging.instance.getToken();
  // print('fcm - $fcmToken');
  // FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  // await setupFlutterNotifications();
  //Start App
  runApp(App());
}

//Main Function Ends
// App Widget Class Starts
class App extends StatefulWidget {
  const App({Key? key}) : super(key: key);

  static void setLocale(BuildContext context, Locale newLocale) {
    _AppState? state = context.findAncestorStateOfType<_AppState>();
    state?.setLocale(newLocale);
  }

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> with SingleTickerProviderStateMixin {
  //Variable Declaration Starts
  late final AnimationController controller;
  late final Animation<Offset> offsetAnimation;
  bool splashLoading = true;
  Locale? _locale;
  setLocale(Locale locale) {
    setState(() {
      _locale = locale;
    });
  }
  //Variable Declaration Ends

  //Initialize the State Starts
  @override
  void initState() {
    super.initState();
    //Animation Initialization
    upGraderApi(context);
    bottomIndex = 0;
    http.Client client = http.Client();
    controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);

    offsetAnimation = Tween<Offset>(
      begin: Offset.zero,
      end: const Offset(1.5, 0.0),
    ).animate(CurvedAnimation(
      parent: controller,
      curve: Curves.elasticIn,
    ));
    Future.delayed(const Duration(seconds: 3)).then((value) async {
      await storage.write(key: 'bottom_index', value: "0");
      setState(() {
        splashLoading = false;
        client;
      });
    });
  }
  //Initialize the State Ends

  //Main Widget Starts
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);
    //Variable Declaration Inside Widget
    double height = size.height;
    double width = size.width;
    precacheImage(AssetImage(preCacheImage), context);
    //Widget Return Starts
    //Splash Screen and Router Begins
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => ConnectivityProvider()),
          ChangeNotifierProvider(create: (_) => AppUpgradeProvider()),
          // ChangeNotifierProvider(create: (_) => ThemeProvider())
        ],
        child: splashLoading && baseSideMenu.isEmpty
            ? Container(
                color: splashColorCode,
                child: Center(
                  child: SlideTransition(
                    position: offsetAnimation,
                    child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: appId == "11"
                            ? SvgPicture.asset(
                                logo,
                                width: width * 0.45,
                                height: height * 0.22,
                              )
                            : SvgPicture.asset(
                                logo,
                              )),
                  ),
                ),
              )
            : MaterialApp.router(
                routerConfig: routesData(),
                title: appTitle,
                locale: _locale,
                supportedLocales: const [
                  Locale("en", "US"),
                  Locale("ta", "IN")
                ],
                localizationsDelegates: const [
                  ApplicationLocalizations.delegate,
                  GlobalMaterialLocalizations.delegate,
                  GlobalWidgetsLocalizations.delegate,
                  GlobalCupertinoLocalizations.delegate,
                ],
                localeResolutionCallback: (locale, supportedLocales) {
                  for (var supportedLocale in supportedLocales) {
                    if (supportedLocale.languageCode == locale!.languageCode &&
                        supportedLocale.countryCode == locale.countryCode) {
                      return supportedLocale;
                    }
                  }
                  return supportedLocales.first;
                },
                debugShowCheckedModeBanner: false,
                theme: MyTheme.lightTheme,
                // darkTheme: MyTheme.darkTheme,
                // themeMode: ThemeMode.system,
              ));
    //Widget Return Ends
  }
//Main Widget Ends
//dynamic link
// initDynamicLinks(BuildContext context) async {
//   await Future.delayed(Duration(seconds: 3));
//   var data = await FirebaseDynamicLinks.instance.getInitialLink();
//   var deepLink = data?.link;
//   final queryParams = deepLink.queryParameters;
//   if (queryParams.length > 0) {
//     var userName = queryParams['userId'];
//   }
//   FirebaseDynamicLinks.instance.onLink(onSuccess: (dynamicLink) async {
//     var deepLink = dynamicLink?.link;
//     debugPrint('DynamicLinks onLink $deepLink');
//   }, onError: (e) async {
//     debugPrint('DynamicLinks onError $e');
//   });
// }
}
// App Widget Class Ends

//MyApp Widget Class Starts
class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  //Initialize  the State Starts
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 0)).then((value) async {
      var oldVersion = await storage.read(key: 'appVersion');
      final currentVersion = await PackageInfo.fromPlatform();
      if (oldVersion !=
          "${currentVersion.version}+${currentVersion.buildNumber}") {
        var logResult = await NetworkAPI().logAPI();
        if (!logResult['status']) {
          await messageFlushBar(context, logResult['message'], 6);
          if (token != null || token != '') {
            await LoginController().logout().then((value) => context.push('/'));
          }
        } else {
          await storage.write(
              key: 'appVersion',
              value: "${currentVersion.version}+${currentVersion.buildNumber}");
        }
      }
    });
  }
  //Initialize  the State Ends

  @override
  void dispose() {
    super.dispose();
  }

  //Main Widget Starts
  @override
  Widget build(context) {
    //Widget Return Starts
    // Choose the first Screen of the app
    return WillPopScope(
        onWillPop: () async {
          // Exit When App First screen back or Go to the first screen
          if (bottomIndex != 0) {
            setState(() {
              bottomIndex = 0;
            });
            context.pushNamed('/');
          } else {
            showExitPopup(context);
          }
          await storage.write(
              key: 'bottom_index', value: bottomIndex.toString());
          return false; // return true if the route to be popped
        },
        child: const BottomNavigationPage());
    //Widget Return Ends
  }
  //Main Widget Ends
}
//MyApp Widget Class Ends
