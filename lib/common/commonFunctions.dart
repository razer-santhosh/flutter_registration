// ignore_for_file: file_names, depend_on_referenced_packages

import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:intl/intl.dart';
import 'package:lms/common/toast.dart';
import 'package:lms/common/validateFunction.dart';
import 'package:open_app_file/open_app_file.dart';
import 'package:open_store/open_store.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import '../constants.dart';
import '../env/env.dart';
import '../main.dart';
import '../src/model/addCourseModel.dart';
import 'alertDialog.dart';
import 'decryption.dart';
import 'internetCheck.dart';
import 'networkApi.dart';
import 'permissionRequest.dart';

class CommonFunctions {
  //Get User Profile Details
  getProfile() async {
    try {
      String? certificateCount = await storage.read(key: 'certificateCount');
      if (certificateCount != null) {
        allowNameEdit = int.tryParse(certificateCount) ?? 0;
      }
      userId = await storage.read(key: 'user_id');
      appId = await storage.read(key: 'app_id') ?? baseAppId.toString();
      if (userId != null) {
        var body = {
          'token': token ?? await storage.read(key: 'token'),
          'required': 'my_profile_view',
          'user_id': int.tryParse(userId) ?? 0,
          'app_id': int.tryParse(appId) ?? int.tryParse(baseAppId.toString())
        };
        var newProfile = await storage.read(key: "profileData");
        if (newProfile == null) {
          var response =
              await NetworkAPI().postData('my_profile2', jsonEncode(body));
          profileData = jsonDecode(response.body);
          await storage.write(key: "profileData", value: response.body);
        } else {
          profileData = jsonDecode(newProfile);
        }
        if (profileData['status'] == 200) {
          var decryptedDataString =
              await decryptData(profileData['encrypted_data']);
          var decoded = jsonDecode(decryptedDataString);
          return null;
        } else {
          return null;
        }
      }
    } on HandshakeException catch (_) {
      return "Connection Error";
    } on SocketException catch (_) {
      return "Connection Error";
    } catch (e) {
      return null;
    }
  }

  genderList() async {
    try {
      var body = {
        'token': token ?? await storage.read(key: 'token'),
        'app_id': int.tryParse(appId) ?? int.tryParse(baseAppId.toString()),
        'required': 'gender_list',
      };
      var response =
          await NetworkAPI().postData('gender_list', jsonEncode(body));
      var genderData = jsonDecode(response.body);
      if (genderData['status'] == 200) {
        List<CommonModel> genderList = [];
        if (genderData['encrypted_data'] != null) {
          final decryptedDataString =
              await decryptData(genderData['encrypted_data']);
          List decoded = jsonDecode(decryptedDataString);
          for (var i in decoded) {
            genderList.add(CommonModel.fromMap(i));
          }
          return genderList;
        } else {
          return null;
        }
      }
    } on HandshakeException catch (_) {
      return null;
    } on SocketException catch (_) {
      return null;
    } catch (e) {
      return null;
    }
  }

  //get state list
  stateList(countryId, ctx) async {
    try {
      var body = {
        'token': token ?? await storage.read(key: 'token'),
        'country_id': countryId,
        'app_id': int.tryParse(appId) ?? int.tryParse(baseAppId.toString())
      };
      var response =
          await NetworkAPI().postData('state_list', jsonEncode(body));
      result = jsonDecode(response.body);
      if (result['status'] == 200) {
        final decryptedDataString = await decryptData(result['encryptedData']);
        List decoded = jsonDecode(decryptedDataString);
        result = stateList;
      } else {
        result = null;
      }
      return result;
    } on HandshakeException catch (_) {
      return null;
    } on SocketException catch (_) {
      messageFlushBar(ctx, errorMsg);
      return null;
    } catch (e) {
      return null;
    }
  }

