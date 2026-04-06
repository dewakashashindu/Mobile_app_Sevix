import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/user_repository.dart';
import '../../domain/dashboard_user.dart';

final userRepositoryProvider = Provider<UserRepository>((ref) {
  return UserRepository();
});

final dashboardUserProvider = FutureProvider<DashboardUser>((ref) async {
  return ref.read(userRepositoryProvider).fetchDashboardUser();
});
