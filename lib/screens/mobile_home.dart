import 'package:flutter/material.dart';
//import '../widgets/site_common.dart';

class MobileHome extends StatefulWidget {
  final String userName;
  final void Function(int)? onTabSwitch;
  const MobileHome({super.key, required this.userName, this.onTabSwitch});

  @override
  State<MobileHome> createState() => _MobileHomeState();
}

class _MobileHomeState extends State<MobileHome> {
  final _pickup = TextEditingController();
  final _drop = TextEditingController();
  String _forWhom = 'For me';
  DateTime? _scheduledDateTime;
  bool _showRideOptions = false;
  int? _selectedRideIndex;
  final List<Map<String, dynamic>> _rides = [
    {
      'title': "Orventus Go",
      'price': "₹99.93",
      'desc': "Affordable compact AC rides",
      'capacity': 4,
    },
    {
      'title': "Orventus XL",
      'price': "₹203.07",
      'desc': "Comfortable SUVs",
      'capacity': 6,
    },
    {
      'title': "Go Non AC",
      'price': "₹91.96",
      'desc': "Everyday affordable rides",
      'capacity': 4,
    },
    {
      'title': "Orventus XS",
      'price': "₹130.00",
      'desc': "Non-AC affordable compact rides",
      'capacity': 4,
    },
  ];

  @override
  void dispose() {
    _pickup.dispose();
    _drop.dispose();
    super.dispose();
  }

  void _book() {
    if (_pickup.text.trim().isEmpty || _drop.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Enter pickup and destination')),
      );
      return;
    }
    setState(() {
      _showRideOptions = true;
    });
  }

  Future<void> _selectDateTime() async {
    final now = DateTime.now();
    final date = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: now,
      lastDate: now.add(const Duration(days: 30)),
    );
    if (date != null) {
      final time = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(now),
      );
      if (time != null) {
        setState(() {
          _scheduledDateTime = DateTime(
            date.year,
            date.month,
            date.day,
            time.hour,
            time.minute,
          );
        });
      }
    }
  }

  Widget _buildRideOptionsSheet(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            "Select a Ride",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          ...List.generate(_rides.length, (index) {
            final ride = _rides[index];
            return GestureDetector(
              onTap: () {
                setState(() {
                  _selectedRideIndex = index;
                });
                Navigator.pushNamed(context, '/ride-status', arguments: {
                  'ride': ride,
                  'pickup': _pickup.text,
                  'drop': _drop.text,
                  'forWhom': _forWhom,
                  'scheduledDateTime': _scheduledDateTime?.toIso8601String(),
                });
              },
              child: Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  border: Border.all(
                      color: _selectedRideIndex == index
                          ? Colors.black
                          : Colors.grey,
                      width: 2),
                  borderRadius: BorderRadius.circular(8),
                  color: _selectedRideIndex == index
                      ? Colors.grey[200]
                      : Colors.white,
                ),
                child: Row(
                  children: [
                    const Icon(Icons.directions_car, size: 32),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("${ride['title']}   👤${ride['capacity']}",
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16)),
                          Text(ride['desc']),
                        ],
                      ),
                    ),
                    Text(ride['price'],
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16)),
                  ],
                ),
              ),
            );
          }),
        ],
      ),
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)?.settings.arguments;
    if (args is Map && args['resetHome'] == true) {
      setState(() {
        _showRideOptions = false;
        _selectedRideIndex = null;
        _pickup.clear();
        _drop.clear();
        _forWhom = 'For me';
        _scheduledDateTime = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (widget.onTabSwitch != null) {
          widget.onTabSwitch!(0);
        }
        return false;
      },
      child: Scaffold(
        backgroundColor: Colors.grey[100],
        appBar: AppBar(
          backgroundColor: Colors.black,
          elevation: 0,
          title: Row(
            children: [
              const Icon(Icons.directions_car, color: Colors.white),
              const SizedBox(width: 8),
              Text(
                "Orventus",
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.account_circle, color: Colors.white),
              onPressed: () {},
            ),
          ],
        ),
        body: Stack(
          children: [
            // Map placeholder background
            Container(
              color: Colors.grey[300],
              child: const Center(
                child: Text("Map Placeholder",
                    style: TextStyle(color: Colors.black54)),
              ),
            ),

            // Bottom booking panel (like Uber)
            Align(
              alignment: Alignment.bottomCenter,
              child: !_showRideOptions
                  ? Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius:
                            const BorderRadius.vertical(top: Radius.circular(20)),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 10,
                            offset: const Offset(0, -4),
                          ),
                        ],
                      ),
                      child: ListView(
                        shrinkWrap: true,
                        children: [
                          Text(
                            "Hi, ${widget.userName}",
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 12),
                          TextField(
                            controller: _pickup,
                            decoration: InputDecoration(
                              prefixIcon: const Icon(Icons.my_location),
                              hintText: 'Enter pickup location',
                              filled: true,
                              fillColor: Colors.grey[100],
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide.none,
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          TextField(
                            controller: _drop,
                            decoration: InputDecoration(
                              prefixIcon: const Icon(Icons.location_on),
                              hintText: 'Enter destination',
                              filled: true,
                              fillColor: Colors.grey[100],
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide.none,
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          DropdownButtonFormField<String>(
                            value: _forWhom,
                            decoration: InputDecoration(
                              labelText: 'Ride for',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            items: const [
                              DropdownMenuItem(
                                value: 'For me',
                                child: Text('For me'),
                              ),
                              DropdownMenuItem(
                                value: 'For someone else',
                                child: Text('For someone else'),
                              ),
                            ],
                            onChanged: (val) {
                              setState(() {
                                _forWhom = val ?? 'For me';
                              });
                            },
                          ),
                          const SizedBox(height: 16),
                          ListTile(
                            title: const Text('Schedule Ride'),
                            subtitle: Text(_scheduledDateTime == null
                                ? 'Pickup now'
                                : 'Scheduled for ${_scheduledDateTime!.toLocal()}'),
                            trailing: ElevatedButton(
                              onPressed: _selectDateTime,
                              child: const Text('Select'),
                            ),
                          ),
                          const SizedBox(height: 16),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.black,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                padding: const EdgeInsets.symmetric(vertical: 14),
                              ),
                              onPressed: _book,
                              child: const Text(
                                'Search Rides',
                                style: TextStyle(fontSize: 16, color: Colors.white),
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                        ],
                      ),
                    )
                  : _buildRideOptionsSheet(context),
            ),
          ],
        ),
      ),
    );
  }
}