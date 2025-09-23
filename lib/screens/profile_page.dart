// lib/screens/profile_page.dart

import 'package:flutter/material.dart';
import '../api/api_service.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final ApiService _apiService = ApiService();
  final _nameController = TextEditingController();
  
  // We now have two futures to load data in parallel
  Future<Map<String, dynamic>>? _profileFuture;
  Future<List<dynamic>>? _historyFuture;

  @override
  void initState() {
    super.initState();
    // Load both sets of data when the page opens
    _loadData();
  }
  
  void _loadData() {
    setState(() {
      _profileFuture = _apiService.getMyProfile();
      _historyFuture = _apiService.getMyRideHistory();
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _updateProfile() async {
    try {
      final result = await _apiService.updateMyProfile(_nameController.text);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(result['msg']), backgroundColor: Colors.green),
        );
        _loadData(); // Refresh all data on the page
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString()), backgroundColor: Colors.red),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Profile & Rides')),
      body: FutureBuilder(
        // Use Future.wait to wait for both API calls to complete
        future: Future.wait([_profileFuture!, _historyFuture!]),
        builder: (context, AsyncSnapshot<List<dynamic>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData) {
            return const Center(child: Text('No data found.'));
          }

          // Extract the data from the snapshot
          final profileData = snapshot.data![0] as Map<String, dynamic>;
          final user = profileData['user'];
          final historyData = snapshot.data![1] as List<dynamic>;
          
          _nameController.text = user['name'] ?? '';

          return ListView( // Use ListView to make the page scrollable
            padding: const EdgeInsets.all(24.0),
            children: [
              // --- Profile Section ---
              Text('My Details', style: Theme.of(context).textTheme.headlineSmall),
              const SizedBox(height: 16),
              CircleAvatar(
                radius: 50,
                // TODO: Replace with user['profilePictureUrl'] when implemented
                backgroundColor: Colors.grey[300],
                child: const Icon(Icons.person, size: 60, color: Colors.white),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Full Name'),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _updateProfile,
                child: const Text('Save Changes'),
              ),
              const Divider(height: 48),

              // --- Ride History Section ---
              Text('Ride History', style: Theme.of(context).textTheme.headlineSmall),
              const SizedBox(height: 16),
              if (historyData.isEmpty)
                const Center(child: Text('You have no past rides.'))
              else
                ...historyData.map((ride) {
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    child: ListTile(
                      leading: const Icon(Icons.drive_eta),
                      title: Text('To: ${ride['dropAddress']}'),
                      subtitle: Text('Status: ${ride['status']}'),
                      trailing: Text('\$${ride['fare']}'),
                    ),
                  );
                }).toList(),
            ],
          );
        },
      ),
    );
  }
}