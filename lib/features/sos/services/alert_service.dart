import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

class AlertService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Create a new SOS Alert
  Future<void> createAlert({
    required double latitude,
    required double longitude,
    String type = 'SOS',
  }) async {
    final user = _auth.currentUser;
    if (user == null) return;

    try {
      await _firestore.collection('alerts').add({
        'userId': user.uid,
        'userEmail': user.email,
        'type': type,
        'latitude': latitude,
        'longitude': longitude,
        'timestamp': FieldValue.serverTimestamp(),
        'status': 'ACTIVE', // ACTIVE, RESOLVED
      });
    } catch (e) {
      if (kDebugMode) {
        print('Error creating alert: $e');
      }
      rethrow;
    }
  }

  // Stream of active alerts for the Community Dashboard
  Stream<QuerySnapshot> get activeAlertsStream {
    return _firestore
        .collection('alerts')
        .where('status', isEqualTo: 'ACTIVE')
        .orderBy('timestamp', descending: true)
        .snapshots();
  }

  // Resolve an alert (mark as safe)
  Future<void> resolveAlert(String alertId) async {
    try {
      await _firestore.collection('alerts').doc(alertId).update({
        'status': 'RESOLVED',
      });
    } catch (e) {
      rethrow;
    }
  }
}
