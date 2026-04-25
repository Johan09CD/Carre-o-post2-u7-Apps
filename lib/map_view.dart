import 'dart:async';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geosense/location_service.dart';

class MapView extends StatefulWidget {
  const MapView({super.key});

  @override
  State<MapView> createState() => _MapViewState();
}

class _MapViewState extends State<MapView> {
  GoogleMapController? _mapController;
  LatLng? _currentPosition;
  final Set<Marker> _markers = {};
  final Set<Circle> _geofences = {};
  StreamSubscription<Position>? _positionSub;

  @override
  void initState() {
    super.initState();
    _initLocation();
  }

  Future<void> _initLocation() async {
    try {
      final pos = await LocationService.getCurrentPosition();
      final latlng = LatLng(pos.latitude, pos.longitude);
      setState(() {
        _currentPosition = latlng;
        _markers.add(_buildMarker(latlng));
        _geofences.add(_buildGeofenceCircle(latlng, 200));
      });
      _mapController?.animateCamera(
        CameraUpdate.newLatLngZoom(latlng, 16),
      );
      _positionSub = LocationService.getPositionStream().listen(_onPosition);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error de ubicación: $e')),
        );
      }
    }
  }

  void _onPosition(Position pos) {
    final latlng = LatLng(pos.latitude, pos.longitude);
    setState(() {
      _markers
        ..removeWhere((m) => m.markerId.value == 'user')
        ..add(_buildMarker(latlng));
    });
  }

  Marker _buildMarker(LatLng pos) => Marker(
    markerId: const MarkerId('user'),
    position: pos,
    infoWindow: const InfoWindow(title: 'Mi posición'),
  );

  Circle _buildGeofenceCircle(LatLng center, double radiusM) => Circle(
    circleId: const CircleId('geofence_1'),
    center: center,
    radius: radiusM,
    fillColor: Colors.blue.withOpacity(0.15),
    strokeColor: Colors.blue,
    strokeWidth: 2,
  );

  @override
  void dispose() {
    _positionSub?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_currentPosition == null) {
      return const Center(child: CircularProgressIndicator());
    }
    return GoogleMap(
      onMapCreated: (c) => _mapController = c,
      initialCameraPosition: CameraPosition(
        target: _currentPosition!,
        zoom: 16,
      ),
      markers: _markers,
      circles: _geofences,
      myLocationEnabled: false,
    );
  }
}