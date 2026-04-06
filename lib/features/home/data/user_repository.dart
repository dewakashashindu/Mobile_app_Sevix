import '../domain/dashboard_user.dart';

class UserRepository {
  Future<DashboardUser> fetchDashboardUser() async {
    await Future.delayed(const Duration(milliseconds: 250));
    return const DashboardUser(
      name: 'Jehan',
      currentLocation: 'No.13/Basil House',
      unreadNotifications: 3,
    );
  }
}
