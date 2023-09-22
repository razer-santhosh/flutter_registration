import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'appUpgrade.dart';

class ConnectivityProvider with ChangeNotifier {
  bool _isOnline = false;
  bool get isOnline => _isOnline ? _isOnline : checkRealtimeConnection();

  checkRealtimeConnection() {
    Connectivity connectivity = Connectivity();
    connectivity.checkConnectivity().then((value) async {
      if (value == ConnectivityResult.none) {
        _isOnline = false;
      } else {
        _isOnline = true;
      }
      return _isOnline;
    });
    connectivity.onConnectivityChanged.listen((result) async {
      if (result == ConnectivityResult.none) {
        _isOnline = false;
      } else {
        _isOnline = true;
      }
      notifyListeners();
    });
    return _isOnline;
  }
}

class AppUpgradeProvider extends ChangeNotifier {
  bool _isUpdateAvailable = false;
  bool get isUpdateAvailable =>
      _isUpdateAvailable ? _isUpdateAvailable : checkUpgrade();
  checkUpgrade() {
    upgradeProvider().then((value) async {
      if (value != null) {
        _isUpdateAvailable = value;
        return value;
      }
      notifyListeners();
      return false;
    });
    return _isUpdateAvailable;
  }
}
