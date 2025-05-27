import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:google_maps/utils/location_service.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class RouteTrackerPage extends StatefulWidget {
  const RouteTrackerPage({super.key});

  @override
  State<RouteTrackerPage> createState() => _RouteTrackerPageState();
}

class _RouteTrackerPageState extends State<RouteTrackerPage> {
  late CameraPosition initialCameraPosition;
  late LocationService locationService;
  late GoogleMapController mapController;
  late TextEditingController searchController;

  @override
  void initState() {
    initialCameraPosition = CameraPosition(target: LatLng(0, 0), zoom: 12);
    locationService = LocationService();
    searchController = TextEditingController();
    searchController.addListener(() {
      // Handle search input changes if needed
      log('Search input: ${searchController.text}');
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GoogleMap(
          onMapCreated: (GoogleMapController controller) {
            mapController = controller;
            updateInitialCameraPosition();
          },
          initialCameraPosition: initialCameraPosition,
        ),
        Positioned(
          top: 40,
          left: 16,
          right: 16,
          child: Material(
            elevation: 4,
            borderRadius: BorderRadius.circular(8),
            child: TextField(
              controller: searchController,
              decoration: InputDecoration(
                hintText: 'Search here',
                prefixIcon: Icon(Icons.search),
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(
                  vertical: 14,
                  horizontal: 16,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  void updateInitialCameraPosition() async {
    try {
      var locationData = await locationService.getCurrentLocation();
      mapController.animateCamera(
        CameraUpdate.newLatLng(
          LatLng(locationData!.latitude!, locationData.longitude!),
        ),
      );
    } on LocationPermissionException catch (e) {
      /// Handle the case where permission is denied
    } on LocationServiceException catch (e) {
      /// Handle the case where location service is disabled
    } catch (e) {
      /// Handle other exceptions
    }
  }
}
