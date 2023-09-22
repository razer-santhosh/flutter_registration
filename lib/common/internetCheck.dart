// ignore_for_file: prefer_typing_uninitialized_variables, file_names
import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart' deferred as internet;
import '../constants.dart';

//Check Internet Connection Status Function Starts
checkInternet() async {
  var connectivityResult;
  await internet.loadLibrary().then((value) async => {
        connectivityResult =
            await (internet.Connectivity().checkConnectivity()),
        if (connectivityResult == internet.ConnectivityResult.mobile ||
            connectivityResult == internet.ConnectivityResult.vpn ||
            connectivityResult == internet.ConnectivityResult.wifi)
          {
            internetStatus = true,
          }
        else
          {
            internetStatus = false,
          }
      });
  return internetStatus;
}
//Check Internet Connection Status Function Ends

Future<bool> hasNetwork() async {
  try {
    final result = await InternetAddress.lookup('example.com');
    return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
  } on SocketException catch (_) {
    return false;
  }
}
