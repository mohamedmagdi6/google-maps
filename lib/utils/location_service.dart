import 'package:location/location.dart';

class LocationService {
  Location location = Location();

  // Service location permissions function
  Future<void> isLocationServiceEnabled() async {
    bool isServiceEnabled = await location.serviceEnabled();
    if (!isServiceEnabled) {
      isServiceEnabled = await location.requestService();
      if (!isServiceEnabled) {
        throw LocationServiceException();
      }
    }
  }

  // location permission function

  Future<void> requestLocationPermission() async {
    PermissionStatus permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
    } else if (permissionGranted == PermissionStatus.deniedForever) {
      // Handle the case where permission is denied forever
      throw LocationPermissionException();
    }
    if (permissionGranted != PermissionStatus.granted) {
      throw LocationPermissionException();
    }
  }

  // get real time location function
  void getRealTimeLocation(void Function(LocationData)? onData) async {
    await isLocationServiceEnabled();
    await requestLocationPermission();
    location.changeSettings(
      distanceFilter: 1,
    ); // distanceFilter: makes the location update every 1 meter
    location.onLocationChanged.listen(onData);
  }

  // get current location function
  Future<LocationData?> getCurrentLocation() async {
    await isLocationServiceEnabled();
    await requestLocationPermission();
    return await location.getLocation();
  }
}

class LocationServiceException implements Exception {}

class LocationPermissionException implements Exception {}
