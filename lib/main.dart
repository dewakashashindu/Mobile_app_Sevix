import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sevix/l10n/app_localizations.dart';
import 'package:sevix/features/home/presentation/providers/user_provider.dart';
import 'settings_screen.dart' as separate;
import 'worker_type_screen.dart' as worker_ui;
import 'notification_screen.dart' as notification_ui;
import 'booking_screen.dart' as booking_ui;
import 'language_select_screen.dart';
import 'login_screen.dart';
import 'signup_screen.dart';
import 'bookings_management_screen.dart';
import 'services/biometric_service.dart';
import 'widgets/app_state_views.dart';

void main() {
  runApp(const ProviderScope(child: SevixApp()));
}

// ============================================================
// ROOT APP
// ============================================================
class SevixApp extends StatelessWidget {
  const SevixApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sevix',
      debugShowCheckedModeBanner: false,
      localizationsDelegates: [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF0B1533)),
        useMaterial3: true,
      ),
      home: const AppRoot(),
    );
  }
}

// ============================================================
// THEME
// ============================================================
class AppTheme {
  final Color background;
  final Color cardBackground;
  final Color textPrimary;
  final Color textSecondary;
  final Color border;
  final Color divider;
  final Color primary;
  final Color tabBarBackground;
  final Color tabBarActive;
  final Color tabBarInactive;
  final Color inputBackground;
  final Color inputBorder;
  final Color inputPlaceholder;

  const AppTheme({
    required this.background,
    required this.cardBackground,
    required this.textPrimary,
    required this.textSecondary,
    required this.border,
    required this.divider,
    required this.primary,
    required this.tabBarBackground,
    required this.tabBarActive,
    required this.tabBarInactive,
    required this.inputBackground,
    required this.inputBorder,
    required this.inputPlaceholder,
  });

  static const light = AppTheme(
    background: Color(0xFFF8F9FA),
    cardBackground: Colors.white,
    textPrimary: Color(0xFF2A2A2A),
    textSecondary: Color(0xFF888888),
    border: Color(0xFFECECEC),
    divider: Color(0xFFF0F0F0),
    primary: Color(0xFF0B1533),
    tabBarBackground: Colors.white,
    tabBarActive: Color(0xFF0B1533),
    tabBarInactive: Color(0xFF888888),
    inputBackground: Color(0xFFF9FAFB),
    inputBorder: Color(0xFFDDDDDD),
    inputPlaceholder: Color(0xFF999999),
  );

  static const dark = AppTheme(
    background: Color(0xFF121212),
    cardBackground: Color(0xFF1E1E1E),
    textPrimary: Color(0xFFFFFFFF),
    textSecondary: Color(0xFFAAAAAA),
    border: Color(0xFF333333),
    divider: Color(0xFF2A2A2A),
    primary: Color(0xFF4A90E2),
    tabBarBackground: Color(0xFF1E1E1E),
    tabBarActive: Color(0xFF4A90E2),
    tabBarInactive: Color(0xFF666666),
    inputBackground: Color(0xFF2A2A2A),
    inputBorder: Color(0xFF444444),
    inputPlaceholder: Color(0xFF666666),
  );
}

// ============================================================
// TRANSLATIONS
// ============================================================
class AppTranslations {
  final String goodMorning;
  final String searchPlaceholder;
  final String homeTab;
  final String bookingsTab;
  final String useCurrentLocation;
  final String edit;
  final String cancel;
  final String save;

  const AppTranslations({
    required this.goodMorning,
    required this.searchPlaceholder,
    required this.homeTab,
    required this.bookingsTab,
    required this.useCurrentLocation,
    required this.edit,
    required this.cancel,
    required this.save,
  });

  static const en = AppTranslations(
    goodMorning: 'Good Morning,',
    searchPlaceholder: 'Search workers, services...',
    homeTab: 'Home',
    bookingsTab: 'Bookings',
    useCurrentLocation: 'Use Current Location',
    edit: 'Edit',
    cancel: 'Cancel',
    save: 'Save',
  );

  static const si = AppTranslations(
    goodMorning: 'සුභ උදෑසනක්,',
    searchPlaceholder: 'සේවකයන් සොයන්න...',
    homeTab: 'මුල් පිටුව',
    bookingsTab: 'Bookings',
    useCurrentLocation: 'වත්මන් ස්ථානය භාවිත කරන්න',
    edit: 'සංස්කරණය',
    cancel: 'අවලංගු කරන්න',
    save: 'සුරකින්න',
  );

  static const ta = AppTranslations(
    goodMorning: 'காலை வணக்கம்,',
    searchPlaceholder: 'தொழிலாளர்களை தேடவும்...',
    homeTab: 'முகப்பு',
    bookingsTab: 'Bookings',
    useCurrentLocation: 'தற்போதைய இடத்தை பயன்படுத்தவும்',
    edit: 'திருத்து',
    cancel: 'ரத்து செய்',
    save: 'சேமி',
  );

  static AppTranslations forLang(String lang) {
    switch (lang) {
      case 'si':
        return si;
      case 'ta':
        return ta;
      default:
        return en;
    }
  }
}

// ============================================================
// MODELS
// ============================================================
class Worker {
  final int id;
  final String name;
  final String category;
  final double rating;
  final bool available;

  const Worker({
    required this.id,
    required this.name,
    required this.category,
    required this.rating,
    this.available = true,
  });
}

final List<Worker> kWorkers = [
  const Worker(id: 1, name: 'Nimal Perera', category: 'Plumber', rating: 4.8),
  const Worker(
    id: 2,
    name: 'Sunil Edirisinghe',
    category: 'Electrician',
    rating: 4.9,
  ),
  const Worker(id: 3, name: 'Kamal Silva', category: 'Mason', rating: 4.7),
  const Worker(id: 4, name: 'Anil Fernando', category: 'Plumber', rating: 4.6),
  const Worker(
    id: 5,
    name: 'Prasad Wickramasinghe',
    category: 'Electrician',
    rating: 4.8,
  ),
  const Worker(
    id: 6,
    name: 'Ruwan Jayawardena',
    category: 'Mason',
    rating: 4.5,
  ),
  const Worker(
    id: 7,
    name: 'Chaminda Rathnayake',
    category: 'Plumber',
    rating: 4.9,
  ),
  const Worker(
    id: 8,
    name: 'Tharaka Gunasekara',
    category: 'Electrician',
    rating: 4.7,
  ),
];

class AppAddress {
  final int id;
  final String? label;
  final String address;
  final bool pinned;
  final bool isDefault;
  final double? latitude;
  final double? longitude;

  const AppAddress({
    required this.id,
    this.label,
    required this.address,
    this.pinned = false,
    this.isDefault = false,
    this.latitude,
    this.longitude,
  });

  AppAddress copyWith({
    String? label,
    String? address,
    bool? pinned,
    bool? isDefault,
    double? latitude,
    double? longitude,
  }) {
    return AppAddress(
      id: id,
      label: label ?? this.label,
      address: address ?? this.address,
      pinned: pinned ?? this.pinned,
      isDefault: isDefault ?? this.isDefault,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
    );
  }
}

class Favorite {
  final int id;
  final String name;
  final String category;

  const Favorite({
    required this.id,
    required this.name,
    required this.category,
  });
}

