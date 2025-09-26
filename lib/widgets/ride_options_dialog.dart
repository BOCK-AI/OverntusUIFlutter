import 'package:flutter/material.dart';

class RideOptionsDialog extends StatelessWidget {
  final List<dynamic> estimates;
  final Function(Map<String, dynamic>) onRideSelected;

  const RideOptionsDialog({super.key, required this.estimates, required this.onRideSelected});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        constraints: const BoxConstraints(maxWidth: 400),
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Rides we think you\'ll like', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 16),
            Flexible(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: estimates.length,
                itemBuilder: (context, index) {
                  final estimate = estimates[index];
                  // --- THIS IS THE FIX: Provide default values if null ---
                  final vehicleName = estimate['vehicle'] ?? 'Unknown Vehicle';
                  final description = estimate['description'] ?? 'Standard ride';
                  final capacity = estimate['capacity'] ?? 4;
                  final fare = (estimate['fare'] as num?)?.toDouble() ?? 0.0;

                  return InkWell(
                    onTap: () {
                      onRideSelected(estimate);
                      Navigator.of(context).pop();
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12.0),
                      child: Row(
                        children: [
                          Icon(_getVehicleIcon(vehicleName), size: 48),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(vehicleName, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                                    const SizedBox(width: 8),
                                    const Icon(Icons.person, size: 16),
                                    Text(' $capacity'),
                                  ],
                                ),
                                Text(description, style: const TextStyle(color: Colors.black54, fontSize: 12)),
                              ],
                            ),
                          ),
                          Text('₹${fare.toStringAsFixed(2)}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  IconData _getVehicleIcon(String vehicle) {
    if (vehicle.toLowerCase().contains('premier')) return Icons.star_border;
    if (vehicle.toLowerCase().contains('xl')) return Icons.luggage;
    if (vehicle.toLowerCase().contains('pet')) return Icons.pets;
    return Icons.directions_car;
  }
}