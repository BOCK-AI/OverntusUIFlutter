import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:dio/browser.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../models/place_prediction_model.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'dart:convert';
import 'package:google_maps_flutter/google_maps_flutter.dart'; // <-- MISSING IMPORT


class ApiService {
  static final ApiService _instance = ApiService._internal();
  factory ApiService() => _instance;
  late Dio _dio;
  late IO.Socket _socket; // <-- THIS WAS THE MISSING VARIABLE

  final _storage = const FlutterSecureStorage();
  final String _baseUrl = const String.fromEnvironment('API_BASE_URL', defaultValue: 'http://localhost:3000');
  
  ApiService._internal() {
    _dio = Dio(BaseOptions(baseUrl: '$_baseUrl/api/v1'));
    if (kIsWeb) {
      final adapter = BrowserHttpClientAdapter();
      adapter.withCredentials = true;
      _dio.httpClientAdapter = adapter;
    }
    _dio.interceptors.add(InterceptorsWrapper(onRequest: (options, handler) async {
      final accessToken = await _storage.read(key: 'accessToken');
      if (accessToken != null) {
        options.headers['Authorization'] = 'Bearer $accessToken';
      }
      return handler.next(options);
    }));
    _initSocket();

  }
  void _initSocket() {
    _socket = IO.io(_baseUrl, IO.OptionBuilder()
        .setTransports(['websocket']) // Use WebSocket only
        .disableAutoConnect() // Connect manually
        .build());
    _socket.onConnect((_) => print('ApiService: Socket connected! ID: ${_socket.id}'));
    _socket.onDisconnect((reason) => print('ApiService: Socket disconnected. Reason: $reason'));
  }

  void connectSocket() { if (!_socket.connected){ _socket.connect();} }
  void disconnectSocket() { _socket.dispose(); _initSocket(); }

  void listenToRideUpdates(String eventName, Function(dynamic) handler) {
    connectSocket();
    _socket.on(eventName, handler);
  }

  void stopListeningToRideUpdates(String eventName) {
    _socket.off(eventName);
  }

  // --- THIS IS THE DIAGNOSTIC FUNCTION ---
  Future<List<PlacePrediction>> getPlacePredictions(String input) async {
    if (input.trim().length < 2) return [];
    try {
      final response = await _dio.get('/misc/places', queryParameters: {'input': input});
      if (response.data != null && response.data['status'] == 'OK') {
        final List<dynamic> predictionsJson = response.data['predictions'];
        return predictionsJson.map((json) => PlacePrediction.fromJson(json)).toList();
      }
      return [];
    } catch (e) {
      print('Failed to get predictions via proxy: $e');
      return [];
    }
  }

  // --- All other methods remain the same ---
  // ... (login, logout, getMyProfile, etc.)

  // --- AUTH METHODS ---
  Future<String> requestOtp(String name, String phone, String role) async {
    try {
      // The path is now just '/auth/login'
      final response = await _dio.post('/auth/login', data: {'name': name, 'phone': phone, 'role': role});
      return response.data['msg'];
    } on DioException catch (e) {
      throw Exception('Failed to request OTP: ${e.response?.data['msg'] ?? 'Route does not exist'}');
    }
  }

  // The return type is now correct
Future<Map<String, dynamic>> verifyOtpAndLogin(String phone, String otp) async {
  try {
    final response = await _dio.post(
      '/auth/verify',
      data: {'phone': phone, 'otp': otp},
    );
    
    final responseData = response.data;
    if (responseData.containsKey('accessToken') && responseData.containsKey('user')) {
      await _storage.write(key: 'accessToken', value: responseData['accessToken']);
      await _storage.write(key: 'userRole', value: responseData['user']['role']);
      if (responseData.containsKey('refreshToken')) {
         await _storage.write(key: 'refreshToken', value: responseData['refreshToken']);
      }
    }
    // --- THIS IS THE CRITICAL FIX ---
    return responseData; // Return the data so the LoginPage can use it
  } on DioException catch (e) {
    throw Exception('Failed to verify OTP: ${e.response?.data['msg'] ?? e.message}');
  }
}
  
  Future<void> logout() async {
    final refreshToken = await _storage.read(key: 'refreshToken');
    try {
      if (refreshToken != null) {
        await _dio.post('/auth/logout', data: {'refreshToken': refreshToken});
      }
    } finally {
      await _storage.deleteAll();
      disconnectSocket(); // Disconnect socket on logout
    }
  }

  // --- USER PROFILE METHODS ---
  Future<Map<String, dynamic>> getMyProfile() async {
    try {
      final response = await _dio.get('/user/me');
      return response.data;
    } on DioException catch (e) {
      throw Exception('Failed to get profile: ${e.response?.data['msg'] ?? e.message}');
    }
  }
  
  Future<Map<String, dynamic>> updateMyProfile(String name) async {
    try {
      final response = await _dio.put('/user/me', data: {'name': name});
      return response.data;
    } on DioException catch (e) {
      throw Exception('Failed to update profile: ${e.response?.data['msg'] ?? e.message}');
    }
  }

