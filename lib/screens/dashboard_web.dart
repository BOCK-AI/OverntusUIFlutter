import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import '../api/api_service.dart';
import '../models/place_prediction_model.dart';
import '../widgets/ride_options_dialog.dart';

class DashboardWeb extends StatefulWidget {
  const DashboardWeb({super.key});

  @override
  State<DashboardWeb> createState() => _DashboardWebState();
}

class _DashboardWebState extends State<DashboardWeb> {
  // Services and State
  final ApiService _apiService = ApiService();
  final Location _locationService = Location();
  Map<String, dynamic>? _currentUser;
  bool _isLoading = true;
  bool _isFetchingEstimates = false;

  // Controllers
  final TextEditingController _pickupController = TextEditingController();
  final TextEditingController _dropoffController = TextEditingController();
  late GoogleMapController _mapController;

  LatLng _initialCameraPosition = const LatLng(12.9716, 77.5946);

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
    await Future.wait([_fetchProfile(), _initializeLocation()]);
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
        // We need to check if mapController has been initialized before using it
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
    _mapController.animateCamera(CameraUpdate.newLatLngZoom(_initialCameraPosition, 15.0));
  }
  
  void _handleSearch() async {
    if (_pickupController.text.trim().isEmpty || _dropoffController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please select locations.'), backgroundColor: Colors.red));
      return;
    }
    setState(() { _isFetchingEstimates = true; });
    try {
      final estimates = await _apiService.getRideEstimates(_pickupController.text, _dropoffController.text);
      if (!mounted) return;
      showDialog(
        context: context,
        builder: (context) => RideOptionsDialog(
          estimates: estimates,
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

  Widget _buildAutocompleteField({ required TextEditingController controller, required String labelText }) {
    return Autocomplete<PlacePrediction>(
      displayStringForOption: (PlacePrediction option) => option.description,
      optionsBuilder: (TextEditingValue textEditingValue) async {
        if (textEditingValue.text.isEmpty) {
          return const Iterable<PlacePrediction>.empty();
        }
        return await _apiService.getPlacePredictions(textEditingValue.text);
      },
      onSelected: (PlacePrediction selection) {
        controller.text = selection.description;
      },
      fieldViewBuilder: (context, fieldController, fieldFocusNode, onFieldSubmitted) {
        return TextField(
          controller: fieldController,
          focusNode: fieldFocusNode,
          decoration: InputDecoration(labelText: labelText),
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
                _buildAutocompleteField(controller: _pickupController, labelText: 'Pickup location'),
                const SizedBox(height: 16),
                _buildAutocompleteField(controller: _dropoffController, labelText: 'Dropoff location'),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(items: const [DropdownMenuItem(value: 'now', child: Text('Pickup now'))], onChanged: (value) {}, value: 'now'),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(items: const [DropdownMenuItem(value: 'me', child: Text('For me'))], onChanged: (value) {}, value: 'me'),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _isFetchingEstimates ? null : _handleSearch,
                    child: _isFetchingEstimates ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2)) : const Text('Search'),
                    style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 16)),
                  ),
                ),
              ],
            ),
          ),
        ),
        Expanded(
          child: GoogleMap(
            onMapCreated: _onMapCreated,
            initialCameraPosition: CameraPosition(target: _initialCameraPosition, zoom: 12.0),
          ),
        ),
      ],
    );
  }
}