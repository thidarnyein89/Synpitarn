import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late GoogleMapController _mapController;
  Set<Marker> _markers = {};
  late BitmapDescriptor atmIcon;

  final LatLng _yangonCenter = const LatLng(16.8409, 96.1735);

  // Dummy ATM Data (use actual coordinates from your area)
  final List<Map<String, dynamic>> atmLocations = [
    {"name": "UAB ATM (Wai Pon La)", "lat": 16.8421, "lng": 96.1430},
    {"name": "CB Bank ATM", "lat": 16.8450, "lng": 96.1580},
    {"name": "KBZ Bank ATM", "lat": 16.8475, "lng": 96.1563},
    {"name": "UAB ATM (Nandaw)", "lat": 16.8053, "lng": 96.1562},
    {"name": "CB Bank ATM (Main)", "lat": 16.8285, "lng": 96.1300},
  ];

  @override
  void initState() {
    super.initState();
    _loadCustomMarker().then((_) {
      _loadATMMarkers();
    });
  }

  Future<void> _loadCustomMarker() async {
    atmIcon = await BitmapDescriptor.fromAssetImage(
      const ImageConfiguration(size: Size(10, 10)),
      'assets/images/atm_marker_transparent.png',
    );
  }

  void _loadATMMarkers() {
    Set<Marker> loadedMarkers =
        atmLocations.map((atm) {
          return Marker(
            markerId: MarkerId(atm["name"]),
            position: LatLng(atm["lat"], atm["lng"]),
            infoWindow: InfoWindow(title: atm["name"]),
            icon: atmIcon,
          );
        }).toSet();

    setState(() {
      _markers = loadedMarkers;
    });
  }

  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('ATM Map (Yangon)'), centerTitle: true),
      body: GoogleMap(
        onMapCreated: _onMapCreated,
        initialCameraPosition: CameraPosition(
          target: _yangonCenter,
          zoom: 14.5,
        ),
        markers: _markers,
        myLocationEnabled: false,
        zoomControlsEnabled: true,
      ),
    );
  }
}
