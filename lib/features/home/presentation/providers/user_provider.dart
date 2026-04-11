import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../data/user_repository.dart';
import '../../domain/dashboard_user.dart';

final userRepositoryProvider = Provider<UserRepository>((ref) {
  return UserRepository();
});

/// Stream of dashboard user for real-time updates
final dashboardUserProvider = StreamProvider<DashboardUser>((ref) {
  final userRepository = ref.read(userRepositoryProvider);
  return userRepository.streamDashboardUser();
});

/// Provider to check if user is authenticated
final isUserAuthenticatedProvider = Provider<bool>((ref) {
  final currentUser = FirebaseAuth.instance.currentUser;
  return currentUser != null;
});

/// Provider to get unread notifications count
final unreadNotificationCountProvider = StreamProvider<int>((ref) {
  final dashboardUserAsync = ref.watch(dashboardUserProvider);

  return dashboardUserAsync.when(
    data: (user) => Stream.value(user.unreadNotifications),
    loading: () => Stream.value(0),
    error: (_, __) => Stream.value(0),
  );
});