// ============================================================
// CATEGORY TRANSLATIONS
// ============================================================
String getCategoryTranslation(String category, String lang) {
  const Map<String, Map<String, String>> translations = {
    'Plumber': {'en': 'Plumber', 'si': 'නළ සේවකයා', 'ta': 'குழாய்வேலை'},
    'Electrician': {
      'en': 'Electrician',
      'si': 'විදුලි කාර්මිකය',
      'ta': 'மின்சாரி',
    },
    'Mason': {'en': 'Mason', 'si': 'කොන්ක්‍රිට් කම්කරු', 'ta': 'கொத்தனார்'},
    'Carpenter': {
      'en': 'Carpenter',
      'si': 'ඉදිකිරීම් කාර්මිකය',
      'ta': 'தச்சர்',
    },
    'Painter': {'en': 'Painter', 'si': 'පින්තාරු කරු', 'ta': 'சித்தரிப்பவர்'},
    'Gardener': {'en': 'Gardener', 'si': 'ගොවිකම', 'ta': 'தோட்டக்காரர்'},
    'Cleaner': {
      'en': 'Cleaner',
      'si': 'පිරිසිදු කරන්නා',
      'ta': 'சுத்தம் செய்பவர்',
    },
    'AC Technician': {
      'en': 'AC Technician',
      'si': 'AC කාර්මිකය',
      'ta': 'AC தொழில்நுட்பவியலாளர்',
    },
    'Mechanic': {'en': 'Mechanic', 'si': 'යාන්ත්‍රිකය', 'ta': 'மெக்கானிக்'},
    'Welder': {'en': 'Welder', 'si': 'වෑල්ඩර්', 'ta': 'வெல்டர்'},
    'Tiler': {'en': 'Tiler', 'si': 'ටයිල් කාර්මිකය', 'ta': 'ஓடு வேலையாளர்'},
    'Roofer': {'en': 'Roofer', 'si': 'වහල් කාර්මිකය', 'ta': 'கூரை வேலையாளர்'},
  };
  return translations[category]?[lang] ?? category;
}

// ============================================================
// APP ROOT (STATE MANAGEMENT + ROUTING)
// ============================================================
class AppRoot extends StatefulWidget {
  const AppRoot({super.key});

  @override
  State<AppRoot> createState() => _AppRootState();
}

enum _GlobalScreenState { loading, content, error }

class _AppRootState extends State<AppRoot> {
  bool _isLoggedIn = false;
  bool _showSignup = false;
  String _selectedLanguage = '';
  String _currentTheme = 'light';
  Map<String, bool> _notificationSettings = {
    'newBids': true,
    'workerAccepted': true,
    'jobUpdates': true,
    'messages': true,
  };
  bool _biometricEnabled = false;
  bool _biometricAvailable = false;

  List<AppAddress> _addresses = const [
    AppAddress(
      id: 1,
      label: 'Home',
      address: 'No.13/Basil House',
      pinned: true,
      isDefault: true,
    ),
    AppAddress(id: 2, label: 'Work', address: 'No.22/Flower Road'),
    AppAddress(id: 3, label: 'Apartment', address: 'Apartment 5B, Main Street'),
  ];
  int _selectedAddressIndex = 0;

  String _activeTab = 'home';
  String _currentScreen = 'home';
  Worker? _selectedWorker;