  //Get District Data Starts
  // getDistrict(StateModel state, [bool courseRegistration = false]) async {
  //   var body = {
  //     'token': token ?? await storage.read(key: 'token'),
  //     'required': 'get_district_list',
  //     'master_state_id': state.id
  //   };
  //   if (courseRegistration) {
  //     body['master_division_id'] = masterDivisionId;
  //   }
  //   var response =
  //       await NetworkAPI().postData('district_list', jsonEncode(body));
  //   var districtData = jsonDecode(response.body);
  //   if (districtData['status'] == 200) {
  //     final decryptedDataString =
  //         await decryptData(districtData['encryptedData']);
  //     List decoded = jsonDecode(decryptedDataString);
  //     List<CommonModel> districtList = [];
  //     for (var l in decoded) {
  //       districtList.add(CommonModel.fromMap(l));
  //     }
  //     return districtList;
  //   } else {
  //     return null;
  //   }
  // }
  //Get District Data Ends

  // Get Centre List   Starts
  // getCentreList(context, StateModel stateId,
  //     {CommonModel? district, titleId}) async {
  //   try {
  //     appId = await storage.read(key: 'app_id') ?? baseAppId.toString();
  //     var companyId = await storage.read(key: 'referralCompanyCode');
  //     var body = {
  //       "token": token,
  //       "master_division_id": masterDivisionId,
  //       "master_state_id": stateId.id,
  //       "app_id": int.tryParse(appId)
  //     };
  //     if (companyId != null) {
  //       body['chosen_user_company'] = companyId;
  //     }
  //     if (district != null) {
  //       body['master_district_id'] = district.id;
  //     }
  //     if (titleId != null) {
  //       body['course_title_code_id'] = titleId;
  //     }
  //     var response =
  //         await NetworkAPI().postData('centre_list', jsonEncode(body));
  //     var centreListData = jsonDecode(response.body);
  //     var centres = await storage.read(key: "referralCompanyCode");
  //     Navigator.pop(context);
  //     if (centreListData != null) {
  //       if (centreListData['status'] == 200) {
  //         final decryptedDataString =
  //             await decryptData(centreListData['encrypted_data']);
  //         var decoded = jsonDecode(decryptedDataString);
  //         var decryptedCentres = decoded['centre_list'];
  //         String chosenCompanyCodeStatus =
  //             decoded['chosen_company_code_status'].toString();
  //         List<CentreListModel>? centreList = [];
  //         if (decryptedCentres != null && decryptedCentres.isNotEmpty) {
  //           for (var i in decryptedCentres) {
  //             centreList.add(CentreListModel.fromMap(i));
  //           }
  //           return {
  //             "centreList": centreList,
  //             "chosenCompanyCodeStatus": chosenCompanyCodeStatus
  //           };
  //         } else {
  //           if (centres == null || centres == "") {
  //             messageFlushBar(
  //                 context, "Centre list not available for the chosen district");
  //           }
  //           return null;
  //         }
  //       } else if (centreListData['status'] == 404) {
  //         if (centres == null || centres == "") {
  //           messageFlushBar(
  //               context, "Centre list not available for the chosen district");
  //         }
  //         return null;
  //       } else {
  //         return null;
  //       }
  //     }
  //   } on HandshakeException catch (_) {
  //     return "Connection Error";
  //   } on SocketException catch (_) {
  //     return "Connection Error";
  //   } catch (e) {
  //     return null;
  //   }
  // }
  //Get Centre List  Ends

  // Get Payment Status   Starts
  getPaymentStatus(context, cartId) async {
    try {
      appId = await storage.read(key: 'app_id') ?? baseAppId.toString();
      var body = {
        "token": token,
        "cart_id": int.tryParse(cartId),
        "app_id": int.tryParse(appId)
      };
      var response =
          await NetworkAPI().postData('payment_status', jsonEncode(body));
      var paymentStatusData = jsonDecode(response.body);
      if (paymentStatusData != null) {
        if (paymentStatusData['status'] == 200) {
          if (paymentStatusData['data'] != null &&
              paymentStatusData['data'].isNotEmpty) {
            return {"status": paymentStatusData['data']['name']};
          } else {
            return null;
          }
        } else if (paymentStatusData['status'] == 404) {
          return null;
        } else {
          return null;
        }
      }
    } on HandshakeException catch (_) {
      return null;
    } on SocketException catch (_) {
      return null;
    } catch (e) {
      return null;
    }
  }
  // Get Payment Status   Ends

