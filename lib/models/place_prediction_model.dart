// lib/models/place_prediction_model.dart

class PlacePrediction {
  final String description;
  final String placeId;
  final double? lat;
  final double? lng;

  PlacePrediction({
    required this.description,
    required this.placeId,
    this.lat,
    this.lng,
  });

  factory PlacePrediction.fromJson(Map<String, dynamic> json) {
    return PlacePrediction(
      description: json['description'],
      placeId: json['place_id'],
    );
  }
}