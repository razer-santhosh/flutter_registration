// ignore_for_file: use_build_context_synchronously, file_names, invalid_return_type_for_catch_error
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:native_updater/native_updater.dart';
import 'package:open_store/open_store.dart';
import 'package:package_info_plus/package_info_plus.dart';
import '../constants.dart';
import '../main.dart';
import '../src/view/login.dart';
import 'appUpgrade.dart';

class AppUpdate extends StatefulWidget {
  const AppUpdate({Key? key}) : super(key: key);

  @override
  State<AppUpdate> createState() => _AppUpdateState();
}

class _AppUpdateState extends State<AppUpdate> {
  bool updateNow = false;
  String appName = '',
      versionLatest = '',
      version = '',
      buildNumber = '',
      packageName = '',
      versionWithBuildNo = '';
  //Initialize State Starts
  @override
  void initState() {
    super.initState();
    checkAppUpdate();
  }
  //Initialize State Ends

  @override
  void dispose() {
    super.dispose();
  }

  //Main Widget Starts
  @override
  Widget build(BuildContext context) {
    NativeUpdater.displayUpdateAlert(
      context,
      forceUpdate: true,
      appStoreUrl: '',
    );
    //Widget Return Starts
    return WillPopScope(
        onWillPop: () async => false,
        child: Scaffold(
          backgroundColor: Colors.white,
          body: (updateNow)
              ? Container(
                  padding: const EdgeInsets.all(10.0),
                  color: Colors.white,
                  alignment: Alignment.center,
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SvgPicture.asset(
                          logoLogin,
                          width: 170,
                          height: 60,
                          fit: BoxFit.contain,
                        ),
                        Flexible(
                          child: Padding(
                            padding: const EdgeInsets.only(
                              left: 40.0,
                              right: 30.0,
                              top: 10.0,
                              bottom: 10.0,
                            ),
                            child: Text(
                              "A new version $versionLatest of $appName is available!\nyou have $version+$buildNumber",
                              style: const TextStyle(
                                color: Colors.black54,
                              ),
                              maxLines: 4,
                              textAlign: TextAlign.justify,
                              softWrap: true,
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        ElevatedButton(
                          onPressed: () async {
                            if(Platform.isAndroid) {
                              await OpenStore.instance.open(
                                androidAppBundleId:
                                packageName, // Android app bundle package name
                              );
                            }else{
                              await OpenStore.instance.open(
                                appStoreId:
                                '', // Android app bundle package name
                              );
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: colorCode,
                            textStyle: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text('Update Now',
                              style: TextStyle(color: Colors.white)),
                        ),
                      ]))
              : Center(
                  child: Container(
                      color: Colors.transparent,
                      child: const CircularProgressIndicator(
                        color: colorCode,
                      ))),
        ));
  }

  checkAppUpdate() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    var mapData = await upGraderApi(context);
    setState(() {
      version = packageInfo.version;
      buildNumber = packageInfo.buildNumber;
      appName = packageInfo.appName;
      packageName = packageInfo.packageName;
      versionWithBuildNo = "${version.toString()}+${buildNumber.toString()}";
      versionLatest = mapData['updateVersion'] ?? '';
      updateNow = mapData['updateAvailable'] ?? false;
    });

    if (!updateNow) {
      if (token != null) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const MyApp()),
        );
      } else {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const LoginLive()),
        );
      }
    }
  }
}
