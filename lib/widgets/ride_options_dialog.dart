// lib/widgets/ride_options_dialog.dart

import 'package:flutter/material.dart';

class RideOptionsDialog extends StatelessWidget {
  final List<dynamic> estimates;
  final Function(Map<String, dynamic>) onRideSelected;

  const RideOptionsDialog({
    super.key,
    required this.estimates,
    required this.onRideSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        constraints: const BoxConstraints(maxWidth: 400), // Set a max width
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Rides we think you\'ll like', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 16),

            // Use a flexible list that won't overflow
            Flexible(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: estimates.length,
                itemBuilder: (context, index) {
                  final estimate = estimates[index];
                  
                  // This is the new, richer list item
                  return InkWell(
                    onTap: () {
                      onRideSelected(estimate);
                      Navigator.of(context).pop();
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12.0),
                      child: Row(
                        children: [
                          // Vehicle Icon
                          Icon(_getVehicleIcon(estimate['vehicle']), size: 48, color: Colors.black87),
                          const SizedBox(width: 16),

                          // Vehicle Details
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      estimate['vehicle'],
                                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                                    ),
                                    const SizedBox(width: 8),
                                    const Icon(Icons.person, size: 16, color: Colors.black54),
                                    Text(
                                      ' ${estimate['capacity']}',
                                      style: const TextStyle(color: Colors.black54),
                                    )
                                  ],
                                ),
                                Text(
                                  estimate['description'],
                                  style: const TextStyle(color: Colors.black54, fontSize: 12),
                                ),
                              ],
                            ),
                          ),

                          // Fare
                          Text(
                            '₹${estimate['fare'].toStringAsFixed(2)}',
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                          ),
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

  // Helper to get an icon based on vehicle type
  IconData _getVehicleIcon(String vehicle) {
    if (vehicle.toLowerCase().contains('premier')) return Icons.star_border;
    if (vehicle.toLowerCase().contains('xl')) return Icons.luggage;
    if (vehicle.toLowerCase().contains('pet')) return Icons.pets;
    return Icons.directions_car;
  }
}