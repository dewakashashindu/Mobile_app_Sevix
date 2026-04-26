import 'package:flutter/material.dart';

typedef LanguageCode = String;
typedef ThemeModeCode = String;

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({
    super.key,
    required this.onBack,
    required this.language,
    required this.currentTheme,
    required this.onLanguageChange,
    required this.onThemeChange,
    required this.notificationSettings,
    required this.onNotificationSettingsChange,
    required this.biometricEnabled,
    required this.onBiometricToggle,
    required this.onLogout,
    required this.onDeleteAccount,
  });

  final VoidCallback onBack;
  final LanguageCode language; // en | si | ta
  final ThemeModeCode currentTheme; // light | dark
  final ValueChanged<LanguageCode> onLanguageChange;
  final ValueChanged<ThemeModeCode> onThemeChange;
  final Map<String, bool> notificationSettings;
  final ValueChanged<Map<String, bool>> onNotificationSettingsChange;
  final bool biometricEnabled;
  final Future<bool> Function(bool) onBiometricToggle;
  final VoidCallback onLogout;
  final VoidCallback onDeleteAccount;

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final TextEditingController _feedbackController = TextEditingController();
  final TextEditingController _nameController = TextEditingController(
    text: 'Jehan',
  );
  final TextEditingController _emailController = TextEditingController(
    text: 'jehan@example.com',
  );
  final TextEditingController _phoneController = TextEditingController(
    text: '+94 77 123 4567',
  );

  final TextEditingController _currentPasswordController =
      TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  late Map<String, bool> _notificationSettings;
  late bool _biometricEnabled;

  static const _notificationTypeOrder = [
    'newBids',
    'workerAccepted',
    'jobUpdates',
    'messages',
  ];

  @override
  void initState() {
    super.initState();
    _notificationSettings = Map<String, bool>.from(widget.notificationSettings);
    _biometricEnabled = widget.biometricEnabled;
  }

  @override
  void didUpdateWidget(covariant SettingsScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.notificationSettings != widget.notificationSettings) {
      _notificationSettings = Map<String, bool>.from(
        widget.notificationSettings,
      );
    }
    if (oldWidget.biometricEnabled != widget.biometricEnabled) {
      _biometricEnabled = widget.biometricEnabled;
    }
  }

  @override
  void dispose() {
    _feedbackController.dispose();
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

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
        primary: Color(0xFF4A90E2),
      );
    }
    return const _ScreenTheme(
      background: Color(0xFFF8F9FA),
      cardBackground: Colors.white,
      textPrimary: Color(0xFF2A2A2A),
      textSecondary: Color(0xFF888888),
      border: Color(0xFFECECEC),
      divider: Color(0xFFF0F0F0),
      primary: Color(0xFF0B1533),
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

  List<_LangItem> get _languages => const [
    _LangItem(code: 'en', name: 'English', nativeName: 'English', flag: '🇬🇧'),
    _LangItem(code: 'si', name: 'Sinhala', nativeName: 'සිංහල', flag: '🇱🇰'),
    _LangItem(code: 'ta', name: 'Tamil', nativeName: 'தமிழ்', flag: '🇱🇰'),
  ];

  List<_ThemeItem> get _themes => [
    _ThemeItem(
      id: 'light',
      name: _txt('Light', 'ආලෝකමත්', 'ஒளி'),
      icon: Icons.sunny,
    ),
    _ThemeItem(
      id: 'dark',
      name: _txt('Dark', 'අඳුරු', 'இருள்'),
      icon: Icons.nightlight_round,
    ),
  ];

  void _toast(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  void _updateNotificationSetting(String key, bool value) {
    setState(() {
      _notificationSettings[key] = value;
    });
    widget.onNotificationSettingsChange(
      Map<String, bool>.from(_notificationSettings),
    );
  }

  String _notificationTypeLabel(String key) {
    switch (key) {
      case 'newBids':
        return _txt('New Bids', 'නව ලංසු', 'புதிய பிட்கள்');
      case 'workerAccepted':
        return _txt(
          'Worker Accepted',
          'සේවකයා පිළිගත්තා',
          'பணியாளர் ஏற்றுக்கொண்டார்',
        );
      case 'jobUpdates':
        return _txt('Job Updates', 'රැකියා යාවත්කාලීන', 'வேலை புதுப்பிப்புகள்');
      case 'messages':
        return _txt('Messages', 'පණිවිඩ', 'செய்திகள்');
      default:
        return key;
    }
  }

  IconData _notificationTypeIcon(String key) {
    switch (key) {
      case 'newBids':
        return Icons.gavel_outlined;
      case 'workerAccepted':
        return Icons.verified_user_outlined;
      case 'jobUpdates':
        return Icons.build_circle_outlined;
      case 'messages':
        return Icons.chat_bubble_outline;
      default:
        return Icons.notifications_outlined;
    }
  }

  Future<void> _openLanguagePicker() async {
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: _theme.cardBackground,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _sheetTitle(
                _txt(
                  'Select Language',
                  'භාෂාව තෝරන්න',
                  'மொழியைத் தேர்ந்தெடுக்கவும்',
                ),
              ),
              const SizedBox(height: 8),
              ..._languages.map(
                (languageItem) => ListTile(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  leading: Text(
                    languageItem.flag,
                    style: const TextStyle(fontSize: 24),
                  ),
                  title: Text(languageItem.nativeName),
                  subtitle: Text(languageItem.name),
                  trailing: widget.language == languageItem.code
                      ? Icon(Icons.check_circle, color: _theme.primary)
                      : null,
                  onTap: () {
                    widget.onLanguageChange(languageItem.code);
                    Navigator.pop(context);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _openThemePicker() async {
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: _theme.cardBackground,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _sheetTitle(
                _txt(
                  'Select Theme',
                  'තේමාව තෝරන්න',
                  'தீமைத் தேர்ந்தெடுக்கவும்',
                ),
              ),
              const SizedBox(height: 8),
              ..._themes.map(
                (themeItem) => ListTile(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  leading: Icon(themeItem.icon),
                  title: Text(themeItem.name),
                  trailing: widget.currentTheme == themeItem.id
                      ? Icon(Icons.check_circle, color: _theme.primary)
                      : null,
                  onTap: () {
                    widget.onThemeChange(themeItem.id);
                    Navigator.pop(context);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _openEditInfoModal() async {
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: _theme.cardBackground,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            left: 16,
            right: 16,
            top: 16,
            bottom: MediaQuery.of(context).viewInsets.bottom + 16,
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _sheetTitle(
                  _txt(
                    'Edit Profile',
                    'පැතිකඩ සංස්කරණය',
                    'சுயவிவரத்தைத் திருத்து',
                  ),
                ),
                const SizedBox(height: 12),
                _label(_txt('Name', 'නම', 'பெயர்')),
                _textField(_nameController),
                const SizedBox(height: 12),
                _label(_txt('Email', 'විද්‍යුත් තැපෑල', 'மின்னஞ்சல்')),
                _textField(
                  _emailController,
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 12),
                _label(_txt('Phone', 'දුරකථනය', 'தொலைபேசி')),
                _textField(_phoneController, keyboardType: TextInputType.phone),
                const SizedBox(height: 16),
                _primaryButton(
                  text: _txt('Save', 'සුරකින්න', 'சேமி'),
                  onTap: () {
                    Navigator.pop(context);
                    _toast(
                      _txt(
                        'Information updated successfully!',
                        'තොරතුරු සාර්ථකව යාවත්කාලීන කරන ලදී!',
                        'தகவல் வெற்றிகரமாக புதுப்பிக்கப்பட்டது!',
                      ),
                    );
                    setState(() {});
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _openResetPasswordModal() async {
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: _theme.cardBackground,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            left: 16,
            right: 16,
            top: 16,
            bottom: MediaQuery.of(context).viewInsets.bottom + 16,
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _sheetTitle(
                  _txt(
                    'Reset Password',
                    'මුරපදය නැවත සකසන්න',
                    'கடவுச்சொல்லை மீட்டமை',
                  ),
                ),
                const SizedBox(height: 12),
                _label(
                  _txt(
                    'Current Password',
                    'වත්මන් මුරපදය',
                    'தற்போதைய கடவுச்சொல்',
                  ),
                ),
                _textField(_currentPasswordController, obscureText: true),
                const SizedBox(height: 12),
                _label(_txt('New Password', 'නව මුරපදය', 'புதிய கடவுச்சொல்')),
                _textField(_newPasswordController, obscureText: true),
                const SizedBox(height: 12),
                _label(
                  _txt(
                    'Confirm Password',
                    'මුරපදය තහවුරු කරන්න',
                    'கடவுச்சொல்லை உறுதிப்படுத்தவும்',
                  ),
                ),
                _textField(_confirmPasswordController, obscureText: true),
                const SizedBox(height: 16),
                _primaryButton(
                  text: _txt(
                    'Reset Password',
                    'මුරපදය නැවත සකසන්න',
                    'கடவுச்சொல்லை மீட்டமை',
                  ),
                  onTap: () {
                    if (_currentPasswordController.text.trim().isEmpty ||
                        _newPasswordController.text.trim().isEmpty ||
                        _confirmPasswordController.text.trim().isEmpty) {
                      _toast(
                        _txt(
                          'Please fill all fields',
                          'කරුණාකර සියලු ක්ෂේත්‍ර පුරවන්න',
                          'அனைத்து புலங்களையும் நிரப்பவும்',
                        ),
                      );
                      return;
                    }
                    if (_newPasswordController.text !=
                        _confirmPasswordController.text) {
                      _toast(
                        _txt(
                          'Passwords do not match',
                          'මුරපද ගැලපෙන්නේ නැත',
                          'கடவுச்சொற்கள் பொருந்தவில்லை',
                        ),
                      );
                      return;
                    }

                    _currentPasswordController.clear();
                    _newPasswordController.clear();
                    _confirmPasswordController.clear();
                    Navigator.pop(context);
                    _toast(
                      _txt(
                        'Password reset successfully!',
                        'මුරපදය සාර්ථකව නැවත සකසන ලදී!',
                        'கடவுச்சொல் வெற்றிகரமாக மீட்டமைக்கப்பட்டது!',
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _openFeedbackModal() async {
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: _theme.cardBackground,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            left: 16,
            right: 16,
            top: 16,
            bottom: MediaQuery.of(context).viewInsets.bottom + 16,
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _sheetTitle(
                  _txt('Send Feedback', 'ප්‍රතිචාර යවන්න', 'கருத்து அனுப்பு'),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _feedbackController,
                  minLines: 4,
                  maxLines: 6,
                  decoration: InputDecoration(
                    hintText: _txt(
                      'Type your feedback here...',
                      'ඔබේ ප්‍රතිචාර මෙහි ටයිප් කරන්න...',
                      'உங்கள் கருத்தை இங்கே உள்ளிடவும்...',
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                _primaryButton(
                  text: _txt('Submit', 'ඉදිරිපත් කරන්න', 'சமர்ப்பிக்கவும்'),
                  onTap: _feedbackController.text.trim().isEmpty
                      ? null
                      : () {
                          _feedbackController.clear();
                          Navigator.pop(context);
                          _toast(
                            _txt(
                              'Thank you for your feedback!',
                              'ඔබගේ ප්‍රතිචාරයට ස්තුතියි!',
                              'உங்கள் கருத்துக்கு நன்றி!',
                            ),
                          );
                          setState(() {});
                        },
                ),
              ],
            ),
          ),
        );
      },
    );
    if (mounted) {
      setState(() {});
    }
  }

  Future<void> _confirmDeleteAccount() async {
    await showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          _txt('Delete Account?', 'ගිණුම මකන්නද?', 'கணக்கை நீக்கவா?'),
        ),
        content: Text(
          _txt(
            'This action cannot be undone. All your data will be permanently deleted.',
            'මෙම ක්‍රියාව ආපසු හැරවිය නොහැක. ඔබගේ සියලු දත්ත ස්ථිරව මකා දමනු ලැබේ.',
            'இந்த செயலை மாற்ற முடியாது. உங்கள் அனைத்து தரவும் நிரந்தரமாக நீக்கப்படும்.',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(_txt('Cancel', 'අවලංගු කරන්න', 'ரத்து செய்')),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: const Color(0xFFE74C3C),
            ),
            onPressed: () {
              Navigator.pop(context);
              widget.onDeleteAccount();
            },
            child: Text(_txt('Delete', 'මකන්න', 'நீக்கு')),
          ),
        ],
      ),
    );
  }

  Widget _sheetTitle(String text) {
    return Row(
      children: [
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: _theme.textPrimary,
            ),
          ),
        ),
        IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.close),
        ),
      ],
    );
  }

  Widget _label(String text) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: _theme.textPrimary,
      ),
    );
  }

  Widget _textField(
    TextEditingController controller, {
    bool obscureText = false,
    TextInputType? keyboardType,
  }) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        filled: true,
        fillColor: _isDark ? const Color(0xFF2A2A2A) : const Color(0xFFF8F9FA),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  Widget _primaryButton({required String text, required VoidCallback? onTap}) {
    return SizedBox(
      width: double.infinity,
      child: FilledButton(
        onPressed: onTap,
        style: FilledButton.styleFrom(
          backgroundColor: _theme.primary,
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Text(text),
      ),
    );
  }

  Widget _card({
    required String title,
    required IconData icon,
    required List<Widget> children,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _theme.cardBackground,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: _theme.divider,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, size: 18, color: _theme.textPrimary),
              ),
              const SizedBox(width: 12),
              Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: _theme.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ...children,
        ],
      ),
    );
  }

  Widget _settingTile({
    required IconData icon,
    Color? iconColor,
    required String label,
    String? value,
    VoidCallback? onTap,
    Widget? trailing,
  }) {
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: _theme.divider,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Icon(icon, color: iconColor ?? _theme.textPrimary),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: _theme.textPrimary,
                    ),
                  ),
                  if (value != null)
                    Text(
                      value,
                      style: TextStyle(
                        color: _theme.textSecondary,
                        fontSize: 13,
                      ),
                    ),
                ],
              ),
            ),
            trailing ?? Icon(Icons.chevron_right, color: _theme.textSecondary),
          ],
        ),
      ),
    );
  }

  Widget _divider() {
    return Container(
      height: 1,
      margin: const EdgeInsets.symmetric(vertical: 4),
      color: _theme.divider,
    );
  }

  @override
  Widget build(BuildContext context) {
    final selectedLanguage = _languages.firstWhere(
      (l) => l.code == widget.language,
      orElse: () => _languages.first,
    );

    final selectedTheme = _themes.firstWhere(
      (t) => t.id == widget.currentTheme,
      orElse: () => _themes.first,
    );

    return Scaffold(
      backgroundColor: _theme.background,
      body: SafeArea(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
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
                    child: Text(
                      _txt('Settings', 'සැකසීම්', 'அமைப்புகள்'),
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: _theme.textPrimary,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(width: 48),
                ],
              ),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  _card(
                    title: _txt('Account', 'ගිණුම', 'கணக்கு'),
                    icon: Icons.person,
                    children: [
                      _settingTile(
                        icon: Icons.edit_outlined,
                        label: _txt(
                          'Edit Profile',
                          'පැතිකඩ සංස්කරණය',
                          'சுயவிவரத்தைத் திருத்து',
                        ),
                        value:
                            '${_nameController.text}, ${_emailController.text}',
                        onTap: _openEditInfoModal,
                      ),
                      _divider(),
                      _settingTile(
                        icon: Icons.lock_outline,
                        iconColor: const Color(0xFFE74C3C),
                        label: _txt(
                          'Reset Password',
                          'මුරපදය නැවත සකසන්න',
                          'கடவுச்சொல்லை மீட்டமை',
                        ),
                        value: _txt(
                          'Change your password',
                          'ඔබගේ මුරපදය වෙනස් කරන්න',
                          'உங்கள் கடவுச்சொல்லை மாற்றவும்',
                        ),
                        onTap: _openResetPasswordModal,
                      ),
                      _divider(),
                      _settingTile(
                        icon: Icons.fingerprint,
                        iconColor: const Color(0xFF27AE60),
                        label: _txt(
                          'Biometric Login',
                          'ජෛව සත්‍යාපන පිවිසුම',
                          'பயோமெட்ரிக் உள்நுழைவு',
                        ),
                        value: _txt(
                          'Use Face ID / Fingerprint',
                          'Face ID / ඇඟිලි සලකුණු භාවිතා කරන්න',
                          'Face ID / விரல் ரேகையை பயன்படுத்தவும்',
                        ),
                        trailing: Switch(
                          value: _biometricEnabled,
                          onChanged: (value) async {
                            setState(() => _biometricEnabled = value);
                            final success = await widget.onBiometricToggle(
                              value,
                            );
                            if (!mounted) {
                              return;
                            }
                            if (!success) {
                              setState(() => _biometricEnabled = !value);
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                  _card(
                    title: _txt('Preferences', 'මනාපයන්', 'விருப்பத்தேர்வுகள்'),
                    icon: Icons.tune,
                    children: [
                      _settingTile(
                        icon: Icons.language,
                        iconColor: const Color(0xFF3498DB),
                        label: _txt('Language', 'භාෂාව', 'மொழி'),
                        value: selectedLanguage.nativeName,
                        onTap: _openLanguagePicker,
                      ),
                      _divider(),
                      _settingTile(
                        icon: _isDark ? Icons.nightlight_round : Icons.sunny,
                        iconColor: const Color(0xFFF39C12),
                        label: _txt('Theme', 'තේමාව', 'தீம்'),
                        value: selectedTheme.name,
                        onTap: _openThemePicker,
                      ),
                    ],
                  ),
                  _card(
                    title: _txt('Notifications', 'දැනුම්දීම්', 'அறிவிப்புகள்'),
                    icon: Icons.notifications,
                    children: List.generate(
                      _notificationTypeOrder.length * 2 - 1,
                      (index) {
                        if (index.isOdd) {
                          return _divider();
                        }
                        final key = _notificationTypeOrder[index ~/ 2];
                        return _settingTile(
                          icon: _notificationTypeIcon(key),
                          label: _notificationTypeLabel(key),
                          trailing: Switch(
                            value: _notificationSettings[key] ?? true,
                            onChanged: (value) =>
                                _updateNotificationSetting(key, value),
                          ),
                        );
                      },
                    ),
                  ),
                  _card(
                    title: _txt('About', 'පිළිබඳව', 'பற்றி'),
                    icon: Icons.info,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: Column(
                          children: [
                            Text(
                              'Sevix',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.w800,
                                color: _theme.textPrimary,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '${_txt('Version', 'අනුවාදය', 'பதிப்பு')} 1.0.0',
                              style: TextStyle(color: _theme.textSecondary),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              _txt(
                                '© 2025 Sevix. All rights reserved.',
                                '© 2025 Sevix. සියලු හිමිකම් ඇවිරිණි.',
                                '© 2025 Sevix. அனைத்து உரிமைகளும் பாதுகாக்கப்பட்டவை.',
                              ),
                              style: TextStyle(
                                color: _theme.textSecondary,
                                fontSize: 12,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  _card(
                    title: _txt(
                      'Feedback & Support',
                      'ප්‍රතිචාර සහ සහාය',
                      'கருத்து & ஆதரவு',
                    ),
                    icon: Icons.chat_bubble_outline,
                    children: [
                      _settingTile(
                        icon: Icons.edit_note,
                        label: _txt(
                          'Send Feedback',
                          'ප්‍රතිචාර යවන්න',
                          'கருத்து அனுப்பு',
                        ),
                        value: _txt(
                          'Tell us what you think',
                          'ඔබේ අදහස් අපට කියන්න',
                          'உங்கள் கருத்தை எங்களுக்கு தெரிவிக்கவும்',
                        ),
                        onTap: _openFeedbackModal,
                      ),
                      _divider(),
                      _settingTile(
                        icon: Icons.support_agent,
                        label: _txt(
                          'Contact Support',
                          'සහාය අමතන්න',
                          'ஆதரவுக்கு தொடர்பு கொள்ளவும்',
                        ),
                        value: _txt(
                          'Email our support team',
                          'අපගේ සහාය කණ්ඩායමට ඊමේල් කරන්න',
                          'எங்கள் ஆதரவு குழுவிற்கு மின்னஞ்சல் அனுப்பவும்',
                        ),
                        onTap: () {
                          _toast('support@sevix.com');
                        },
                      ),
                    ],
                  ),
                  _card(
                    title: _txt('Legal', 'නීතිමය', 'சட்ட விதிகள்'),
                    icon: Icons.description_outlined,
                    children: [
                      _settingTile(
                        icon: Icons.article_outlined,
                        label: _txt(
                          'Terms & Conditions',
                          'නියම සහ කොන්දේසි',
                          'விதிமுறைகள் மற்றும் நிபந்தனைகள்',
                        ),
                        value: _txt(
                          'Read our terms of service',
                          'අපගේ සේවා කොන්දේසි කියවන්න',
                          'எங்கள் சேவை விதிமுறைகளைப் படிக்கவும்',
                        ),
                        onTap: () => _toast(
                          _txt(
                            'Terms & Conditions',
                            'නියම සහ කොන්දේසි',
                            'விதிமுறைகள் மற்றும் நிபந்தனைகள்',
                          ),
                        ),
                      ),
                      _divider(),
                      _settingTile(
                        icon: Icons.verified_user_outlined,
                        label: _txt(
                          'Privacy Policy',
                          'රහස්‍යතා ප්‍රතිපත්තිය',
                          'தனியுரிமைக் கொள்கை',
                        ),
                        value: _txt(
                          'How we handle your data',
                          'අපි ඔබගේ දත්ත හැසිරවන ආකාරය',
                          'நாங்கள் உங்கள் தரவை எவ்வாறு கையாளுகிறோம்',
                        ),
                        onTap: () => _toast(
                          _txt(
                            'Privacy Policy',
                            'රහස්‍යතා ප්‍රතිපත්තිය',
                            'தனியுரிமைக் கொள்கை',
                          ),
                        ),
                      ),
                      _divider(),
                      _settingTile(
                        icon: Icons.code,
                        label: _txt(
                          'Open Source Licenses',
                          'විවෘත මූලාශ්‍ර බලපත්‍ර',
                          'திறந்த மூல உரிமங்கள்',
                        ),
                        value: _txt(
                          'View open source libraries',
                          'විවෘත මූලාශ්‍ර පුස්තකාල බලපත්‍ර බලන්න',
                          'திறந்த மூல நூலகங்களைப் பார்க்கவும்',
                        ),
                        onTap: () => _toast(
                          _txt(
                            'Open Source Licenses',
                            'විවෘත මූලාශ්‍ර බලපත්‍ර',
                            'திறந்த மூல உரிமங்கள்',
                          ),
                        ),
                      ),
                      _divider(),
                      _settingTile(
                        icon: Icons.cookie_outlined,
                        label: _txt(
                          'Cookie Policy',
                          'කුකී ප්‍රතිපත්තිය',
                          'குக்கீக் கொள்கை',
                        ),
                        value: _txt(
                          'How we use cookies',
                          'අපි කුකීස් භාවිතා කරන ආකාරය',
                          'நாங்கள் குக்கீகளை எவ்வாறு பயன்படுத்துகிறோம்',
                        ),
                        onTap: () => _toast(
                          _txt(
                            'Cookie Policy',
                            'කුකී ප්‍රතිපත්තිය',
                            'குக்கீக் கொள்கை',
                          ),
                        ),
                      ),
                    ],
                  ),
                  _card(
                    title: _txt(
                      'Account Actions',
                      'ගිණුම් ක්‍රියා',
                      'கணக்கு செயல்கள்',
                    ),
                    icon: Icons.shield_outlined,
                    children: [
                      _settingTile(
                        icon: Icons.logout,
                        iconColor: const Color(0xFFFF9800),
                        label: _txt('Logout', 'ඉවත් වන්න', 'வெளியேறு'),
                        value: _txt(
                          'Sign out of your account',
                          'ඔබේ ගිණුමෙන් ඉවත් වන්න',
                          'உங்கள் கணக்கிலிருந்து வெளியேறவும்',
                        ),
                        onTap: _confirmLogout,
                      ),
                      _divider(),
                        Future<void> _confirmLogout() async {
                          final confirmed = await showDialog<bool>(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: Text(_txt('Log out?', 'ඉවත් වන්නද?', 'வெளியேறவா?')),
                              content: Text(_txt(
                                'Are you sure you want to log out?',
                                'ඔබට ඉවත් වීමට අවශ්‍යද?',
                                'நீங்கள் வெளியேற விரும்புகிறீர்களா?',
                              )),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context, false),
                                  child: Text(_txt('No', 'නැහැ', 'இல்லை')),
                                ),
                                FilledButton(
                                  onPressed: () => Navigator.pop(context, true),
                                  child: Text(_txt('Yes', 'ඔව්', 'ஆம்')),
                                ),
                              ],
                            ),
                          );
                          if (confirmed == true) {
                            widget.onLogout();
                          }
                        }
                      _settingTile(
                        icon: Icons.delete_outline,
                        iconColor: const Color(0xFFE74C3C),
                        label: _txt(
                          'Delete Account',
                          'ගිණුම මකන්න',
                          'கணக்கை நீக்கு',
                        ),
                        value: _txt(
                          'Permanently delete your account',
                          'ඔබේ ගිණුම ස්ථිරව මකන්න',
                          'உங்கள் கணக்கை நிரந்தரமாக நீக்கவும்',
                        ),
                        onTap: _confirmDeleteAccount,
                      ),
                    ],
                  ),
                ],
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
    required this.primary,
  });

  final Color background;
  final Color cardBackground;
  final Color textPrimary;
  final Color textSecondary;
  final Color border;
  final Color divider;
  final Color primary;
}

class _LangItem {
  const _LangItem({
    required this.code,
    required this.name,
    required this.nativeName,
    required this.flag,
  });

  final String code;
  final String name;
  final String nativeName;
  final String flag;
}

class _ThemeItem {
  const _ThemeItem({required this.id, required this.name, required this.icon});

  final String id;
  final String name;
  final IconData icon;
}
