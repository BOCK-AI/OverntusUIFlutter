// lib/models/place_prediction_model.dart

class PlacePrediction {
  final String description;
  final String placeId;

  PlacePrediction({
    required this.description,
    required this.placeId,
  });

  factory PlacePrediction.fromJson(Map<String, dynamic> json) {
    return PlacePrediction(
      description: json['description'] ?? 'No description',
      placeId: json['place_id'] ?? '',
    );
  }
}