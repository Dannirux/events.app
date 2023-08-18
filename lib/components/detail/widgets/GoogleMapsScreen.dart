import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../models/event.dart';

class GoogleMapScreen extends StatefulWidget {
  final List<Event> events;

  GoogleMapScreen({required this.events});

  @override
  _GoogleMapScreenState createState() => _GoogleMapScreenState();
}

class _GoogleMapScreenState extends State<GoogleMapScreen> {
  late GoogleMapController mapController;
  Position? currentPosition;
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
      _getCurrentLocation();
      _initializeMarkers();
    } else if (status.isDenied) {
      // Handle denied permission
      // ...
    } else if (status.isPermanentlyDenied) {
      // Handle permanently denied permission
      // ...
    }
  }

  Future<void> _getCurrentLocation() async {
    final Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
    setState(() {
      currentPosition = position;
    });
  }

  void _initializeMarkers() {
    setState(() {
      for (var event in widget.events) {
        markers.add(
          Marker(
            markerId: MarkerId(event.id),
            position: LatLng(event.latitude, event.longitude),
            infoWindow: InfoWindow(title: event.name),
          ),
        );
      }
      if (currentPosition != null) {
        markers.add(
          Marker(
            markerId: MarkerId('currentLocation'),
            position: LatLng(currentPosition!.latitude, currentPosition!.longitude),
            infoWindow: InfoWindow(title: 'Mi ubicación'),
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
        initialCameraPosition: currentPosition != null
            ? CameraPosition(
          target: LatLng(currentPosition!.latitude, currentPosition!.longitude),
          zoom: 15.0,
        )
            : CameraPosition(target: quitoLatLng, zoom: 15.0),
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