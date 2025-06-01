import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:google_maps/models/auto_complete_data_model.dart';
import 'package:google_maps/utils/places_services.dart';
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
  List<Predictions> autoCompletePlaces = [];
  late PlacesServices placesServices;

  @override
  void initState() {
    initialCameraPosition = CameraPosition(target: LatLng(0, 0), zoom: 12);
    locationService = LocationService();
    searchController = TextEditingController();
    placesServices = PlacesServices();
    fetchAutoCompletePlaces();

    super.initState();
  }

  void fetchAutoCompletePlaces() {
    searchController.addListener(() {
      String input = searchController.text;
      if (input.isEmpty) {
        setState(() {
          autoCompletePlaces.clear();
        });
        return;
      }
      placesServices.getAutoCompleteData(input).then((value) {
        setState(() {
          autoCompletePlaces = value;
        });
      });
    });
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
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
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
                if (autoCompletePlaces.isNotEmpty)
                  Container(
                    constraints: BoxConstraints(maxHeight: 300),
                    child: ListView.separated(
                      shrinkWrap: true,
                      itemCount: autoCompletePlaces.length,
                      separatorBuilder:
                          (context, index) =>
                              Divider(height: 1, color: Colors.grey[300]),
                      itemBuilder: (context, index) {
                        final place = autoCompletePlaces[index];
                        return ListTile(
                          leading: Icon(
                            Icons.location_on,
                            color: Colors.blueAccent,
                          ),
                          title: Text(
                            place.description ?? 'No description',
                            style: TextStyle(fontWeight: FontWeight.w500),
                          ),
                          subtitle: Text(
                            'structuredFormatting?.secondaryText',
                            style: TextStyle(color: Colors.grey[600]),
                          ),
                          onTap: () {
                            // Handle place selection
                          },
                        );
                      },
                    ),
                  ),
              ],
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
      log(e.toString());
    } on LocationServiceException catch (e) {
      /// Handle the case where location service is disabled
      log(e.toString());
    } catch (e) {
      /// Handle other exceptions
    }
  }
}
