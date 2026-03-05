import 'package:flutter/material.dart';
import 'settings_screen.dart' as separate;
import 'worker_type_screen.dart' as worker_ui;

void main() {
  runApp(const SevixApp());
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

class _AppRootState extends State<AppRoot> {
  bool _isLoggedIn = false;
  bool _showSignup = false;
  String _selectedLanguage = '';
  String _currentTheme = 'light';

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
  bool _promoVisible = true;
  final List<String> _promotions = const [
    'First job - 10% off',
    'Free booking today',
  ];

  AppTheme get _theme =>
      _currentTheme == 'dark' ? AppTheme.dark : AppTheme.light;
  AppTranslations get _t => AppTranslations.forLang(_selectedLanguage);

  void _selectCategory(String categoryName) {
    final available = kWorkers
        .where((w) => w.category == categoryName && w.available)
        .toList();
    if (available.isNotEmpty) {
      setState(() {
        _selectedWorker = available.first;
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

  @override
  Widget build(BuildContext context) {
    if (_selectedLanguage.isEmpty) {
      return LanguageSelectScreen(
        onSelect: (lang) => setState(() => _selectedLanguage = lang),
      );
    }

    if (!_isLoggedIn) {
      if (_showSignup) {
        return SignupScreen(
          theme: _theme,
          selectedLanguage: _selectedLanguage,
          onSignUpSuccess: () => setState(() {
            _isLoggedIn = true;
            _showSignup = false;
          }),
          onNavigateToLogin: () => setState(() => _showSignup = false),
        );
      }
      return LoginScreen(
        theme: _theme,
        selectedLanguage: _selectedLanguage,
        onLoginSuccess: () => setState(() => _isLoggedIn = true),
        onNavigateToSignup: () => setState(() => _showSignup = true),
      );
    }

    if (_activeTab == 'bookings') {
      return BookingsScreen(
        theme: _theme,
        language: _selectedLanguage,
        onBack: () => setState(() => _activeTab = 'home'),
      );
    }

    if (_activeTab == 'favorites') {
      return FavoriteScreen(
        theme: _theme,
        language: _selectedLanguage,
        favorites: _favorites,
        onBack: () => setState(() => _activeTab = 'home'),
        onRemoveFavorite: (id) => setState(
          () => _favorites = _favorites.where((f) => f.id != id).toList(),
        ),
        onSelectFavorite: (cat) {
          setState(() => _activeTab = 'home');
          _selectCategory(cat);
        },
      );
    }

    if (_activeTab == 'settings') {
      return separate.SettingsScreen(
        language: _selectedLanguage,
        currentTheme: _currentTheme,
        onBack: () => setState(() => _activeTab = 'home'),
        onLanguageChange: (lang) => setState(() => _selectedLanguage = lang),
        onThemeChange: (th) => setState(() => _currentTheme = th),
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
      );
    }

    if (_currentScreen == 'notifications') {
      return NotificationScreen(
        theme: _theme,
        language: _selectedLanguage,
        onBack: () => setState(() => _currentScreen = 'home'),
      );
    }

    if (_currentScreen == 'findWorker') {
      return FindWorkerScreen(
        theme: _theme,
        language: _selectedLanguage,
        workerType: _bookingContext['workerType'] ?? '',
        userAddress: _bookingContext['address'] ?? '',
        onBack: () => setState(() => _currentScreen = 'home'),
      );
    }

    if (_currentScreen == 'booking' && _selectedWorker != null) {
      return BookingScreen(
        theme: _theme,
        language: _selectedLanguage,
        worker: _selectedWorker!,
        onBack: () => setState(() {
          _currentScreen = 'home';
          _selectedWorker = null;
        }),
        onConfirmBooking: () {
          final name = _selectedWorker?.name ?? '';
          setState(() {
            _currentScreen = 'home';
            _selectedWorker = null;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Booking confirmed for $name!')),
          );
        },
        onFindWorker: (wType, addr) => setState(() {
          _bookingContext = {'workerType': wType, 'address': addr};
          _currentScreen = 'findWorker';
        }),
      );
    }

    if (_currentScreen == 'workerType') {
      return worker_ui.WorkerTypeScreen(
        language: _selectedLanguage,
        currentTheme: _currentTheme,
        favoriteCategories: _favorites.map((f) => f.category).toList(),
        onBack: () => setState(() => _currentScreen = 'home'),
        onSelectCategory: _selectCategory,
        onToggleFavorite: (cat) => setState(() {
          if (_favorites.any((f) => f.category == cat)) {
            _favorites = _favorites.where((f) => f.category != cat).toList();
          } else {
            _favorites = [
              ..._favorites,
              Favorite(id: cat.hashCode, name: cat, category: cat),
            ];
          }
        }),
        getCategoryCount: (category) =>
            kWorkers.where((w) => w.available && w.category == category).length,
      );
    }

    // Main home screen
    return HomeScreen(
      theme: _theme,
      language: _selectedLanguage,
      t: _t,
      activeTab: _activeTab,
      addresses: _addresses,
      selectedAddressIndex: _selectedAddressIndex,
      promotions: _promotions,
      promoVisible: _promoVisible,
      onUpdateAddresses: (list) => setState(() => _addresses = list),
      onSetSelectedAddressIndex: (i) =>
          setState(() => _selectedAddressIndex = i),
      onSelectCategory: _selectCategory,
      onShowCategories: () => setState(() => _currentScreen = 'workerType'),
      onBookNow: _bookNow,
      onNotificationPress: () =>
          setState(() => _currentScreen = 'notifications'),
      onSetActiveTab: (tab) => setState(() => _activeTab = tab),
      onGoToFavorites: () => setState(() => _activeTab = 'favorites'),
      onGoToSettings: () => setState(() => _activeTab = 'settings'),
      onSetPromoVisible: (v) => setState(() => _promoVisible = v),
      onNavigateSearch: (action) {
        switch (action) {
          case 'settings':
            setState(() => _activeTab = 'settings');
          case 'workerType':
            setState(() => _currentScreen = 'workerType');
          case 'bookings':
            setState(() => _activeTab = 'bookings');
          case 'favorites':
            setState(() => _activeTab = 'favorites');
          case 'notifications':
            setState(() => _currentScreen = 'notifications');
        }
      },
    );
  }
}

// ============================================================
// LANGUAGE SELECT SCREEN
// ============================================================
class LanguageSelectScreen extends StatelessWidget {
  final void Function(String) onSelect;
  const LanguageSelectScreen({super.key, required this.onSelect});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0B1533),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.engineering, size: 80, color: Colors.white),
              const SizedBox(height: 24),
              const Text(
                'Sevix',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Service at your doorstep',
                style: TextStyle(color: Colors.white54, fontSize: 14),
              ),
              const SizedBox(height: 48),
              const Text(
                'Select Language / භාෂාව / மொழி',
                style: TextStyle(color: Colors.white70, fontSize: 14),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              _langBtn('English', () => onSelect('en')),
              const SizedBox(height: 14),
              _langBtn('සිංහල', () => onSelect('si')),
              const SizedBox(height: 14),
              _langBtn('தமிழ்', () => onSelect('ta')),
            ],
          ),
        ),
      ),
    );
  }

  Widget _langBtn(String label, VoidCallback onTap) {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton(
        onPressed: onTap,
        style: OutlinedButton.styleFrom(
          foregroundColor: Colors.white,
          side: const BorderSide(color: Colors.white38, width: 1.5),
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Text(
          label,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}

// ============================================================
// LOGIN SCREEN
// ============================================================
class LoginScreen extends StatefulWidget {
  final AppTheme theme;
  final String selectedLanguage;
  final VoidCallback onLoginSuccess;
  final VoidCallback onNavigateToSignup;

  const LoginScreen({
    super.key,
    required this.theme,
    required this.selectedLanguage,
    required this.onLoginSuccess,
    required this.onNavigateToSignup,
  });

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  bool _obscure = true;

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final t = widget.theme;
    final lang = widget.selectedLanguage;
    return Scaffold(
      backgroundColor: t.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 48),
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  color: const Color(0xFF0B1533),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Icon(
                  Icons.engineering,
                  color: Colors.white,
                  size: 36,
                ),
              ),
              const SizedBox(height: 24),
              Text(
                lang == 'si'
                    ? 'නැවත සාදරයෙන් පිළිගනිමු'
                    : lang == 'ta'
                    ? 'மீண்டும் வரவேற்கிறோம்'
                    : 'Welcome Back',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: t.textPrimary,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                lang == 'si'
                    ? 'ඉදිරියට යන්න ලොගින් වන්න'
                    : lang == 'ta'
                    ? 'தொடர உள்நுழையவும்'
                    : 'Sign in to continue',
                style: TextStyle(fontSize: 16, color: t.textSecondary),
              ),
              const SizedBox(height: 40),
              TextField(
                controller: _emailCtrl,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  labelText: lang == 'si'
                      ? 'ඊමේල්'
                      : lang == 'ta'
                      ? 'மின்னஞ்சல்'
                      : 'Email',
                  prefixIcon: const Icon(Icons.email_outlined),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  filled: true,
                  fillColor: t.inputBackground,
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _passCtrl,
                obscureText: _obscure,
                decoration: InputDecoration(
                  labelText: lang == 'si'
                      ? 'මුරපදය'
                      : lang == 'ta'
                      ? 'கடவுச்சொல்'
                      : 'Password',
                  prefixIcon: const Icon(Icons.lock_outlined),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscure ? Icons.visibility_off : Icons.visibility,
                    ),
                    onPressed: () => setState(() => _obscure = !_obscure),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  filled: true,
                  fillColor: t.inputBackground,
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: widget.onLoginSuccess,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0B1533),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    lang == 'si'
                        ? 'ලොගින්'
                        : lang == 'ta'
                        ? 'உள்நுழை'
                        : 'Login',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Center(
                child: TextButton(
                  onPressed: widget.onNavigateToSignup,
                  child: Text(
                    lang == 'si'
                        ? 'ගිණුමක් නැද්ද? ලියාපදිංචි වන්න'
                        : lang == 'ta'
                        ? 'கணக்கு இல்லையா? பதிவு செய்யவும்'
                        : "Don't have an account? Sign Up",
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ============================================================
// SIGNUP SCREEN
// ============================================================
class SignupScreen extends StatefulWidget {
  final AppTheme theme;
  final String selectedLanguage;
  final VoidCallback onSignUpSuccess;
  final VoidCallback onNavigateToLogin;

  const SignupScreen({
    super.key,
    required this.theme,
    required this.selectedLanguage,
    required this.onSignUpSuccess,
    required this.onNavigateToLogin,
  });

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _passCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final t = widget.theme;
    final lang = widget.selectedLanguage;
    return Scaffold(
      backgroundColor: t.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 48),
              Text(
                lang == 'si'
                    ? 'ගිණුම සාදන්න'
                    : lang == 'ta'
                    ? 'கணக்கு உருவாக்கவும்'
                    : 'Create Account',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: t.textPrimary,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                lang == 'si'
                    ? 'ලියාපදිංචි වී ආරම්භ කරන්න'
                    : lang == 'ta'
                    ? 'தொடங்க பதிவு செய்யுங்கள்'
                    : 'Sign up to get started',
                style: TextStyle(fontSize: 16, color: t.textSecondary),
              ),
              const SizedBox(height: 40),
              TextField(
                controller: _nameCtrl,
                decoration: InputDecoration(
                  labelText: lang == 'si'
                      ? 'සම්පූර්ණ නම'
                      : lang == 'ta'
                      ? 'முழு பெயர்'
                      : 'Full Name',
                  prefixIcon: const Icon(Icons.person_outlined),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  filled: true,
                  fillColor: t.inputBackground,
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _emailCtrl,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  labelText: lang == 'si'
                      ? 'ඊමේල්'
                      : lang == 'ta'
                      ? 'மின்னஞ்சல்'
                      : 'Email',
                  prefixIcon: const Icon(Icons.email_outlined),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  filled: true,
                  fillColor: t.inputBackground,
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _passCtrl,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: lang == 'si'
                      ? 'මුරපදය'
                      : lang == 'ta'
                      ? 'கடவுச்சொல்'
                      : 'Password',
                  prefixIcon: const Icon(Icons.lock_outlined),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  filled: true,
                  fillColor: t.inputBackground,
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: widget.onSignUpSuccess,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0B1533),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    lang == 'si'
                        ? 'ලියාපදිංචි වන්න'
                        : lang == 'ta'
                        ? 'பதிவு செய்யுங்கள்'
                        : 'Sign Up',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Center(
                child: TextButton(
                  onPressed: widget.onNavigateToLogin,
                  child: Text(
                    lang == 'si'
                        ? 'දැනටමත් ගිණුමක් තිබේද? ලොගින් වන්න'
                        : lang == 'ta'
                        ? 'ஏற்கனவே கணக்கு உள்ளதா? உள்நுழையவும்'
                        : 'Already have an account? Login',
                  ),
                ),
              ),
            ],
          ),
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
  final List<String> promotions;
  final bool promoVisible;
  final void Function(List<AppAddress>) onUpdateAddresses;
  final void Function(int) onSetSelectedAddressIndex;
  final void Function(String) onSelectCategory;
  final VoidCallback onShowCategories;
  final VoidCallback onBookNow;
  final VoidCallback onNotificationPress;
  final void Function(String) onSetActiveTab;
  final VoidCallback onGoToFavorites;
  final VoidCallback onGoToSettings;
  final void Function(bool) onSetPromoVisible;
  final void Function(String) onNavigateSearch;

  const HomeScreen({
    super.key,
    required this.theme,
    required this.language,
    required this.t,
    required this.activeTab,
    required this.addresses,
    required this.selectedAddressIndex,
    required this.promotions,
    required this.promoVisible,
    required this.onUpdateAddresses,
    required this.onSetSelectedAddressIndex,
    required this.onSelectCategory,
    required this.onShowCategories,
    required this.onBookNow,
    required this.onNotificationPress,
    required this.onSetActiveTab,
    required this.onGoToFavorites,
    required this.onGoToSettings,
    required this.onSetPromoVisible,
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
        'id': 'nav-favorites',
        'label': lang == 'en'
            ? 'Favorites'
            : lang == 'si'
            ? 'ප්‍රියතම'
            : 'பிடித்தவை',
        'action': 'favorites',
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
                    _buildTopSection(theme, lang, t),
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
                    if (widget.promoVisible && widget.promotions.isNotEmpty)
                      _buildPromoBanner(theme, lang),
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
  }

  Widget _buildTopSection(AppTheme theme, String lang, AppTranslations t) {
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFF0B1533),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(3000),
          bottomRight: Radius.circular(6000),
        ),
      ),
      padding: const EdgeInsets.fromLTRB(22, 50, 22, 150),
      child: Column(
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
                      '${t.goodMorning} Jehan !',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 10),
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
                            child: Text(
                              '$_addressDisplayText...▼',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 13,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                onPressed: widget.onNotificationPress,
                icon: const Icon(
                  Icons.notifications_outlined,
                  size: 24,
                  color: Colors.white,
                ),
                padding: const EdgeInsets.all(18),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            decoration: BoxDecoration(
              color: Colors.white.withAlpha(51),
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            child: Row(
              children: [
                const Icon(Icons.search, size: 18, color: Colors.white),
                const SizedBox(width: 10),
                Expanded(
                  child: TextField(
                    controller: _searchCtrl,
                    focusNode: _searchFocus,
                    style: const TextStyle(color: Colors.white, fontSize: 14),
                    decoration: InputDecoration(
                      hintText: t.searchPlaceholder,
                      hintStyle: TextStyle(
                        color: Colors.white.withAlpha(153),
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
          if (_searchFocused && _searchQuery.trim().isNotEmpty)
            _buildSearchSuggestions(theme, lang),
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
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      child: Wrap(
        spacing: 12,
        runSpacing: 12,
        children: [
          CategoryCircle(
            label: getCategoryTranslation('Plumber', lang),
            icon: 'plumber',
            theme: theme,
            onPress: () => widget.onSelectCategory('Plumber'),
          ),
          CategoryCircle(
            label: getCategoryTranslation('Electrician', lang),
            icon: 'electrician',
            theme: theme,
            onPress: () => widget.onSelectCategory('Electrician'),
          ),
          CategoryCircle(
            label: getCategoryTranslation('Mason', lang),
            icon: 'mason',
            theme: theme,
            onPress: () => widget.onSelectCategory('Mason'),
          ),
          CategoryCircle(
            label: getCategoryTranslation('Carpenter', lang),
            icon: 'carpenter',
            theme: theme,
            onPress: () => widget.onSelectCategory('Carpenter'),
          ),
          CategoryCircle(
            label: getCategoryTranslation('Painter', lang),
            icon: 'painter',
            theme: theme,
            onPress: () => widget.onSelectCategory('Painter'),
          ),
          CategoryCircle(
            label: getCategoryTranslation('Gardener', lang),
            icon: 'gardener',
            theme: theme,
            onPress: () => widget.onSelectCategory('Gardener'),
          ),
          CategoryCircle(
            label: getCategoryTranslation('Cleaner', lang),
            icon: 'cleaner',
            theme: theme,
            onPress: () => widget.onSelectCategory('Cleaner'),
          ),
          CategoryCircle(
            label: lang == 'en'
                ? 'More'
                : lang == 'si'
                ? 'තවත්'
                : 'மேலும்',
            isMore: true,
            theme: theme,
            onPress: widget.onShowCategories,
          ),
        ],
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

  Widget _buildPromoBanner(AppTheme theme, String lang) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 14, 16, 0),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: theme.cardBackground,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: theme.primary),
      ),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () => ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text(widget.promotions[0]))),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '⭐ ${widget.promotions[0]}',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: theme.primary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    lang == 'en'
                        ? 'Tap for details'
                        : lang == 'si'
                        ? 'විස්තර සඳහා ස්පර්ශ කරන්න'
                        : 'விவரங்களுக்கு தொடர்பு கொள்ளவும்',
                    style: TextStyle(fontSize: 12, color: theme.textSecondary),
                  ),
                ],
              ),
            ),
          ),
          IconButton(
            onPressed: () => widget.onSetPromoVisible(false),
            icon: Icon(Icons.close, size: 18, color: theme.textSecondary),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNav(AppTheme theme, String lang, AppTranslations t) {
    return Container(
      decoration: BoxDecoration(
        color: theme.tabBarBackground,
        border: Border(top: BorderSide(color: theme.border)),
      ),
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _TabButton(
            icon: widget.activeTab == 'home' ? Icons.home : Icons.home_outlined,
            label: t.homeTab,
            active: widget.activeTab == 'home',
            theme: theme,
            onTap: () => widget.onSetActiveTab('home'),
          ),
          _TabButton(
            icon: widget.activeTab == 'bookings'
                ? Icons.calendar_today
                : Icons.calendar_today_outlined,
            label: t.bookingsTab,
            active: widget.activeTab == 'bookings',
            theme: theme,
            onTap: () => widget.onSetActiveTab('bookings'),
          ),
          _TabButton(
            icon: widget.activeTab == 'favorites'
                ? Icons.star
                : Icons.star_outline,
            label: lang == 'en'
                ? 'Favorites'
                : lang == 'si'
                ? 'ප්‍රියතම'
                : 'பிடித்தவை',
            active: widget.activeTab == 'favorites',
            theme: theme,
            onTap: widget.onGoToFavorites,
          ),
          _TabButton(
            icon: widget.activeTab == 'settings'
                ? Icons.settings
                : Icons.settings_outlined,
            label: lang == 'en'
                ? 'Settings'
                : lang == 'si'
                ? 'සැකසීම්'
                : 'அமைப்புகள்',
            active: widget.activeTab == 'settings',
            theme: theme,
            onTap: widget.onGoToSettings,
          ),
        ],
      ),
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
// TAB BUTTON
// ============================================================
class _TabButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool active;
  final AppTheme theme;
  final VoidCallback onTap;

  const _TabButton({
    required this.icon,
    required this.label,
    required this.active,
    required this.theme,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 24,
              color: active ? theme.tabBarActive : theme.tabBarInactive,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                fontWeight: active ? FontWeight.w600 : FontWeight.w500,
                color: active ? theme.tabBarActive : theme.tabBarInactive,
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
// BOOKINGS SCREEN
// ============================================================
class BookingsScreen extends StatelessWidget {
  final AppTheme theme;
  final String language;
  final VoidCallback onBack;

  const BookingsScreen({
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
        title: const Text('Bookings'),
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
              Icons.calendar_today_outlined,
              size: 64,
              color: theme.textSecondary,
            ),
            const SizedBox(height: 16),
            Text(
              language == 'si'
                  ? 'Bookings නැත'
                  : language == 'ta'
                  ? 'முன்பதிவுகள் இல்லை'
                  : 'No bookings yet',
              style: TextStyle(fontSize: 18, color: theme.textSecondary),
            ),
          ],
        ),
      ),
    );
  }
}

// ============================================================
// FAVORITE SCREEN
// ============================================================
class FavoriteScreen extends StatelessWidget {
  final AppTheme theme;
  final String language;
  final List<Favorite> favorites;
  final VoidCallback onBack;
  final void Function(int) onRemoveFavorite;
  final void Function(String) onSelectFavorite;

  const FavoriteScreen({
    super.key,
    required this.theme,
    required this.language,
    required this.favorites,
    required this.onBack,
    required this.onRemoveFavorite,
    required this.onSelectFavorite,
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
              ? 'Favorites'
              : language == 'si'
              ? 'ප්‍රියතම'
              : 'பிடித்தவை',
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: onBack,
        ),
      ),
      body: favorites.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.star_outline,
                    size: 64,
                    color: theme.textSecondary,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    language == 'en'
                        ? 'No favorites yet'
                        : language == 'si'
                        ? 'ප්‍රියතම නැත'
                        : 'பிடித்தவை இல்லை',
                    style: TextStyle(fontSize: 18, color: theme.textSecondary),
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: favorites.length,
              itemBuilder: (_, i) {
                final f = favorites[i];
                return Card(
                  color: theme.cardBackground,
                  child: ListTile(
                    leading: const Icon(Icons.star, color: Colors.amber),
                    title: Text(
                      f.name,
                      style: TextStyle(
                        color: theme.textPrimary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    subtitle: Text(
                      f.category,
                      style: TextStyle(color: theme.textSecondary),
                    ),
                    onTap: () => onSelectFavorite(f.category),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete_outline, color: Colors.red),
                      onPressed: () => onRemoveFavorite(f.id),
                    ),
                  ),
                );
              },
            ),
    );
  }
}

