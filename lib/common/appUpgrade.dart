// ignore_for_file: file_names

import 'dart:convert';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:flutter/material.dart';
import '../src/model/baseSideMenuModel.dart';
import 'package:package_info_plus/package_info_plus.dart';
import '../constants.dart';
import 'networkApi.dart';

//App Version Check for update Function Starts
// upGrader() async {
//   bool isUpdateAvailable = false;
//   PackageInfo packageInfo = await PackageInfo.fromPlatform();
//   String packageName = packageInfo.packageName;
//   final checker = AppVersionChecker(
//     appId: packageName,
//   );
//   checker.checkUpdate().then((value) {
//     if (value.newVersion != null) {
//       if (value.currentVersion != value.newVersion && value.canUpdate) {
//         OpenStore.instance.open(
//           androidAppBundleId: packageName, // Android app bundle package name
//         );
//         isUpdateAvailable = true;
//       } else {
//         isUpdateAvailable = false;
//       }
//     } else {
//       isUpdateAvailable = true;
//     }
//   });
//   return isUpdateAvailable;
// }
//App Version Check for update Function Ends

//App Version Check for update Function With API StartsF
upGraderApi(context) async {
  String? isUpdateAvailable = '';
  bool updateAvailable = false;
  try {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    String version = packageInfo.version;
    String buildNumber = packageInfo.buildNumber;
    //String appName = packageInfo.appName;
    String packageName = packageInfo.packageName;
    String versionWithBuildNo = "$version+$buildNumber";
    userId = await storage.read(key: 'user_id');
    appId = await storage.read(key: 'app_id') ?? baseAppId.toString();
    token = await storage.read(key: 'token');
    var body = {"package_name": packageName};
    var response =
        await NetworkAPI().postData('current_app_version', jsonEncode(body));
    if (response.statusCode == 200) {
      var versionCheck = jsonDecode(response.body);
      if (versionCheck['status'] == 200 && versionCheck['data'] != null) {
        String newVersionOnly =
            versionCheck['data'][0]['name'].toString().split('+').first;
        String newBuildNoOnly =
            versionCheck['data'][0]['name'].toString().split('+').last;
        if ((versionCheck['data'][0]['name'].trim() !=
                versionWithBuildNo.trim()) &&
            (newVersionOnly == version &&
                int.parse(buildNumber) < int.parse(newBuildNoOnly))) {
          isUpdateAvailable = versionCheck['data'][0]['name'];
          updateAvailable = true;
        } else if (newVersionOnly != version) {
          int version1Number = getExtendedVersionNumber(newVersionOnly);
          int version2Number = getExtendedVersionNumber(version);
          if (version2Number < version1Number) {
            isUpdateAvailable = versionCheck['data'][0]['name'];
            updateAvailable = true;
          } else {
            isUpdateAvailable = null;
            updateAvailable = false;
          }
        } else {
          isUpdateAvailable = null;
          updateAvailable = false;
        }
      } else {
        isUpdateAvailable = null;
        updateAvailable = false;
      }
      await storage.delete(key: "menuItems");
      bool menuContains = await storage.containsKey(key: "menuItems");
      if (menuContains) {
        var menuBars = await storage.read(key: "menuItems");
        menuItems = jsonDecode(menuBars.toString());
        /*  menuItems.sort((a,b) {
        var aNo = int.tryParse(a['priority_no'].toString()); //before -> var adate = a.expiry;
        var bNo = int.tryParse(b['priority_no'].toString()); //before -> var bdate = b.expiry;
        return aNo.compareTo(bNo); //to get the order other way just switch `adate & bdate`
      });*/
      } else {
        menuItems = null;
      }
      if (menuItems == null) {
        var menus = versionCheck['data'][0]['master_app_modules'];
        await storage.write(key: "menuItems", value: jsonEncode(menus));
        menuItems = menus;
        /* menuItems.sort((a,b) {
        var aNo = int.tryParse(a['priority_no'].toString()); //before -> var adate = a.expiry;
        var bNo = int.tryParse(b['priority_no'].toString()); //before -> var bdate = b.expiry;
        return aNo.compareTo(bNo); //to get the order other way just switch `adate & bdate`
      });*/
      }

      if (baseSideMenu.isEmpty) {
        for (int i = 0; i < menuItems.length; i++) {
          IconData icon = Icons.home_outlined;
          if (menuItems[i]["route"] == "dashboard") {
            icon = Icons.home_outlined;
          } else if (menuItems[i]["route"] == "buy-course") {
            icon = Icons.add_shopping_cart_outlined;
          } else if (menuItems[i]["route"] == "certificates") {
            icon = Icons.school_outlined;
          } else if (menuItems[i]["route"] == "profile") {
            icon = Icons.person_outlined;
          } else if (menuItems[i]["route"] == "contact-us") {
            icon = Icons.call_outlined;
          } else if (menuItems[i]["route"] == "job-apply") {
            icon = Icons.work_outline_outlined;
          } else if (menuItems[i]["route"] == "free-courses") {
            icon = Icons.menu_book_outlined;
          }
          if (baseSideMenu.isEmpty) {
            baseSideMenu.add(BaseSideMenuModel(
                bottomIndex: i,
                icon: icon,
                menu_module_name: menuItems[i]['menu_module_name'],
                route: "/${menuItems[i]['route']}"));
          } else {
            baseSideMenu.insert(
                i,
                BaseSideMenuModel(
                    bottomIndex: i,
                    icon: icon,
                    menu_module_name: menuItems[i]['menu_module_name'],
                    route: "/${menuItems[i]['route']}"));
          }

          if (i < 3) {
            if (baseSideMenu.isEmpty) {
              bottomNavBar.add(TabItem(
                title: menuItems[i]['menu_module_name'],
                icon: Icon(
                  icon,
                  color: Colors.grey,
                ),
                activeIcon: Icon(
                  icon,
                  color: Colors.white,
                ),
              ));
            } else {
              bottomNavBar.insert(
                  i,
                  TabItem(
                    title: menuItems[i]['menu_module_name'],
                    icon: Icon(
                      icon,
                      color: Colors.grey,
                    ),
                    activeIcon: Icon(
                      icon,
                      color: Colors.white,
                    ),
                  ));
            }
          }
        }
        // baseSideMenu.add(BaseSideMenuModel(
        //     bottomIndex: 5,
        //     icon: Icons.work_outline_outlined,
        //     menu_module_name: "Jobs",
        //     route: "/job-apply"));
        // baseSideMenu.add(BaseSideMenuModel(
        //     bottomIndex: 6,
        //     icon: Icons.work_outline_outlined,
        //     menu_module_name: "Free Course",
        //     route: "/free-courses"));
      }
    } else {
      isUpdateAvailable = null;
      updateAvailable = false;
    }
  } catch (e) {
    isUpdateAvailable = null;
    updateAvailable = false;
  }
  await storage.write(
      key: "updateAvailable", value: updateAvailable.toString());
  await storage.write(key: "updateVersion", value: isUpdateAvailable);

  return {
    "updateAvailable": updateAvailable,
    "updateVersion": isUpdateAvailable
  };
}
//App Version Check for update Function With API Ends

//App Extended Version Check Start
int getExtendedVersionNumber(String version) {
  // Note that if you want to support bigger version cells than 99,
  // just increase the returned versionCells multipliers
  List versionCells = version.split('.');
  versionCells = versionCells.map((i) => int.tryParse(i)).toList();
  return versionCells[0] * 10000 + versionCells[1] * 100 + versionCells[2];
}
//App Extended Version Check End

//App Version Provide Check Start
upgradeProvider() async {
  var available = await storage.read(key: 'updateAvailable');
  bool updateAvailable =
      available != null && available.toLowerCase() == "true" ? true : false;
  return updateAvailable;
}
//App Version Provide Check Ends