  // --- RIDE METHODS ---
  Future<List<dynamic>> getMyRideHistory() async {
    try {
      final response = await _dio.get('/rides/my-history');
      return response.data['rides'];
    } on DioException catch (e) {
      throw Exception('Failed to load ride history: ${e.response?.data['msg'] ?? e.message}');
    }
  }

  Future<List<dynamic>> getAvailableRides() async {
    try {
      final response = await _dio.get('/rides/available');
      return response.data['rides'];
    } on DioException catch (e) {
      throw Exception('Failed to load available rides: ${e.response?.data['msg'] ?? e.message}');
    }
  }

  Future<Map<String, dynamic>> acceptRide(int rideId) async {
    try {
      final response = await _dio.put('/rides/$rideId/accept');
      return response.data;
    } on DioException catch (e) {
      throw Exception('Failed to accept ride: ${e.response?.data['msg'] ?? e.message}');
    }
  }


Future<List<dynamic>> getRideEstimates(String pickupAddress, String dropAddress) async {
    try {
      final response = await _dio.post('/rides/estimate', data: {'pickupAddress': pickupAddress, 'dropAddress': dropAddress});
      return response.data['estimates'];
    } on DioException catch (e) {
      throw Exception('Failed to get estimates: ${e.response?.data['msg'] ?? e.message}');
    }
  }

Future<Map<String, dynamic>> createRide(
    String pickupAddress,
    String dropoffAddress,
    String vehicle,
    double fare
  ) async {
    try {
      final response = await _dio.post('/rides', data: {
        'pickupAddress': pickupAddress,
        'dropAddress': dropoffAddress,
        'vehicle': vehicle,
        'fare': fare,
      });
      return response.data;
    } on DioException catch (e) {
      throw Exception('Failed to create ride: ${e.response?.data['msg'] ?? e.message}');
    }
  }
  Future<void> testPlacesApi() async {
  print('--- TESTING PLACES API VIA BACKEND PROXY ---');
  try {
    // Use our authenticated dio instance to call our own backend
    final response = await _dio.get(
      '/misc/places', // This is our new backend endpoint
      queryParameters: {
        'input': 'kengeri', // The search term
      },
    );
    print('SUCCESS! Backend proxy responded with:');
    print(response.data);
  } on DioException catch (e) {
    print('ERROR! Backend proxy failed with:');
    if (e.response != null) {
      print('Status Code: ${e.response?.statusCode}');
      print('Response Data: ${e.response?.data}');
    } else {
      print('Error without response: ${e.message}');
    }
  }
}
// In lib/api/api_service.dart

// In lib/api/api_service.dart
void sendRiderLocation(int rideId, double lat, double lng) {
    if (_socket.connected) {
      _socket.emit('rider-location-update', {
        'rideId': rideId,
        'lat': lat,
        'lng': lng,
      });
    }
  }

Future<Map<String, dynamic>> updateRideStatus(int rideId, String status) async {
    try {
      final response = await _dio.put('/rides/$rideId/status', data: {'status': status});
      return response.data;
    } on DioException catch (e) {
      throw Exception('Failed to update ride status: ${e.response?.data['msg'] ?? e.message}');
    }
  }


// Add this new method to your ApiService
// In lib/api/api_service.dart

Future<Map<String, dynamic>> initiateRide(String pickupPlaceId, String dropoffPlaceId) async {
  try {
    final response = await _dio.post(
      '/rides/initiate',
      data: {
        'pickupPlaceId': pickupPlaceId,

        'dropoffPlaceId': dropoffPlaceId,
      },
    );
    return response.data;
  } on DioException catch (e) {
    throw Exception('Failed to initiate ride: ${e.response?.data['msg'] ?? e.message}');
  }
}

// Add this new method to your ApiService

Future<Map<String, dynamic>> getRoutePolyline(LatLng start, LatLng end) async {
    try {
      final response = await _dio.get(
        '/rides/route',
        queryParameters: {
          'startLat': start.latitude,
          'startLng': start.longitude,
          'endLat': end.latitude,
          'endLng': end.longitude,
        },
      );
      // It correctly returns the full Map object from the backend
      return response.data;
    } on DioException catch (e) {
      throw Exception('Failed to get route polyline: ${e.response?.data['msg'] ?? e.message}');
    }
  }

// Add this new function to your ApiService class

Future<PlacePrediction> getPlaceDetails(String placeId) async {
  try {
    // We will use our backend as a proxy to avoid CORS issues.
    // This requires a new endpoint on the backend.
    final response = await _dio.get(
      '/misc/place-details', 
      queryParameters: {'placeId': placeId},
    );
    
    final result = response.data['result'];
    return PlacePrediction(
      description: result['formatted_address'],
      placeId: placeId,
      lat: result['geometry']['location']['lat'],
      lng: result['geometry']['location']['lng'],
    );
  } on DioException catch (e) {
    throw Exception('Failed to get place details: ${e.response?.data['msg'] ?? e.message}');
  }
}

}