import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import '../api/api_service.dart';
import '../models/place_prediction_model.dart';
import '../widgets/ride_options_dialog.dart';
import 'dart:math'; // Needed for min/max functions
import 'package:flutter_polyline_points/flutter_polyline_points.dart'; // <-- NEW, RELIABLE PACKAGE

// At the top of lib/screens/dashboard_web.dart

// At the top of lib/screens/dashboard_web.dart

class DashboardWeb extends StatefulWidget {
  const DashboardWeb({super.key});

  @override
  State<DashboardWeb> createState() => _DashboardWebState();
}

class _DashboardWebState extends State<DashboardWeb> {
  final ApiService _apiService = ApiService();
  final Location _locationService = Location();

  Map<String, dynamic>? _currentUser;
  bool _isLoading = true;
  bool _isFetchingEstimates = false;

  final TextEditingController _pickupController = TextEditingController();
  final TextEditingController _dropoffController = TextEditingController();
  late GoogleMapController _mapController;
  LatLng _initialCameraPosition = const LatLng(12.9716, 77.5946);

  PlacePrediction? _selectedPickup;
  PlacePrediction? _selectedDropoff;
  final Set<Marker> _markers = {};
  final Set<Polyline> _polylines = {};

  @override
  void initState() {
    super.initState();
    _initializeDashboard();
  }

  @override
  void dispose() {
    _pickupController.dispose();
    _dropoffController.dispose();
    super.dispose();
  }

  // --- LOGIC FUNCTIONS ---

 Future<void> _initializeDashboard() async {
    await _fetchProfile();
    if (mounted) setState(() => _isLoading = false);
  }
  
  Future<void> _fetchProfile() async {
    try {
      final profileData = await _apiService.getMyProfile();
      if (mounted) setState(() => _currentUser = profileData['user']);
    } catch (e) {
      print('Error fetching profile: $e');
    }
  }

  Future<void> _initializeLocation() async {
    try {
      bool serviceEnabled = await _locationService.serviceEnabled();
      if (!serviceEnabled) {
        serviceEnabled = await _locationService.requestService();
        if (!serviceEnabled) return;
      }
      PermissionStatus permissionGranted = await _locationService.hasPermission();
      if (permissionGranted == PermissionStatus.denied) {
        permissionGranted = await _locationService.requestPermission();
        if (permissionGranted != PermissionStatus.granted) return;
      }
      final LocationData locationData = await _locationService.getLocation();
      if (locationData.latitude != null && locationData.longitude != null) {
        final userLocation = LatLng(locationData.latitude!, locationData.longitude!);
        setState(() => _initialCameraPosition = userLocation);
        // This check is important because the map might not be created yet
        if (mounted && _mapController != null) {
          _mapController.animateCamera(CameraUpdate.newLatLngZoom(userLocation, 15.0));
        }
      }
    } catch (e) {
      print('Error initializing location: $e');
    }
  }
  
  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;
    // After the map is created, we can try to move to the user's location if we already have it.
    _mapController.animateCamera(CameraUpdate.newLatLngZoom(_initialCameraPosition, 12.0));
  }
  
  // In lib/screens/dashboard_web.dart

 // In lib/screens/dashboard_web.dart

