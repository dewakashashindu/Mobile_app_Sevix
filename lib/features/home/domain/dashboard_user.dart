class DashboardUser {
  const DashboardUser({
    required this.name,
    required this.currentLocation,
    required this.unreadNotifications,
  });

  final String name;
  final String currentLocation;
  final int unreadNotifications;
}
