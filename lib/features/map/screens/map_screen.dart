import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:hack_avensis/core/services/location_service.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  GoogleMapController? _controller;
  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(28.6219, 77.0878), // Default: New Delhi (MSIT area approx)
    zoom: 14.4746,
  );

  final Set<Marker> _markers = {};

  @override
  void initState() {
    super.initState();
    _checkLocationPermission();
  }

  Future<void> _checkLocationPermission() async {
    try {
      Position position = await LocationService().getCurrentLocation();
      if (mounted) {
        _controller?.animateCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(
              target: LatLng(position.latitude, position.longitude),
              zoom: 15,
            ),
          ),
        );
        setState(() {
          _markers.add(
            Marker(
              markerId: const MarkerId('me'),
              position: LatLng(position.latitude, position.longitude),
              infoWindow: const InfoWindow(title: 'My Location'),
              icon: BitmapDescriptor.defaultMarkerWithHue(
                BitmapDescriptor.hueAzure,
              ),
            ),
          );
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Location Error: $e')));
      }
    }
  }

  void _onMapCreated(GoogleMapController controller) {
    _controller = controller;
    // Initial markers are added in setState above after getting location
    setState(() {
      // Add 'Safe Haven' dummy markers
      _markers.add(
        const Marker(
          markerId: MarkerId('safe1'),
          position: LatLng(28.6219, 77.0878), // Example near New Delhi
          infoWindow: InfoWindow(title: 'Safe Haven: MSIT Gate'),
        ),
      );
      _markers.add(
        const Marker(
          markerId: MarkerId('safe2'),
          position: LatLng(28.6250, 77.0900),
          infoWindow: InfoWindow(title: '24/7 Pharmacy (Volunteer)'),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Safety Map")),
      body: GoogleMap(
        initialCameraPosition: _kGooglePlex,
        onMapCreated: _onMapCreated,
        myLocationEnabled: true,
        myLocationButtonEnabled: true,
        markers: _markers,
      ),
    );
  }
}
