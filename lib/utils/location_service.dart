import 'package:location/location.dart';

class LocationService {
  Location location = Location();

  // Service location permissions function
  Future<bool> isLocationServiceEnabled() async {
    bool isServiceEnabled = await location.serviceEnabled();
    if (!isServiceEnabled) {
      isServiceEnabled = await location.requestService();
    }
    return isServiceEnabled;
  }

  // location permission function

  Future<bool> requestLocationPermission() async {
    PermissionStatus permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
    } else if (permissionGranted == PermissionStatus.deniedForever) {
      // Handle the case where permission is denied forever
      return false;
    }
    return permissionGranted == PermissionStatus.granted;
  }

  // get real time location function
  void getRealTimeLocation(void Function(LocationData)? onData) {
    location.changeSettings(
      distanceFilter: 1,
    ); // distanceFilter: makes the location update every 1 meter
    location.onLocationChanged.listen(onData);
  }
}
