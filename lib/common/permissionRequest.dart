// ignore_for_file: file_names
import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:shared_storage/saf.dart';
import '../constants.dart';
import '../main.dart';
import 'toast.dart';
import 'package:permission_handler/permission_handler.dart';

Future<void> loadPersistedUriPermissions() async {
  await Permission.storage.request();
  persistPermissionUris = await persistedUriPermissions();
}

permissionRequest(ctx) async {
  bool granted = false;
  if (await Permission.storage.request().isGranted) {
    granted = true;
  } else {
    try {
      PermissionStatus status;
      if (Platform.isAndroid) {
        final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
        final AndroidDeviceInfo info = await deviceInfoPlugin.androidInfo;
        if ((info.version.sdkInt) >= 33) {
          await loadPersistedUriPermissions();
          status = PermissionStatus.granted;
          //status = await Permission.manageExternalStorage.request();
        } else {
          status = await Permission.storage.request();
        }
      } else {
        status = await Permission.storage.request();
      }
      switch (status) {
        case PermissionStatus.denied:
          return false;
        case PermissionStatus.granted:
          return true;
        case PermissionStatus.restricted:
          return false;
        case PermissionStatus.limited:
          return true;
        case PermissionStatus.provisional:
          return true;
        case PermissionStatus.permanentlyDenied:
          return false;
      }
    } catch (e) {
      messageFlushBar(ctx, errorMsg);
      return false;
    }
  }
  return granted;
}
