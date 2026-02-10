import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hack_avensis/core/constants/app_colors.dart';
import 'package:hack_avensis/features/sos/services/alert_service.dart';
// import 'package:url_launcher/url_launcher.dart'; // Add to pubspec if navigation is needed

class CommunityScreen extends StatelessWidget {
  const CommunityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Community Watch'),
        backgroundColor: AppColors.background,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: AlertService().activeAlertsStream,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(child: Text('Something went wrong'));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.security, size: 64, color: Colors.green),
                  SizedBox(height: 16),
                  Text(
                    'All Clear\nNo active alerts in your area.',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                ],
              ),
            );
          }

          return ListView(
            padding: const EdgeInsets.all(16),
            children: snapshot.data!.docs.map((DocumentSnapshot document) {
              Map<String, dynamic> data =
                  document.data()! as Map<String, dynamic>;

              // Formatting timestamp
              DateTime? timestamp;
              if (data['timestamp'] != null) {
                timestamp = (data['timestamp'] as Timestamp).toDate();
              }

              return Card(
                color: Colors.red.shade50,
                margin: const EdgeInsets.only(bottom: 16),
                child: ListTile(
                  leading: const Icon(
                    Icons.warning_amber_rounded,
                    color: Colors.red,
                    size: 36,
                  ),
                  title: const Text(
                    'SOS ALERT',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.red,
                    ),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('User ID: ${data['userId']?.substring(0, 5)}...'),
                      if (timestamp != null)
                        Text('Time: ${timestamp.hour}:${timestamp.minute}'),
                      const SizedBox(height: 4),
                      Text(
                        'Location: ${data['latitude']}, ${data['longitude']}',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  trailing: ElevatedButton(
                    onPressed: () {
                      // Implement Navigation here
                      // e.g. launch google maps
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Opening Maps...")),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('Locate'),
                  ),
                ),
              );
            }).toList(),
          );
        },
      ),
    );
  }
}