  Map<String, String> _bookingContext = const {'workerType': '', 'address': ''};
  List<Favorite> _favorites = const [];
  final Map<String, _GlobalScreenState> _screenStates = {};
  final Map<String, String> _screenErrors = {};

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadBiometricState();
    });
  }

  AppTheme get _theme =>
      _currentTheme == 'dark' ? AppTheme.dark : AppTheme.light;
  AppTranslations get _t => AppTranslations.forLang(_selectedLanguage);

  BiometricService get _biometricService => ProviderScope.containerOf(
    context,
    listen: false,
  ).read(biometricServiceProvider);

  Future<void> _loadBiometricState() async {
    final available = await _biometricService.isBiometricAvailable();
    final enabled = await _biometricService.isBiometricEnabled();
    if (!mounted) {
      return;
    }
    setState(() {
      _biometricAvailable = available;
      _biometricEnabled = enabled;
    });
  }

  Future<bool> _toggleBiometric(bool value) async {
    if (value) {
      final available = await _biometricService.isBiometricAvailable();
      if (!available) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                'Biometric hardware is not available on this device.',
              ),
            ),
          );
        }
        return false;
      }
    }

    await _biometricService.setBiometricEnabled(value);
    if (!mounted) {
      return false;
    }
    setState(() {
      _biometricEnabled = value;
    });
    return true;
  }

  Future<bool> _handleBiometricLogin() async {
    final enabled = await _biometricService.isBiometricEnabled();
    if (!enabled) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Biometric login is disabled.')),
        );
      }
      return false;
    }

    final available = await _biometricService.isBiometricAvailable();
    if (!available) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Biometrics are not available.')),
        );
      }
      return false;
    }

    final authenticated = await _biometricService.authenticate(
      reason: 'Use fingerprint or Face ID to sign in',
    );

    if (authenticated && mounted) {
      setState(() {
        _isLoggedIn = true;
      });
    }
    return authenticated;
  }

  String _txt(String en, String si, String ta) {
    switch (_selectedLanguage) {
      case 'si':
        return si;
      case 'ta':
        return ta;
      default:
        return en;
    }
  }

  void _primeScreenState(String key) {
    if (_screenStates.containsKey(key)) {
      return;
    }
    _screenStates[key] = _GlobalScreenState.loading;
    Future.delayed(const Duration(milliseconds: 500), () {
      if (!mounted) {
        return;
      }
      if (_screenStates[key] == _GlobalScreenState.loading) {
        setState(() {
          _screenStates[key] = _GlobalScreenState.content;
        });
      }
    });
  }

  void _retryScreen(String key) {
    setState(() {
      _screenErrors.remove(key);
      _screenStates[key] = _GlobalScreenState.loading;
    });
    Future.delayed(const Duration(milliseconds: 500), () {
      if (!mounted) {
        return;
      }
      setState(() {
        _screenStates[key] = _GlobalScreenState.content;
      });
    });
  }

  Widget _buildStatefulRoute({
    required String screenKey,
    required String title,
    required Widget Function() builder,
    bool forceEmpty = false,
    String? emptyMessage,
    VoidCallback? onEmptyAction,
    String? emptyActionLabel,
  }) {
    _primeScreenState(screenKey);
    final state = _screenStates[screenKey] ?? _GlobalScreenState.loading;

    if (state == _GlobalScreenState.loading) {
      return AppLoadingState(title: title);
    }

    if (state == _GlobalScreenState.error) {
      return AppErrorState(
        title: title,
        message:
            _screenErrors[screenKey] ??
            _txt(
              'Something went wrong while loading this screen.',
              'මෙම තිරය පූරණය කිරීමේදී දෝෂයක් ඇති විය.',
              'இந்த திரையை ஏற்றும் போது பிழை ஏற்பட்டது.',
            ),
        onRetry: () => _retryScreen(screenKey),
      );
    }

    if (forceEmpty) {
      return AppEmptyState(
        title: title,
        message:
            emptyMessage ??
            _txt(
              'Nothing to show yet.',
              'තවම පෙන්වීමට කිසිවක් නැත.',
              'காண்பிக்க இதுவரை எதுவும் இல்லை.',
            ),
        actionLabel: emptyActionLabel,
        onAction: onEmptyAction,
      );
    }

    try {
      return builder();
    } catch (error) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) {
          return;
        }
        setState(() {
          _screenStates[screenKey] = _GlobalScreenState.error;
          _screenErrors[screenKey] = error.toString();
        });
      });
      return AppErrorState(
        title: title,
        message: _txt(
          'Failed to render this screen. Tap retry.',
          'මෙම තිරය පෙන්වීමට අසමත් විය. නැවත උත්සාහ කරන්න.',
          'இந்த திரையை காட்ட முடியவில்லை. மீண்டும் முயற்சிக்கவும்.',
        ),
        onRetry: () => _retryScreen(screenKey),
      );
    }
  }

  Widget _withSelectedLocale(Widget child) {
    if (_selectedLanguage.isEmpty) {
      return child;
    }
    return Localizations.override(
      context: context,
      locale: Locale(_selectedLanguage),
      child: child,
    );
  }

  void _selectCategory(String categoryName) {
    final resolvedCategory = _categoryNameFromIdOrName(categoryName);
    final available = kWorkers
        .where((w) => w.category == resolvedCategory && w.available)
        .toList();
    if (available.isNotEmpty) {
      setState(() {
        _selectedWorker = available.first;
        _bookingContext = {
          'workerType': resolvedCategory,
          'categoryId': categoryName.toLowerCase(),
          'address': _selectedAddressIndex < _addresses.length
              ? _addresses[_selectedAddressIndex].address
              : '',
        };
        _currentScreen = 'booking';
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No workers available in this category at the moment'),
        ),
      );
    }
  }

  void _bookNow() {
    final available = kWorkers.where((w) => w.available).toList();
    if (available.isNotEmpty) {
      setState(() {
        _selectedWorker = available.first;
        _currentScreen = 'booking';
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No workers available at the moment')),
      );
    }
  }

  String _categoryNameFromIdOrName(String idOrName) {
    const map = {
      'plumber': 'Plumber',
      'electrician': 'Electrician',
      'mason': 'Mason',
      'carpenter': 'Carpenter',
      'painter': 'Painter',
      'gardener': 'Gardener',
      'cleaner': 'Cleaner',
      'ac-technician': 'AC Technician',
      'mechanic': 'Mechanic',
      'welder': 'Welder',
      'tiler': 'Tiler',
      'roofer': 'Roofer',
    };

    final normalized = idOrName.toLowerCase();
    return map[normalized] ?? idOrName;
  }

  @override
  Widget build(BuildContext context) {
    if (_selectedLanguage.isEmpty) {
      return _buildStatefulRoute(
        screenKey: 'language-select',
        title: 'Language',
        builder: () => LanguageSelectScreen(
          onSelect: (lang) => setState(() => _selectedLanguage = lang),
        ),
      );
    }

    if (!_isLoggedIn) {
      if (_showSignup) {
        return _buildStatefulRoute(
          screenKey: 'signup',
          title: _txt('Sign Up', 'ලියාපදිංචි වන්න', 'பதிவு செய்யவும்'),
          builder: () => _withSelectedLocale(
            SignupScreen(
              theme: _theme,
              selectedLanguage: _selectedLanguage,
              onSignUpSuccess: () => setState(() {
                _isLoggedIn = true;
                _showSignup = false;
              }),
              onNavigateToLogin: () => setState(() => _showSignup = false),
            ),
          ),
        );
      }
      return _buildStatefulRoute(
        screenKey: 'login',
        title: _txt('Login', 'පිවිසුම', 'உள்நுழை'),
        builder: () => _withSelectedLocale(
          LoginScreen(
            theme: _theme,
            selectedLanguage: _selectedLanguage,
            onLoginSuccess: () => setState(() => _isLoggedIn = true),
            onNavigateToSignup: () => setState(() => _showSignup = true),
            biometricAvailable: _biometricAvailable,
            biometricEnabled: _biometricEnabled,
            onBiometricLogin: _handleBiometricLogin,
          ),
        ),
      );
    }

    if (_activeTab == 'bookings') {
      return _buildStatefulRoute(
        screenKey: 'bookings',
        title: _txt('Bookings', 'වෙන්කිරීම්', 'முன்பதிவுகள்'),
        builder: () => _withSelectedLocale(
          BookingsManagementScreen(
            theme: _theme,
            selectedLanguage: _selectedLanguage,
            onBack: () => setState(() => _activeTab = 'home'),
          ),
        ),
      );
    }

    if (_activeTab == 'chat') {
      return _buildStatefulRoute(
        screenKey: 'chat',
        title: _txt('Chat', 'සංවාද', 'அரட்டை'),
        forceEmpty: false,
        emptyMessage: _txt(
          'No messages yet.',
          'තවම පණිවිඩ නොමැත.',
          'இதுவரை செய்திகள் இல்லை.',
        ),
        builder: () => _withSelectedLocale(
          ChatScreen(
            theme: _theme,
            language: _selectedLanguage,
            onBack: () => setState(() => _activeTab = 'home'),
          ),
        ),
      );
    }

    if (_activeTab == 'settings') {
      return _buildStatefulRoute(
        screenKey: 'settings',
        title: _txt('Settings', 'සැකසීම්', 'அமைப்புகள்'),
        builder: () => _withSelectedLocale(
          separate.SettingsScreen(
            language: _selectedLanguage,
            currentTheme: _currentTheme,
            onBack: () => setState(() => _activeTab = 'home'),
            onLanguageChange: (lang) =>
                setState(() => _selectedLanguage = lang),
            onThemeChange: (th) => setState(() => _currentTheme = th),
            notificationSettings: _notificationSettings,
            onNotificationSettingsChange: (settings) =>
                setState(() => _notificationSettings = settings),
            biometricEnabled: _biometricEnabled,
            onBiometricToggle: _toggleBiometric,
            onLogout: () => setState(() {
              _isLoggedIn = false;
              _activeTab = 'home';
              _currentScreen = 'home';
            }),
            onDeleteAccount: () => setState(() {
              _isLoggedIn = false;
              _activeTab = 'home';
              _currentScreen = 'home';
            }),
          ),
        ),
      );
    }

    if (_currentScreen == 'notifications') {
      return _buildStatefulRoute(
        screenKey: 'notifications',
        title: _txt('Notifications', 'දැනුම්දීම්', 'அறிவிப்புகள்'),
        forceEmpty: !_notificationSettings.values.any((isEnabled) => isEnabled),
        emptyMessage: _txt(
          'All notification types are turned off. Enable one in Settings.',
          'සියලු දැනුම්දීම් වර්ග අක්‍රියයි. සැකසීම් තුළ එකක් සක්‍රිය කරන්න.',
          'அனைத்து அறிவிப்பு வகைகளும் அணைக்கப்பட்டுள்ளன. அமைப்புகளில் ஒன்றை இயக்கவும்.',
        ),
        emptyActionLabel: _txt(
          'Open Settings',
          'සැකසීම් විවෘත කරන්න',
          'அமைப்புகளைத் திறக்கவும்',
        ),
        onEmptyAction: () => setState(() {
          _activeTab = 'settings';
          _currentScreen = 'home';
        }),
        builder: () => _withSelectedLocale(
          notification_ui.NotificationScreen(
            language: _selectedLanguage,
            currentTheme: _currentTheme,
            notificationSettings: _notificationSettings,
            translateCategory: getCategoryTranslation,
            onBack: () => setState(() => _currentScreen = 'home'),
          ),
        ),
      );
    }

    if (_currentScreen == 'findWorker') {
      return _buildStatefulRoute(
        screenKey: 'find-worker',
        title: _txt('Find Worker', 'සේවකයෙකු සොයන්න', 'பணியாளரைத் தேடு'),
        builder: () => _withSelectedLocale(
          FindWorkerScreen(
            theme: _theme,
            language: _selectedLanguage,
            workerType: _bookingContext['workerType'] ?? '',
            userAddress: _bookingContext['address'] ?? '',
            onBack: () => setState(() => _currentScreen = 'home'),
          ),
        ),
      );
    }

    if (_currentScreen == 'booking') {
      return _buildStatefulRoute(
        screenKey: 'booking',
        title: _txt('Booking', 'වෙන්කිරීම', 'முன்பதிவு'),
        builder: () => _withSelectedLocale(
          booking_ui.BookingScreen(
            initialWorkerCategory:
                _bookingContext['workerType'] ??
                _selectedWorker?.category ??
                'Plumber',
            language: _selectedLanguage,
            currentTheme: _currentTheme,
            translateCategory: getCategoryTranslation,
            onBack: () => setState(() {
              _currentScreen = 'home';
              _selectedWorker = null;
              _bookingContext = {};
            }),
            onPostJobRequest: (jobRequest) {
              setState(() {
                _activeTab = 'bookings';
                _currentScreen = 'home';
                _selectedWorker = null;
                _bookingContext = {};
              });
              // Navigate to bookings tab and show confirmation.
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    getCategoryTranslation(
                      'Job posted! Opening Bookings to view bids.',
                      _selectedLanguage,
                    ),
                  ),
                  backgroundColor: Colors.green,
                  duration: const Duration(seconds: 3),
                ),
              );
            },
          ),
        ),
      );
    }

    if (_currentScreen == 'workerType') {
      return _buildStatefulRoute(
        screenKey: 'worker-type',
        title: _txt('Worker Types', 'සේවක වර්ග', 'பணியாளர் வகைகள்'),
        forceEmpty: kWorkers.where((w) => w.available).isEmpty,
        emptyMessage: _txt(
          'No workers are currently available. Please try again soon.',
          'දැනට සේවකයින් නොමැත. කරුණාකර පසුව නැවත උත්සාහ කරන්න.',
          'தற்போது பணியாளர்கள் இல்லை. பின்னர் மீண்டும் முயற்சிக்கவும்.',
        ),
        emptyActionLabel: _txt('Back Home', 'මුල් පිටුවට', 'முகப்பிற்கு'),
        onEmptyAction: () => setState(() => _currentScreen = 'home'),
        builder: () => _withSelectedLocale(
          worker_ui.WorkerTypeScreen(
            language: _selectedLanguage,
            currentTheme: _currentTheme,
            favoriteCategories: _favorites.map((f) => f.category).toList(),
            onBack: () => setState(() => _currentScreen = 'home'),
            onSelectCategory: _selectCategory,
            onToggleFavorite: (cat) => setState(() {
              if (_favorites.any((f) => f.category == cat)) {
                _favorites = _favorites
                    .where((f) => f.category != cat)
                    .toList();
              } else {
                _favorites = [
                  ..._favorites,
                  Favorite(id: cat.hashCode, name: cat, category: cat),
                ];
              }
            }),
            getCategoryCount: (category) => kWorkers
                .where((w) => w.available && w.category == category)
                .length,
          ),
        ),
      );
    }

    // Main home screen
    return _buildStatefulRoute(
      screenKey: 'home',
      title: _txt('Home', 'මුල් පිටුව', 'முகப்பு'),
      forceEmpty: _addresses.isEmpty,
      emptyMessage: _txt(
        'No saved addresses yet. Add one to start booking services.',
        'තවම සුරකින ලද ලිපින නැත. සේවා වෙන්කිරීම සඳහා එකක් එක් කරන්න.',
        'சேமிக்கப்பட்ட முகவரிகள் இல்லை. சேவைகளை முன்பதிவு செய்ய ஒன்றை சேர்க்கவும்.',
      ),
      emptyActionLabel: _txt(
        'Add Current Location',
        'වත්මන් ස්ථානය එක් කරන්න',
        'தற்போதைய இடத்தைச் சேர்க்கவும்',
      ),
      onEmptyAction: () => setState(() {
        _addresses = const [
          AppAddress(
            id: 1,
            label: 'Current location',
            address: 'Current Location',
            isDefault: true,
          ),
        ];
        _selectedAddressIndex = 0;
      }),
      builder: () => _withSelectedLocale(
        HomeScreen(
          theme: _theme,
          language: _selectedLanguage,
          t: _t,
          activeTab: _activeTab,
          addresses: _addresses,
          selectedAddressIndex: _selectedAddressIndex,
          onUpdateAddresses: (list) => setState(() => _addresses = list),
          onSetSelectedAddressIndex: (i) =>
              setState(() => _selectedAddressIndex = i),
          onSelectCategory: _selectCategory,
          onShowCategories: () => setState(() => _currentScreen = 'workerType'),
          onBookNow: _bookNow,
          onNotificationPress: () =>
              setState(() => _currentScreen = 'notifications'),
          onSetActiveTab: (tab) => setState(() => _activeTab = tab),
          onGoToChat: () => setState(() => _activeTab = 'chat'),
          onGoToSettings: () => setState(() => _activeTab = 'settings'),
          onNavigateSearch: (action) {
            switch (action) {
              case 'settings':
                setState(() => _activeTab = 'settings');
              case 'workerType':
                setState(() => _currentScreen = 'workerType');
              case 'bookings':
                setState(() => _activeTab = 'bookings');
              case 'chat':
                setState(() => _activeTab = 'chat');
              case 'notifications':
                setState(() => _currentScreen = 'notifications');
            }
          },
        ),
      ),
    );
  }
}

