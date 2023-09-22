// ignore_for_file: file_names
import 'dart:convert';
import 'dart:io';
import 'package:open_store/open_store.dart';
import 'package:package_info_plus/package_info_plus.dart';
import '../../common/internetCheck.dart';
import '../../common/networkApi.dart';
import '../../common/theme.dart';
import '../../common/toast.dart';
import '../../constants.dart';
import '../view/dashboard.dart';

class LoginController {
  //Send OTP Function Starts
  sendOtp(email, context, appId) async {
    final info = await PackageInfo.fromPlatform();
    try {
      late bool otpStatus;
      info.packageName;
      await checkInternet().then((value) async {
        if (value) {
          var body = {
            'user_id': '$email',
            'package_name': info.packageName,
            'app_id': appId
          };
          var response = await NetworkAPI().otpPostData(jsonEncode(body));
          var result = jsonDecode(response.body);
          if (result['status'] == 200) {
            if (result['registration_status'] > 1) {
              messageFlushBar(context, "Invalid Email Id or Mobile Number");
              otpStatus = false;
            } else {
              otpSent = otpStatus = true;
              await storage.write(
                  key: 'app_id',
                  value: result['app_id'] != null && result['app_id'] != 0
                      ? result['app_id'].toString()
                      : baseAppId.toString().toString());
              await storage.write(
                  key: 'appVersion',
                  value: "${info.version}+${info.buildNumber}");
              await storage.write(
                  key: 'existing_user',
                  value: result['registration_status'].toString());
            }
          } else if (result['status'] == 301) {
            if (Platform.isAndroid) {
              OpenStore.instance.open(
                androidAppBundleId: result[
                    'android_package_name'], // Android app bundle package name
              );
            }
          } else {
            messageFlushBar(context, "Invalid Email Id or Mobile Number");
            otpStatus = false;
          }
        } else {
          messageFlushBar(context);
          otpStatus = false;
        }
      });
      return otpStatus;
    } on HandshakeException catch (_) {
      return 'Connection Error';
    } on SocketException catch (_) {
      messageFlushBar(context, errorMsg);
      return false;
    } catch (e) {
      return false;
    }
  }
  //Send Otp Function Ends

  //Otp Verification Function Starts
  verifyOTP(userId, otp, type, context, newCurrentScreen) async {
    if (type == 'mobile') {
      userId = int.tryParse(userId);
    }
    appId = await storage.read(key: 'app_id') ?? baseAppId.toString();
    await storage.write(key: 'current_screen', value: newCurrentScreen);
    String? existingUser = await storage.read(key: 'existing_user');
    var body = {
      'user_id': userId,
      'app_id': appId,
      'password': int.tryParse(otp)
    };
    try {
      var res = await NetworkAPI().postData("login", jsonEncode(body));
      if (res.statusCode == 200) {
        var resultData = jsonDecode(res.body);
        if (resultData['status'] == 200) {
          if (existingUser == '1') {
            var result = resultData['data'];
            userName = "${result['first_name']} ${result['last_name']}";
            token = result['token'];
            await storage.write(key: 'token', value: token);
            var res = await NetworkAPI().logAPI();
            if (!res['status']) {
              messageFlushBar(context, res['message']);
              return false;
            }
            await storage.containsKey(key: 'dashboardResult').then(
                (value) async => await storage.delete(key: 'dashboardResult'));
            await storage.write(key: 'token', value: token);
            await storage.write(
                key: 'student_care_email_id',
                value: result['student_care_email_id']);
            await storage.write(
                key: 'student_care_contact_no',
                value: result['student_care_contact_no'].toString());
            await storage.write(
                key: 'profile_picture', value: result['profile_picture']);
            await storage.write(key: 'user_id', value: result['id'].toString());
            await storage.write(
                key: 'user_email_id', value: result['email_id']);
            await storage.write(
                key: 'user_mobile', value: result['contact_no']);
            if (result['adv_url'] != null) {
              await storage.write(key: 'jobPakkaUrl', value: result['adv_url']);
            }
            await storage.write(key: 'username', value: userName);
            if (result['referral_company_code'] != null &&
                result['referral_company_code'] != "") {
              await storage.write(
                  key: 'referralCompanyCode',
                  value: result['referral_company_code']);
            } else {
              var referral = await storage.read(key: 'referral_code');
              if (referral != null && referral != '') {
                await storage.write(
                    key: 'referralCompanyCode', value: referral.toString());
              }
            }
            await storage.write(
                key: 'masterStateId',
                value: result['master_state_id'] != null
                    ? result['master_state_id'].toString()
                    : '1');
          }
          return {'status': true, 'message': resultData['message']};
        } else {
          return {'status': false, 'message': resultData['message']};
        }
      } else {
        messageFlushBar(context, jsonDecode(res.body)['message']);
        return {'status': false};
      }
    } on HandshakeException catch (_) {
      return {'status': false, 'message': 'Connection Error'};
    } on SocketException catch (_) {
      messageFlushBar(context, errorMsg);
      return {'status': false};
    } catch (e) {
      messageFlushBar(context, errorMsg);
      return {'status': false};
    }
  }
  //Otp Verification Function Ends

  //Logout User Function Starts
  logout() async {
    profileData = null;
    nsdcData = '';
    dashboardData = 0;
    token = null;
    dashboardResult = null;
    bottomIndex = 0;
    menuItems = [];
    baseSideMenu = [];
    bottomNavBar = [];
    addCount = 0;
    profilePicture = null;
    encodedImage = null;
    await storage.deleteAll();
  }
  //Logout user Function Ends
}
