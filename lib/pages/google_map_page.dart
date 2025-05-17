import 'package:flutter/material.dart';
import 'package:google_maps/models/marker_model.dart';
import 'package:google_maps/utils/location_service.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class GoogleMapPage extends StatefulWidget {
  const GoogleMapPage({super.key});

  @override
  State<GoogleMapPage> createState() => _GoogleMapPageState();
}

class _GoogleMapPageState extends State<GoogleMapPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  GoogleMapController? mapController;
  late LocationService locationService;
  Set<Marker> mapMarkers = {};
  Set<Polyline> polylines = {};
  Set<Polygon> polygons = {};
  late Location location;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
    location = Location();
    locationService = LocationService();
    initializeLocationServices();
    initMarker();
    initPolyline();
    initPoyGon();
  }

  @override
  void dispose() {
    _controller.dispose();
    mapController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Google Map')),
      body: Stack(
        children: [
          GoogleMap(
            polygons: polygons,
            polylines: polylines,
            markers: mapMarkers,
            onMapCreated: (GoogleMapController controller) {
              mapController = controller;
            },
            // cameraTargetBounds: CameraTargetBounds(
            //   LatLngBounds(
            //     northeast: const LatLng(30.63792201718762, 31.382469997852287),
            //     southwest: const LatLng(30.633627342081983, 31.378395747273252),
            //   ),
            // ),
            initialCameraPosition: CameraPosition(
              target: const LatLng(30.576681472168644, 31.503726980819803),

              zoom: 12,
            ),
          ),
          Positioned(
            bottom: 20,
            left: 20,
            child: FloatingActionButton(
              onPressed: () async {
                // Move to current location (example coordinates used here)
                mapController!.animateCamera(
                  CameraUpdate.newLatLng(
                    LatLng(30.594842775901547, 31.733810556358584),
                  ),
                );
              },
              child: const Icon(Icons.my_location),
            ),
          ),
        ],
      ),
    );
  }

  void initMarker() {
    Set<Marker> markers =
        markersModel.map((marker) {
          return Marker(
            markerId: MarkerId(marker.id),
            position: marker.position,
            infoWindow: InfoWindow(
              title: marker.title,
              snippet: marker.snippet,
            ),
          );
        }).toSet();

    setState(() {
      mapMarkers = markers;
    });
  }

  void initPolyline() {
    Polyline polyline = Polyline(
      startCap: Cap.roundCap,
      endCap: Cap.roundCap,
      polylineId: const PolylineId('1'),
      points: [
        const LatLng(30.594842775901547, 31.733810556358584),
        const LatLng(30.638183411309782, 31.37968581530116),
      ],
      color: Colors.red,
      width: 2,
    );

    setState(() {
      polylines.add(polyline);
    });
  }

  void initPoyGon() {
    Polygon polygon = Polygon(
      holes:
          [], // ال holes دى بتبقى عباره عن  list<list<latLng>>    ## clall holyPolygon ##
      polygonId: const PolygonId('1'),
      points: [
        const LatLng(30.594842775901547, 31.733810556358584),
        const LatLng(30.638183411309782, 31.37968581530116),
        const LatLng(30.576681472168644, 31.503726980819803),
      ],
      fillColor: Colors.red.withAlpha(50),
      strokeColor: Colors.red,
      strokeWidth: 1,
    );

    setState(() {
      polygons.add(polygon);
    });
  }

  void initializeLocationServices() async {
    bool isServiceEnabled = await locationService.isLocationServiceEnabled();
    if (isServiceEnabled) {
      bool hasPermission = await locationService.requestLocationPermission();
      if (hasPermission) {
        locationService.getRealTimeLocation((locationData) {
          mapController?.animateCamera(
            CameraUpdate.newLatLng(
              LatLng(locationData.latitude!, locationData.longitude!),
            ),
          );
          mapMarkers.add(
            Marker(
              markerId: const MarkerId('currentLocation'),
              position: LatLng(locationData.latitude!, locationData.longitude!),
              infoWindow: const InfoWindow(title: 'Current Location'),
            ),
          );
          setState(() {});
        });
      }
    }
  }
}
