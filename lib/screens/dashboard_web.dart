import 'package:flutter/material.dart';

class DashboardWeb extends StatefulWidget {
  final String userType;
  const DashboardWeb({super.key, required this.userType});

  @override
  State<DashboardWeb> createState() => _DashboardWebState();
}

class _DashboardWebState extends State<DashboardWeb> {
  final _pickup = TextEditingController();
  final _dropoff = TextEditingController();
  String _pickupTime = 'Pickup now';
  String _forWhom = 'For me';
  DateTime? _scheduledTime;

  bool _showRideOptions = false;
  int? _selectedRideIndex; // Track selected ride option

  @override
  void dispose() {
    _pickup.dispose();
    _dropoff.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Hide ride options if coming back from ride status (pop)
    final modalRoute = ModalRoute.of(context);
    if (modalRoute != null && modalRoute.isCurrent) {
      setState(() {
        _showRideOptions = false;
        _selectedRideIndex = null;
      });
    }
  }

  Future<void> _selectDateTime() async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(const Duration(days: 1)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 30)),
    );

    if (pickedDate != null) {
      final pickedTime = await showTimePicker(
        context: context,
        initialTime: const TimeOfDay(hour: 9, minute: 0),
      );

      if (pickedTime != null) {
        setState(() {
          _scheduledTime = DateTime(
            pickedDate.year,
            pickedDate.month,
            pickedDate.day,
            pickedTime.hour,
            pickedTime.minute,
          );
        });
      }
    }
  }

  void _onSearch() {
    if (_pickup.text.isNotEmpty && _dropoff.text.isNotEmpty) {
      setState(() {
        _showRideOptions = true;
        _selectedRideIndex = null;
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter pickup and dropoff')),
      );
    }
  }

  void _requestRide() {
    if (_selectedRideIndex != null) {
      Navigator.pushNamed(context, '/ride-status').then((_) {
        // When returning from ride-status, hide ride options
        setState(() {
          _showRideOptions = false;
          _selectedRideIndex = null;
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      // TOP NAVIGATION BAR
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        title: Row(
          children: [
            const Icon(Icons.local_taxi, color: Colors.black),
            const SizedBox(width: 8),
            const Text("Orventus",
                style: TextStyle(
                    color: Colors.black, fontWeight: FontWeight.bold)),
            const SizedBox(width: 40),
            _NavTab(title: "Ride", selected: true),
            const SizedBox(width: 20),
            _NavTab(title: "Rentals"),
            const SizedBox(width: 20),
            _NavTab(title: "Courier"),
          ],
        ),
        actions: [
          TextButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.receipt_long_outlined, color: Colors.black),
            label: const Text("", style: TextStyle(color: Colors.black)),
          ),
          const SizedBox(width: 12),
          IconButton(
            icon: const Icon(Icons.account_circle, color: Colors.black),
            onPressed: () {},
          ),
          const SizedBox(width: 16),
        ],
      ),

      // MAIN BODY
      body: Row(
        children: [
          // LEFT SIDE: Booking form
          Container(
            width: 350,
            color: Colors.grey.shade100,
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("Get a ride",
                    style:
                        TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                const SizedBox(height: 20),

                // Pickup
                TextField(
                  controller: _pickup,
                  decoration: const InputDecoration(
                    labelText: "Pickup location",
                    prefixIcon: Icon(Icons.radio_button_checked),
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),

                // Dropoff
                TextField(
                  controller: _dropoff,
                  decoration: const InputDecoration(
                    labelText: "Dropoff location",
                    prefixIcon: Icon(Icons.stop_circle_outlined),
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),

                // Pickup time
                DropdownButtonFormField<String>(
                  value: _pickupTime,
                  items: const [
                    DropdownMenuItem(
                        value: "Pickup now", child: Text("Pickup now")),
                    DropdownMenuItem(
                        value: "Schedule for later",
                        child: Text("Schedule for later")),
                  ],
                  onChanged: (v) {
                    setState(() => _pickupTime = v!);
                    if (v == "Schedule for later") {
                      _selectDateTime();
                    }
                  },
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.access_time),
                    border: OutlineInputBorder(),
                  ),
                ),
                if (_scheduledTime != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text(
                      "Scheduled: ${_scheduledTime.toString()}",
                      style: const TextStyle(color: Colors.blueGrey),
                    ),
                  ),
                const SizedBox(height: 12),

                // For me / someone else
                DropdownButtonFormField<String>(
                  value: _forWhom,
                  items: const [
                    DropdownMenuItem(value: "For me", child: Text("For me")),
                    DropdownMenuItem(
                        value: "For someone else",
                        child: Text("For someone else")),
                  ],
                  onChanged: (v) => setState(() => _forWhom = v!),
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.person),
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 20),

                // Search button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _onSearch,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      backgroundColor: Colors.black,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)),
                    ),
                    child: const Text("Search", style: TextStyle(fontSize: 16)),
                  ),
                ),
              ],
            ),
          ),

          // RIGHT SIDE: Map + Ride Options
          Expanded(
            child: Stack(
              children: [
                Container(
                  color: Colors.grey.shade300,
                  child: const Center(
                    child: Text(
                      "Google Maps Placeholder\n(Add cars overlay here)",
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),

                // Ride Options Panel (slides up after search)
                if (_showRideOptions)
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      height: 300,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius:
                            BorderRadius.vertical(top: Radius.circular(16)),
                        boxShadow: [
                          BoxShadow(
                              color: Colors.black26,
                              blurRadius: 8,
                              offset: Offset(0, -2)),
                        ],
                      ),
                      child: Column(
                        children: [
                          Expanded(
                            child: ListView(
                              padding: const EdgeInsets.all(16),
                              children: [
                                _rideOption("Orventus Go", "₹99.93",
                                    "Affordable compact AC rides", 4, index: 0),
                                _rideOption("Orventus XL", "₹203.07",
                                    "Comfortable SUVs", 6, index: 1),
                                _rideOption("Go Non AC", "₹91.96",
                                    "Everyday affordable rides", 4, index: 2),
                                _rideOption("Orventus XS", "₹130.00",
                                    "Non-AC affordable compact rides", 4, index: 3),
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.all(12),
                            child: Row(
                              children: [
                                const Icon(Icons.money),
                                const SizedBox(width: 8),
                                const Text("Cash"),
                                const Spacer(),
                                ElevatedButton(
                                  onPressed: _selectedRideIndex != null
                                      ? _requestRide
                                      : null,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.black,
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 30, vertical: 14),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                  child: const Text("Request Ride"),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _rideOption(String title, String price, String desc, int capacity,
      {bool unavailable = false, required int index}) {
    final isSelected = _selectedRideIndex == index;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedRideIndex = index;
        });
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          border: Border.all(
              color: isSelected ? Colors.blue : Colors.black, width: 2),
          borderRadius: BorderRadius.circular(8),
          color: unavailable
              ? Colors.grey.shade200
              : isSelected
                  ? Colors.blue.shade50
                  : Colors.white,
        ),
        child: Row(
          children: [
            const Icon(Icons.directions_car, size: 40),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("$title   👤$capacity",
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 16)),
                  Text(desc),
                ],
              ),
            ),
            Text(price,
                style: const TextStyle(
                    fontWeight: FontWeight.bold, fontSize: 16)),
            if (isSelected)
              const Padding(
                padding: EdgeInsets.only(left: 8.0),
                child: Icon(Icons.check_circle, color: Colors.blue),
              ),
          ],
        ),
      ),
    );
  }
}

// Custom nav tab widget
class _NavTab extends StatelessWidget {
  final String title;
  final bool selected;
  const _NavTab({required this.title, this.selected = false});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: TextStyle(
        color: Colors.black,
        fontWeight: selected ? FontWeight.bold : FontWeight.normal,
        decoration:
            selected ? TextDecoration.underline : TextDecoration.none,
      ),
    );
  }
}