  //dlm files download function starts
  downloadFile(ctx, id) async {
    dynamic result;
    try {
      // await checkInternet().then((value) async {
      // if (value == true) {
      userId = await storage.read(key: 'user_id');
      appId = await storage.read(key: 'app_id') ?? baseAppId.toString();
      userId = int.tryParse(userId);
      var body = {
        'token': '$token',
        'required': 'useraddondata',
        "master_role_id": 2,
        "user_id": userId,
        "app_id": int.tryParse(appId),
        "course_addon_id": id,
        "user_course_id": int.tryParse(courseId),
        "course_concept_id": courseData['user_course_payment_deliverables'][0]
            ['course_concept_id'],
        "course_service_provider_id":
            courseData['user_course_payment_deliverables'][0]
                ['course_service_provider_id'],
        "course_level_id": courseData['user_course_payment_deliverables'][0]
            ['course_level_id'],
      };
      var response =
          await NetworkAPI().postData('user_course_addon', jsonEncode(body));
      result = jsonDecode(response.body);
      if (result['status'] == 200 && result['data'].isNotEmpty) {
        var res = result['data'];
        if (res[0] != null) {
          String type = id == 5
              ? 'questions'
              : id == 7
                  ? 'lab_exercise'
                  : id == 16
                      ? 'internship'
                      : 'syllabus';
          dynamic encodedStr;
          if (res[0]["url"] != null && res[0]["url"] != "") {
            if (hasValidUrl(res[0]["url"])) {
              if (res[0]["url"].contains(".zip") ||
                  res[0]["url"].contains(".pdf")) {
                encodedStr = res[0]['url'];
                var extension = encodedStr.split(".").last;
                String fileName =
                    '${courseData['user_course_payment_deliverables'][0]['course_concept_name']}_${courseData['user_course_payment_deliverables'][0]['course_level_name'] != null ? '${courseData['user_course_payment_deliverables'][0]['course_level_name']}_' : ''}${type}_${DateFormat('d_M_y_hh_mm_ss_a').format(DateTime.now())}.$extension';
                Dio dio = Dio();
                String storagePath = "";
                if (Platform.isAndroid) {
                  storagePath = Env.baseStorage.toString();
                } else {
                  Directory? downloadsDir = await getDownloadsDirectory();
                  storagePath = downloadsDir.toString();
                }
                await dio.download(
                  res[0]['url'],
                  "$storagePath/$fileName",
                  onReceiveProgress: (received, total) async {
                    if (total != -1) {
                      // String progress =
                      //     "${(received / total * 100).toStringAsFixed(0)}%";
                    }
                  },
                ).then((value) async {
                  Navigator.pop(ctx);
                  if (extension == "pdf") {
                    String storagePath = "";
                    if (Platform.isAndroid) {
                      storagePath = Env.baseStorage.toString();
                    } else {
                      Directory? downloadsDir = await getDownloadsDirectory();
                      storagePath = downloadsDir.toString();
                    }
                    OpenAppFile.open("$storagePath/$fileName",
                        mimeType: 'application/pdf');
                  } else {
                    messageFlushBar(ctx, "File downloaded successfully");
                  }
                });
              } else {
                Navigator.pop(ctx);
                return res[0]["url"].toString();
              }
            } else {
              Navigator.pop(ctx);
              messageFlushBar(ctx, errorMsg);
              return null;
            }
          } else if (res[0]["filedata"] != null && res[0]["filedata"] != "") {
            bool permission = await permissionRequest(ctx);
            if (permission) {
              encodedStr = res[0]['filedata'];
              var extension =
                  encodedStr.split(";")[0].split("data:application/")[1];
              // var mimeType = encodedStr.split(";")[0];
              encodedStr = encodedStr.split(",")[1];
              String fileName =
                  '${courseData['user_course_payment_deliverables'][0]['course_concept_name']}_${courseData['user_course_payment_deliverables'][0]['course_level_name'] != null ? '${courseData['user_course_payment_deliverables'][0]['course_level_name']}_' : ''}${type}_${DateFormat('d_M_y_hh_mm_ss_a').format(DateTime.now())}.$extension';
              var bytes = base64.decode(encodedStr);
              String storagePath = "";
              if (Platform.isAndroid) {
                storagePath = Env.baseStorage.toString();
              } else {
                Directory? downloadsDir = await getDownloadsDirectory();
                storagePath = downloadsDir.toString();
              }
              File file = File("$storagePath/$fileName");
              if (await File("$storagePath/$fileName").exists()) {
                if (extension == "pdf") {
                  OpenAppFile.open("$storagePath/$fileName",
                      mimeType: 'application/pdf');
                } else {
                  messageFlushBar(ctx, "File already exist");
                }
              } else {
                await file.writeAsBytes(bytes).then((value) {
                  Navigator.pop(ctx);
                  if (extension == "pdf") {
                    OpenAppFile.open("$storagePath/$fileName",
                        mimeType: 'application/pdf');
                  } else {
                    messageFlushBar(
                        ctx, "File downloaded in your downloads folder");
                  }
                });
                return "Success";
              }
              Navigator.pop(ctx);
              return "Success";
            } else {
              Navigator.pop(ctx);
              Future.delayed(const Duration(milliseconds: 500))
                  .then((value) async {
                await messageFlushBar(ctx, "Enable Storage Permission");
                openAppSettings();
              });
              return null;
            }
          } else {
            Navigator.pop(ctx);
            Future.delayed(const Duration(milliseconds: 500)).then((value) {
              dialogWithOkButton(ctx, 'No File Found');
            });
            return null;
          }
        } else {
          Navigator.pop(ctx);
          Future.delayed(const Duration(milliseconds: 500)).then((value) {
            dialogWithOkButton(ctx, 'No File Found');
          });
          return null;
        }
      } else {
        Navigator.pop(ctx);
        Future.delayed(const Duration(milliseconds: 500)).then((value) {
          dialogWithOkButton(ctx, 'No File Found');
        });
        return null;
      }
      // }
      // else {
      //   Navigator.pop(ctx);
      //   return null;
      // }
      // });
    } on HandshakeException catch (_) {
      return 'Connection Error';
    } on SocketException catch (_) {
      return 'Connection Error';
    } catch (e) {
      Navigator.pop(ctx);
      Future.delayed(const Duration(milliseconds: 500)).then((value) {
        dialogWithOkButton(ctx, 'No File Found');
      });
      return null;
    }
  }
  //dlm files download function end

