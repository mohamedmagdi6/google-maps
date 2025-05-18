import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class RouteTrackerPage extends StatefulWidget {
  const RouteTrackerPage({super.key});

  @override
  State<RouteTrackerPage> createState() => _RouteTrackerPageState();
}

class _RouteTrackerPageState extends State<RouteTrackerPage> {
  @override
  Widget build(BuildContext context) {
    return GoogleMap(
      initialCameraPosition: CameraPosition(
        target: LatLng(30.576681472168644, 31.503726980819803),
        zoom: 12,
      ),
    );
  }
}
