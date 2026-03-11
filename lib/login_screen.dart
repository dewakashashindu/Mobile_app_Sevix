import 'package:flutter/material.dart';

/// Login screen extracted from main.dart and redesigned
/// to match the provided React Native implementation.
class LoginScreen extends StatefulWidget {
  /// Theme object; expected to have fields like background,
  /// cardBackground, textPrimary, textSecondary, primary, border.
  final dynamic theme;
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
  final _resetEmailCtrl = TextEditingController();

  bool _showPassword = false;
  bool _loading = false;
  bool _resetLoading = false;

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passCtrl.dispose();
    _resetEmailCtrl.dispose();
    super.dispose();
  }

  String _t(String key) {
    final lang = widget.selectedLanguage;
    const translations = {
      'login': {'en': 'Login', 'si': 'ඇතුල් වන්න', 'ta': 'உள்நுழைய'},
      'email': {'en': 'Email', 'si': 'ඊමේල්', 'ta': 'மின்னஞ்சல்'},
      'password': {'en': 'Password', 'si': 'මුරපදය', 'ta': 'கடவுச்சொல்'},
      'forgotPassword': {
        'en': 'Forgot Password?',
        'si': 'මුරපදය අමතකද?',
        'ta': 'கடவுச்சொல் மறந்துவிட்டதா?',
      },
      'orContinueWith': {
        'en': 'Or continue with',
        'si': 'නැතිනම් මෙයින් ඉදිරියට',
        'ta': 'அல்லது இதனுடன் தொடரவும்',
      },
      'welcome': {
        'en': 'Welcome Back!',
        'si': 'නැවත සාදරයෙන් පිළිගනිමු!',
        'ta': 'மீண்டும் வருக!',
      },
      'loginDescription': {
        'en': 'Sign in to continue',
        'si': 'ඉදිරියට යාමට පිවිසෙන්න',
        'ta': 'தொடர உள்நுழையவும்',
      },
      'dontHaveAccount': {
        'en': "Don't have an account?",
        'si': 'ගිණුමක් නැද්ද?',
        'ta': 'கணக்கு இல்லையா?',
      },
      'signUp': {'en': 'Sign Up', 'si': 'ලියාපදිංචි වන්න', 'ta': 'பதிவுசெய்க'},
      'cancel': {'en': 'Cancel', 'si': 'අවලංගු කරන්න', 'ta': 'ரத்து செய்'},
    };

    final values = translations[key];
    if (values == null) return key;
    return values[lang] ?? values['en'] ?? key;
  }

  void _handleLogin() {
    final theme = widget.theme;
    final email = _emailCtrl.text.trim();
    final password = _passCtrl.text;

    if (email.isEmpty || password.isEmpty) {
      _showSnack(theme, 'Please fill in all fields');
      return;
    }
    final emailRegex = RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$');
    if (!emailRegex.hasMatch(email)) {
      _showSnack(theme, 'Please enter a valid email address');
      return;
    }

    setState(() => _loading = true);
    Future.delayed(const Duration(milliseconds: 900), () {
      if (!mounted) return;
      setState(() => _loading = false);
      _showSnack(theme, 'Login successful!', success: true);
      widget.onLoginSuccess();
    });
  }

  void _showSnack(dynamic theme, String message, {bool success = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: success ? Colors.green : Colors.red,
      ),
    );
  }

  Future<void> _showForgotDialog() async {
    final theme = widget.theme;
    _resetEmailCtrl.text = _emailCtrl.text;

    await showDialog<void>(
      context: context,
      barrierDismissible: !(_resetLoading),
      builder: (context) {
        return Center(
          child: Material(
            color: Colors.transparent,
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 24),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: theme.cardBackground,
                borderRadius: BorderRadius.circular(12),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black26,
                    offset: Offset(0, 4),
                    blurRadius: 8,
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _t('forgotPassword'),
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: theme.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    widget.selectedLanguage == 'en'
                        ? 'Enter your email to receive a reset link.'
                        : widget.selectedLanguage == 'si'
                        ? 'පිටවීමේ සබැඳියක් ලබන්න ඔබේ ඊමේල් ඇතුළත් කරන්න.'
                        : 'மீட்டெடுக்கும் இணைப்பை பெற உங்கள் மின்னஞ்சலைச் பதிவுசெய்க.',
                    style: TextStyle(color: theme.textSecondary, fontSize: 14),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    decoration: BoxDecoration(
                      color: theme.cardBackground,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: theme.border),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: TextField(
                      controller: _resetEmailCtrl,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: _t('email'),
                        hintStyle: TextStyle(color: theme.textSecondary),
                      ),
                      keyboardType: TextInputType.emailAddress,
                      autofocus: true,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: _resetLoading
                            ? null
                            : () {
                                Navigator.of(context).pop();
                              },
                        child: Text(
                          _t('cancel'),
                          style: TextStyle(color: theme.textPrimary),
                        ),
                      ),
                      const SizedBox(width: 8),
                      ElevatedButton(
                        onPressed: _resetLoading ? null : _handleSendReset,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: theme.primary,
                          foregroundColor: Colors.white,
                        ),
                        child: _resetLoading
                            ? const SizedBox(
                                height: 18,
                                width: 18,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation(
                                    Colors.white,
                                  ),
                                ),
                              )
                            : Text(
                                widget.selectedLanguage == 'en'
                                    ? 'Send'
                                    : widget.selectedLanguage == 'si'
                                    ? 'යවන්න'
                                    : 'செல்வது',
                              ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _handleSendReset() {
    final theme = widget.theme;
    final email = _resetEmailCtrl.text.trim();
    if (email.isEmpty) {
      _showSnack(theme, 'Please enter your email');
      return;
    }
    final emailRegex = RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$');
    if (!emailRegex.hasMatch(email)) {
      _showSnack(theme, 'Please enter a valid email address');
      return;
    }
    setState(() => _resetLoading = true);
    Future.delayed(const Duration(seconds: 1), () {
      if (!mounted) return;
      setState(() => _resetLoading = false);
      Navigator.of(context).pop();
      _showSnack(
        theme,
        'A password reset link has been sent to your email address.',
        success: true,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = widget.theme;
    return Scaffold(
      backgroundColor: theme.background,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: constraints.maxHeight - 80,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildHeader(theme),
                    const SizedBox(height: 32),
                    _buildEmailField(theme),
                    const SizedBox(height: 16),
                    _buildPasswordField(theme),
                    const SizedBox(height: 8),
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: _showForgotDialog,
                        child: Text(
                          _t('forgotPassword'),
                          style: TextStyle(
                            color: theme.primary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    _buildLoginButton(theme),
                    const SizedBox(height: 28),
                    _buildDivider(theme),
                    const SizedBox(height: 20),
                    _buildSocialButtons(theme),
                    const SizedBox(height: 24),
                    _buildFooter(theme),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildHeader(dynamic theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 56,
          height: 56,
          decoration: BoxDecoration(
            color: theme.primary,
            borderRadius: BorderRadius.circular(16),
          ),
          child: const Icon(Icons.engineering, color: Colors.white, size: 30),
        ),
        const SizedBox(height: 24),
        Text(
          _t('welcome'),
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: theme.textPrimary,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          _t('loginDescription'),
          style: TextStyle(fontSize: 16, color: theme.textSecondary),
        ),
      ],
    );
  }

  Widget _buildEmailField(dynamic theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          _t('email'),
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: theme.textPrimary,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: theme.cardBackground,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: theme.border),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              Icon(Icons.mail_outline, color: theme.textSecondary, size: 20),
              const SizedBox(width: 12),
              Expanded(
                child: TextField(
                  controller: _emailCtrl,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: _t('email'),
                    hintStyle: TextStyle(color: theme.textSecondary),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPasswordField(dynamic theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          _t('password'),
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: theme.textPrimary,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: theme.cardBackground,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: theme.border),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              Icon(Icons.lock_outline, color: theme.textSecondary, size: 20),
              const SizedBox(width: 12),
              Expanded(
                child: TextField(
                  controller: _passCtrl,
                  obscureText: !_showPassword,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: _t('password'),
                    hintStyle: TextStyle(color: theme.textSecondary),
                  ),
                ),
              ),
              IconButton(
                onPressed: () => setState(() => _showPassword = !_showPassword),
                icon: Icon(
                  _showPassword ? Icons.visibility : Icons.visibility_off,
                  color: theme.textSecondary,
                  size: 20,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildLoginButton(dynamic theme) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: _loading ? null : _handleLogin,
        style: ElevatedButton.styleFrom(
          backgroundColor: theme.primary,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 4,
          shadowColor: theme.primary,
        ),
        child: _loading
            ? const SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation(Colors.white),
                ),
              )
            : Text(
                _t('login'),
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
      ),
    );
  }

  Widget _buildDivider(dynamic theme) {
    return Row(
      children: [
        Expanded(child: Container(height: 1, color: theme.border)),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Text(
            _t('orContinueWith'),
            style: TextStyle(color: theme.textSecondary, fontSize: 14),
          ),
        ),
        Expanded(child: Container(height: 1, color: theme.border)),
      ],
    );
  }

  Widget _buildSocialButtons(dynamic theme) {
    Widget btn(IconData icon) {
      return Container(
        width: 56,
        height: 56,
        decoration: BoxDecoration(
          color: theme.cardBackground,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: theme.border),
        ),
        child: Icon(icon, color: theme.textPrimary),
      );
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        btn(Icons.g_mobiledata),
        const SizedBox(width: 16),
        btn(Icons.apple),
        const SizedBox(width: 16),
        btn(Icons.facebook),
      ],
    );
  }

  Widget _buildFooter(dynamic theme) {
    return Padding(
      padding: const EdgeInsets.only(top: 24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            _t('dontHaveAccount'),
            style: TextStyle(color: theme.textSecondary, fontSize: 14),
          ),
          const SizedBox(width: 4),
          GestureDetector(
            onTap: widget.onNavigateToSignup,
            child: Text(
              _t('signUp'),
              style: TextStyle(
                color: theme.primary,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
