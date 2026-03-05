import 'package:flutter/material.dart';

enum NotificationType { booking, message, promotion, system }

class AppNotificationItem {
  const AppNotificationItem({
    required this.id,
    required this.type,
    required this.title,
    required this.message,
    required this.time,
    required this.isRead,
    this.workerCategory,
  });

  final String id;
  final NotificationType type;
  final String title;
  final String message;
  final String time;
  final bool isRead;
  final String? workerCategory;

  AppNotificationItem copyWith({bool? isRead}) {
    return AppNotificationItem(
      id: id,
      type: type,
      title: title,
      message: message,
      time: time,
      isRead: isRead ?? this.isRead,
      workerCategory: workerCategory,
    );
  }
}

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({
    super.key,
    required this.onBack,
    required this.language,
    required this.currentTheme,
    required this.translateCategory,
  });

  final VoidCallback onBack;
  final String language; // en | si | ta
  final String currentTheme; // light | dark
  final String Function(String categoryName, String language) translateCategory;

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  String _selectedFilter = 'all';
  late List<AppNotificationItem> _notifications;

  bool get _isDark => widget.currentTheme == 'dark';

  _ScreenTheme get _theme {
    if (_isDark) {
      return const _ScreenTheme(
        background: Color(0xFF121212),
        cardBackground: Color(0xFF1E1E1E),
        textPrimary: Colors.white,
        textSecondary: Color(0xFFAAAAAA),
        border: Color(0xFF333333),
        divider: Color(0xFF2A2A2A),
      );
    }
    return const _ScreenTheme(
      background: Color(0xFFF8F9FA),
      cardBackground: Colors.white,
      textPrimary: Color(0xFF2A2A2A),
      textSecondary: Color(0xFF888888),
      border: Color(0xFFECECEC),
      divider: Color(0xFFF0F0F0),
    );
  }

  String _txt(String en, String si, String ta) {
    switch (widget.language) {
      case 'si':
        return si;
      case 'ta':
        return ta;
      default:
        return en;
    }
  }

  @override
  void initState() {
    super.initState();
    _notifications = [
      AppNotificationItem(
        id: '1',
        type: NotificationType.booking,
        title: _txt(
          'Booking Confirmed',
          'වෙන්කිරීම තහවුරු කරන ලදී',
          'முன்பதிவு உறுதி',
        ),
        message: _txt(
          'Your booking with Nimal Perera has been confirmed for Dec 25, 10:00 AM',
          'නිමල් පෙරේරා සමඟ ඔබගේ වෙන්කිරීම දෙසැම්බර් 25, පෙ.ව. 10:00 සඳහා තහවුරු කර ඇත',
          'நிமால் பெரேரா உடனான உங்கள் முன்பதிவு டிசம்பர் 25, காலை 10:00 க்கு உறுதிப்படுத்தப்பட்டது',
        ),
        time: _txt('2 hours ago', 'පැය 2කට පෙර', '2 மணி நேரத்திற்கு முன்'),
        isRead: false,
        workerCategory: 'Plumber',
      ),
      AppNotificationItem(
        id: '2',
        type: NotificationType.message,
        title: _txt('New Message', 'නව පණිවිඩය', 'புதிய செய்தி'),
        message: _txt(
          'Sunil Edirisinghe: I will arrive at your location in 15 minutes',
          'සුනිල් එදිරිසිංහ: මම විනාඩි 15කින් ඔබගේ ස්ථානයට පැමිණෙමි',
          'சுனில் எதிரிசிங்ஹ: நான் 15 நிமிடங்களில் உங்கள் இடத்திற்கு வருவேன்',
        ),
        time: _txt('4 hours ago', 'පැය 4කට පෙර', '4 மணி நேரத்திற்கு முன்'),
        isRead: false,
      ),
      AppNotificationItem(
        id: '3',
        type: NotificationType.booking,
        title: _txt(
          'Booking Completed',
          'වෙන්කිරීම සම්පූර්ණයි',
          'முன்பதிவு முடிந்தது',
        ),
        message: _txt(
          'Your service with Kamal Silva has been completed. Please rate your experience',
          'කමල් සිල්වා සමඟ ඔබගේ සේවාව සම්පූර්ණ කර ඇත. කරුණාකර ඔබගේ අත්දැකීම අගය කරන්න',
          'கமல் சில்வா உடனான உங்கள் சேவை முடிந்துவிட்டது. தயவுசெய்து உங்கள் அனுபவத்தை மதிப்பிடுங்கள்',
        ),
        time: _txt('Yesterday', 'ඊයේ', 'நேற்று'),
        isRead: true,
        workerCategory: 'Mason',
      ),
      AppNotificationItem(
        id: '4',
        type: NotificationType.promotion,
        title: _txt(
          '🎉 Special Offer!',
          '🎉 විශේෂ දීමනාව!',
          '🎉 சிறப்பு சலுகை!',
        ),
        message: _txt(
          'Get 20% off on your next booking. Use code: SEVIX20',
          'ඔබගේ ඊළඟ වෙන්කිරීමෙන් 20% ක් වට්ටම් ලබා ගන්න. කේතය භාවිතා කරන්න: SEVIX20',
          'உங்கள் அடுத்த முன்பதிவில் 20% தள்ளுபடி பெறுங்கள். குறியீட்டைப் பயன்படுத்தவும்: SEVIX20',
        ),
        time: _txt('Yesterday', 'ඊයේ', 'நேற்று'),
        isRead: true,
      ),
      AppNotificationItem(
        id: '5',
        type: NotificationType.system,
        title: _txt(
          'Payment Successful',
          'ගෙවීම සාර්ථකයි',
          'பணம் செலுத்தல் வெற்றி',
        ),
        message: _txt(
          'Rs. 4,500 has been paid to Kamal Silva for completed service',
          'සම්පූර්ණ කළ සේවාව සඳහා රු. 4,500 ක් කමල් සිල්වාට ගෙවා ඇත',
          'முடிக்கப்பட்ட சேவைக்காக ரூ. 4,500 கமல் சில்வாவுக்கு செலுத்தப்பட்டது',
        ),
        time: _txt('2 days ago', 'දින 2කට පෙර', '2 நாட்களுக்கு முன்'),
        isRead: true,
      ),
    ];
  }

  List<AppNotificationItem> get _filteredNotifications {
    if (_selectedFilter == 'all') {
      return _notifications;
    }
    return _notifications
        .where((item) => item.type.name == _selectedFilter)
        .toList();
  }

  int get _unreadCount => _notifications.where((item) => !item.isRead).length;

  void _markAsRead(String id) {
    setState(() {
      _notifications = _notifications
          .map((item) => item.id == id ? item.copyWith(isRead: true) : item)
          .toList();
    });
  }

  void _markAllAsRead() {
    setState(() {
      _notifications = _notifications
          .map((item) => item.copyWith(isRead: true))
          .toList();
    });
  }

  IconData _iconForType(NotificationType type) {
    switch (type) {
      case NotificationType.booking:
        return Icons.calendar_today;
      case NotificationType.message:
        return Icons.chat_bubble;
      case NotificationType.promotion:
        return Icons.local_offer;
      case NotificationType.system:
        return Icons.info;
    }
  }

  Color _colorForType(NotificationType type) {
    switch (type) {
      case NotificationType.booking:
        return const Color(0xFF3498DB);
      case NotificationType.message:
        return const Color(0xFF27AE60);
      case NotificationType.promotion:
        return const Color(0xFFE74C3C);
      case NotificationType.system:
        return const Color(0xFFF39C12);
    }
  }

  String _filterLabel(String filter) {
    switch (filter) {
      case 'all':
        return _txt('All', 'සියල්ල', 'அனைத்தும்');
      case 'booking':
        return _txt('Bookings', 'වෙන්කිරීම්', 'முன்பதிவுகள்');
      case 'message':
        return _txt('Messages', 'පණිවිඩ', 'செய்திகள்');
      case 'promotion':
        return _txt('Offers', 'දීමනා', 'சலுகைகள்');
      case 'system':
        return _txt('System', 'පද්ධතිය', 'அமைப்பு');
      default:
        return filter;
    }
  }

  @override
  Widget build(BuildContext context) {
    const filters = ['all', 'booking', 'message', 'promotion', 'system'];

    return Scaffold(
      backgroundColor: _theme.background,
      body: SafeArea(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
              decoration: BoxDecoration(
                color: _theme.cardBackground,
                border: Border(bottom: BorderSide(color: _theme.border)),
              ),
              child: Row(
                children: [
                  IconButton(
                    onPressed: widget.onBack,
                    icon: Icon(Icons.arrow_back, color: _theme.textPrimary),
                  ),
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          _txt('Notifications', 'දැනුම්දීම්', 'அறிவிப்புகள்'),
                          style: TextStyle(
                            color: _theme.textPrimary,
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        if (_unreadCount > 0) ...[
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFFE74C3C),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              '$_unreadCount',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  if (_unreadCount > 0)
                    TextButton(
                      onPressed: _markAllAsRead,
                      child: Text(
                        _txt(
                          'Read all',
                          'සියල්ල කියවන්න',
                          'அனைத்தையும் படிக்கவும்',
                        ),
                        style: const TextStyle(
                          color: Color(0xFF3498DB),
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    )
                  else
                    const SizedBox(width: 60),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(
                color: _theme.cardBackground,
                border: Border(bottom: BorderSide(color: _theme.border)),
              ),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Row(
                  children: filters.map((filter) {
                    final active = _selectedFilter == filter;
                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(20),
                        onTap: () => setState(() => _selectedFilter = filter),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: active
                                ? const Color(0xFF0B1533)
                                : _theme.divider,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            _filterLabel(filter),
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: active
                                  ? Colors.white
                                  : _theme.textSecondary,
                            ),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
            Expanded(
              child: _filteredNotifications.isEmpty
                  ? Center(
                      child: Padding(
                        padding: const EdgeInsets.all(32),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.notifications_off_outlined,
                              size: 64,
                              color: _theme.divider,
                            ),
                            const SizedBox(height: 12),
                            Text(
                              _txt(
                                'No notifications',
                                'දැනුම්දීම් නොමැත',
                                'அறிவிப்புகள் இல்லை',
                              ),
                              style: TextStyle(
                                color: _theme.textPrimary,
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              _txt(
                                'You are all caught up! Check back later for updates',
                                'ඔබ සියල්ල දැනගෙන සිටී! යාවත්කාලීන කිරීම් සඳහා පසුව නැවත පරීක්ෂා කරන්න',
                                'நீங்கள் அனைத்தையும் பார்த்துவிட்டீர்கள்! புதுப்பிப்புகளுக்கு பின்னர் மீண்டும் பாருங்கள்',
                              ),
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: _theme.textSecondary,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: _filteredNotifications.length,
                      itemBuilder: (context, index) {
                        final notification = _filteredNotifications[index];
                        final typeColor = _colorForType(notification.type);

                        return InkWell(
                          borderRadius: BorderRadius.circular(16),
                          onTap: () => _markAsRead(notification.id),
                          child: Container(
                            margin: const EdgeInsets.only(bottom: 12),
                            padding: const EdgeInsets.all(14),
                            decoration: BoxDecoration(
                              color: !notification.isRead
                                  ? const Color(0xFFF8FBFF)
                                  : _theme.cardBackground,
                              borderRadius: BorderRadius.circular(16),
                              border: Border(
                                left: BorderSide(
                                  color: !notification.isRead
                                      ? const Color(0xFF3498DB)
                                      : Colors.transparent,
                                  width: 3,
                                ),
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.05),
                                  blurRadius: 8,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  width: 46,
                                  height: 46,
                                  decoration: BoxDecoration(
                                    color: typeColor.withValues(alpha: 0.12),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    _iconForType(notification.type),
                                    color: typeColor,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Expanded(
                                            child: Text(
                                              notification.title,
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                color: _theme.textPrimary,
                                                fontSize: 15,
                                                fontWeight: FontWeight.w700,
                                              ),
                                            ),
                                          ),
                                          if (!notification.isRead)
                                            Container(
                                              width: 8,
                                              height: 8,
                                              decoration: const BoxDecoration(
                                                color: Color(0xFF3498DB),
                                                shape: BoxShape.circle,
                                              ),
                                            ),
                                        ],
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        notification.message,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          color: _theme.textSecondary,
                                          fontSize: 13,
                                          height: 1.35,
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Row(
                                        children: [
                                          Icon(
                                            Icons.access_time,
                                            size: 12,
                                            color: _theme.textSecondary,
                                          ),
                                          const SizedBox(width: 4),
                                          Text(
                                            notification.time,
                                            style: TextStyle(
                                              color: _theme.textSecondary,
                                              fontSize: 11,
                                            ),
                                          ),
                                          if (notification.workerCategory !=
                                              null) ...[
                                            const SizedBox(width: 6),
                                            Container(
                                              width: 3,
                                              height: 3,
                                              decoration: BoxDecoration(
                                                color: _theme.textSecondary,
                                                shape: BoxShape.circle,
                                              ),
                                            ),
                                            const SizedBox(width: 6),
                                            Text(
                                              widget.translateCategory(
                                                notification.workerCategory!,
                                                widget.language,
                                              ),
                                              style: const TextStyle(
                                                color: Color(0xFF3498DB),
                                                fontSize: 11,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ],
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ScreenTheme {
  const _ScreenTheme({
    required this.background,
    required this.cardBackground,
    required this.textPrimary,
    required this.textSecondary,
    required this.border,
    required this.divider,
  });

  final Color background;
  final Color cardBackground;
  final Color textPrimary;
  final Color textSecondary;
  final Color border;
  final Color divider;
}
