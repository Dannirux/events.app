import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';

class GoogleMapScreen extends StatefulWidget {
  final List<LatLng> eventCoordinates;

  GoogleMapScreen({required this.eventCoordinates});

  @override
  _GoogleMapScreenState createState() => _GoogleMapScreenState();
}

class _GoogleMapScreenState extends State<GoogleMapScreen> {
  late GoogleMapController mapController;
  Set<Marker> markers = {};
  bool isMapReady = false;

  @override
  void initState() {
    super.initState();
    _checkLocationPermission();
  }

  Future<void> _checkLocationPermission() async {
    final PermissionStatus status = await Permission.location.request();
    if (status.isGranted) {
      _initializeMarkers();
    } else if (status.isDenied) {
      // Handle denied permission
      // ...
    } else if (status.isPermanentlyDenied) {
      // Handle permanently denied permission
      // ...
    }
  }

  void _initializeMarkers() {
    setState(() {
      for (var coordinate in widget.eventCoordinates) {
        markers.add(
          Marker(
            markerId: MarkerId(coordinate.toString()),
            position: coordinate,
            infoWindow: InfoWindow(title: 'Evento'),
          ),
        );
      }
      isMapReady = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    final LatLng quitoLatLng = LatLng(-0.180653, -78.467834);

    return Scaffold(
      appBar: AppBar(
        title: Text('Mi localización'),
      ),
      body: GoogleMap(
        onMapCreated: (controller) {
          mapController = controller;
        },
        initialCameraPosition: CameraPosition(
          target: quitoLatLng,
          zoom: 15.0,
        ),
        markers: isMapReady ? markers : {},
      ),
    );
  }

  @override
  void dispose() {
    mapController.dispose();
    super.dispose();
  }
}
