// ignore_for_file: file_names, unused_local_variable, depend_on_referenced_packages
import 'dart:convert';
import 'dart:io';
import 'package:animated_icon/animated_icon.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../model/dashboardModel.dart';
import '../../common/networkApi.dart';
import '../../common/internetCheck.dart';
import '../../common/toast.dart';
import '../../constants.dart';
import '../../main.dart';

class DashboardController {
  //Dashboard Data Fetch Function Starts
  getDashboardData(ctx) async {
    currentScreen = await storage.read(key: 'current_screen');
    await checkInternet().then((value) => {internetStatus = value});
    if (internetStatus) {
      appId = await storage.read(key: 'app_id') ?? baseAppId.toString();
      token ??= await storage.read(key: 'token');
      var body = {
        'token': token,
        'required': 'my_courses_view',
        "app_id": int.tryParse(appId)
      };
      try {
        final isSocketConnect = await hasNetwork();
        if (isSocketConnect) {
          var response =
              await NetworkAPI().postData('my_courses', jsonEncode(body));
          var dashboardNewResult = jsonDecode(response.body);
          if (dashboardNewResult['status'] == 200 &&
              dashboardNewResult['data'] != null &&
              dashboardNewResult['data'] != []) {
            var dashboardResultData = dashboardNewResult['data'];
            List<DashboardModel> dashboardModelData = [];
            for (var j in dashboardResultData) {
              dashboardModelData.add(DashboardModel.fromMap(j));
            }
            await storage.write(
                key: "dashboardResult", value: jsonEncode(dashboardModelData));
            await storage.write(
                key: "certificateCount",
                value: dashboardNewResult['user_certificate_count'].toString());
            return dashboardModelData;
          } else {
            return null;
          }
        } else {
          return null;
        }
      } on HandshakeException catch (_) {
        return "Connection Error";
      } on SocketException catch (_) {
        return "Connection Error";
      } catch (e) {
        return null;
      }
    } else {
      return null;
    }
  }
  //Dashboard Data Fetch Function Ends

  //Dashboard Deliverables Data Fetch Function Starts
  getDashboardDeliverables(ctx, userCourseId) async {
    currentScreen = await storage.read(key: 'current_screen');
    await checkInternet().then((value) => {
          internetStatus = value,
        });
    if (internetStatus) {
      appId = await storage.read(key: 'app_id') ?? baseAppId.toString();
      var body = {
        'token': '$token',
        'required': 'my_course_deliverables_list',
        "user_course_id": userCourseId,
        "app_id": int.tryParse(appId)
      };
      try {
        final isSocketConnect = await hasNetwork();
        if (isSocketConnect) {
          var response =
              await NetworkAPI().postData('my_courses', jsonEncode(body));
          var deliverablesResult = jsonDecode(response.body);
          if (deliverablesResult['status'] == 200 &&
              deliverablesResult['data'] != null &&
              deliverablesResult['data'] != {}) {
            var deliverablesList =
                deliverablesResult['data']['course_title_code_concept_levels'];
            List<CourseConceptModel> deliverablesListData = [];
            for (var j in deliverablesList) {
              List<UserCoursePaymentModel> userCoursePaymentList = [];
              for (var k in j['user_course_payment_deliverables']) {
                UserCoursePaymentModel paymentMapModel =
                    UserCoursePaymentModel.fromMap(k);
                userCoursePaymentList.add(paymentMapModel);
              }
              CourseConceptModel mapModel = CourseConceptModel(
                  id: j['id'],
                  status: j['status'],
                  course_learning_mode_id: j['course_learning_mode_id'],
                  user_course_payment_deliverables: userCoursePaymentList);
              deliverablesListData.add(mapModel);
            }
            return deliverablesListData;
          } else {
            return null;
          }
        } else {
          return null;
        }
      } on HandshakeException catch (_) {
        return "Connection Error";
      } on SocketException catch (_) {
        return "Connection Error";
      } catch (e) {
        return null;
      }
    } else {
      return null;
    }
  }
  //Dashboard Deliverables Data Fetch Function Ends

  //Dashboard Data Fetch Function Starts
  getTechnicalSupportData(ctx, userCourseId) async {
    currentScreen = await storage.read(key: 'current_screen');
    await checkInternet().then((value) => {internetStatus = value});
    if (internetStatus) {
      appId = await storage.read(key: 'app_id') ?? baseAppId.toString();
      var body = {
        'token': '$token',
        'required': 'my_course_referral_company',
        "user_course_id": userCourseId,
        "app_id": appId
      };
      try {
        final isSocketConnect = await hasNetwork();
        if (isSocketConnect) {
          var response =
              await NetworkAPI().postData('my_courses2', jsonEncode(body));
          var technicalSupportResult = jsonDecode(response.body);
          if (technicalSupportResult['status'] == 200 &&
              technicalSupportResult['data'] != null &&
              technicalSupportResult['data'] != []) {
            TechnicalModel technicalModel =
                TechnicalModel.fromMap(technicalSupportResult['data']);
            return technicalModel;
          } else {
            return null;
          }
        } else {
          return null;
        }
      } on HandshakeException catch (_) {
        return "Connection Error";
      } on SocketException catch (_) {
        return "Connection Error";
      } catch (e) {
        return null;
      }
    } else {
      messageFlushBar(ctx, 'No internet available...');
      return null;
    }
  }
  //Dashboard Data Fetch Function Ends
}

class DashboardCard extends StatelessWidget {
  final bool selected;
  final IconData? icon;
  final String? image;
  final bool? dues;
  final String label;
  final VoidCallback onTap;

  const DashboardCard(
      {super.key,
      required this.selected,
      this.icon,
      this.image,
      required this.label,
      required this.onTap,
      this.dues = false});

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.sizeOf(context).width;
    return Stack(
      alignment: Alignment.center,
      children: [
        Center(
          child: InkWell(
            onTap: onTap,
            child: Card(
              elevation: 2,
              surfaceTintColor: selected ? Colors.white : Colors.grey[300],
              color: selected ? Colors.white : Colors.grey[300],
              shadowColor: Colors.grey[500],
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              child: Container(
                width: width * 0.28,
                height: currentScreen == 'mobile' ? 180 : 270,
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(
                      height: 10,
                    ),
                    icon != null
                        ? Icon(
                            icon,
                            color: !selected ? Colors.black45 : colorCode,
                            size: currentScreen == 'mobile' ? 30 : 35,
                          )
                        : image != null
                            ? SvgPicture.asset(
                                image!,
                                color: !selected ? Colors.black45 : colorCode,
                                width: currentScreen == 'mobile' ? 25 : 35,
                                height: currentScreen == 'mobile' ? 25 : 35,
                              )
                            : Container(),
                    const SizedBox(
                      height: 2.0,
                    ),
                    Text(
                      label,
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: currentScreen == 'mobile' ? 12 : 15,
                          fontWeight:
                              !selected ? FontWeight.normal : FontWeight.bold),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        if (dues!) ...[
          Positioned(
            top: 7,
            right: 15,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                AnimateIcon(
                  key: UniqueKey(),
                  onTap: () {},
                  iconType: IconType.continueAnimation,
                  height: 12,
                  width: 12,
                  color: Colors.amber.shade600,
                  animateIcon: AnimateIcons.hourglass,
                ),
                Text(
                  "Dues",
                  style: TextStyle(
                      color: colorCode,
                      fontSize: currentScreen == 'mobile' ? 12 : 15,
                      fontWeight:
                          !selected ? FontWeight.normal : FontWeight.bold),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }
}
