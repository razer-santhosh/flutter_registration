// ignore_for_file: file_names
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

class LocationDetails {
  Position? currentLocation;
  late LocationPermission permission;

  getCurrentLocation() async {
    try {
      permission = await Geolocator
          .checkPermission();
      //to check if permission allowed for the app to access GPS
      if ((permission != LocationPermission.deniedForever &&
              permission == LocationPermission.denied) ||
          permission == LocationPermission.whileInUse) {
        permission = await Geolocator
            .requestPermission(); //it will only ask for GPS access permission if not allowed before
        return await Geolocator.getCurrentPosition();
      }
    } catch (e) {
      return null;
    }
    return null;
  }

  //get address
  getAddress(Position location) async {
    return placemarkFromCoordinates(location.latitude, location.longitude);
  }
}
