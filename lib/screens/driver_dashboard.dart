import 'package:flutter/material.dart';

class DriverDashboard extends StatefulWidget {
  final String userType;
  const DriverDashboard({super.key, required this.userType});

  @override
  State<DriverDashboard> createState() => _DriverDashboardState();
}

class _DriverDashboardState extends State<DriverDashboard> {
  bool isOnline = false;

  @override
  Widget build(BuildContext context) {
    final isWeb = MediaQuery.of(context).size.width > 800;

    return Scaffold(
      body: Column(
        children: [
          // Custom Black Header
          Container(
            color: Colors.black,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: SafeArea(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Left side: Logo & Title
                  Row(
                    children: const [
                      Icon(Icons.directions_car, color: Colors.white),
                      SizedBox(width: 8),
                      Text(
                        "Orventus Driver",
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                    ],
                  ),

                  // Right side: Buttons (responsive)
                  LayoutBuilder(
                    builder: (context, constraints) {
                      if (constraints.maxWidth > 500) {
                        // Show full row of buttons on larger screens
                        return Row(
                          children: [
                            // Go Online Button
                            ElevatedButton.icon(
                              onPressed: () {
                                setState(() {
                                  isOnline = !isOnline;
                                });
                              },
                              icon: Icon(
                                isOnline ? Icons.toggle_on : Icons.toggle_off,
                                color: Colors.white,
                              ),
                              label:
                                  Text(isOnline ? "Online" : "Go Online"),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: isOnline
                                    ? Colors.green
                                    : Colors.transparent,
                                foregroundColor: Colors.white,
                                side: BorderSide(
                                  color: Colors.white.withOpacity(0.6),
                                ),
                                shape: RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.circular(20)),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 10),
                              ),
                            ),
                            const SizedBox(width: 12),

                            // Support Button
                            ElevatedButton.icon(
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (_) => AlertDialog(
                                    title: const Text("Call Support"),
                                    content: const Text(
                                        "For issues, contact support at +91 9876543210"),
                                    actions: [
                                      TextButton(
                                        onPressed: () =>
                                            Navigator.pop(context),
                                        child: const Text("OK"),
                                      ),
                                    ],
                                  ),
                                );
                              },
                              icon: const Icon(Icons.phone,
                                  color: Colors.white),
                              label: const Text("Support"),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.transparent,
                                foregroundColor: Colors.white,
                                side: BorderSide(
                                  color: Colors.white.withOpacity(0.6),
                                ),
                                shape: RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.circular(20)),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 10),
                              ),
                            ),
                            const SizedBox(width: 12),

                            // Help Button
                            ElevatedButton.icon(
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (_) => AlertDialog(
                                    title: const Text("Help"),
                                    content: const Text(
                                        "For issues, contact support at support@orventus.com"),
                                    actions: [
                                      TextButton(
                                        onPressed: () =>
                                            Navigator.pop(context),
                                        child: const Text("OK"),
                                      ),
                                    ],
                                  ),
                                );
                              },
                              icon: const Icon(Icons.info_outline,
                                  color: Colors.white),
                              label: const Text("Help"),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.transparent,
                                foregroundColor: Colors.white,
                                side: BorderSide(
                                  color: Colors.white.withOpacity(0.6),
                                ),
                                shape: RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.circular(20)),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 10),
                              ),
                            ),
                            const SizedBox(width: 12),

                            // Logout
                            IconButton(
                              onPressed: () {
                                Navigator.pushReplacementNamed(
                                    context, '/login');
                              },
                              icon: const Icon(Icons.logout,
                                  color: Colors.white, size: 28),
                              tooltip: "Logout",
                            ),
                          ],
                        );
                      } else {
                        // On small screens, show a menu instead
                        return PopupMenuButton<String>(
                          icon: const Icon(Icons.more_vert,
                              color: Colors.white),
                          onSelected: (value) {
                            if (value == "online") {
                              setState(() {
                                isOnline = !isOnline;
                              });
                            } else if (value == "support") {
                              showDialog(
                                context: context,
                                builder: (_) => AlertDialog(
                                  title: const Text("Call Support"),
                                  content: const Text(
                                      "For issues, contact support at +91 9876543210"),
                                  actions: [
                                    TextButton(
                                      onPressed: () =>
                                          Navigator.pop(context),
                                      child: const Text("OK"),
                                    ),
                                  ],
                                ),
                              );
                            } else if (value == "help") {
                              showDialog(
                                context: context,
                                builder: (_) => AlertDialog(
                                  title: const Text("Help"),
                                  content: const Text(
                                      "For issues, contact support at support@orventus.com"),
                                  actions: [
                                    TextButton(
                                      onPressed: () =>
                                          Navigator.pop(context),
                                      child: const Text("OK"),
                                    ),
                                  ],
                                ),
                              );
                            } else if (value == "logout") {
                              Navigator.pushReplacementNamed(
                                  context, '/login');
                            }
                          },
                          itemBuilder: (context) => [
                            PopupMenuItem(
                              value: "online",
                              child:
                                  Text(isOnline ? "Go Offline" : "Go Online"),
                            ),
                            const PopupMenuItem(
                              value: "support",
                              child: Text("Support"),
                            ),
                            const PopupMenuItem(
                              value: "help",
                              child: Text("Help"),
                            ),
                            const PopupMenuItem(
                              value: "logout",
                              child: Text("Logout"),
                            ),
                          ],
                        );
                      }
                    },
                  ),
                ],
              ),
            ),
          ),

          // Main content
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Stats Section
                  isWeb
                      ? Row(
                          children: [
                            Expanded(
                                child: _buildStatCard("Earnings", "₹4,520")),
                            const SizedBox(width: 16),
                            Expanded(child: _buildStatCard("Trips", "128")),
                            const SizedBox(width: 16),
                            Expanded(child: _buildStatCard("Rating", "4.8 ★")),
                          ],
                        )
                      : Column(
                          children: [
                            _buildStatCard("Earnings", "₹4,520"),
                            const SizedBox(height: 12),
                            _buildStatCard("Trips", "128"),
                            const SizedBox(height: 12),
                            _buildStatCard("Rating", "4.8 ★"),
                          ],
                        ),
                  const SizedBox(height: 24),

                  // Map Placeholder
                  Container(
                    height: isWeb ? 400 : 250,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Center(
                      child: Text("Map Placeholder",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.w500)),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Ride Requests
                  Text("Incoming Ride Requests",
                      style: Theme.of(context).textTheme.titleLarge),
                  const SizedBox(height: 12),
                  _buildRideRequestCard(
                      "Rajesh", "MG Road → Whitefield", "₹250"),
                  _buildRideRequestCard(
                      "Ananya", "Airport → Indiranagar", "₹600"),

                  const SizedBox(height: 24),

                  // Completed Rides
                  Text("Completed Rides",
                      style: Theme.of(context).textTheme.titleLarge),
                  const SizedBox(height: 12),
                  _buildCompletedRideCard(
                      "Kiran", "Koramangala → HSR Layout", "₹180"),
                  _buildCompletedRideCard(
                      "Neha", "BTM → Electronic City", "₹400"),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(String title, String value) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
              color: Colors.black12, blurRadius: 8, offset: const Offset(2, 2)),
        ],
      ),
      child: Column(
        children: [
          Text(value,
              style:
                  const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Text(title,
              style: const TextStyle(
                  fontSize: 16, fontWeight: FontWeight.w500, color: Colors.grey))
        ],
      ),
    );
  }

  Widget _buildRideRequestCard(String name, String route, String fare) {
    return Card(
      elevation: 3,
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.directions_car, color: Colors.black),
                const SizedBox(width: 8),
                Expanded(child: Text("$name - $route")),
                Text(fare,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.green)),
              ],
            ),
            const SizedBox(height: 6),
            const Text("Pickup in 5 mins"),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      minimumSize: const Size(70, 36)),
                  child: const Text("Accept"),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      minimumSize: const Size(70, 36)),
                  child: const Text("Reject"),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _buildCompletedRideCard(String name, String route, String fare) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 6),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: const Icon(Icons.check_circle, color: Colors.green),
        title: Text("$name - $route"),
        subtitle: const Text("Completed"),
        trailing: Text(fare,
            style: const TextStyle(
                fontWeight: FontWeight.bold, color: Colors.black)),
      ),
    );
  }
}
