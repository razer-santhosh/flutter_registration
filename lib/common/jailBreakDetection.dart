// ignore_for_file: file_names

import 'dart:io';
import 'package:flutter/services.dart';
import 'package:flutter_jailbreak_detection/flutter_jailbreak_detection.dart';

Future<bool> checkJailbrokenOrRooted() async {
  bool jailbrokenOrRooted = true;
  try {
    if (Platform.isAndroid) {
      jailbrokenOrRooted = await FlutterJailbreakDetection.developerMode;
    } else if (Platform.isIOS) {
      jailbrokenOrRooted = await FlutterJailbreakDetection.jailbroken;
    } else {
      jailbrokenOrRooted = true;
    }
    return jailbrokenOrRooted;
  } on PlatformException {
    jailbrokenOrRooted = true;
    return jailbrokenOrRooted;
  }
}