// ============================================================
// SETTINGS SCREEN
// ============================================================
class SettingsScreen extends StatelessWidget {
  final AppTheme theme;
  final String language;
  final String currentTheme;
  final VoidCallback onBack;
  final void Function(String) onLanguageChange;
  final void Function(String) onThemeChange;
  final VoidCallback onLogout;
  final VoidCallback onDeleteAccount;

  const SettingsScreen({
    super.key,
    required this.theme,
    required this.language,
    required this.currentTheme,
    required this.onBack,
    required this.onLanguageChange,
    required this.onThemeChange,
    required this.onLogout,
    required this.onDeleteAccount,
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
              ? 'Settings'
              : language == 'si'
              ? 'සැකසීම්'
              : 'அமைப்புகள்',
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: onBack,
        ),
      ),
      body: ListView(
        children: [
          ListTile(
            leading: const Icon(Icons.language),
            title: Text(
              language == 'en'
                  ? 'Language'
                  : language == 'si'
                  ? 'භාෂාව'
                  : 'மொழி',
              style: TextStyle(color: theme.textPrimary),
            ),
            subtitle: Text(
              language.toUpperCase(),
              style: TextStyle(color: theme.textSecondary),
            ),
            trailing: PopupMenuButton<String>(
              onSelected: onLanguageChange,
              itemBuilder: (_) => const [
                PopupMenuItem(value: 'en', child: Text('English')),
                PopupMenuItem(value: 'si', child: Text('සිංහල')),
                PopupMenuItem(value: 'ta', child: Text('தமிழ்')),
              ],
            ),
          ),
          Divider(color: theme.border),
          ListTile(
            leading: const Icon(Icons.dark_mode_outlined),
            title: Text(
              language == 'en'
                  ? 'Dark Mode'
                  : language == 'si'
                  ? 'අඳුරු ප්‍රකාරය'
                  : 'இருண்ட முறை',
              style: TextStyle(color: theme.textPrimary),
            ),
            trailing: Switch(
              value: currentTheme == 'dark',
              onChanged: (v) => onThemeChange(v ? 'dark' : 'light'),
              activeThumbColor: const Color(0xFF4A90E2),
            ),
          ),
          Divider(color: theme.border),
          const SizedBox(height: 24),
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.red),
            title: const Text(
              'Logout',
              style: TextStyle(color: Colors.red, fontWeight: FontWeight.w600),
            ),
            onTap: onLogout,
          ),
          ListTile(
            leading: const Icon(Icons.delete_forever, color: Colors.red),
            title: const Text(
              'Delete Account',
              style: TextStyle(color: Colors.red, fontWeight: FontWeight.w600),
            ),
            onTap: onDeleteAccount,
          ),
        ],
      ),
    );
  }
}

