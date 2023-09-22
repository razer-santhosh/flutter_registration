// ignore_for_file: file_names, use_build_context_synchronously, unnecessary_overrides
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'appUpgrade.dart';
import 'baseSidemenu.dart';
import 'decorationScreen.dart';
import 'baseAppBar.dart';
import 'theme.dart';
import '../constants.dart';
import '../main.dart';
import '../src/controller/dashboardController.dart';
import '../../src/view/dashboard.dart';

//Bottom Navigation Screen Starts
class BottomNavigationPage extends StatefulWidget {
  const BottomNavigationPage({Key? key}) : super(key: key);

  @override
  State<BottomNavigationPage> createState() => _BottomNavigationPageState();
}

class _BottomNavigationPageState extends State<BottomNavigationPage>
    with TickerProviderStateMixin {
  //Variable Declaration Starts
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  List<Widget> pageList = [];
  bool dashLoading = true, showBtn = false, isOpen = false;
  String encodedValue = "";
  List<TabItem> bottomNavItems = [];
  //Variable Declaration Ends

  //Initialize The State Starts
  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance
        .addPostFrameCallback((timeStamp) => getUsers(context));
  }
  //Initialize The State Ends

  //Dispose the State Starts
  @override
  void dispose() {
    super.dispose();
  }
  //Dispose the State Ends

  //Main Widget Starts
  @override
  Widget build(BuildContext context) {
    //Variable Declaration Inside Widget Starts
    Size size = MediaQuery.of(context).size;
    double screenWidth = size.width;
    double screenHeight = size.height;
    if (screenWidth > 920) //desktop
    {
      currentScreen = 'desktop';
    } else if (screenWidth > 420 &&
        screenWidth < 920 &&
        Platform.isAndroid) //tab
    {
      currentScreen = 'tab';
    } else if (screenWidth < 420 && Platform.isAndroid) //mobile
    {
      currentScreen = 'mobile';
    } else if (screenWidth < 600 && Platform.isIOS) //mobile
    {
      currentScreen = 'mobile';
    }
    //Variable Declaration Inside Widget Ends

    //Main Widget Return
    return bottomIndex >= 3
        ? Container()
        : Container(
            child: userName != null
                ? Scaffold(
                    key: scaffoldKey,
                    drawer: const BaseSideMenu(),
                    resizeToAvoidBottomInset: false,
                    extendBody: true,
                    appBar: (bottomIndex == 0)
                        ? BaseAppBar(
                            appBar: AppBar(),
                            leading: IconButton(
                              icon: Icon(
                                Icons.menu_outlined,
                                color: colorCode.withOpacity(0.8),
                                size: 22,
                              ),
                              onPressed: () async {
                                scaffoldKey.currentState!.openDrawer();
                              },
                            ),
                            actionWidgets: [
                              if (baseSideMenu.isNotEmpty &&
                                  baseSideMenu[0].route == "/profile") ...[
                                IconButton(
                                    onPressed: (() async {
                                      await storage.delete(
                                          key: 'profile_picture');
                                      await storage
                                          .delete(key: "profileData")
                                          .then((value) =>
                                              {context.pushNamed("/profile")});
                                    }),
                                    icon: const Icon(
                                      Icons.refresh_outlined,
                                      color: Colors.white,
                                    ))
                              ],
                              GestureDetector(
                                onTap: () async {
                                  await storage.write(
                                      key: 'bottom_index', value: "0");
                                  if (bottomIndex == 0) {
                                    setState(() {
                                      bottomIndex = 0;
                                    });
                                    Router.neglect(context, () {
                                      context.pushNamed(baseSideMenu[0].route);
                                    });
                                  } else if (bottomIndex == 1) {
                                    setState(() {
                                      bottomIndex = 1;
                                    });
                                    await storage.write(
                                        key: 'bottom_index', value: "1");
                                    context.pop();
                                    context.pushNamed(baseSideMenu[1].route);
                                  }
                                },
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(0),
                                  child: SvgPicture.asset(
                                    logoLogin,
                                    width: 170,
                                    height: 60,
                                    fit: BoxFit.contain,
                                  ),
                                ),
                              ),
                            ],
                            bgColor: Colors.white,
                          )
                        : (bottomIndex == 1)
                            ? BaseAppBar(
                                bgColor: (baseSideMenu[1].route == "/dashboard")
                                    ? Colors.white
                                    : colorCode,
                                appBar: AppBar(),
                                title: Text(baseSideMenu[1].menu_module_name),
                                actionWidgets: (baseSideMenu[1].route ==
                                        "/dashboard")
                                    ? [
                                        GestureDetector(
                                          onTap: () async {
                                            await storage.write(
                                                key: 'bottom_index',
                                                value: "0");
                                            if (bottomIndex == 0) {
                                              setState(() {
                                                bottomIndex = 0;
                                              });
                                              Router.neglect(context, () {
                                                context.pushNamed(
                                                    baseSideMenu[0].route);
                                              });
                                            } else if (bottomIndex == 1) {
                                              setState(() {
                                                bottomIndex = 1;
                                              });
                                              await storage.write(
                                                  key: 'bottom_index',
                                                  value: "1");
                                              context.pop();
                                              context.pushNamed(
                                                  baseSideMenu[1].route);
                                            }
                                          },
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(0),
                                            child: SvgPicture.asset(
                                              logoLogin,
                                              width: 170,
                                              height: 60,
                                              fit: BoxFit.contain,
                                            ),
                                          ),
                                        ),
                                      ]
                                    : (baseSideMenu[1].route == "/profile")
                                        ? [
                                            IconButton(
                                                onPressed: (() async {
                                                  await storage.delete(
                                                      key: 'profile_picture');
                                                  await storage
                                                      .delete(
                                                          key: "profileData")
                                                      .then((value) => {
                                                            context.pushNamed(
                                                                "/profile")
                                                          });
                                                }),
                                                icon: const Icon(
                                                  Icons.refresh_outlined,
                                                  color: Colors.white,
                                                ))
                                          ]
                                        : const [],
                                leading: IconButton(
                                  icon: Icon(
                                    Icons.menu_outlined,
                                    color:
                                        (baseSideMenu[1].route == "/dashboard")
                                            ? colorCode
                                            : Colors.white,
                                    size: 22,
                                  ),
                                  onPressed: () async {
                                    scaffoldKey.currentState!.openDrawer();
                                  },
                                ),
                              )
                            : (bottomIndex == 2)
                                ? BaseAppBar(
                                    bgColor: colorCode,
                                    appBar: AppBar(),
                                    title:
                                        Text(baseSideMenu[2].menu_module_name),
                                    actionWidgets: (baseSideMenu[2].route ==
                                            "/profile")
                                        ? [
                                            IconButton(
                                                onPressed: (() async {
                                                  await storage.delete(
                                                      key: 'profile_picture');
                                                  await storage
                                                      .delete(
                                                          key: "profileData")
                                                      .then((value) => {
                                                            context.pushNamed(
                                                                "/profile")
                                                          });
                                                }),
                                                icon: const Icon(
                                                  Icons.refresh_outlined,
                                                  color: Colors.white,
                                                ))
                                          ]
                                        : const [],
                                    leading: IconButton(
                                      icon: const Icon(
                                        Icons.menu_outlined,
                                        color: Colors.white,
                                        size: 22,
                                      ),
                                      onPressed: () async {
                                        scaffoldKey.currentState!.openDrawer();
                                      },
                                    ),
                                  )
                                : BaseAppBar(
                                    appBar: AppBar(), bgColor: colorCode),
                    body: Column(children: [
                      pageList.isNotEmpty ? pageList[bottomIndex] : Container()
                    ]),
                    bottomNavigationBar: bottomNavItems.isNotEmpty
                        ? StyleProvider(
                            style: Style(),
                            child: ConvexAppBar(
                              initialActiveIndex: bottomIndex,
                              style: TabStyle.reactCircle,
                              activeColor: colorCode,
                              backgroundColor: Colors.white,
                              color: Colors.grey,
                              height: screenHeight * 0.065,
                              onTap: (index) async {
                                if (index == 1) {
                                  setState(() {
                                    bottomIndex = 1;
                                  });
                                } else if (index == 2) {
                                  setState(() {
                                    bottomIndex = 2;
                                  });
                                } else {
                                  int dashboardIndex = baseSideMenu
                                      .where((e) => e.route == "/dashboard")
                                      .toList()
                                      .first
                                      .bottomIndex;
                                  if (dashboardIndex > 3) {
                                    await storage
                                        .containsKey(key: 'dashboardResult')
                                        .then((value) {
                                      storage.delete(key: 'dashboardResult');
                                    });
                                  }
                                  setState(() {
                                    bottomIndex = 0;
                                  });
                                }
                                await storage.write(
                                    key: 'bottom_index',
                                    value: bottomIndex.toString());
                                if (Platform.isAndroid || Platform.isIOS) {
                                  await upGraderApi(context);
                                }
                              },
                              items: bottomNavItems,
                            ),
                          )
                        : null,
                  )
                : const Center(),
          );
    //Main Widget Return
  }
  //Main Widget Ends

  //Get Dashboard Data function Start
  getDataDashboard(ctx) async {
    addCount++;
    int index = 0;
    await storage.write(key: 'current_screen', value: currentScreen);
    await storage.containsKey(key: 'dashboardResult').then((value) async {
      if (value) {
        dynamic certificateProcessed =
            await storage.read(key: 'certificateCount');
        if (certificateProcessed != null) {
          allowNameEdit = int.parse(certificateProcessed.toString());
        }
        var temp = await storage.read(key: 'dashboardResult');
        List? newData = temp != null ? jsonDecode(temp) as List : [];
        if (newData.isEmpty) {
          index = baseSideMenu.isNotEmpty
              ? baseSideMenu
                  .where((e) => e.route == "/buy-course")
                  .toList()
                  .first
                  .bottomIndex
              : 1;
        } else {
          index = 0;
        }
      } else {
        var data = await DashboardController().getDashboardData(ctx);
        if (data != null) {
          if (data == "Connection Error") {
            context.pushNamed("/noInternet");
          } else {
            if (data.isEmpty) {
              index = baseSideMenu.isNotEmpty
                  ? baseSideMenu
                      .where((e) => e.route == "/buy-course")
                      .toList()
                      .first
                      .bottomIndex
                  : 1;
            } else {
              index = 0;
            }
          }
        } else {
          index = baseSideMenu.isNotEmpty
              ? baseSideMenu
                  .where((e) => e.route == "/buy-course")
                  .toList()
                  .first
                  .bottomIndex
              : 1;
        }
      }
    });
    return addCount <= 1 ? index : 0;
  }
  //Get Dashboard Data function Ends

  //Bottom Sheet for Add Course Starts
  // showSheet() async {
  //   setState(() {
  //     isOpen = true;
  //   });
  //   // WidgetsBinding.instance.addPostFrameCallback((_) async {
  //   await showModalBottomSheet(
  //       useRootNavigator: true,
  //       context: context,
  //       isScrollControlled: true,
  //       enableDrag: false,
  //       isDismissible: false,
  //       shape: const RoundedRectangleBorder(
  //           borderRadius: BorderRadius.only(
  //         topRight: Radius.circular(10.0),
  //         topLeft: Radius.circular(10.0),
  //       )),
  //       builder: (BuildContext context) {
  //         return const CoursePayment(
  //             /*  maxAmountWithoutGST:
  //                             courseRegisterDetailList!.max_amount_without_gst!,
  //                         minAmountWithGST: courseRegisterDetailList!
  //                             .min_token_amount_with_gst!,
  //                         maxAmountWithGST:
  //                             courseRegisterDetailList!.max_amount_with_gst!,
  //                         courseCriteriaTitleId: courseRegisterDetailList!
  //                             .course_criteria_title_id,*/
  //             );
  //       }).then((value) async => {
  //         setState(() {
  //           bottomIndex = 0;
  //           addCount++;
  //           isOpen = false;
  //         }),
  //         await storage.write(key: 'bottom_index', value: "0"),
  //         context.pushNamed("/"),
  //       });
  //   // });
  // }
  //Bottom Sheet for Add Course Ends

  //Get User Data For initialize the Screen
  getUsers(ctx) async {
    userName = await storage.read(key: 'username');
    var index = await storage.read(key: 'bottom_index');
    int indexes = index == null ? 0 : int.parse(index.toString());
    bottomNavItems = bottomNavBar;
    for (int k = 0; k < baseSideMenu.length; k++) {
      Widget menu = switch (baseSideMenu[k].route) {
        '/dashboard' => const Dashboard(),
        _ => const Dashboard(),
      };
      pageList.add(SizedBox(
          height: currentScreen == 'mobile'
              ? MediaQuery.of(ctx).size.height * 0.88
              : MediaQuery.of(ctx).size.height * 0.9,
          child: menu));
    }
    // (baseSideMenu[k].route == "/dashboard")
    //     ? SizedBox(
    //         height: currentScreen == 'mobile'
    //             ? MediaQuery.of(ctx).size.height * 0.88
    //             : MediaQuery.of(ctx).size.height * 0.9,
    //         child: const Dashboard())
    //     : (baseSideMenu[k].route == "/buy-course")
    //         ? SizedBox(
    //             height: currentScreen == 'mobile'
    //                 ? MediaQuery.of(ctx).size.height * 0.88
    //                 : MediaQuery.of(ctx).size.height * 0.9,
    //             child: const AddCourse())
    //         : (baseSideMenu[k].route == "/certificates")
    //             ? SizedBox(
    //                 height: currentScreen == 'mobile'
    //                     ? MediaQuery.of(ctx).size.height * 0.88
    //                     : MediaQuery.of(ctx).size.height * 0.9,
    //                 child: const MyCertificate())
    //             : (baseSideMenu[k].route == "/profile")
    //                 ? SizedBox(
    //                     height: currentScreen == 'mobile'
    //                         ? MediaQuery.of(ctx).size.height * 0.88
    //                         : MediaQuery.of(ctx).size.height * 0.9,
    //                     child: const Profile())
    //                 : (baseSideMenu[k].route == "/contact-us")
    //                     ? SizedBox(
    //                         height: currentScreen == 'mobile'
    //                             ? MediaQuery.of(ctx).size.height * 0.88
    //                             : MediaQuery.of(ctx).size.height * 0.9,
    //                         child: const ContactUs())
    //                     : (baseSideMenu[k].route == "/job-apply")
    //                         ? SizedBox(
    //                             height: currentScreen == 'mobile'
    //                                 ? MediaQuery.of(ctx).size.height * 0.88
    //                                 : MediaQuery.of(ctx).size.height * 0.9,
    //                             child: const JobApply())
    //                         : (baseSideMenu[k].route == "/free-courses")
    //                             ? SizedBox(
    //                                 height: currentScreen == 'mobile'
    //                                     ? MediaQuery.of(ctx).size.height *
    //                                         0.88
    //                                     : MediaQuery.of(ctx).size.height *
    //                                         0.9,
    //                                 child: const FreeCourses())
    //                             : SizedBox(
    //                                 height: currentScreen == 'mobile'
    //                                     ? MediaQuery.of(ctx).size.height *
    //                                         0.88
    //                                     : MediaQuery.of(ctx).size.height *
    //                                         0.9,
    //                                 child: const Dashboard());
    int newIndex = await getDataDashboard(ctx);
    if (mounted) {
      setState(() {
        pageList;
        colorCode;
        logo;
        userName;
        bottomNavItems;
        bottomIndex = indexes == 0 ? newIndex : indexes;
        dashLoading = false;
      });
    }
  }
//Get User Data For initialize the Screen
}
//Bottom Navigation Screen Ends



