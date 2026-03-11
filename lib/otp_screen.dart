import 'dart:async';
import 'package:flutter/material.dart';
import 'main.dart' show AppTheme;

class OTPScreen extends StatefulWidget {
  final AppTheme theme;
  final String selectedLanguage;
  final VoidCallback onOTPVerified;
  final VoidCallback? onResendOTP;
  final String? phoneNumber;
  final String? email;

  const OTPScreen({
    super.key,
    required this.theme,
    required this.selectedLanguage,
    required this.onOTPVerified,
    this.onResendOTP,
    this.phoneNumber,
    this.email,
  });

  @override
  State<OTPScreen> createState() => _OTPScreenState();
}

class _OTPScreenState extends State<OTPScreen> {
  final _otpCtrl = TextEditingController();
  bool _isLoading = false;
  int _resendTimer = 0;
  Timer? _timer;

  @override
  void dispose() {
    _otpCtrl.dispose();
    _timer?.cancel();
    super.dispose();
  }

  void _startResendTimer() {
    setState(() => _resendTimer = 30);
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_resendTimer > 0) {
        setState(() => _resendTimer--);
      } else {
        timer.cancel();
      }
    });
  }

  String _getTranslation(String key) {
    final translations = {
      'enterOTP': {
        'en': 'Enter OTP',
        'si': 'OTP ඇතුළත් කරන්න',
        'ta': 'OTP ஐ உள்ளிடவும்',
      },
      'otpSent': {
        'en': 'We have sent an OTP to your email',
        'si': 'ඔබගේ ඊමේල් වෙත OTP යවා ඇත',
        'ta': 'உங்கள் மின்னஞ்சலுக்கு OTP அனுப்பப்பட்டுள்ளது',
      },
      'verify': {
        'en': 'Verify',
        'si': 'සත්‍යාපනය කරන්න',
        'ta': 'சரிபார்க்கவும்',
      },
      'resend': {
        'en': 'Resend OTP',
        'si': 'OTP නැවත යවන්න',
        'ta': 'OTP ஐ மீண்டும் அனுப்பவும்',
      },
      'invalidOTP': {
        'en': 'Please enter a valid 6-digit OTP',
        'si': 'කරුණාකර වලංගු ඉලක්කම් 6 ක OTP කේතයක් ඇතුළු කරන්න',
        'ta': 'செல்லுபடியாகும் 6 இலக்க OTP ஐ உள்ளிடவும்',
      },
      'error': {'en': 'Error', 'si': 'දෝෂයකි', 'ta': 'பிழை'},
    };
    return translations[key]?[widget.selectedLanguage] ??
        translations[key]?['en'] ??
        key;
  }

  void _handleVerify() async {
    if (_otpCtrl.text.length != 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(_getTranslation('invalidOTP')),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    // Simulate OTP verification
    await Future.delayed(const Duration(seconds: 1));

    setState(() => _isLoading = false);

    if (mounted) {
      widget.onOTPVerified();
    }
  }

  void _handleResend() {
    if (_resendTimer == 0 && widget.onResendOTP != null) {
      widget.onResendOTP!();
      _startResendTimer();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            widget.selectedLanguage == 'si'
                ? 'OTP නැවත යවන ලදි'
                : widget.selectedLanguage == 'ta'
                ? 'OTP மீண்டும் அனுப்பப்பட்டது'
                : 'OTP resent successfully',
          ),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = widget.theme;

    return Scaffold(
      backgroundColor: t.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: t.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Container(
            width: double.infinity,
            constraints: const BoxConstraints(maxWidth: 400),
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: t.cardBackground,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // OTP Icon
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFF0B1533).withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.lock_outline,
                    size: 48,
                    color: const Color(0xFF0B1533),
                  ),
                ),
                const SizedBox(height: 24),

                // Title
                Text(
                  _getTranslation('enterOTP'),
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: t.textPrimary,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),

                // Subtitle
                Text(
                  _getTranslation('otpSent'),
                  style: TextStyle(fontSize: 14, color: t.textSecondary),
                  textAlign: TextAlign.center,
                ),
                if (widget.email != null || widget.phoneNumber != null) ...[
                  const SizedBox(height: 8),
                  Text(
                    widget.email ?? widget.phoneNumber ?? '',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: t.textPrimary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
                const SizedBox(height: 32),

                // OTP Input
                TextField(
                  controller: _otpCtrl,
                  keyboardType: TextInputType.number,
                  maxLength: 6,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 28,
                    letterSpacing: 16,
                    fontWeight: FontWeight.bold,
                    color: t.textPrimary,
                  ),
                  decoration: InputDecoration(
                    hintText: '------',
                    hintStyle: TextStyle(
                      color: t.textSecondary.withOpacity(0.5),
                      letterSpacing: 16,
                    ),
                    counterText: '',
                    border: UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: const Color(0xFF0B1533),
                        width: 2,
                      ),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: const Color(0xFF0B1533),
                        width: 2,
                      ),
                    ),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: t.border, width: 2),
                    ),
                  ),
                  onSubmitted: (_) => _handleVerify(),
                ),
                const SizedBox(height: 32),

                // Verify Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _handleVerify,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF0B1533),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 2,
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
                            _getTranslation('verify'),
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                  ),
                ),
                const SizedBox(height: 16),

                // Resend OTP Button
                TextButton(
                  onPressed: _resendTimer == 0 && widget.onResendOTP != null
                      ? _handleResend
                      : null,
                  child: Text(
                    _resendTimer > 0
                        ? 'Resend OTP (${_resendTimer}s)'
                        : _getTranslation('resend'),
                    style: TextStyle(
                      color: _resendTimer > 0
                          ? t.textSecondary
                          : const Color(0xFF0B1533),
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
