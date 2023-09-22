// ignore_for_file: use_build_context_synchronously, file_names
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:package_info_plus/package_info_plus.dart';
import '../constants.dart';
import '../main.dart';
import '../src/controller/loginController.dart';
import 'appUpgrade.dart';
import 'clipper.dart';
import 'theme.dart';

class BaseSideMenu extends StatefulWidget {
  const BaseSideMenu({Key? key}) : super(key: key);

  @override
  State<BaseSideMenu> createState() => _BaseSideMenuState();
}

class _BaseSideMenuState extends State<BaseSideMenu> {
  PackageInfo packageInfo = PackageInfo(
    appName: '',
    packageName: '',
    version: '',
    buildNumber: '',
  );
  bool logout = false;
  bool drawer = true;

  @override
  void initState() {
    super.initState();
    _initPackageInfo();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);
    double width = size.width;
    double height = size.height;

    return Drawer(
      surfaceTintColor: Colors.white,
      width: currentScreen == 'mobile' ? width * 0.7 : width / 2,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(bottomRight: Radius.circular(10)),
      ),
      child: SingleChildScrollView(
        child: Column(children: [
          GestureDetector(
            onTap: () async {
              setState(() {
                bottomIndex = baseSideMenu
                    .where((e) => e.route == "/profile")
                    .toList()
                    .first
                    .bottomIndex;
              });
              await storage.write(
                  key: 'bottom_index', value: bottomIndex.toString());
              context.pop();
              context.pushNamed("/profile");
            },
            child: Container(
              height: currentScreen == 'mobile' ? height * 0.25 : 190,
              alignment: Alignment.bottomCenter,
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                colors: [colorCode, colorCode.withOpacity(0.5)],
                begin: Alignment.bottomLeft,
                end: Alignment.topRight,
              )),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Center(
                      child: Container(
                    height: 80.0,
                    width: 80.0,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                    ),
                    child: encodedImage != null
                        ? ClipOval(
                            clipper: MyClip(),
                            child: FadeInImage(
                              fit: BoxFit.fill,
                              placeholderFit: BoxFit.fill,
                              placeholder: AssetImage(loading),
                              image: MemoryImage(encodedImage!),
                            ),
                          )
                        : CircleAvatar(
                            radius: 50,
                            backgroundColor:
                                const Color.fromARGB(255, 211, 205, 205)
                                    .withOpacity(0.7),
                            child: Text(
                              userName != null
                                  ? '${userName[0].toUpperCase()} ${userName[1].toUpperCase()}'
                                  : "",
                              style: const TextStyle(fontSize: 30),
                            ),
                          ),
                  )),
                  SizedBox(
                    height: width * 0.01,
                  ),
                  Text(
                      userName != null
                          ? toBeginningOfSentenceCase(userName)!
                          : "",
                      overflow: TextOverflow.ellipsis,
                      maxLines: 3,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: currentScreen == "mobile"
                              ? width * 0.04
                              : width * 0.028)),
                  if (userMobile != null) ...[
                    const Padding(
                      padding: EdgeInsets.only(bottom: 10),
                    ),
                    Text(userMobile ?? "",
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: currentScreen == "mobile"
                                ? width * 0.04
                                : width * 0.025)),
                  ],
                  const SizedBox(
                    height: 5,
                  ),
                ],
              ),
            ),
          ),
          if (baseSideMenu.isNotEmpty)
            ListView.builder(
              shrinkWrap: true,
              padding: EdgeInsets.zero,
              itemCount: baseSideMenu.length,
              itemBuilder: (context, index) {
                return Container(
                  margin: EdgeInsets.zero,
                  child: Ink(
                    decoration: const BoxDecoration(color: Colors.transparent),
                    child: ListTile(
                      title: Row(
                        children: [
                          Icon(baseSideMenu[index].icon,
                              size: 22,
                              color: (bottomIndex ==
                                      baseSideMenu[index].bottomIndex)
                                  ? colorCode
                                  : null),
                          Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: Text(baseSideMenu[index].menu_module_name,
                                style: TextStyle(
                                    color: (bottomIndex ==
                                            baseSideMenu[index].bottomIndex)
                                        ? colorCode
                                        : Colors.black,
                                    fontSize: currentScreen == "mobile"
                                        ? width * 0.045
                                        : width * 0.023,
                                    fontWeight: FontWeight.w400,
                                    letterSpacing: 0.2)),
                          )
                        ],
                      ),
                      onTap: () async {
                        if (bottomIndex == baseSideMenu[index].bottomIndex) {
                          context.pop();
                        } else {
                          setState(() {
                            if (baseSideMenu[index].route == "/buy-course") {
                              addCount = 0;
                            }
                            bottomIndex = baseSideMenu[index].bottomIndex;
                          });
                          await storage.write(
                              key: 'bottom_index',
                              value: bottomIndex.toString());
                          context.pushNamed(baseSideMenu[index].route);
                        }
                      },
                    ),
                  ),
                );
              },
            ),

          /* Container(
            margin: EdgeInsets.zero,
            child: Ink(
              decoration: const BoxDecoration(color: Colors.transparent),
              child: ListTile(
                title: Row(
                  children: <Widget>[
                    Icon(Icons.quiz_outlined,
                        size: 22,
                        color: (bottomIndex == baseSideMenu.length)
                            ? colorCode
                            : null),
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Text("Exam",
                          style: TextStyle(
                              color: (bottomIndex == baseSideMenu.length)
                                  ? colorCode
                                  : Colors.black,
                              fontSize: currentScreen == "mobile"
                                  ? width * 0.045
                                  : width * 0.023,
                              fontWeight: FontWeight.w400,
                              letterSpacing: 0.2)),
                    )
                  ],
                ),
                onTap: () async {
                  if (bottomIndex == baseSideMenu.length) {
                    context.pop();
                  } else {
                    await storage.write(
                        key: 'bottom_index', value: bottomIndex.toString());
                    context.pushNamed("/exam-categories");
                  }
                },
              ),
            ),
          ),*/
          // change user
          // Container(
          //   margin: EdgeInsets.zero,
          //   child: Ink(
          //     decoration: const BoxDecoration(color: Colors.transparent),
          //     child: Padding(
          //       padding: const EdgeInsets.symmetric(horizontal: 5),
          //       child: DropdownSearch<StudentModel>(
          //         asyncItems: getUsers,
          //         //to compare search input with both number and name
          //         filterFn: (filter, searchTerm) {
          //           return filter.mobileNumber.contains(searchTerm) ||
          //               filter.name.toLowerCase().contains(searchTerm);
          //         },
          //         compareFn: (i, s) => i.name == s.name,
          //         popupProps: PopupProps.menu(
          //           isFilterOnline: true,
          //           showSearchBox: true,
          //           showSelectedItems: true,
          //           menuProps: MenuProps(
          //               shape: RoundedRectangleBorder(
          //                   borderRadius: BorderRadius.circular(10))),
          //           searchFieldProps: const TextFieldProps(
          //               autofocus: true,
          //               padding: EdgeInsets.zero,
          //               decoration: InputDecoration(
          //                   isDense: true,
          //                   focusedBorder: OutlineInputBorder(
          //                       gapPadding: 0,
          //                       borderSide: BorderSide(color: colorCode)),
          //                   enabledBorder: OutlineInputBorder(
          //                       gapPadding: 0,
          //                       borderSide: BorderSide(color: colorCode)))),
          //           itemBuilder: (context, item, isSelected) {
          //             if (item != usersList.first) {
          //               //hide selected user from showing default
          //               return Container(
          //                 margin: const EdgeInsets.symmetric(vertical: 5),
          //                 padding: EdgeInsets.zero,
          //                 decoration: usersList.first.name != item.name
          //                     ? BoxDecoration(
          //                         borderRadius: BorderRadius.circular(5),
          //                         color: Colors.grey[350],
          //                       )
          //                     : BoxDecoration(
          //                         borderRadius: BorderRadius.circular(5),
          //                         color: Colors.blue,
          //                       ),
          //                 child: Padding(
          //                   padding: const EdgeInsets.all(8.0),
          //                   child: Text(
          //                       '${item.name.toUpperCase()}\n${item.mobileNumber}',
          //                       style: TextStyle(
          //                           color: usersList.first.name == item.name
          //                               ? Colors.white
          //                               : Colors.black,
          //                           fontSize: 16)),
          //                 ),
          //               );
          //             } else {
          //               return const Center();
          //             }
          //           },
          //           loadingBuilder: (context, searchEntry) {
          //             return Center(
          //               child: Container(
          //                   color: Colors.transparent,
          //                   child: const CircularProgressIndicator(
          //                     color: colorCode,
          //                   )),
          //             );
          //           },
          //         ),
          //         itemAsString: (StudentModel student) {
          //           return student.name[0].toUpperCase() +
          //               student.name.substring(1);
          //         },
          //         items: usersList,
          //         onChanged: changeUser,
          //         selectedItem: usersList.first,
          //       ),
          //     ),
          //   ),
          // ),
          Divider(
            color: colorCode.withOpacity(0.5),
            thickness: 2,
          ),
          Container(
            margin: const EdgeInsets.fromLTRB(10, 10, 10, 5),
            child: ListTile(
              title: Row(
                children: <Widget>[
                  const Icon(
                    Icons.logout,
                    size: 22,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Text("Logout",
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: currentScreen == "mobile"
                                ? width * 0.045
                                : width * 0.02,
                            fontWeight: FontWeight.w400,
                            letterSpacing: 0.2)),
                  )
                ],
              ),
              onTap: () async {
                showGeneralDialog(
                    context: context,
                    barrierDismissible: false,
                    pageBuilder: (ctx, a1, a2) {
                      return Container();
                    },
                    transitionDuration: const Duration(milliseconds: 100),
                    transitionBuilder:
                        (BuildContext builderContext, a1, a2, child) {
                      var curve = Curves.easeInOut.transform(a1.value);
                      return Transform.scale(
                          scale: curve,
                          child: Dialog(
                              surfaceTintColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20.0),
                                side: const BorderSide(
                                    width: 2, color: Colors.transparent),
                              ),
                              child: const Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Padding(padding: EdgeInsets.all(15)),
                                  CircularProgressIndicator(
                                    color: colorCode,
                                  ),
                                  Padding(padding: EdgeInsets.only(bottom: 10)),
                                  Text("Logging Out..."),
                                  Padding(padding: EdgeInsets.only(bottom: 10)),
                                ],
                              )));
                    });
                Future.delayed(const Duration(milliseconds: 100), () async {
                  await LoginController().logout().then((val) {
                    Navigator.of(context, rootNavigator: true).pop();
                    if (Platform.isAndroid || Platform.isIOS) {
                      upGraderApi(context);
                    }
                    context.pushNamed("/");
                  });
                });
              },
            ),
          ),
          if (packageInfo.version != '')
            Padding(
              padding: EdgeInsets.only(
                  top:
                      currentScreen == 'mobile' ? height * 0.1 : height * 0.45),
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Text(
                    'App Version ${packageInfo.version}.${packageInfo.buildNumber}'),
              ),
            )
        ]),
      ),
    );
  }

  // Future<List<StudentModel>> getUsers(String? value) async {
  //   List<StudentModel> studentList = [];
  //   await Future.delayed(const Duration(seconds: 0), () {
  //     if (value != null && value.isNotEmpty) {
  //       studentList
  //           .add(StudentModel(name: 'robin', mobileNumber: '6385139855'));
  //       studentList
  //           .add(StudentModel(name: 'kaushik', mobileNumber: '1234567890'));
  //       studentList
  //           .add(StudentModel(name: 'vasuki', mobileNumber: '2222222222'));
  //     }
  //   });
  //   return studentList
  //       .where((element) => (element.name.toLowerCase().contains('$value') ||
  //           element.mobileNumber.contains('$value')))
  //       .toList();
  // }

  // changeUser(newStudent) {
  //   usersList = [];
  //   setState(() {
  //     usersList.add(newStudent);
  //   });
  // }

  Future<void> _initPackageInfo() async {
    final info = await PackageInfo.fromPlatform();
    userName = await storage.read(key: 'username');
    userMobile = await storage.read(key: 'user_mobile');
    if (Platform.isAndroid || Platform.isIOS) {
      if (mounted) {
        await upGraderApi(context);
      }
    }
    if (mounted) {
      setState(() {
        packageInfo = info;
        userName;
        userMobile;
        drawer = false;
      });
    }
  }
}
