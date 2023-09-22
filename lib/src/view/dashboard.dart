// ignore_for_file: unnecessary_null_comparison, prefer_if_null_operators, use_build_context_synchronously, prefer_typing_uninitialized_variables, unnecessary_string_interpolations, unrelated_type_equality_checks
import 'dart:convert';
import 'dart:io';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:lms/common/commonFunctions.dart';
import 'package:pod_player/pod_player.dart';
import '../../common/baseAppBar.dart';
import '../../common/baseSidemenu.dart';
import '../../common/clipper.dart';
import '../../env/env.dart';
import '../controller/dashboardController.dart';
import '../model/dashboardModel.dart';
import '../../common/internetCheck.dart';
import '../../common/theme.dart';
import '../../common/toast.dart';
import '../../main.dart';
import '../../constants.dart';
import 'noDataFound.dart';

//Global Variable Declaration
int ebooksData = 0, feedbackStatus = 0, dashboardData = 0, refresh = 0;
dynamic dashboardResult, banner = '', email;
//Global Variable Declaration

//Dashboard Screen Starts
class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState
    extends State<Dashboard> /*with SingleTickerProviderStateMixin*/ {
  //Variable Declaration Starts
  // late AnimationController _controller;
  List<DashboardModel> dashboardModelData = [];
  bool dashboardLoading = true,
      technicalLoading = false,
      deliverableLoading = false,
      technicalSupport = false,
      showVideo = true;
  int activeIndex = 0;
  CarouselController carouselController = CarouselController();
  List<CourseConceptModel>? courseConceptModel = [];
  List<bool> courseConceptData = [];
  TechnicalModel? technicalSupportModel;
  Uint8List? encodedImg;
  dynamic jobPakkaVideo, firstTime;
  String? adUrl;
  final GlobalKey<ScaffoldState> dashboardKey = GlobalKey<ScaffoldState>();
  PodVideoPlayer? currentPlayer;
  //Variable Declaration Ends

  @override
  void initState() {
    super.initState();
    currentPlayer = PodVideoPlayer(
        controller: PodPlayerController(
            playVideoFrom: PlayVideoFrom.network(
                'https://test-videos.co.uk/vids/bigbuckbunny/mp4/h264/1080/Big_Buck_Bunny_1080_10s_1MB.mp4'))
          ..initialise());
    getDataDashboard();
  }

  @override
  void dispose() {
    currentPlayer?.controller.dispose();
    super.dispose();
  }

  //Main Widget Starts
  @override
  Widget build(BuildContext context) {
    //Variable Declaration Inside Widget Starts
    Size size = MediaQuery.sizeOf(context);
    double width = size.width;
    double height = size.height;
    if (width > 920) //desktop
    {
      currentScreen = 'desktop';
    } else if (width > 420 && width < 920 && Platform.isAndroid) //tab
    {
      currentScreen = 'tab';
    } else if (width < 420 && Platform.isAndroid) //mobile
    {
      currentScreen = 'mobile';
    } else if (width < 600 && Platform.isIOS) //mobile
    {
      currentScreen = 'mobile';
    }
    //Variable Declaration Inside Widget Ends

    //Widget Return Starts
    return WillPopScope(
        onWillPop: () async {
          if (context.canPop()) {
            context.pop();
          }
          context.pushNamed('/');
          return false;
        },
        child: Scaffold(
            key: dashboardKey,
            drawer: const BaseSideMenu(),
            appBar: bottomIndex >= 3 &&
                    baseSideMenu
                            .where((e) => e.route == "/dashboard")
                            .toList()
                            .first
                            .bottomIndex >=
                        3
                ? BaseAppBar(
                    bgColor: colorCode,
                    appBar: AppBar(),
                    title: const Text('My Courses'),
                    actionWidgets: const [],
                    leading: IconButton(
                      icon: const Icon(
                        Icons.menu_outlined,
                        color: Colors.white,
                        size: 22,
                      ),
                      onPressed: () async {
                        dashboardKey.currentState!.openDrawer();
                      },
                    ),
                  )
                : null,
            body: RefreshIndicator(
                color: colorCode,
                onRefresh: () async {
                  await storage
                      .delete(key: "dashboardResult")
                      .then((value) => getDataDashboard());
                },
                child: showVideo
                    ? Center(
                        child: Container(
                          color: Colors.transparent,
                          child: SizedBox(
                            height: height * 0.5,
                            width: width * 0.8,
                            child: currentPlayer,
                          ),
                        ),
                      )
                    : dashboardLoading
                        ? Center(
                            child: Container(
                              color: Colors.transparent,
                              child: const CircularProgressIndicator(
                                color: colorCode,
                              ),
                            ),
                          )
                        : (dashboardModelData != null &&
                                dashboardModelData.isNotEmpty)
                            ? Padding(
                                padding:
                                    const EdgeInsets.only(top: 0, bottom: 0),
                                child: (dashboardModelData.length == 1)
                                    ? sliderWidget(dashboardModelData, width)[0]
                                    : Stack(
                                        children: [
                                          CarouselSlider(
                                            carouselController:
                                                carouselController,
                                            items: sliderWidget(
                                                dashboardModelData, width),
                                            options: CarouselOptions(
                                                height: height,
                                                enlargeCenterPage: false,
                                                viewportFraction: 1,
                                                autoPlayCurve:
                                                    Curves.fastOutSlowIn,
                                                enableInfiniteScroll: false,
                                                onPageChanged: (i, r) {
                                                  setState(() {
                                                    activeIndex = i;
                                                    courseConceptModel = [];
                                                    technicalSupportModel =
                                                        null;
                                                  });
                                                }),
                                          ),
                                          Positioned(
                                            top: height * 0.35,
                                            right: 5,
                                            left: 7,
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                if (activeIndex > 0)
                                                  GestureDetector(
                                                    onTap: () async {
                                                      activeIndex--;
                                                      setState(() {
                                                        activeIndex;
                                                        courseConceptModel = [];
                                                        technicalSupportModel =
                                                            null;
                                                      });
                                                      carouselController
                                                          .jumpToPage(
                                                        activeIndex,
                                                      );
                                                    },
                                                    child: const Icon(
                                                      Icons.arrow_back_ios,
                                                      size: 20,
                                                      color: colorCode,
                                                    ),
                                                  ),
                                                const Spacer(),
                                                if (activeIndex <
                                                    dashboardModelData.length -
                                                        1)
                                                  GestureDetector(
                                                    onTap: () async {
                                                      activeIndex++;
                                                      setState(() {
                                                        courseConceptModel = [];
                                                        technicalSupportModel =
                                                            null;
                                                        activeIndex;
                                                      });
                                                      carouselController
                                                          .jumpToPage(
                                                        activeIndex,
                                                      );
                                                    },
                                                    child: const Icon(
                                                      Icons.arrow_forward_ios,
                                                      size: 20,
                                                      color: colorCode,
                                                    ),
                                                  ),
                                              ],
                                            ),
                                          ),
                                          /* Positioned(
                                top: height * 0.337,
                                right: 50,
                                left: 50,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: dashboardModelData.map((url) {
              int index =
              dashboardModelData.indexOf(url);
              return GestureDetector(
                onTap: () {
              setState(() {
                activeIndex = index;
                courseConceptModel = [];
                technicalSupportModel = null;
              });
              carouselController
                  .animateToPage(index);
                },
                child: Container(
              width: 8.0,
              height: 8.0,
              margin: const EdgeInsets.symmetric(
                  vertical: 4.0, horizontal: 2.0),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: activeIndex == index
                    ? caddColorCode
                    : const Color.fromRGBO(
                        0, 0, 0, 0.4),
              ),
                ),
              );
                                  }).toList(),
                                ),
                                  ),*/
                                        ],
                                      ),
                              )
                            : Center(
                                child: Container(
                                  height: height * 0.7,
                                  width: width * 0.9,
                                  padding: EdgeInsets.only(top: height * 0.15),
                                  child: NoDataFound(
                                    subTitle: "No Courses found in your record",
                                    subtitleTextStyle: fontStyleSubNoDataFound,
                                    titleTextStyle: fontStyle3Web,
                                    image: "assets/images/no-record.png",
                                  ),
                                ),
                              ))));
    //Widget Return Ends
  }

  //Main Widget Ends

  //Sliders of Carousel Starts
  List<Widget> sliderWidget(List<DashboardModel> dashboard, double width) {
    Size size = MediaQuery.of(context).size;
    double width = size.width;
    double height = size.height;
    final List<Widget> dashboardSlider = dashboard.map((item) {
      String encodedValue;
      // DateTime? courseStartDate =
      //     item.start_date != null ? DateTime.parse(item.start_date!) : null;
      // DateTime? courseEndDate =
      //     item.end_date != null ? DateTime.parse(item.end_date!) : null;
      return Stack(children: [
        Column(
          children: [
            Container(
              height: height * 0.2,
              decoration: const BoxDecoration(
                color: colorCode,
                borderRadius:
                    BorderRadius.vertical(bottom: Radius.circular(20.0)),
              ),
              child: Align(
                alignment: Alignment.topLeft,
                child: Padding(
                  padding: const EdgeInsets.only(
                    top: 10,
                    left: 10,
                  ),
                  child: SizedBox(
                    width:
                        currentScreen == 'mobile' ? width * 0.6 : width * 0.75,
                    child: Text(
                      item.course_criteria_title_name,
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          fontSize: currentScreen == 'mobile' ? 17 : 25),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: height * 0.18,
            ),
            SizedBox(
              height: height * 0.47,
              child: Container(
                margin: EdgeInsets.only(
                  right: currentScreen == 'tab' ? width * 0.05 : 2,
                  left: currentScreen == 'tab' ? width * 0.05 : 2,
                ),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      GridView.count(
                        shrinkWrap: true,
                        childAspectRatio: 1.2,
                        physics: const ClampingScrollPhysics(),
                        primary: true,
                        padding: EdgeInsets.only(
                            bottom: MediaQuery.viewInsetsOf(context).bottom),
                        crossAxisSpacing: 0,
                        mainAxisSpacing: 10,
                        crossAxisCount: 3,
                        children: [
                          if ((item.course_affilation_id == 2 ||
                                  item.course_affilation_id == 3) &&
                              item.master_course_enrollment_source_id != 3)
                            DashboardCard(
                              selected: true,
                              icon: Icons.fact_check_outlined,
                              label: 'NSDC',
                              onTap: () async {
                                await checkInternet().then((value) async => {
                                      if (value == true)
                                        {
                                          await storage.write(
                                            key: 'nsdcFilled',
                                            value: item.nsdc_filled_status
                                                .toString(),
                                          ),
                                          await storage
                                              .write(
                                                key: 'currentCourseId',
                                                value: item.id.toString(),
                                              )
                                              .then((value) => {
                                                    context.pushNamed("/nsdc"),
                                                  }),
                                        }
                                      else
                                        {
                                          messageFlushBar(context),
                                        }
                                    });
                              },
                            ),
                          DashboardCard(
                            selected: item.start_date != null ? true : false,
                            icon: Icons.menu_book_outlined,
                            label: 'Deliverables',
                            onTap: () async {
                              await storage.write(
                                  key: 'batch_assigned',
                                  value: item.start_date != null ? '1' : '0');
                              await checkInternet().then((value) async => {
                                    if (value == true)
                                      {
                                        if (item.start_date != null)
                                          {
                                            courseId = item.id.toString(),
                                            await storage
                                                .write(
                                                  key: 'currentCourseId',
                                                  value: item.id.toString(),
                                                )
                                                .then((value) => {
                                                      context.pushNamed(
                                                          "/deliverables"),
                                                    }),
                                          }
                                        else
                                          {
                                            messageFlushBar(context,
                                                'Batch is not assigned yet')
                                          }
                                      }
                                    else
                                      {
                                        messageFlushBar(context),
                                      }
                                  });
                            },
                          ),
                          if (item.master_course_enrollment_source_id != 3)
                            DashboardCard(
                              selected: true,
                              image: 'assets/images/wa_app_logo.svg',
                              label: 'Payment',
                              dues: item.master_certificate_id == 1,
                              onTap: () async {
                                setState(() {
                                  dlmPage = true;
                                  courseData = null;
                                  selfPacedData = null;
                                  quizData = 0;
                                  quizResultData = null;
                                  quizResult = null;
                                });
                                var map = {
                                  "passCode": "dZ(y)H7sVW(BDtB@",
                                  "user_course_id": item.id,
                                  "course_criteria_title_id":
                                      item.course_criteria_title_id,
                                  "company_code": item.sales_company_code,
                                  "cartId": "",
                                  "paymentURl": ""
                                };
                                encodedValue =
                                    base64.encode(utf8.encode(jsonEncode(map)));
                                await storage.write(
                                    key: 'courseId', value: encodedValue);
                                context.pushNamed('/payment');
                              },
                            ),
                          DashboardCard(
                            selected: (item.master_certificate_id == 5 ||
                                    item.master_certificate_id == 7)
                                ? true
                                : false,
                            icon: Icons.feed_outlined,
                            label: 'Feedback',
                            onTap: () async => {
                              if (item.master_certificate_id == 5) ...[
                                if (allowNameEdit == 0)
                                  {
                                    showDialog(
                                      context: context,
                                      barrierDismissible: false,
                                      builder: (BuildContext context) =>
                                          StatefulBuilder(
                                              builder: (context, setState) {
                                        return AlertDialog(
                                          surfaceTintColor: Colors.white,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10.0),
                                            side: const BorderSide(
                                                width: 2,
                                                color: Colors.transparent),
                                          ),
                                          contentPadding:
                                              const EdgeInsets.fromLTRB(
                                                  20, 0, 0, 0),
                                          actionsPadding: EdgeInsets.zero,
                                          content: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              const SizedBox(height: 10),
                                              const Center(
                                                  child: Padding(
                                                padding: EdgeInsets.all(5),
                                                child: Text(
                                                  "Verify Your Details",
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w700),
                                                ),
                                              )),
                                              const SizedBox(height: 10),
                                              Container(
                                                height: 120.0,
                                                width: 120.0,
                                                decoration: const BoxDecoration(
                                                  shape: BoxShape.circle,
                                                ),
                                                child: encodedImg != null
                                                    ? ClipOval(
                                                        clipper: MyClip(),
                                                        child: FadeInImage(
                                                          fit: BoxFit.fill,
                                                          placeholder:
                                                              AssetImage(
                                                                  loading),
                                                          image: MemoryImage(
                                                              encodedImg!),
                                                        ),
                                                      )
                                                    : CircleAvatar(
                                                        radius: 50,
                                                        backgroundColor:
                                                            colorCode
                                                                .withOpacity(
                                                                    0.7),
                                                        child: const Icon(
                                                            Icons
                                                                .person_outlined,
                                                            color: Colors.white,
                                                            size: 40.0),
                                                      ),
                                              ),
                                              const SizedBox(height: 10),
                                              Center(
                                                  child: Padding(
                                                padding:
                                                    const EdgeInsets.all(5),
                                                child: Text(userName),
                                              )),
                                              const SizedBox(height: 15),
                                              const Center(
                                                  child: Padding(
                                                padding: EdgeInsets.all(5),
                                                child: Text(
                                                  "NOTE: Please, Verify the above-seen Picture & Name, Which is to be printed on your Certificate. Once agreed, It cannot be modified later.",
                                                  style: TextStyle(
                                                      color: Colors.redAccent,
                                                      fontSize: 12),
                                                ),
                                              )),
                                            ],
                                          ),
                                          actions: [
                                            FilledButton(
                                              onPressed: () async {
                                                await storage.write(
                                                    key: 'feedback_courseId',
                                                    value: item.id.toString());
                                                Navigator.pop(context);
                                                context.pushNamed('/feedback');
                                              },
                                              style: FilledButton.styleFrom(
                                                  backgroundColor: colorCode,
                                                  shape: RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10))),
                                              child: const Text(
                                                "Agree",
                                                style: TextStyle(
                                                    color: Colors.white),
                                              ),
                                            ),
                                            OutlinedButton(
                                              onPressed: () async {
                                                Navigator.pop(context);
                                              },
                                              style: ButtonStyle(
                                                padding:
                                                    MaterialStateProperty.all(
                                                        EdgeInsets.zero),
                                                shape: MaterialStateProperty
                                                    .all(RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10))),
                                              ),
                                              child: const Padding(
                                                padding: EdgeInsets.symmetric(
                                                    vertical: 8.0,
                                                    horizontal: 20),
                                                child: Text(
                                                  "Cancel",
                                                  style: TextStyle(
                                                      color: Colors.black),
                                                ),
                                              ),
                                            ),
                                            const SizedBox(width: 10)
                                          ],
                                        );
                                      }),
                                    ),
                                  }
                                else
                                  {
                                    await storage.write(
                                        key: 'feedback_courseId',
                                        value: item.id.toString()),
                                    context.pushNamed('/feedback')
                                  }
                              ] else if (item.master_certificate_id == 7) ...[
                                messageFlushBar(
                                    context, 'Feedback already submitted')
                              ] else ...[
                                messageFlushBar(
                                    context, 'Course not completed yet')
                              ]
                            },
                          ),
                          if (item.master_course_enrollment_source_id != 3)
                            DashboardCard(
                              selected: item.master_certificate_id == 7
                                  ? true
                                  : false,
                              icon: Icons.school_outlined,
                              label: 'Certificate',
                              onTap: () async {
                                if (item.master_certificate_id == 7) {
                                  String url =
                                      '${Env.downloadUrl}$token&user_course_id=${item.id}';
                                  context.pushNamed("/pdf-view", params: {
                                    "url": url,
                                    "courseName":
                                        item.course_criteria_title_name
                                  });
                                } else if (item.master_certificate_id == 6) {
                                  messageFlushBar(
                                      context, 'Feedback not submitted yet');
                                } else {
                                  messageFlushBar(
                                      context, 'Certificate not issued yet');
                                }
                              },
                            )
                        ],
                      ),
                      const SizedBox(
                        height: 0,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
        Positioned(
          top: height * 0.001,
          right: 10,
          child: Container(
            margin: const EdgeInsets.only(
              top: 12,
            ),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(10)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.alarm,
                  size: 18,
                  color: colorCode,
                ),
                const SizedBox(width: 2),
                Text('${item.duration} Hrs',
                    style: const TextStyle(
                        color: colorCode, fontWeight: FontWeight.w700))
              ],
            ),
          ),
        ),
        Positioned(
            top: height * 0.12,
            right: width * 0.05,
            left: width * 0.05,
            child: SizedBox(
                height: height * 0.22,
                child: Card(
                    surfaceTintColor: Colors.white,
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    child: Column(mainAxisSize: MainAxisSize.min, children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                item.start_date != null
                                    ? Text(
                                        ' ${DateFormat('dd-MMM-yy').format(DateTime.parse("${item.start_date}"))} - ${DateFormat('dd-MMM-yy').format(DateTime.parse("${item.end_date}"))}',
                                        style: fontStyleRegWeb,
                                      )
                                    : Text(
                                        ' Yet to Schedule',
                                        style: fontStyleRegWeb,
                                      ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: height * 0.02,
                      ),
                      if (item.session_link != null &&
                          item.session_link != "") ...[
                        InkWell(
                          splashColor: colorCode.withOpacity(0.3),
                          splashFactory: InkRipple.splashFactory,
                          onTap: () {
                            CommonFunctions().launchUrlTeams(item.session_link!
                                .replaceAll("https:", "msteams:"));
                          },
                          child: Container(
                              height: height * 0.06,
                              width: width * 0.42,
                              padding: const EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: const Color(0xff464EB8),
                              ),
                              child: const Center(
                                  child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                    Icon(
                                      Icons.video_call_outlined,
                                      color: Colors.white,
                                      size: 26,
                                    ),
                                    Text(
                                      "Join Now",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                      ),
                                    ),
                                  ]))),
                        ),
                      ] else ...[
                        InkWell(
                          splashColor: colorCode,
                          splashFactory: InkRipple.splashFactory,
                          onTap: item.master_certificate_id == 1 &&
                                  item.master_course_enrollment_source_id != 3
                              ? () async {
                                  setState(() {
                                    dlmPage = true;
                                    courseData = null;
                                    selfPacedData = null;
                                    quizData = 0;
                                    quizResultData = null;
                                    quizResult = null;
                                  });
                                  var map = {
                                    "passCode": "dZ(y)H7sVW(BDtB@",
                                    "user_course_id": item.id,
                                    "course_criteria_title_id":
                                        item.course_criteria_title_id,
                                    "company_code": item.sales_company_code,
                                    "cartId": "",
                                    "paymentURl": ""
                                  };
                                  encodedValue = base64
                                      .encode(utf8.encode(jsonEncode(map)));
                                  await storage.write(
                                      key: 'courseId', value: encodedValue);
                                  context.pushNamed('/payment');
                                }
                              : () {
                                  SystemChrome.setPreferredOrientations(
                                      [DeviceOrientation.landscapeRight]);
                                },
                          child: Container(
                              height: height * 0.06,
                              width: width * 0.42,
                              padding: const EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: item.master_certificate_id == 7
                                    ? Colors.green
                                    : item.master_certificate_id == 4
                                        ? Colors.blue
                                        : item.master_certificate_id == 1
                                            ? Colors.red
                                            : const Color(0xff6C0BAA),
                              ),
                              child: Center(
                                child: Text(
                                  item.master_certificate_name.trim(),
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                              )),
                        ),
                      ],
                      if (![null, ''].contains(item.created_at))
                        SizedBox(
                          height: height * 0.03,
                        ),
                      Container(
                        width: width,
                        padding: EdgeInsets.zero,
                        margin: EdgeInsets.only(top: height * 0.02),
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          gradient: LinearGradient(colors: [
                            Colors.white,
                            colorCode,
                            colorCode,
                            Colors.white
                          ]),
                        ),
                        child: Text(
                          'Enrolled at ${DateFormat('dd-MMM-yy').format(DateTime.parse("${item.created_at}"))}',
                          textAlign: TextAlign.center,
                          style: const TextStyle(color: Colors.white),
                        ),
                      )
                    ]))))
      ]);
    }).toList();
    return dashboardSlider;
  }

  //Sliders of Carousel Ends

  //Get Dashboard Data function Start
  getDataDashboard() async {
    var temp;
    await storage.write(key: 'current_screen', value: currentScreen);
    userName = await storage.read(key: 'username');
    if (profilePicture != null) {
      await storage.write(key: 'profile_picture', value: profilePicture);
    } else {
      profilePicture = await storage.read(key: 'profile_picture');
    }
    if (profilePicture != null) {
      img64 = profilePicture;
      String decodeProfile =
          profilePicture != null ? profilePicture.split(',').last : '';
      final decodeString = base64.decode(decodeProfile.toString());
      encodedImg = decodeString;
    } else {
      encodedImg = null;
    }
    await storage.containsKey(key: 'dashboardResult').then((value) async {
      if (value) {
        dynamic certificateProcessed =
            await storage.read(key: 'certificateCount');
        if (certificateProcessed != null) {
          allowNameEdit = int.parse(certificateProcessed.toString());
        }
        temp = await storage.read(key: 'dashboardResult');
        temp = jsonDecode(temp) as List;
        for (var j in temp) {
          dashboardModelData.add(DashboardModel.fromMap(j));
        }
        await storage.delete(key: 'dashboardResult');
      } else {
        var data = await DashboardController().getDashboardData(context);
        if (data != null) {
          if (data == "Connection Error") {
            context.pushNamed("/noInternet");
            return;
          } else {
            dynamic certificateProcessed =
                await storage.read(key: 'certificateCount');
            if (certificateProcessed != null) {
              allowNameEdit = int.parse(certificateProcessed.toString());
            }
            dashboardModelData = data;
          }
        }
      }
    });
    //job pakka code
    adUrl = await storage.read(key: 'jobPakkaUrl');
    if (adUrl != null) {
      Future.delayed(const Duration(seconds: 2), () async {
        firstTime = await storage.read(key: 'app_first_time');
        await storage.write(key: 'app_first_time', value: '0');
        setState(() {
          firstTime;
        });
        if (firstTime == '1') {
          jobPakkaAlert(context);
        }
      });
    }

    if (mounted) {
      setState(
        () {
          dashboardModelData;
          userName;
          bottomIndex;
          encodedImg;
          currentScreen;
          dashboardLoading = false;
        },
      );
    }
  }

  //Get Dashboard Data function Ends

  //job pakka alert dialog start
  jobPakkaAlert(context) async {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) =>
            StatefulBuilder(builder: (context, setState) {
              //Variable Declaration Inside Widget Starts
              Size size = MediaQuery.sizeOf(context);
              double width = size.width;
              double height = size.height;

              return Stack(
                children: [
                  Positioned(
                    bottom: height * 0.1,
                    right: width * 0.02,
                    child: GestureDetector(
                      child: Container(
                        width: width * 0.63,
                        height: height * 0.31,
                        alignment: Alignment.bottomRight,
                        decoration: const BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage('assets/images/ad.jpg'),
                              fit: BoxFit.cover,
                            ),
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(10),
                              topRight: Radius.circular(10),
                              bottomLeft: Radius.circular(10),
                              bottomRight: Radius.circular(10),
                            )),
                      ),
                      onTap: () {
                        showJobPakkaVideo(adUrl);
                      },
                    ),
                  ),
                  Positioned(
                    bottom: height * 0.37,
                    right: width * 0.02,
                    child: GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: const Icon(
                          Icons.close_outlined,
                          color: colorCode,
                          size: 30,
                        )),
                  ),
                ],
              );
            }));
  }

  //job pakka alert dialog

  //show job pakka video starts
  showJobPakkaVideo(url) {
    jobPakkaVideo =
        PodPlayerController(playVideoFrom: PlayVideoFrom.youtube(url));
    jobPakkaVideo.initialise();
    return showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) =>
            StatefulBuilder(builder: (context, setState) {
              return PodVideoPlayer(controller: jobPakkaVideo);
            })).then((value) => {
          Future.delayed(const Duration(milliseconds: 500), () {
            jobPakkaVideo.dispose();
          })
        });
  }
//show job pakka video ends
}
//Dashboard Screen Ends
