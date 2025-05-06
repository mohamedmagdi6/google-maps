import 'package:google_maps_flutter/google_maps_flutter.dart';

class MarkerModel {
  final String id;
  final String title;
  final String snippet;
  final LatLng position;

  MarkerModel({
    required this.id,
    required this.title,
    required this.snippet,
    required this.position,
  });
}

List<MarkerModel> markersModel = [
  MarkerModel(
    id: '1',
    title: 'Magdy house',
    snippet: 'This is the first marker',
    position: const LatLng(30.594842775901547, 31.733810556358584),
  ),
  MarkerModel(
    id: '3',
    title: 'Nouran House',
    snippet: 'This is the third marker',
    position: const LatLng(30.638183411309782, 31.37968581530116),
  ),
];