  enquiryOTP(ctx, userId) async {
    try {
      dynamic result;
      late bool otpStatus;
      await checkInternet().then((value) async {
        if (value) {
          var body = {
            'user_id': '$userId',
            'package_from': 'react',
            'otp_digit_count': 4,
            'app_id': int.tryParse(appId) ?? int.tryParse(baseAppId.toString())
          };
          var response = await NetworkAPI().otpPostData(jsonEncode(body));
          result = jsonDecode(response.body);
          if (result['status'] == 200) {
            otpSent = true;
            otpStatus = true;
          } else {
            messageFlushBar(ctx, result['message']);
            otpStatus = false;
          }
        } else {
          otpStatus = false;
        }
      });
      return {'otpStatus': otpStatus, 'data': result};
    } on HandshakeException catch (_) {
      return 'Connection Error';
    } on SocketException catch (_) {
      messageFlushBar(ctx, errorMsg);
      return {'otpStatus': false};
    } catch (e) {
      return {'otpStatus': false};
    }
  }

  referralCodeCheck(ctx, referralId, [courseTitleId]) async {
    try {
      dynamic result;
      bool isValid = true;
      List<CentreListModel>? centreList = [];
      String chosenCompanyCodeStatus = "";
      await checkInternet().then((value) async {
        if (value) {
          var body = {
            'centre_code': referralId,
            'master_division_id': masterDivisionId,
            "app_id": int.tryParse(appId) ?? int.tryParse(baseAppId.toString())
          };
          if (courseTitleId != null) {
            body['course_title_code_id'] = courseTitleId;
          }
          var response =
              await NetworkAPI().postData('centre_list', jsonEncode(body));
          result = jsonDecode(response.body);

          if (result['status'] == 200 && result['data'].isNotEmpty) {
            List<String> decryptedChunks = [];
            for (int j = 0; j < result['encrypted_data'].length; j++) {
              String decrypted =
                  decryptAESCryptoJS(result['encrypted_data'][j]);
              decryptedChunks.add(decrypted);
            }
            final decryptedDataString = decryptedChunks.join('');
            var decryptedCentres =
                jsonDecode(decryptedDataString)['centre_list'];
            chosenCompanyCodeStatus =
                jsonDecode(decryptedDataString)['chosen_company_code_status']
                    .toString();
            for (var i in decryptedCentres) {
              centreList.add(CentreListModel.fromMap(i));
            }
            isValid = true;
          } else {
            isValid = false;
          }
        } else {
          messageFlushBar(ctx, 'No internet available...');
          isValid = false;
        }
      });
      return {
        'status': isValid,
        'data': centreList,
        'chosenCompanyCodeStatus': chosenCompanyCodeStatus
      };
    } on HandshakeException catch (_) {
      return {'status': false};
    } on SocketException catch (_) {
      messageFlushBar(ctx, errorMsg);
      return {'status': false};
    } catch (e) {
      return {'status': false};
    }
  }