// ============================================================
// NOTIFICATION SCREEN
// ============================================================
class NotificationScreen extends StatelessWidget {
  final AppTheme theme;
  final String language;
  final VoidCallback onBack;

  const NotificationScreen({
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
              ? 'Notifications'
              : language == 'si'
              ? 'දැනුම්දීම්'
              : 'அறிவிப்புகள்',
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
              Icons.notifications_none,
              size: 64,
              color: theme.textSecondary,
            ),
            const SizedBox(height: 16),
            Text(
              language == 'en'
                  ? 'No notifications'
                  : language == 'si'
                  ? 'දැනුම්දීම් නැත'
                  : 'அறிவிப்புகள் இல்லை',
              style: TextStyle(fontSize: 18, color: theme.textSecondary),
            ),
          ],
        ),
      ),
    );
  }
}

// ============================================================
// WORKER TYPE SCREEN
// ============================================================
class WorkerTypeScreen extends StatelessWidget {
  final AppTheme theme;
  final String language;
  final List<Favorite> favorites;
  final VoidCallback onBack;
  final void Function(String) onSelectCategory;
  final void Function(String) onToggleFavorite;

  const WorkerTypeScreen({
    super.key,
    required this.theme,
    required this.language,
    required this.favorites,
    required this.onBack,
    required this.onSelectCategory,
    required this.onToggleFavorite,
  });

