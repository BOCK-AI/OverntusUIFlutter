import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class RideStatus extends StatelessWidget {
  final String rideId;

  const RideStatus({super.key, required this.rideId});

  void _showCancelDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Cancel Ride"),
        content: const Text("Are you sure you want to cancel your ride? "
            "You may be charged a cancellation fee."),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text("No"),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx); // close dialog
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Ride Cancelled")),
              );
              Navigator.pop(context); // Pop ride_status
              Navigator.pushReplacementNamed(context, '/dashboard', arguments: {'resetHome': true});
            },
            child: const Text("Yes, Cancel"),
          ),
        ],
      ),
    );
  }

  void _showPriceSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (ctx) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text("Trip Cost",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            const Text("₹260",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => Navigator.pop(ctx),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 48),
              ),
              child: const Text("Close"),
            ),
          ],
        ),
      ),
    );
  }

  void _showPhoneDialog(BuildContext context, String phoneNumber) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Driver Contact"),
        content: Text("Phone: $phoneNumber"),
        actions: [
          TextButton(
            onPressed: () {
              Clipboard.setData(ClipboardData(text: phoneNumber));
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Number copied to clipboard")),
              );
            },
            child: const Text("Copy"),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text("Close"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    // wider constraint for web, smaller for mobile
    final maxContentWidth = screenWidth > 1000 ? 900 : 750;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Ride Status'),
        backgroundColor: const Color.fromARGB(0, 0, 0, 0),
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: maxContentWidth.toDouble()),
          child: Column(
            children: [
              // Map Section
              Expanded(
                child: Container(
                  width: double.infinity,
                  color: Colors.grey[300],
                  child: const Center(
                    child: Text(
                      'Map Placeholder',
                      style: TextStyle(color: Color.fromARGB(0, 0, 0, 0)),
                    ),
                  ),
                ),
              ),

              // Ride Info Card
              Container(
                padding: const EdgeInsets.all(16),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black12,
                        blurRadius: 6,
                        offset: Offset(0, -2)),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Pickup & ETA
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Meet at your pickup spot",
                                  style:
                                      TextStyle(fontWeight: FontWeight.w600)),
                              SizedBox(height: 4),
                              Text("",
                                  style: TextStyle(color: Colors.blue)),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.black,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Text(
                            "5 min",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),

                    const Divider(height: 24),

                    // Driver & Vehicle Info
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                              Text("Driver: Anderson",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16)),
                              SizedBox(height: 4),
                              Text("Car: 3M53AF2 • Silver Honda Civic",
                                  style: TextStyle(color: Colors.black87)),
                              SizedBox(height: 4),
                              Text("OTP: 6948",
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black)),
                            ],
                          ),
                        ),
                        const Icon(Icons.directions_car, size: 48),
                      ],
                    ),

                    const SizedBox(height: 16),

                    // Call Button
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        IconButton(
                          onPressed: () =>
                              _showPhoneDialog(context, "+91 9876543210"),
                          icon: const Icon(Icons.phone, size: 32),
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),

                    // Cancel & View Price
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () => _showCancelDialog(context),
                            child: const Text("Cancel Ride"),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () => _showPriceSheet(context),
                            child: const Text("View Price"),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}