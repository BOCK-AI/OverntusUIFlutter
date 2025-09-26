// lib/models/ride_model.dart
class RideModel {
  final int id;
  final String status;
  final String pickupAddress;
  final String dropoffAddress;
  final double fare;

  RideModel({
    required this.id,
    required this.status,
    required this.pickupAddress,
    required this.dropoffAddress,
    required this.fare,
  });

  factory RideModel.fromJson(Map<String, dynamic> json) {
    return RideModel(
      id: json['id'],
      status: json['status'],
      pickupAddress: json['pickupAddress'],
      dropoffAddress: json['dropAddress'],
      fare: (json['fare'] as num).toDouble(),
    );
  }
}