// ============================================================
// HOME SCREEN
// ============================================================
class HomeScreen extends StatefulWidget {
  final AppTheme theme;
  final String language;
  final AppTranslations t;
  final String activeTab;
  final List<AppAddress> addresses;
  final int selectedAddressIndex;
  final void Function(List<AppAddress>) onUpdateAddresses;
  final void Function(int) onSetSelectedAddressIndex;
  final void Function(String) onSelectCategory;
  final VoidCallback onShowCategories;
  final VoidCallback onBookNow;
  final VoidCallback onNotificationPress;
  final void Function(String) onSetActiveTab;
  final VoidCallback onGoToChat;
  final VoidCallback onGoToSettings;
  final void Function(String) onNavigateSearch;

  const HomeScreen({
    super.key,
    required this.theme,
    required this.language,
    required this.t,
    required this.activeTab,
    required this.addresses,
    required this.selectedAddressIndex,
    required this.onUpdateAddresses,
    required this.onSetSelectedAddressIndex,
    required this.onSelectCategory,
    required this.onShowCategories,
    required this.onBookNow,
    required this.onNotificationPress,
    required this.onSetActiveTab,
    required this.onGoToChat,
    required this.onGoToSettings,
    required this.onNavigateSearch,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _searchCtrl = TextEditingController();
  final _searchFocus = FocusNode();
  String _searchQuery = '';
  bool _searchFocused = false;

  @override
  void initState() {
    super.initState();
    _searchFocus.addListener(
      () => setState(() => _searchFocused = _searchFocus.hasFocus),
    );
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    _searchFocus.dispose();
    super.dispose();
  }

  String get _addressDisplayText {
    if (widget.addresses.isEmpty ||
        widget.selectedAddressIndex >= widget.addresses.length) {
      return '';
    }
    final a = widget.addresses[widget.selectedAddressIndex];
    return a.label != null ? '${a.label} • ${a.address}' : a.address;
  }

  List<Map<String, String>> get _searchResults {
    if (_searchQuery.trim().isEmpty) return [];
    final q = _searchQuery.toLowerCase();
    const categories = [
      'Plumber',
      'Electrician',
      'Mason',
      'Carpenter',
      'Painter',
      'Gardener',
      'Cleaner',
      'AC Technician',
      'Mechanic',
      'Welder',
      'Tiler',
      'Roofer',
    ];
    final lang = widget.language;

    final catMatches = categories
        .where((c) => c.toLowerCase().contains(q))
        .map((c) => {'kind': 'category', 'id': 'cat-$c', 'name': c})
        .toList();

    final navItems = [
      {
        'id': 'nav-workerType',
        'label': lang == 'en'
            ? 'Worker Types'
            : lang == 'si'
            ? 'සේවක වර්ග'
            : 'பணியாளர் வகைகள்',
        'action': 'workerType',
      },
      {'id': 'nav-bookings', 'label': 'Bookings', 'action': 'bookings'},
      {
        'id': 'nav-chat',
        'label': lang == 'en'
            ? 'Chat'
            : lang == 'si'
            ? 'සංවාද'
            : 'அரட்டை',
        'action': 'chat',
      },
      {
        'id': 'nav-notifications',
        'label': lang == 'en'
            ? 'Notifications'
            : lang == 'si'
            ? 'දැනුම්දීම්'
            : 'அறிவிப்புகள்',
        'action': 'notifications',
      },
    ];

    final navMatches = navItems
        .where((n) => n['label']!.toLowerCase().contains(q))
        .map(
          (n) => {
            'kind': 'nav',
            'id': n['id']!,
            'name': n['label']!,
            'action': n['action']!,
          },
        )
        .toList();

    return [...catMatches, ...navMatches].take(6).toList();
  }

  void _openLocationModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      backgroundColor: widget.theme.cardBackground,
      builder: (ctx) => _LocationModalSheet(
        theme: widget.theme,
        language: widget.language,
        t: widget.t,
        addresses: widget.addresses,
        selectedIndex: widget.selectedAddressIndex,
        onSelectIndex: (i) {
          widget.onSetSelectedAddressIndex(i);
          Navigator.pop(ctx);
        },
        onUseCurrentLocation: () {
          final a = AppAddress(
            id: DateTime.now().millisecondsSinceEpoch,
            label: 'Current location',
            address: 'Current Location',
            latitude: 6.927079,
            longitude: 79.861244,
          );
          final newList = [
            a,
            ...widget.addresses.where((x) => x.address != a.address),
          ];
          widget.onUpdateAddresses(newList);
          widget.onSetSelectedAddressIndex(0);
          Navigator.pop(ctx);
        },
        onUpdateAddresses: widget.onUpdateAddresses,
        onOpenEditAddress: (idx, isNew) {
          Navigator.pop(ctx);
          _openEditAddressDialog(editIndex: isNew ? null : idx);
        },
        onOpenActions: (idx) {
          Navigator.pop(ctx);
          _openAddressActionsDialog(idx);
        },
      ),
    );
  }

