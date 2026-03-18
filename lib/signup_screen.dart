import 'package:flutter/material.dart';
import 'main.dart' show AppTheme;
import 'otp_screen.dart';
import 'services/auth_manager.dart';

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
  final _phoneCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  final _confirmPassCtrl = TextEditingController();

  String _selectedCountryCode = '+94';
  bool _termsAccepted = false;
  bool _isLoading = false;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  String? _emailError;
  String? _phoneError;
  String? _passwordError;
  String? _confirmPasswordError;

  // Password strength: 0 = weak, 1 = medium, 2 = strong
  int _passwordStrength = 0;

  final _countryCodeOptions = [
    {'code': '+94', 'flag': '🇱🇰', 'country': 'Sri Lanka'},
    {'code': '+91', 'flag': '🇮🇳', 'country': 'India'},
    {'code': '+1', 'flag': '🇺🇸', 'country': 'USA'},
    {'code': '+44', 'flag': '🇬🇧', 'country': 'UK'},
    {'code': '+61', 'flag': '🇦🇺', 'country': 'Australia'},
  ];

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _phoneCtrl.dispose();
    _passCtrl.dispose();
    _confirmPassCtrl.dispose();
    super.dispose();
  }

  void _calculatePasswordStrength(String password) {
    if (password.isEmpty) {
      setState(() => _passwordStrength = 0);
      return;
    }

    int strength = 0;

    // Check length
    if (password.length >= 8) strength++;

    // Check for uppercase, lowercase, number, special char
    bool hasUpper = password.contains(RegExp(r'[A-Z]'));
    bool hasLower = password.contains(RegExp(r'[a-z]'));
    bool hasDigit = password.contains(RegExp(r'\d'));
    bool hasSpecial = password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'));

    int criteriaCount = 0;
    if (hasUpper) criteriaCount++;
    if (hasLower) criteriaCount++;
    if (hasDigit) criteriaCount++;
    if (hasSpecial) criteriaCount++;

    if (criteriaCount >= 3 && password.length >= 10) {
      strength = 2; // Strong
    } else if (criteriaCount >= 2 && password.length >= 8) {
      strength = 1; // Medium
    }

    setState(() => _passwordStrength = strength);
  }

  bool _validateEmail(String email) {
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    return emailRegex.hasMatch(email);
  }

  bool _validatePhone(String phone) {
    return phone.length >= 7 &&
        phone.length <= 15 &&
        RegExp(r'^\d+$').hasMatch(phone);
  }

  bool _hasUpperCase(String password) => password.contains(RegExp(r'[A-Z]'));
  bool _hasLowerCase(String password) => password.contains(RegExp(r'[a-z]'));
  bool _hasDigit(String password) => password.contains(RegExp(r'\d'));
  bool _hasSpecialChar(String password) =>
      password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'));

  Future<void> _handleSignUp() async {
    setState(() {
      _emailError = null;
      _phoneError = null;
      _passwordError = null;
      _confirmPasswordError = null;
    });

    bool hasError = false;

    // Validate name
    if (_nameCtrl.text.trim().isEmpty) {
      hasError = true;
    }

    // Validate email
    if (!_validateEmail(_emailCtrl.text.trim())) {
      setState(
        () => _emailError = widget.selectedLanguage == 'si'
            ? 'වලංගු ඊමේල් ලිපිනයක් ඇතුළු කරන්න'
            : widget.selectedLanguage == 'ta'
            ? 'சரியான மின்னஞ்சல் முகவரியை உள்ளிடவும்'
            : 'Please enter a valid email address',
      );
      hasError = true;
    }

    // Validate phone
    if (!_validatePhone(_phoneCtrl.text.trim())) {
      setState(
        () => _phoneError = widget.selectedLanguage == 'si'
            ? 'වලංගු දුරකථන අංකයක් ඇතුළු කරන්න'
            : widget.selectedLanguage == 'ta'
            ? 'சரியான தொலைபேசி எண்ணை உள்ளிடவும்'
            : 'Please enter a valid phone number',
      );
      hasError = true;
    }

    // Validate password
    if (_passCtrl.text.length < 8) {
      setState(
        () => _passwordError = widget.selectedLanguage == 'si'
            ? 'මුරපදය අවම වශයෙන් අක්ෂර 8ක් විය යුතුය'
            : widget.selectedLanguage == 'ta'
            ? 'கடவுச்சொல் குறைந்தது 8 எழுத்துக்களாக இருக்க வேண்டும்'
            : 'Password must be at least 8 characters',
      );
      hasError = true;
    }

    // Validate confirm password
    if (_passCtrl.text != _confirmPassCtrl.text) {
      setState(
        () => _confirmPasswordError = widget.selectedLanguage == 'si'
            ? 'මුරපද නොගැලපේ'
            : widget.selectedLanguage == 'ta'
            ? 'கடவுச்சொற்கள் பொருந்தவில்லை'
            : 'Passwords do not match',
      );
      hasError = true;
    }

    // Validate terms
    if (!_termsAccepted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            widget.selectedLanguage == 'si'
                ? 'කරුණාකර නියම සහ කොන්දේසි පිළිගන්න'
                : widget.selectedLanguage == 'ta'
                ? 'விதிமுறைகள் மற்றும் நிபந்தனைகளை ஏற்றுக்கொள்ளவும்'
                : 'Please accept terms and conditions',
          ),
          backgroundColor: Colors.red,
        ),
      );
      hasError = true;
    }

    if (hasError) return;

    setState(() => _isLoading = true);

    final result = await AuthManager.instance.register(
      fullName: _nameCtrl.text.trim(),
      email: _emailCtrl.text.trim(),
      phone: '$_selectedCountryCode${_phoneCtrl.text.trim()}',
      password: _passCtrl.text,
    );

    if (!mounted) return;
    setState(() => _isLoading = false);

    if (!result.success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(result.message), backgroundColor: Colors.red),
      );
      return;
    }

    if (result.requiresOtp && result.otpSessionId != null) {
      _navigateToOTPScreen(result.otpSessionId!);
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(result.message), backgroundColor: Colors.green),
    );
    widget.onSignUpSuccess();
  }

  void _navigateToOTPScreen(String otpSessionId) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => OTPScreen(
          theme: widget.theme,
          selectedLanguage: widget.selectedLanguage,
          phoneNumber: '$_selectedCountryCode${_phoneCtrl.text}',
          email: _emailCtrl.text,
          otpSessionId: otpSessionId,
          onOTPVerified: () {
            Navigator.pop(context);
            widget.onSignUpSuccess();
          },
        ),
      ),
    );
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
              const SizedBox(height: 20),
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
              const SizedBox(height: 32),

              // Name field
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

              // Phone field with country code picker
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 100,
                    decoration: BoxDecoration(
                      color: t.inputBackground,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: t.border),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: _selectedCountryCode,
                        isExpanded: true,
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        borderRadius: BorderRadius.circular(12),
                        dropdownColor: t.cardBackground,
                        icon: Icon(
                          Icons.arrow_drop_down,
                          color: t.textSecondary,
                        ),
                        items: _countryCodeOptions.map((option) {
                          return DropdownMenuItem<String>(
                            value: option['code'],
                            child: Text(
                              '${option['flag']} ${option['code']}',
                              style: TextStyle(color: t.textPrimary),
                            ),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() => _selectedCountryCode = value!);
                        },
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextField(
                      controller: _phoneCtrl,
                      keyboardType: TextInputType.phone,
                      decoration: InputDecoration(
                        labelText: lang == 'si'
                            ? 'දුරකථන අංකය'
                            : lang == 'ta'
                            ? 'தொலைபேசி எண்'
                            : 'Phone Number',
                        errorText: _phoneError,
                        prefixIcon: const Icon(Icons.phone_outlined),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        filled: true,
                        fillColor: t.inputBackground,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Email field
              TextField(
                controller: _emailCtrl,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  labelText: lang == 'si'
                      ? 'ඊමේල්'
                      : lang == 'ta'
                      ? 'மின்னஞ்சல்'
                      : 'Email',
                  errorText: _emailError,
                  prefixIcon: const Icon(Icons.email_outlined),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  filled: true,
                  fillColor: t.inputBackground,
                ),
              ),
              const SizedBox(height: 16),

              // Password field
              TextField(
                controller: _passCtrl,
                obscureText: _obscurePassword,
                onChanged: _calculatePasswordStrength,
                decoration: InputDecoration(
                  labelText: lang == 'si'
                      ? 'මුරපදය'
                      : lang == 'ta'
                      ? 'கடவுச்சொல்'
                      : 'Password',
                  errorText: _passwordError,
                  prefixIcon: const Icon(Icons.lock_outlined),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword
                          ? Icons.visibility_outlined
                          : Icons.visibility_off_outlined,
                    ),
                    onPressed: () =>
                        setState(() => _obscurePassword = !_obscurePassword),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  filled: true,
                  fillColor: t.inputBackground,
                ),
              ),

              // Password strength indicator
              if (_passCtrl.text.isNotEmpty) ...[
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        height: 4,
                        decoration: BoxDecoration(
                          color: _passwordStrength >= 0
                              ? (_passwordStrength == 0
                                    ? Colors.red
                                    : _passwordStrength == 1
                                    ? Colors.orange
                                    : Colors.green)
                              : Colors.grey[300],
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Container(
                        height: 4,
                        decoration: BoxDecoration(
                          color: _passwordStrength >= 1
                              ? (_passwordStrength == 1
                                    ? Colors.orange
                                    : Colors.green)
                              : Colors.grey[300],
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Container(
                        height: 4,
                        decoration: BoxDecoration(
                          color: _passwordStrength >= 2
                              ? Colors.green
                              : Colors.grey[300],
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      _passwordStrength == 0
                          ? (lang == 'si'
                                ? 'දුර්වල'
                                : lang == 'ta'
                                ? 'பலவீனமான'
                                : 'Weak')
                          : _passwordStrength == 1
                          ? (lang == 'si'
                                ? 'මධ්‍යම'
                                : lang == 'ta'
                                ? 'நடுத்தர'
                                : 'Medium')
                          : (lang == 'si'
                                ? 'ශක්තිමත්'
                                : lang == 'ta'
                                ? 'வலுவான'
                                : 'Strong'),
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: _passwordStrength == 0
                            ? Colors.red
                            : _passwordStrength == 1
                            ? Colors.orange
                            : Colors.green,
                      ),
                    ),
                  ],
                ),
              ],

              // Password requirements
              if (_passCtrl.text.isNotEmpty) ...[
                const SizedBox(height: 12),
                _buildPasswordRequirement(
                  lang == 'si'
                      ? 'අවම වශයෙන් අක්ෂර 8ක්'
                      : lang == 'ta'
                      ? 'குறைந்தது 8 எழுத்துக்கள்'
                      : 'At least 8 characters',
                  _passCtrl.text.length >= 8,
                ),
                _buildPasswordRequirement(
                  lang == 'si'
                      ? 'ලොකු අකුරු'
                      : lang == 'ta'
                      ? 'பெரிய எழுத்துக்கள்'
                      : 'Uppercase letter',
                  _hasUpperCase(_passCtrl.text),
                ),
                _buildPasswordRequirement(
                  lang == 'si'
                      ? 'කුඩා අකුරු'
                      : lang == 'ta'
                      ? 'சிறிய எழுத்துக்கள்'
                      : 'Lowercase letter',
                  _hasLowerCase(_passCtrl.text),
                ),
                _buildPasswordRequirement(
                  lang == 'si'
                      ? 'අංකයක්'
                      : lang == 'ta'
                      ? 'எண்ணொன்று'
                      : 'Number',
                  _hasDigit(_passCtrl.text),
                ),
                _buildPasswordRequirement(
                  lang == 'si'
                      ? 'විශේෂ අක්ෂරයක්'
                      : lang == 'ta'
                      ? 'சிறப்பு எழுத்து'
                      : 'Special character',
                  _hasSpecialChar(_passCtrl.text),
                ),
              ],

              const SizedBox(height: 16),

              // Confirm Password field
              TextField(
                controller: _confirmPassCtrl,
                obscureText: _obscureConfirmPassword,
                decoration: InputDecoration(
                  labelText: lang == 'si'
                      ? 'මුරපදය තහවුරු කරන්න'
                      : lang == 'ta'
                      ? 'கடவுச்சொல்லை உறுதிப்படுத்தவும்'
                      : 'Confirm Password',
                  errorText: _confirmPasswordError,
                  prefixIcon: const Icon(Icons.lock_outlined),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscureConfirmPassword
                          ? Icons.visibility_outlined
                          : Icons.visibility_off_outlined,
                    ),
                    onPressed: () => setState(
                      () => _obscureConfirmPassword = !_obscureConfirmPassword,
                    ),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  filled: true,
                  fillColor: t.inputBackground,
                ),
              ),
              const SizedBox(height: 16),

              // Terms and conditions checkbox
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 24,
                    height: 24,
                    child: Checkbox(
                      value: _termsAccepted,
                      onChanged: (value) =>
                          setState(() => _termsAccepted = value ?? false),
                      activeColor: t.primary,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: GestureDetector(
                      onTap: () =>
                          setState(() => _termsAccepted = !_termsAccepted),
                      child: Text(
                        lang == 'si'
                            ? 'මම නියම සහ කොන්දේසි පිළිගනිමි'
                            : lang == 'ta'
                            ? 'விதிமுறைகள் மற்றும் நிபந்தனைகளை ஏற்றுக்கொள்கிறேன்'
                            : 'I accept the terms and conditions',
                        style: TextStyle(fontSize: 14, color: t.textSecondary),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Sign Up button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _handleSignUp,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0B1533),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: _isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Colors.white,
                            ),
                          ),
                        )
                      : Text(
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

              // Navigate to login
              Center(
                child: TextButton(
                  onPressed: widget.onNavigateToLogin,
                  child: Text(
                    lang == 'si'
                        ? 'දැනටමත් ගිණුමක් තිබේද? ලොගින් වන්න'
                        : lang == 'ta'
                        ? 'ஏற்கனவே கணக்கு உள்ளதா? உள்நுழையவும்'
                        : 'Already have an account? Login',
                    style: TextStyle(color: t.primary),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPasswordRequirement(String text, bool met) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(
            met ? Icons.check_circle : Icons.cancel,
            size: 16,
            color: met ? Colors.green : Colors.grey,
          ),
          const SizedBox(width: 8),
          Text(
            text,
            style: TextStyle(
              fontSize: 12,
              color: met ? Colors.green : widget.theme.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}