  @override
  Widget build(BuildContext context) {
    const cats = [
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
    return Scaffold(
      backgroundColor: theme.background,
      appBar: AppBar(
        backgroundColor: const Color(0xFF0B1533),
        foregroundColor: Colors.white,
        title: Text(
          language == 'en'
              ? 'Worker Types'
              : language == 'si'
              ? 'සේවක වර්ග'
              : 'பணியாளர் வகைகள்',
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: onBack,
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Wrap(
          spacing: 12,
          runSpacing: 16,
          children: cats.map((c) {
            return CategoryCircle(
              key: ValueKey(c),
              label: getCategoryTranslation(c, language),
              theme: theme,
              onPress: () => onSelectCategory(c),
            );
          }).toList(),
        ),
      ),
    );
  }
}

// ============================================================
// BOOKING SCREEN
// ============================================================
class BookingScreen extends StatelessWidget {
  final AppTheme theme;
  final String language;
  final Worker worker;
  final VoidCallback onBack;
  final VoidCallback onConfirmBooking;
  final void Function(String, String) onFindWorker;

  const BookingScreen({
    super.key,
    required this.theme,
    required this.language,
    required this.worker,
    required this.onBack,
    required this.onConfirmBooking,
    required this.onFindWorker,
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
              ? 'Book Worker'
              : language == 'si'
              ? 'සේවකයා Book කරන්න'
              : 'பணியாளர் முன்பதிவு',
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: onBack,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Card(
              color: theme.cardBackground,
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 32,
                      backgroundColor: const Color(0xFF0B1533),
                      child: Text(
                        worker.name[0],
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            worker.name,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: theme.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            worker.category,
                            style: TextStyle(color: theme.textSecondary),
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              const Icon(
                                Icons.star,
                                color: Colors.amber,
                                size: 16,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                '${worker.rating}',
                                style: TextStyle(
                                  color: theme.textSecondary,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: onConfirmBooking,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0B1533),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  language == 'en'
                      ? 'Confirm Booking'
                      : language == 'si'
                      ? 'Booking තහවුරු කරන්න'
                      : 'முன்பதிவை உறுதிப்படுத்தவும்',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
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
