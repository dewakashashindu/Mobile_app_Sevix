import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../domain/dashboard_user.dart';

class UserRepository {
  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

  /// Fetch dashboard user from Firestore
  Future<DashboardUser> fetchDashboardUser() async {
    try {
      final currentUser = _auth.currentUser;
      if (currentUser == null) {
        throw Exception('User not authenticated');
      }

      // Fetch user document from 'users' collection
      final userDoc = await _firestore
          .collection('users')
          .doc(currentUser.uid)
          .get();

      if (!userDoc.exists) {
        // User document doesn't exist, create a default one or throw
        throw Exception('User profile not found');
      }

      final userData = userDoc.data() ?? {};
      final name = userData['displayName'] ?? currentUser.displayName ?? 'User';
      final currentLocation = userData['currentLocation'] ?? 'No location set';

      // Count unread notifications
      int unreadCount = 0;
      try {
        final notificationsQuery = await _firestore
            .collection('users')
            .doc(currentUser.uid)
            .collection('notifications')
            .where('read', isEqualTo: false)
            .count()
            .get();
        unreadCount = notificationsQuery.count ?? 0;
      } catch (e) {
        // If notifications collection doesn't exist, unread count is 0
        unreadCount = 0;
      }

      return DashboardUser(
        name: name,
        currentLocation: currentLocation,
        unreadNotifications: unreadCount,
      );
    } catch (e) {
      rethrow;
    }
  }

  /// Stream of dashboard user for real-time updates
  Stream<DashboardUser> streamDashboardUser() {
    final currentUser = _auth.currentUser;
    if (currentUser == null) {
      return Stream.error('User not authenticated');
    }

    return _firestore
        .collection('users')
        .doc(currentUser.uid)
        .snapshots()
        .asyncMap((userDoc) async {
          if (!userDoc.exists) {
            throw Exception('User profile not found');
          }

          final userData = userDoc.data() ?? {};
          final name =
              userData['displayName'] ?? currentUser.displayName ?? 'User';
          final currentLocation =
              userData['currentLocation'] ?? 'No location set';

          // Count unread notifications in real-time
          int unreadCount = 0;
          try {
            final notificationsQuery = await _firestore
                .collection('users')
                .doc(currentUser.uid)
                .collection('notifications')
                .where('read', isEqualTo: false)
                .count()
                .get();
            unreadCount = notificationsQuery.count ?? 0;
          } catch (e) {
            unreadCount = 0;
          }

          return DashboardUser(
            name: name,
            currentLocation: currentLocation,
            unreadNotifications: unreadCount,
          );
        });
  }
}