  //decrypt data
  decryptData(encryptedData) {
    List<String> decryptedChunks = [];
    for (int j = 0; j < encryptedData.length; j++) {
      String decrypted = decryptAESCryptoJS(encryptedData[j]);
      decryptedChunks.add(decrypted);
    }
    final decryptedDataString = decryptedChunks.join('');
    return decryptedDataString;
  }

  //decoration style
  inputBoxStyle(label, icon) {
    return InputDecoration(
      labelText: label,
      contentPadding: const EdgeInsets.all(6),
      prefixIcon: Icon(
        icon == 'email' ? Icons.mail_outlined : Icons.mobile_friendly_outlined,
        size: 13,
        color: colorCode,
      ),
      border: const OutlineInputBorder(),
      counterText: '',
    );
  }

  //name field
  nameWidget(bool focus, TextEditingController ctrl, bool read, String label,
      String errormsg) {
    return TextFormField(
      autofocus: focus,
      controller: ctrl,
      readOnly: read,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      cursorColor: inputBoxFocusBorder,
      decoration: InputDecoration(
          label: Text(label),
          isDense: true,
          floatingLabelStyle: const TextStyle(color: inputBoxBorder),
          focusedBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: inputBoxFocusBorder)),
          focusColor: inputBoxFocusBorder),
      style: const TextStyle(
        decorationThickness: 0, //remove underline for string while typing
      ),
      keyboardType: TextInputType.text,
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp('[a-zA-Z ]')),
        LengthLimitingTextInputFormatter(20)
      ],
      validator: (value) {
        if (value == null || value.isEmpty) {
          return errormsg;
        }
        return null;
      },
    );
  }

  //Download Certificate Function Starts
  // downloadCertificate(userCourseId, courseName, ctx) async {
  //   await checkInternet().then((value) => {internetStatus = value});
  //   if (internetStatus) {
  //     bool isGranted = false;
  //     try {
  //       isGranted = await permissionRequest(ctx);
  //       if (isGranted) {
  //         otpDialog(ctx, 7);
  //         String fileName = '$courseName.pdf';
  //         int percentage = 0;
  //         Dio dio = Dio();
  //         String url = '${Env.downloadUrl}token&user_course_id=$userCourseId';
  //         await dio.download(url, "${Env.baseStorage}/$fileName",
  //             onReceiveProgress: ((count, total) {
  //           percentage = ((count / total) * 100).floor();
  //         })).then((value) => {
  //               Navigator.of(ctx, rootNavigator: true).pop(),
  //               OpenAppFile.open("${Env.baseStorage}/$fileName",
  //                   mimeType: 'application/pdf'),
  //             });
  //       } else {
  //         messageFlushBar(ctx, "Enable Storage Permission", "Error",
  //             Icons.error_outline_outlined);
  //       }
  //     } on HandshakeException catch (_) {
  //       return "Connection Error";
  //     } on SocketException catch (_) {
  //       return "Connection Error";
  //     } catch (e) {
  //       errorMessageFlushBar(ctx, errorMsg, Icons.error_outline_outlined);
  //     }
  //   } else {
  //     connectionFlushBar(ctx);
  //   }
  // }
  //Download Certificate Function Ends

  //local notification
  showLocalNotification(fileName) async {
    String storagePath = "";
    if (Platform.isAndroid) {
      storagePath = Env.baseStorage.toString();
    } else {
      Directory? downloadsDir = await getDownloadsDirectory();
      storagePath = downloadsDir.toString();
    }
    const AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails('your channel id', 'your channel name',
            channelDescription: 'your channel description',
            importance: Importance.max,
            priority: Priority.high,
            ticker: 'ticker');
    const NotificationDetails notificationDetails = NotificationDetails(
        android: androidNotificationDetails, iOS: DarwinNotificationDetails());
    await flutterLocalNotificationsPlugin.show(
        0, fileName, 'Downloaded successfully', notificationDetails,
        payload: '$storagePath/$fileName');
  }

  // static String createQueryUrl(String query) {
  //   Uri uri;
  //   if (Platform.isAndroid) {
  //     uri = Uri(scheme: 'geo', host: '0,0', queryParameters: {'q': query});
  //   } else if (Platform.isIOS) {
  //     uri = Uri.https('maps.apple.com', '/', {'q': query});
  //   } else {
  //     uri = Uri.https(
  //         'www.google.com', '/maps/search/', {'api': '1', 'query': query});
  //   }
  //   return uri.toString();
  // }

  /// Launches the maps application for this platform.
  // static Future<bool> launchQuery(String query) {
  // return launchUrl(Uri.parse(createQueryUrl(query)));
  // }

  /// Launches the Teams application for this platform.
  launchUrlTeams(String url) async {
    try {
      if (!await launchUrl(
        Uri.parse(url),
        mode: LaunchMode.externalApplication,
      )) {
        OpenStore.instance.open(
          androidAppBundleId:
              "com.microsoft.teams", // Android app bundle package name
        );
      }
    } catch (e) {
      OpenStore.instance.open(
        androidAppBundleId:
            "com.microsoft.teams", // Android app bundle package name
      );
    }
  }

  //mail
  sendingMails(String mailId) async {
    var url = Uri.parse("mailto:$mailId");
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    }
  }

  //url
  launchWebApp(String webUrl) async {
    var url = Uri.parse(webUrl);
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    }
  }
}

class CommonModel {
  final int id;
  final String name;

  const CommonModel({
    required this.id,
    required this.name,
  });

  //Json to Model
  factory CommonModel.fromMap(Map<String, dynamic> json) =>
      CommonModel(id: json["id"], name: json["name"]);

  //Model to Json
  Map toJson() => {
        'id': id,
        'name': name,
      };
}