  void _openEditAddressDialog({int? editIndex}) {
    final isNew = editIndex == null;
    final initial = isNew ? null : widget.addresses[editIndex];
    final labelCtrl = TextEditingController(text: initial?.label ?? '');
    final addrCtrl = TextEditingController(text: initial?.address ?? '');
    final lang = widget.language;
    final t = widget.t;
    final theme = widget.theme;

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDialogState) => AlertDialog(
          backgroundColor: theme.cardBackground,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          title: Text(
            '${t.edit} ${lang == 'en'
                ? 'Address'
                : lang == 'si'
                ? 'ලිපිනය'
                : 'முகவரி'}',
            style: TextStyle(
              color: theme.textPrimary,
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: labelCtrl,
                decoration: InputDecoration(
                  hintText: lang == 'en'
                      ? 'Label (Home, Work)...'
                      : lang == 'si'
                      ? 'ලේබලය (ගෘහ, සේවා)...'
                      : 'லேபல் (வீடு, வேலை)...',
                  hintStyle: TextStyle(color: theme.inputPlaceholder),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  isDense: true,
                  filled: true,
                  fillColor: theme.inputBackground,
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: addrCtrl,
                decoration: InputDecoration(
                  hintText: lang == 'en'
                      ? 'Enter address'
                      : lang == 'si'
                      ? 'ලිපිනය ඇතුළත් කරන්න'
                      : 'முகவரியை உள்ளிடவும்',
                  hintStyle: TextStyle(color: theme.inputPlaceholder),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  isDense: true,
                  filled: true,
                  fillColor: theme.inputBackground,
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: Text(
                t.cancel,
                style: TextStyle(color: theme.textSecondary),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                final trimmed = addrCtrl.text.trim();
                if (trimmed.isEmpty) {
                  Navigator.pop(ctx);
                  return;
                }
                final lbl = labelCtrl.text.trim();
                if (isNew) {
                  final newAddr = AppAddress(
                    id: DateTime.now().millisecondsSinceEpoch,
                    label: lbl.isNotEmpty ? lbl : null,
                    address: trimmed,
                  );
                  final updated = [newAddr, ...widget.addresses];
                  updated.sort(
                    (a, b) => (b.pinned ? 1 : 0) - (a.pinned ? 1 : 0),
                  );
                  widget.onUpdateAddresses(updated);
                } else {
                  final updated = widget.addresses.asMap().entries.map((e) {
                    if (e.key == editIndex) {
                      return e.value.copyWith(
                        address: trimmed,
                        label: lbl.isNotEmpty ? lbl : e.value.label,
                      );
                    }
                    return e.value;
                  }).toList();
                  widget.onUpdateAddresses(updated);
                }
                Navigator.pop(ctx);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF0B1533),
                foregroundColor: Colors.white,
              ),
              child: Text(t.save),
            ),
          ],
        ),
      ),
    );
  }

  void _openAddressActionsDialog(int index) {
    final lang = widget.language;
    final theme = widget.theme;

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: theme.cardBackground,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        title: Text(
          lang == 'en'
              ? 'Address Actions'
              : lang == 'si'
              ? 'ලිපිනය ක්‍රියා'
              : 'முகவரி நடவடிக்கைகள்',
          style: TextStyle(
            color: theme.textPrimary,
            fontWeight: FontWeight.w700,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _actionTile(
              lang == 'en'
                  ? 'Edit'
                  : lang == 'si'
                  ? 'සංස්කරණය'
                  : 'திருத்து',
              Icons.edit_outlined,
              Colors.blueGrey,
              () {
                Navigator.pop(ctx);
                _openEditAddressDialog(editIndex: index);
              },
            ),
            _actionTile(
              lang == 'en'
                  ? 'Delete'
                  : lang == 'si'
                  ? 'මකන්න'
                  : 'நீக்கு',
              Icons.delete_outline,
              Colors.red,
              () {
                final list = List<AppAddress>.from(widget.addresses);
                list.removeAt(index);
                widget.onUpdateAddresses(list);
                if (index == widget.selectedAddressIndex) {
                  widget.onSetSelectedAddressIndex(0);
                }
                Navigator.pop(ctx);
              },
            ),
            _actionTile(
              lang == 'en'
                  ? 'Set as Default'
                  : lang == 'si'
                  ? 'පෙරනිමි ලෙස සකසන්න'
                  : 'இயல்புநிலையாக அமைக்கவும்',
              Icons.home_outlined,
              const Color(0xFF0B1533),
              () {
                final updated = widget.addresses
                    .asMap()
                    .entries
                    .map((e) => e.value.copyWith(isDefault: e.key == index))
                    .toList();
                widget.onUpdateAddresses(updated);
                widget.onSetSelectedAddressIndex(index);
                Navigator.pop(ctx);
              },
            ),
            _actionTile(
              lang == 'en'
                  ? 'Pin / Unpin'
                  : lang == 'si'
                  ? 'පින් කරන්න/ඉවත් කරන්න'
                  : 'பின்/அன்-பின்',
              Icons.push_pin_outlined,
              Colors.orange,
              () {
                final copy = List<AppAddress>.from(widget.addresses);
                copy[index] = copy[index].copyWith(pinned: !copy[index].pinned);
                copy.sort((x, y) => (y.pinned ? 1 : 0) - (x.pinned ? 1 : 0));
                widget.onUpdateAddresses(copy);
                Navigator.pop(ctx);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _actionTile(
    String label,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 4),
        child: Row(
          children: [
            Icon(icon, color: color, size: 22),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  color: color,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = widget.theme;
    final lang = widget.language;
    final t = widget.t;

    return Consumer(
      builder: (context, ref, _) {
        final userAsync = ref.watch(dashboardUserProvider);
        final user = userAsync.valueOrNull;

        return Scaffold(
          backgroundColor: theme.background,
          body: SafeArea(
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildTopSection(theme, lang, t, user),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(16, 20, 16, 8),
                          child: Text(
                            lang == 'en'
                                ? 'What are you looking for today?'
                                : lang == 'si'
                                ? 'අද ඔබ සොයන්නේ කුමක්ද?'
                                : 'இன்று நீங்கள் என்ன தேடுகிறீர்கள்?',
                            style: TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 16,
                              color: theme.textPrimary,
                            ),
                          ),
                        ),
                        Divider(
                          color: theme.border,
                          height: 1,
                          thickness: 1,
                          indent: 16,
                          endIndent: 16,
                        ),
                        const SizedBox(height: 12),
                        _buildCategoryGrid(theme, lang),
                        Divider(
                          color: theme.border,
                          height: 1,
                          thickness: 1,
                          indent: 16,
                          endIndent: 16,
                        ),
                        _buildBookNowButton(lang),
                        const SizedBox(height: 32),
                      ],
                    ),
                  ),
                ),
                _buildBottomNav(theme, lang, t),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildTopSection(
    AppTheme theme,
    String lang,
    AppTranslations t,
    dynamic user,
  ) {
    final String userName = user?.name ?? 'User';
    final int unreadCount = user?.unreadNotifications ?? 0;

    return Container(
      margin: const EdgeInsets.fromLTRB(12, 12, 12, 0),
      padding: const EdgeInsets.fromLTRB(18, 18, 18, 20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF07122D), Color(0xFF0B1533), Color(0xFF173775)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0B1533).withValues(alpha: 0.28),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            right: -24,
            top: -24,
            child: Container(
              width: 110,
              height: 110,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: 0.07),
              ),
            ),
          ),
          Positioned(
            left: -16,
            bottom: -34,
            child: Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: 0.05),
              ),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${t.goodMorning} $userName!',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 0.1,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          lang == 'en'
                              ? 'Book trusted workers in minutes'
                              : lang == 'si'
                              ? 'විශ්වාසදායක සේවකයන් ඉක්මනින් වෙන්කරගන්න'
                              : 'நம்பகமான தொழிலாளர்களை நிமிடங்களில் முன்பதிவு செய்யவும்',
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.82),
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        IconButton(
                          onPressed: widget.onNotificationPress,
                          icon: const Icon(
                            Icons.notifications_outlined,
                            color: Colors.white,
                          ),
                        ),
                        if (unreadCount > 0)
                          Positioned(
                            right: 8,
                            top: 8,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 4,
                                vertical: 1,
                              ),
                              decoration: BoxDecoration(
                                color: const Color(0xFFEF4444),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              constraints: const BoxConstraints(
                                minWidth: 16,
                                minHeight: 16,
                              ),
                              child: Text(
                                unreadCount > 9 ? '9+' : '$unreadCount',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 10,
                                  fontWeight: FontWeight.w700,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              GestureDetector(
                onTap: _openLocationModal,
                child: Row(
                  children: [
                    const Icon(
                      Icons.location_pin,
                      size: 14,
                      color: Colors.white,
                    ),
                    const SizedBox(width: 4),
                    Flexible(
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              _addressDisplayText.isEmpty
                                  ? (lang == 'en'
                                        ? 'Select delivery location'
                                        : lang == 'si'
                                        ? 'ස්ථානය තෝරන්න'
                                        : 'இடத்தைத் தேர்ந்தெடுக்கவும்')
                                  : _addressDisplayText,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 13,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(width: 4),
                          const Icon(
                            Icons.keyboard_arrow_down,
                            color: Colors.white,
                            size: 16,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 14),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.16),
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 10,
                ),
                child: Row(
                  children: [
                    const Icon(Icons.search, size: 18, color: Colors.white),
                    const SizedBox(width: 10),
                    Expanded(
                      child: TextField(
                        controller: _searchCtrl,
                        focusNode: _searchFocus,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                        ),
                        decoration: InputDecoration(
                          hintText: t.searchPlaceholder,
                          hintStyle: TextStyle(
                            color: Colors.white.withValues(alpha: 0.65),
                            fontSize: 14,
                          ),
                          border: InputBorder.none,
                          isDense: true,
                          contentPadding: EdgeInsets.zero,
                        ),
                        onChanged: (v) => setState(() => _searchQuery = v),
                      ),
                    ),
                    if (_searchQuery.isNotEmpty)
                      GestureDetector(
                        onTap: () {
                          _searchCtrl.clear();
                          setState(() => _searchQuery = '');
                        },
                        child: const Icon(
                          Icons.cancel,
                          size: 18,
                          color: Colors.white,
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 14),
              SizedBox(
                height: 34,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    _buildHeaderChip(
                      icon: Icons.room_service_outlined,
                      label: lang == 'en'
                          ? '12+ services'
                          : lang == 'si'
                          ? 'සේවා 12+'
                          : '12+ சேவைகள்',
                    ),
                    const SizedBox(width: 8),
                    _buildHeaderChip(
                      icon: Icons.location_on_outlined,
                      label: lang == 'en'
                          ? '${widget.addresses.length} saved places'
                          : lang == 'si'
                          ? 'ස්ථාන ${widget.addresses.length}'
                          : '${widget.addresses.length} சேமித்த இடங்கள்',
                    ),
                    const SizedBox(width: 8),
                    _buildHeaderChip(
                      icon: Icons.flash_on_outlined,
                      label: lang == 'en'
                          ? 'Fast response'
                          : lang == 'si'
                          ? 'වේගවත් ප්‍රතිචාර'
                          : 'வேகமான பதில்',
                    ),
                  ],
                ),
              ),
              if (_searchFocused && _searchQuery.trim().isNotEmpty)
                _buildSearchSuggestions(theme, lang),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderChip({required IconData icon, required String label}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.13),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: Colors.white.withValues(alpha: 0.18)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: Colors.white),
          const SizedBox(width: 6),
          Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchSuggestions(AppTheme theme, String lang) {
    final results = _searchResults;
    return Container(
      margin: const EdgeInsets.only(top: 8),
      decoration: BoxDecoration(
        color: theme.cardBackground,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: theme.border),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 8, offset: Offset(0, 4)),
        ],
      ),
      child: results.isEmpty
          ? Padding(
              padding: const EdgeInsets.symmetric(vertical: 32),
              child: Column(
                children: [
                  Icon(Icons.search, size: 32, color: theme.textSecondary),
                  const SizedBox(height: 8),
                  Text(
                    lang == 'en'
                        ? 'No results'
                        : lang == 'si'
                        ? 'ලබාගත නොහැක'
                        : 'முடிவுகள் இல்லை',
                    style: TextStyle(color: theme.textSecondary, fontSize: 14),
                  ),
                ],
              ),
            )
          : Column(
              children: results.map((item) {
                final isCategory = item['kind'] == 'category';
                return InkWell(
                  onTap: () {
                    setState(() {
                      _searchFocused = false;
                      _searchQuery = '';
                      _searchCtrl.clear();
                    });
                    _searchFocus.unfocus();
                    if (isCategory) {
                      widget.onSelectCategory(item['name']!);
                    } else {
                      widget.onNavigateSearch(item['action']!);
                    }
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      border: Border(bottom: BorderSide(color: theme.divider)),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 36,
                          height: 36,
                          decoration: const BoxDecoration(
                            color: Color(0xFFF5F5F5),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            isCategory ? Icons.apps : Icons.arrow_forward,
                            size: 20,
                            color: const Color(0xFF666666),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                isCategory
                                    ? getCategoryTranslation(
                                        item['name']!,
                                        lang,
                                      )
                                    : item['name']!,
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: theme.textPrimary,
                                ),
                              ),
                              Text(
                                isCategory
                                    ? (lang == 'en'
                                          ? 'Category'
                                          : lang == 'si'
                                          ? 'වර්ගය'
                                          : 'வகை')
                                    : (lang == 'en'
                                          ? 'Go to'
                                          : lang == 'si'
                                          ? 'ට යන්න'
                                          : 'போதை'),
                                style: TextStyle(
                                  fontSize: 12,
                                  color: theme.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
    );
  }

  Widget _buildCategoryGrid(AppTheme theme, String lang) {
    final categories = [
      {'id': 'plumber', 'name': 'Plumber', 'icon': 'plumber'},
      {'id': 'electrician', 'name': 'Electrician', 'icon': 'electrician'},
      {'id': 'mason', 'name': 'Mason', 'icon': 'mason'},
      {'id': 'carpenter', 'name': 'Carpenter', 'icon': 'carpenter'},
      {'id': 'painter', 'name': 'Painter', 'icon': 'painter'},
      {'id': 'gardener', 'name': 'Gardener', 'icon': 'gardener'},
      {'id': 'cleaner', 'name': 'Cleaner', 'icon': 'cleaner'},
      {'id': 'more', 'name': 'More', 'icon': 'more'},
    ];

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final crossAxisCount = constraints.maxWidth >= 900 ? 5 : 4;
          return GridView.count(
            crossAxisCount: crossAxisCount,
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            childAspectRatio: 0.75,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            children: categories.map((item) {
              if (item['id'] == 'more') {
                return CategoryCircle(
                  label: lang == 'en'
                      ? 'More'
                      : lang == 'si'
                      ? 'තවත්'
                      : 'மேலும்',
                  isMore: true,
                  theme: theme,
                  onPress: widget.onShowCategories,
                );
              }

              return CategoryCircle(
                label: getCategoryTranslation(item['name']!, lang),
                icon: item['icon'],
                theme: theme,
                onPress: () => widget.onSelectCategory(item['id']!),
              );
            }).toList(),
          );
        },
      ),
    );
  }

  Widget _buildBookNowButton(String lang) {
    return GestureDetector(
      onTap: widget.onBookNow,
      child: Container(
        margin: const EdgeInsets.fromLTRB(16, 80, 16, 0),
        height: 150,
        decoration: BoxDecoration(
          color: const Color(0xFF0B1533),
          borderRadius: BorderRadius.circular(16),
          boxShadow: const [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 8,
              offset: Offset(0, 4),
            ),
          ],
        ),
        padding: const EdgeInsets.fromLTRB(25, 50, 25, 25),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    lang == 'en'
                        ? 'Need a Worker Now?'
                        : lang == 'si'
                        ? 'දැන් සේවකයෙකු අවශ්‍යද?'
                        : 'இப்போது பணியாளர் தேவையா?',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    lang == 'en'
                        ? 'Get instant booking for your service'
                        : lang == 'si'
                        ? 'ඔබේ සේවාව සඳහා ක්ෂණික වෙන්කිරීමක්'
                        : 'உங்கள் சேவைக்கு உடனடி முன்பதிவு',
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.white.withAlpha(204),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: Colors.white.withAlpha(38),
                borderRadius: BorderRadius.circular(28),
              ),
              child: const Icon(
                Icons.calendar_today,
                size: 28,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomNav(AppTheme theme, String lang, AppTranslations t) {
    final selectedIndex = switch (widget.activeTab) {
      'home' => 0,
      'bookings' => 1,
      'chat' => 2,
      'settings' => 3,
      _ => 0,
    };

    return NavigationBar(
      selectedIndex: selectedIndex,
      onDestinationSelected: (index) {
        if (index == 0) {
          widget.onSetActiveTab('home');
        } else if (index == 1) {
          widget.onSetActiveTab('bookings');
        } else if (index == 2) {
          widget.onGoToChat();
        } else if (index == 3) {
          widget.onGoToSettings();
        }
      },
      destinations: [
        NavigationDestination(
          icon: const Icon(Icons.home_outlined),
          selectedIcon: const Icon(Icons.home),
          label: t.homeTab,
        ),
        NavigationDestination(
          icon: const Icon(Icons.calendar_today_outlined),
          selectedIcon: const Icon(Icons.calendar_today),
          label: t.bookingsTab,
        ),
        NavigationDestination(
          icon: const Icon(Icons.chat_bubble_outline),
          selectedIcon: const Icon(Icons.chat_bubble),
          label: lang == 'en'
              ? 'Chat'
              : lang == 'si'
              ? 'සංවාද'
              : 'அரட்டை',
        ),
        NavigationDestination(
          icon: const Icon(Icons.settings_outlined),
          selectedIcon: const Icon(Icons.settings),
          label: lang == 'en'
              ? 'Settings'
              : lang == 'si'
              ? 'සැකසීම්'
              : 'அமைப்புகள்',
        ),
      ],
    );
  }
}

// ============================================================
// LOCATION MODAL SHEET
// ============================================================
class _LocationModalSheet extends StatefulWidget {
  final AppTheme theme;
  final String language;
  final AppTranslations t;
  final List<AppAddress> addresses;
  final int selectedIndex;
  final void Function(int) onSelectIndex;
  final VoidCallback onUseCurrentLocation;
  final void Function(List<AppAddress>) onUpdateAddresses;
  final void Function(int?, bool) onOpenEditAddress;
  final void Function(int) onOpenActions;

  const _LocationModalSheet({
    required this.theme,
    required this.language,
    required this.t,
    required this.addresses,
    required this.selectedIndex,
    required this.onSelectIndex,
    required this.onUseCurrentLocation,
    required this.onUpdateAddresses,
    required this.onOpenEditAddress,
    required this.onOpenActions,
  });

  @override
  State<_LocationModalSheet> createState() => _LocationModalSheetState();
}

class _LocationModalSheetState extends State<_LocationModalSheet> {
  final _searchCtrl = TextEditingController();

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = widget.theme;
    final lang = widget.language;
    final t = widget.t;
    final q = _searchCtrl.text.trim().toLowerCase();
    final filtered = widget.addresses.where((a) {
      if (q.isEmpty) return true;
      return a.address.toLowerCase().contains(q) ||
          (a.label ?? '').toLowerCase().contains(q);
    }).toList();

    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Container(
        decoration: BoxDecoration(
          color: theme.cardBackground,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
        ),
        padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              lang == 'en'
                  ? 'Select Address'
                  : lang == 'si'
                  ? 'ලිපිනය තෝරන්න'
                  : 'முகவரியைத் தேர்ந்தெடுக்கவும்',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: theme.textPrimary,
              ),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchCtrl,
                    onChanged: (_) => setState(() {}),
                    decoration: InputDecoration(
                      hintText: lang == 'en'
                          ? 'Search saved addresses'
                          : lang == 'si'
                          ? 'ලියන ලිපින හි සොයන්න'
                          : 'சேமிக்கப்பட்ட முகவரிகளை தேடவும்',
                      hintStyle: TextStyle(color: theme.inputPlaceholder),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      isDense: true,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      filled: true,
                      fillColor: theme.inputBackground,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () => widget.onOpenEditAddress(null, true),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0B1533),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.all(10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    minimumSize: Size.zero,
                  ),
                  child: const Icon(Icons.add, size: 18),
                ),
              ],
            ),
            const SizedBox(height: 8),
            SizedBox(
              height: 200,
              child: ListView.builder(
                itemCount: filtered.length,
                itemBuilder: (_, i) {
                  final addr = filtered[i];
                  final idx = widget.addresses.indexWhere(
                    (a) => a.id == addr.id,
                  );
                  final selected = idx == widget.selectedIndex;
                  return GestureDetector(
                    onTap: () => widget.onSelectIndex(idx),
                    onLongPress: () => widget.onOpenActions(idx),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      decoration: BoxDecoration(
                        color: selected ? theme.divider : null,
                        border: Border(bottom: BorderSide(color: theme.border)),
                      ),
                      child: Row(
                        children: [
                          SizedBox(
                            width: 28,
                            child: addr.isDefault
                                ? Icon(
                                    Icons.home,
                                    size: 18,
                                    color: theme.primary,
                                  )
                                : addr.pinned
                                ? Icon(
                                    Icons.star,
                                    size: 18,
                                    color: theme.primary,
                                  )
                                : null,
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  addr.label != null
                                      ? '${addr.label} • ${addr.address}'
                                      : addr.address,
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: theme.textPrimary,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                if (addr.latitude != null &&
                                    addr.longitude != null)
                                  Text(
                                    'Lat: ${addr.latitude!.toStringAsFixed(4)}, Lon: ${addr.longitude!.toStringAsFixed(4)}',
                                    style: TextStyle(
                                      color: theme.textSecondary,
                                      fontSize: 11,
                                    ),
                                  ),
                              ],
                            ),
                          ),
                          if (selected)
                            Icon(
                              Icons.check_circle,
                              size: 20,
                              color: theme.primary,
                            ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: widget.onUseCurrentLocation,
                icon: const Icon(Icons.my_location, size: 18),
                label: Text(t.useCurrentLocation),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0B1533),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () =>
                    widget.onOpenEditAddress(widget.selectedIndex, false),
                icon: const Icon(Icons.edit_outlined, size: 18),
                label: Text(
                  lang == 'en'
                      ? 'Edit selected address'
                      : lang == 'si'
                      ? 'තෝරාගත් ලිපිනය සංස්කරණය කරන්න'
                      : 'தேர்ந்தெடுக்கப்பட்ட முகவரியைத் திருத்தவும்',
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2A2A2A),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ============================================================
// CATEGORY CIRCLE
// ============================================================
class CategoryCircle extends StatelessWidget {
  final String label;
  final bool isMore;
  final String? icon;
  final VoidCallback? onPress;
  final AppTheme theme;

  const CategoryCircle({
    super.key,
    required this.label,
    this.isMore = false,
    this.icon,
    this.onPress,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPress,
      child: SizedBox(
        width: 72,
        child: Column(
          children: [
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: theme.cardBackground,
                shape: BoxShape.circle,
              ),
              child: isMore
                  ? Icon(Icons.apps, size: 26, color: theme.textSecondary)
                  : Icon(_iconData(icon), size: 26, color: _iconColor(icon)),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: theme.textPrimary,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  IconData _iconData(String? name) {
    switch (name) {
      case 'plumber':
        return Icons.water;
      case 'electrician':
        return Icons.flash_on;
      case 'mason':
        return Icons.hardware;
      case 'carpenter':
        return Icons.construction;
      case 'painter':
        return Icons.brush;
      case 'gardener':
        return Icons.eco;
      case 'cleaner':
        return Icons.auto_awesome;
      default:
        return Icons.circle_outlined;
    }
  }

  Color _iconColor(String? name) {
    switch (name) {
      case 'plumber':
        return const Color(0xFF3498DB);
      case 'electrician':
        return const Color(0xFFF39C12);
      case 'mason':
        return const Color(0xFFE74C3C);
      case 'carpenter':
        return const Color(0xFF8B4513);
      case 'painter':
        return const Color(0xFF9B59B6);
      case 'gardener':
        return const Color(0xFF27AE60);
      case 'cleaner':
        return const Color(0xFF1ABC9C);
      default:
        return const Color(0xFF666666);
    }
  }
}

// ============================================================
// CHAT SCREEN
// ============================================================
class ChatScreen extends StatelessWidget {
  final AppTheme theme;
  final String language;
  final VoidCallback onBack;

  const ChatScreen({
    super.key,
    required this.theme,
    required this.language,
    required this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: theme.background,
      appBar: AppBar(
        backgroundColor: const Color(0xFF0B1533),
        foregroundColor: Colors.white,
        title: Text(
          language == 'en'
              ? 'Chat'
              : language == 'si'
              ? 'සංවාද'
              : 'அரட்டை',
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: onBack,
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.chat_bubble_outline,
              size: 64,
              color: theme.textSecondary,
            ),
            const SizedBox(height: 16),
            Text(
              language == 'en'
                  ? 'No chats yet'
                  : language == 'si'
                  ? 'තවම සංවාද නොමැත'
                  : 'இதுவரை அரட்டைகள் இல்லை',
              style: TextStyle(fontSize: 18, color: theme.textSecondary),
            ),
          ],
        ),
      ),
    );
  }
}

// ============================================================
// FIND WORKER SCREEN
// ============================================================
class FindWorkerScreen extends StatelessWidget {
  final AppTheme theme;
  final String language;
  final String workerType;
  final String userAddress;
  final VoidCallback onBack;

  const FindWorkerScreen({
    super.key,
    required this.theme,
    required this.language,
    required this.workerType,
    required this.userAddress,
    required this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: theme.background,
      appBar: AppBar(
        backgroundColor: const Color(0xFF0B1533),
        foregroundColor: Colors.white,
        title: Text(
          language == 'en'
              ? 'Find Worker'
              : language == 'si'
              ? 'සේවකයා සොයන්න'
              : 'பணியாளரைத் தேடவும்',
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: onBack,
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.search, size: 64, color: theme.textSecondary),
            const SizedBox(height: 16),
            Text(
              workerType,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: theme.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              userAddress,
              style: TextStyle(color: theme.textSecondary, fontSize: 14),
            ),
            const SizedBox(height: 24),
            Text(
              language == 'en'
                  ? 'Finding available workers...'
                  : language == 'si'
                  ? 'ලබා ගත හැකි සේවකයන් සොයමින්...'
                  : 'கிடைக்கும் தொழிலாளர்களைத் தேடுகிறது...',
              style: TextStyle(color: theme.textSecondary),
            ),
          ],
        ),
      ),
    );
  }
}