void _handleSearch() async {
    if (_selectedPickup == null || _selectedDropoff == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please select valid locations.'), backgroundColor: Colors.red));
      return;
    }
    setState(() { _isFetchingEstimates = true; });
    try {
      final result = await _apiService.initiateRide(_selectedPickup!.placeId, _selectedDropoff!.placeId);
      
      _markers.clear();
      _polylines.clear();

      // --- THIS IS THE NEW, CORRECT WAY TO DECODE ---
      PolylinePoints polylinePoints = PolylinePoints();
      List<PointLatLng> decodedResult = polylinePoints.decodePolyline(result['polyline']);
      List<LatLng> points = decodedResult.map((point) => LatLng(point.latitude, point.longitude)).toList();
      // --- END FIX ---
      
      if (points.isEmpty) throw Exception("Could not decode polyline");

      final Polyline routePolyline = Polyline(polylineId: const PolylineId('route'), color: Colors.blueAccent, width: 6, points: points);

      final LatLng start = LatLng(result['startLocation']['lat'], result['startLocation']['lng']);
      final LatLng end = LatLng(result['endLocation']['lat'], result['endLocation']['lng']);
      _markers.add(Marker(markerId: const MarkerId('pickup'), position: start, infoWindow: const InfoWindow(title: 'Pickup')));
      _markers.add(Marker(markerId: const MarkerId('dropoff'), position: end, infoWindow: const InfoWindow(title: 'Dropoff')));
      
      setState(() { _polylines.add(routePolyline); });

      _mapController.animateCamera(CameraUpdate.newLatLngBounds(
        LatLngBounds(
          southwest: LatLng(min(start.latitude, end.latitude), min(start.longitude, end.longitude)),
          northeast: LatLng(max(start.latitude, end.latitude), max(start.longitude, end.longitude)),
        ),
        100.0,
      ));
      
      if (!mounted) return;
      showDialog(
        context: context,
        builder: (context) => RideOptionsDialog(
          estimates: result['estimates'],
          onRideSelected: (selectedEstimate) => _handleCreateRide(selectedEstimate),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString()), backgroundColor: Colors.red));
    } finally {
      if (mounted) setState(() { _isFetchingEstimates = false; });
    }
  }
  
  void _handleCreateRide(Map<String, dynamic> selectedEstimate) async {
    try {
      final result = await _apiService.createRide(
        _pickupController.text,
        _dropoffController.text,
        selectedEstimate['vehicle'],
        (selectedEstimate['fare'] as num).toDouble(),
      );
      final newRide = result['ride'];
      if (!mounted) return;
      Navigator.of(context).pushNamed('/ride_status', arguments: {'rideId': newRide['id']});
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString()), backgroundColor: Colors.red));
    }
  }

  Widget _buildAutocompleteField({ required TextEditingController controller, required String labelText, required Function(PlacePrediction) onSelected }) {
    return Autocomplete<PlacePrediction>(
      displayStringForOption: (option) => option.description,
      optionsBuilder: (value) async {
        if (value.text.isEmpty) return const Iterable.empty();
        return await _apiService.getPlacePredictions(value.text);
      },
      onSelected: onSelected,
      fieldViewBuilder: (context, fieldController, fieldFocusNode, onFieldSubmitted) {
        return TextField(
          controller: fieldController,
          focusNode: fieldFocusNode,
          decoration: InputDecoration(labelText: labelText),
          onChanged: (text) => controller.text = text,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isLoading ? 'Loading...' : 'Welcome, ${_currentUser?['name'] ?? 'User'}!'),
        actions: [
          IconButton(icon: const Icon(Icons.person_outline), onPressed: () => Navigator.of(context).pushNamed('/profile'), tooltip: 'My Profile & History'),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await _apiService.logout();
              if (mounted) Navigator.of(context).pushReplacementNamed('/auth_check');
            },
            tooltip: 'Log Out',
          ),
        ],
      ),
      body: _isLoading ? const Center(child: CircularProgressIndicator()) : _buildRideBookingUI(),
    );
  }

  Widget _buildRideBookingUI() {
    return Row(
      children: [
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 400),
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Get a ride', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                const SizedBox(height: 24),
                _buildAutocompleteField(
                  controller: _pickupController,
                  labelText: 'Pickup location',
                  onSelected: (selection) {
                    _pickupController.text = selection.description;
                    _selectedPickup = selection;
                  },
                ),
                const SizedBox(height: 16),
                _buildAutocompleteField(
                  controller: _dropoffController,
                  labelText: 'Dropoff location',
                  onSelected: (selection) {
                    _dropoffController.text = selection.description;
                    _selectedDropoff = selection;
                  },
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(items: const [DropdownMenuItem(value: 'now', child: Text('Pickup now'))], onChanged: (value) {}, value: 'now'),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(items: const [DropdownMenuItem(value: 'me', child: Text('For me'))], onChanged: (value) {}, value: 'me'),
                const SizedBox(height: 24),
                SizedBox(width: double.infinity, child: ElevatedButton(
                  onPressed: _isFetchingEstimates ? null : _handleSearch,
                  child: _isFetchingEstimates ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2)) : const Text('Search'),
                  style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 16)),
                )),
              ],
            ),
          ),
        ),
        Expanded(
          child: GoogleMap(
            onMapCreated: _onMapCreated,
            initialCameraPosition: CameraPosition(target: _initialCameraPosition, zoom: 12.0),
            markers: _markers,
            polylines: _polylines,
          ),
        ),
      ],
    );
  }
}