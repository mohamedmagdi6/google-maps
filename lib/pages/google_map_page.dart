import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class GoogleMapPage extends StatefulWidget {
  const GoogleMapPage({super.key});

  @override
  State<GoogleMapPage> createState() => _GoogleMapPageState();
}

class _GoogleMapPageState extends State<GoogleMapPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late GoogleMapController mapController;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
  }

  @override
  void dispose() {
    _controller.dispose();
    mapController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Google Map')),
      body: Stack(
        children: [
          GoogleMap(
            onMapCreated: (GoogleMapController controller) {
              mapController = controller;
            },
            cameraTargetBounds: CameraTargetBounds(
              LatLngBounds(
                northeast: const LatLng(30.63792201718762, 31.382469997852287),
                southwest: const LatLng(30.633627342081983, 31.378395747273252),
              ),
            ),
            initialCameraPosition: CameraPosition(
              target: LatLng(37.42796133580664, -122.085749655962),
              zoom: 14,
            ),
          ),
          Positioned(
            bottom: 20,
            left: 20,
            child: FloatingActionButton(
              onPressed: () async {
                // Move to current location (example coordinates used here)
                mapController.animateCamera(
                  CameraUpdate.newLatLng(
                    LatLng(37.42796133580664, -122.085749655962),
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
}
