// ignore_for_file: file_names, deprecated_member_use, unused_local_variable
import 'dart:convert';
import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get_ip_address/get_ip_address.dart';
import 'package:http/http.dart' as http;
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import '../constants.dart';
import '../env/env.dart';
import 'commonFunctions.dart';
import 'locationDetails.dart';

//Network API Starts
class NetworkAPI {
  //Get Data Method
  getData(postUrl) async {
    var url = Uri.parse('${Env.apiUrl}/$postUrl');
    var response = await http.get(url, headers: header);
    return response;
  }

  //Post Data Method
  postData(postUrl, dataBody) async {
    var url = Uri.parse('${Env.apiUrl}/$postUrl');
    var response = await http.post(url, headers: header, body: dataBody);
    return response;
  }

  //OtpPost data Method
  otpPostData(dataBody) async {
    var url = Uri.parse(Env.otpUrl);
    var response = await http.post(url, headers: header, body: dataBody);
    return response;
  }

  //OtpPost data Method

  //Vimeo Video Details Get by Id
  vimeoPostData(id) async {
    var url = Uri.parse("https://player.vimeo.com/video/$id/config");
    var response = await http.get(url, headers: {
      'Authorization': 'Bearer ${Env.vimeoToken}',
      'Referer': Env.ebookUrl,
    });

    return response;
  }

  //Vimeo Video check

  //CheckUrl
  checkUrl(url, bookCode, ctx) async {
    final response = await http.head(
        Uri.parse('$url/assets/e-book/$bookCode/index.php?JEcYWcmNeh=$token'));
    return response;
  }

  //checkPaymentUrl
  checkPaymentUrl(url) async {
    final response = await http.head(Uri.parse('$url'));
    return response;
  }

  //LaunchUrl
  launchUrlData(url, pathUrl) {
    launchUrl(Uri.parse('$url/$pathUrl'));
  }

  //Log Check Api
  logAPI() async {
    Map<String, dynamic> deviceData = <String, dynamic>{};
    try {
      String? appLogId = await storage.read(key: 'appLogId');
      if (appLogId != null) {}
      final info = await PackageInfo.fromPlatform();
      final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
      final ipv4 = await IpAddress(type: RequestType.text).getIpAddress();
      /*  String wifiIPv4 = await getPublicIP() ?? "";
      print('Public IP: $wifiIPv4');*/
      var dataBody = {};
      if (Platform.isAndroid) {
        deviceData = _readAndroidBuildData(await deviceInfoPlugin.androidInfo);
        dataBody = {
          "device":
              "${deviceData['isPhysicalDevice'] ? "Physical" : "Emulator"} - ${deviceData['model']}",
          "operating_system": "Android",
          "operating_system_version":
              int.tryParse(deviceData['version.release']) ?? 0,
          "ip_address": ipv4.toString(),
          "master_app_version": '${info.version}+${info.buildNumber}',
          "master_app_id": baseAppId
        };
      } else if (Platform.isIOS) {
        deviceData = _readIosDeviceInfo(await deviceInfoPlugin.iosInfo);
        dataBody = {
          "device":
              "${deviceData['isPhysicalDevice'] ? "Physical" : "Emulator"} - ${deviceData['model']}",
          "operating_system": "IOS",
          "operating_system_version":
              int.tryParse(deviceData['systemVersion']) ?? 0,
          "ip_address": ipv4.toString(),
          "master_app_version": '${info.version}+${info.buildNumber}',
          "master_app_id": baseAppId,
        };
      }
      if (appLogId == null) {
        dataBody['required'] = 'add_device_log';
      } else {
        dataBody['token'] = token;
        dataBody['required'] = 'master_app_modules';
        dataBody['master_app_log_id'] = int.parse(appLogId);
      }
      dataBody['master_app_package_name'] = info.packageName;
      try {
        await LocationDetails().getCurrentLocation().then((coordinates) async {
          if (coordinates != null) {
            List<Placemark> placemarks =
                await LocationDetails().getAddress(coordinates);
            Placemark place = placemarks[0]; //fetch address
            dataBody['country_short_code'] = place.isoCountryCode;
            dataBody['administrative_area'] = place.administrativeArea;
            dataBody['locality'] = place.locality;
            dataBody['sub_locality'] = place.subLocality;
            dataBody['postal_code'] = place.postalCode;
          }
        });
      } catch (e) {
        null;
      }
      if (dataBody.isNotEmpty) {
        var url = Uri.parse('${Env.apiUrl}/app_manager');
        var response =
            await http.post(url, headers: header, body: jsonEncode(dataBody));
        if (response.statusCode == 200) {
          var result = jsonDecode(response.body);
          final decryptedDataString =
              await CommonFunctions().decryptData(result['encrypted_data']);
          var decoded = jsonDecode(decryptedDataString);
          if (appLogId == null &&
              decoded.containsKey('id') &&
              decoded['id'] != null) {
            await storage.write(
                key: 'appLogId', value: decoded['id'].toString());
          } else {
            menuItems = decoded[0]['master_app_modules'];
          }
          return {'status': true};
        } else if (response.statusCode == 406) {
          Map body = jsonDecode(response.body);
          return {'status': false, 'message': body['message']};
        } else {
          return {'status': false};
        }
      } else {
        return {'status': false};
      }
    } catch (e) {
      return {'status': false};
    }
    /* var response = await http.post(url, headers: header);
    return response;*/
  }
//Log Check Api
}

//Network API Ends
Map<String, dynamic> _readAndroidBuildData(AndroidDeviceInfo build) {
  return <String, dynamic>{
    'version.sdkInt': build.version.sdkInt,
    'version.release': build.version.release,
    'brand': build.brand,
    'device': build.device,
    'display': build.display,
    'hardware': build.hardware,
    'host': build.host,
    'id': build.id,
    'manufacturer': build.manufacturer,
    'model': build.model,
    'product': build.product,
    'type': build.type,
    'isPhysicalDevice': build.isPhysicalDevice,
    'token': token,
    'user_id': userId
  };
}

Map<String, dynamic> _readIosDeviceInfo(IosDeviceInfo data) {
  return <String, dynamic>{
    'name': data.name,
    'systemName': data.systemName,
    'systemVersion': data.systemVersion,
    'model': data.model,
    'localizedModel': data.localizedModel,
    'identifierForVendor': data.identifierForVendor,
    'isPhysicalDevice': data.isPhysicalDevice,
    'utsname.sysname:': data.utsname.sysname,
    'utsname.nodename:': data.utsname.nodename,
    'utsname.release:': data.utsname.release,
    'utsname.version:': data.utsname.version,
    'utsname.machine:': data.utsname.machine,
  };
}
