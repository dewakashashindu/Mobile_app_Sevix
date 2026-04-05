import 'dart:math';
import 'dart:io';

import 'package:flutter/material.dart';
import 'main.dart' show AppTheme;

class PaymentCheckoutScreen extends StatefulWidget {
  const PaymentCheckoutScreen({
    super.key,
    required this.theme,
    required this.language,
    required this.jobTitle,
    required this.workerName,
    required this.amount,
  });

  final AppTheme theme;
  final String language;
  final String jobTitle;
  final String workerName;
  final int amount;

  @override
  State<PaymentCheckoutScreen> createState() => _PaymentCheckoutScreenState();
}

class _PaymentCheckoutScreenState extends State<PaymentCheckoutScreen> {
  final TextEditingController _promoController = TextEditingController();
  final TextEditingController _refundDetailsController =
      TextEditingController();
  final TextEditingController _newCardNumberController =
      TextEditingController();
  final TextEditingController _newCardHolderController =
      TextEditingController();
  final TextEditingController _newCardExpiryController =
      TextEditingController();
  final TextEditingController _newCardCvvController = TextEditingController();
  final TextEditingController _otpController = TextEditingController();

  _PaymentMethod _selectedMethod = _PaymentMethod.card;
  _PaymentState _paymentState = _PaymentState.checkout;
  int _currentStep = 0;

  String _appliedPromoCode = '';
  String _promoMessage = '';
  int _discountAmount = 0;
  bool _feeWaived = false;

  bool _simulateFailure = false;
  bool _refundRequested = false;
  _CardInputMode _cardInputMode = _CardInputMode.enterDetails;

  _WalletProvider _selectedWallet = _WalletProvider.sevixWallet;

  List<_StoredCard> _savedCards = const [
    _StoredCard(
      id: 'card_visa_01',
      brand: _CardBrand.visa,
      last4: '4242',
      holderName: 'Dewak User',
      expiry: '12/28',
    ),
    _StoredCard(
      id: 'card_master_01',
      brand: _CardBrand.mastercard,
      last4: '4444',
      holderName: 'Dewak User',
      expiry: '10/27',
    ),
  ];

  String? _selectedCardId = 'card_visa_01';

  String _transactionId = '';
  String _failureReason = '';
  String _refundReason = 'Service quality issue';
  String _otpError = '';

  DateTime? _paidAt;
  DateTime? _refundRequestedAt;
  String _downloadedSlipPath = '';

  @override
  void dispose() {
    _promoController.dispose();
    _refundDetailsController.dispose();
    _newCardNumberController.dispose();
    _newCardHolderController.dispose();
    _newCardExpiryController.dispose();
    _newCardCvvController.dispose();
    _otpController.dispose();
    super.dispose();
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

  int get _serviceFee {
    if (_feeWaived) {
      return 0;
    }
    return max(150, (widget.amount * 0.06).round());
  }

  int get _platformFee => 75;

  int get _subtotal => widget.amount;

  int get _total => _subtotal + _serviceFee + _platformFee - _discountAmount;

  void _applyPromoCode() {
    final code = _promoController.text.trim().toUpperCase();

    setState(() {
      _appliedPromoCode = code;
      _promoMessage = '';
      _discountAmount = 0;
      _feeWaived = false;

      if (code.isEmpty) {
        _promoMessage = _txt(
          'Enter a promo code',
          'ප්රවර්ධන කේතයක් ඇතුලත් කරන්න',
          'சலுகை குறியீட்டை உள்ளிடவும்',
        );
        return;
      }

      if (code == 'SAVE10') {
        _discountAmount = (_subtotal * 0.10).round();
        _promoMessage = _txt(
          'Promo applied: 10% off',
          'ප්රවර්ධනය යෙදූවා: 10% අඩුයි',
          'சலுகை பயன்படுத்தப்பட்டது: 10% தள்ளுபடி',
        );
        return;
      }

      if (code == 'SAVE20') {
        _discountAmount = (_subtotal * 0.20).round();
        _promoMessage = _txt(
          'Promo applied: 20% off',
          'ප්රවර්ධනය යෙදූවා: 20% අඩුයි',
          'சலுகை பயன்படுத்தப்பட்டது: 20% தள்ளுபடி',
        );
        return;
      }

      if (code == 'NOFEE') {
        _feeWaived = true;
        _promoMessage = _txt(
          'Promo applied: Service fee removed',
          'ප්රවර්ධනය යෙදූවා: සේවා ගාස්තුව ඉවත් කරන ලදී',
          'சலுகை பயன்படுத்தப்பட்டது: சேவை கட்டணம் நீக்கப்பட்டது',
        );
        return;
      }

      _promoMessage = _txt(
        'Invalid promo code',
        'වලංගු නොවන ප්රවර්ධන කේතය',
        'தவறான சலுகை குறியீடு',
      );
    });
  }

  Future<void> _payNow() async {
    if (_selectedMethod == _PaymentMethod.card) {
      if (_cardInputMode == _CardInputMode.savedCards) {
        if (_selectedCardId == null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                _txt(
                  'Please select a saved card to continue',
                  'කරුණාකර ඉදිරියට යාමට සුරකින ලද කාඩ්පතක් තෝරන්න',
                  'தொடர சேமிக்கப்பட்ட அட்டையை தேர்ந்தெடுக்கவும்',
                ),
              ),
            ),
          );
          return;
        }
      } else {
        if (!_validateEnteredCardDetails(showMessage: true)) {
          return;
        }
      }

      if (!RegExp(r'^\d{6}$').hasMatch(_otpController.text.trim())) {
        setState(
          () => _otpError = _txt(
            'Please enter a valid 6-digit OTP',
            'කරුණාකර වලංගු ඉලක්කම් 6 OTP ඇතුලත් කරන්න',
            'சரியான 6 இலக்க OTP ஐ உள்ளிடவும்',
          ),
        );
        return;
      }
    }

    if (_selectedMethod == _PaymentMethod.wallet) {
      if (!RegExp(r'^\d{6}$').hasMatch(_otpController.text.trim())) {
        setState(
          () => _otpError = _txt(
            'Please enter a valid 6-digit OTP',
            'කරුණාකර වලංගු ඉලක්කම් 6 OTP ඇතුලත් කරන්න',
            'சரியான 6 இலக்க OTP ஐ உள்ளிடவும்',
          ),
        );
        return;
      }
    }

    if (_otpError.isNotEmpty) {
      setState(() => _otpError = '');
    }

    setState(() {
      _currentStep = 3;
      _paymentState = _PaymentState.processing;
      _failureReason = '';
    });

    await Future<void>.delayed(const Duration(milliseconds: 1200));
    if (!mounted) {
      return;
    }

    if (_simulateFailure) {
      setState(() {
        _paymentState = _PaymentState.failure;
        _failureReason = _txt(
          'Payment authorization failed. Please try another method.',
          'ගෙවීම් අනුමැතිය අසාර්ථකයි. වෙනත් ක්රමයක් උත්සාහ කරන්න.',
          'கட்டண அனுமதி தோல்வியடைந்தது. வேறு முறையை முயற்சிக்கவும்.',
        );
      });
      return;
    }

    final referenceSeed = DateTime.now().millisecondsSinceEpoch;
    setState(() {
      _paymentState = _PaymentState.success;
      _paidAt = DateTime.now();
      _transactionId = _selectedMethod == _PaymentMethod.cash
          ? 'CASH-$referenceSeed'
          : _selectedMethod == _PaymentMethod.wallet
          ? 'WALLET-$referenceSeed'
          : 'CARD-$referenceSeed';
    });
  }

  bool _validateEnteredCardDetails({required bool showMessage}) {
    final numberRaw = _newCardNumberController.text.replaceAll(
      RegExp(r'\D'),
      '',
    );
    final holder = _newCardHolderController.text.trim();
    final expiry = _newCardExpiryController.text.trim();
    final cvv = _newCardCvvController.text.trim();

    String? message;
    if (numberRaw.length < 13 || !_isLuhnValid(numberRaw)) {
      message = _txt(
        'Please enter a valid card number',
        'කරුණාකර වලංගු කාඩ් අංකයක් ඇතුලත් කරන්න',
        'சரியான அட்டை எண்ணை உள்ளிடவும்',
      );
    } else if (holder.isEmpty) {
      message = _txt(
        'Please enter cardholder name',
        'කරුණාකර කාඩ් හිමියාගේ නම ඇතුලත් කරන්න',
        'அட்டைதாரர் பெயரை உள்ளிடவும்',
      );
    } else if (!_isExpiryValid(expiry)) {
      message = _txt(
        'Please enter a valid future expiry date (MM/YY)',
        'කරුණාකර වලංගු කල් ඉකුත් වන දිනයක් ඇතුලත් කරන්න (MM/YY)',
        'சரியான எதிர்கால காலாவதி தேதியை உள்ளிடவும் (MM/YY)',
      );
    } else if (cvv.length < 3 || cvv.length > 4) {
      message = _txt(
        'Please enter a valid CVV',
        'කරුණාකර වලංගු CVV ඇතුලත් කරන්න',
        'சரியான CVV ஐ உள்ளிடவும்',
      );
    }

    if (message != null) {
      if (showMessage) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(message!)));
      }
      return false;
    }
    return true;
  }

  String _cardMethodSummary() {
    if (_cardInputMode == _CardInputMode.savedCards) {
      if (_selectedCard == null) {
        return _txt('Card', 'කාඩ්පත', 'அட்டை');
      }
      return '${_methodLabel(_selectedMethod)} ${_brandLabel(_selectedCard!.brand)} •••• ${_selectedCard!.last4}';
    }

    final numberRaw = _newCardNumberController.text.replaceAll(
      RegExp(r'\D'),
      '',
    );
    final brand = _detectBrand(numberRaw);
    final last4 = numberRaw.length >= 4
        ? numberRaw.substring(numberRaw.length - 4)
        : '----';
    return '${_methodLabel(_selectedMethod)} ${_brandLabel(brand)} •••• $last4';
  }

  _StoredCard? get _selectedCard {
    if (_selectedCardId == null) {
      return null;
    }
    for (final card in _savedCards) {
      if (card.id == _selectedCardId) {
        return card;
      }
    }
    return null;
  }

  Future<void> _downloadSlip() async {
    if (_paymentState != _PaymentState.success) {
      return;
    }

    final content = StringBuffer()
      ..writeln('SEVIX PAYMENT SLIP')
      ..writeln('Invoice ID: $_transactionId')
      ..writeln('Date: ${_formatDate(_paidAt ?? DateTime.now())}')
      ..writeln('Job: ${widget.jobTitle}')
      ..writeln('Worker: ${widget.workerName}')
      ..writeln('Method: ${_methodLabel(_selectedMethod)}')
      ..writeln('Subtotal: LKR $_subtotal')
      ..writeln('Service Fee: LKR $_serviceFee')
      ..writeln('Platform Fee: LKR $_platformFee')
      ..writeln('Discount: LKR $_discountAmount')
      ..writeln('Total Paid: LKR $_total');

    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final fileName = 'sevix_payment_slip_$timestamp.txt';

    Directory targetDir;
    final home = Platform.environment['USERPROFILE'];
    if (home != null && home.isNotEmpty) {
      final downloads = Directory('$home\\Downloads');
      if (downloads.existsSync()) {
        targetDir = downloads;
      } else {
        targetDir = Directory.systemTemp;
      }
    } else {
      targetDir = Directory.systemTemp;
    }

    final file = File('${targetDir.path}${Platform.pathSeparator}$fileName');
    await file.writeAsString(content.toString());

    if (!mounted) {
      return;
    }

    setState(() => _downloadedSlipPath = file.path);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          _txt(
            'Slip downloaded successfully',
            'ස්ලිප් එක සාර්ථකව බාගත කරන ලදී',
            'ஸ்லிப் வெற்றிகரமாக பதிவிறக்கப்பட்டது',
          ),
        ),
        backgroundColor: Colors.green,
      ),
    );
  }

  _CardBrand _detectBrand(String digitsOnly) {
    if (digitsOnly.startsWith('4')) {
      return _CardBrand.visa;
    }
    if (RegExp(r'^(5[1-5]|2[2-7])').hasMatch(digitsOnly)) {
      return _CardBrand.mastercard;
    }
    if (RegExp(r'^(34|37)').hasMatch(digitsOnly)) {
      return _CardBrand.amex;
    }
    return _CardBrand.unknown;
  }

  bool _isLuhnValid(String digits) {
    var sum = 0;
    var shouldDouble = false;

    for (var i = digits.length - 1; i >= 0; i--) {
      var digit = int.parse(digits[i]);
      if (shouldDouble) {
        digit *= 2;
        if (digit > 9) {
          digit -= 9;
        }
      }
      sum += digit;
      shouldDouble = !shouldDouble;
    }
    return sum % 10 == 0;
  }

  bool _isExpiryValid(String expiry) {
    final parts = expiry.split('/');
    if (parts.length != 2) {
      return false;
    }
    final month = int.tryParse(parts[0]);
    final year2 = int.tryParse(parts[1]);
    if (month == null || year2 == null || month < 1 || month > 12) {
      return false;
    }
    final year = 2000 + year2;
    final now = DateTime.now();
    final endOfMonth = DateTime(year, month + 1, 0, 23, 59, 59);
    return endOfMonth.isAfter(now);
  }

  String _formatCardNumber(String raw) {
    final digits = raw.replaceAll(RegExp(r'\D'), '');
    final buffer = StringBuffer();
    for (var i = 0; i < digits.length && i < 19; i++) {
      buffer.write(digits[i]);
      if ((i + 1) % 4 == 0 && i + 1 != digits.length) {
        buffer.write(' ');
      }
    }
    return buffer.toString();
  }

  String _formatExpiry(String raw) {
    final digits = raw.replaceAll(RegExp(r'\D'), '');
    if (digits.isEmpty) {
      return '';
    }
    if (digits.length <= 2) {
      return digits;
    }
    return '${digits.substring(0, 2)}/${digits.substring(2, min(4, digits.length))}';
  }

  String _brandLabel(_CardBrand brand) {
    switch (brand) {
      case _CardBrand.visa:
        return 'VISA';
      case _CardBrand.mastercard:
        return 'MASTERCARD';
      case _CardBrand.amex:
        return 'AMEX';
      case _CardBrand.unknown:
        return _txt('CARD', 'කාඩ්', 'அட்டை');
    }
  }

  String _formatDate(DateTime dt) {
    final mm = dt.month.toString().padLeft(2, '0');
    final dd = dt.day.toString().padLeft(2, '0');
    return '$dd/$mm/${dt.year}';
  }

  String _methodLabel(_PaymentMethod method) {
    switch (method) {
      case _PaymentMethod.card:
        return _txt('Card', 'කාඩ්පත', 'அட்டை');
      case _PaymentMethod.wallet:
        return _txt('Wallet', 'වොලට්', 'வாலெட்');
      case _PaymentMethod.cash:
        return _txt('Cash', 'මුදල්', 'பணம்');
    }
  }

  Future<void> _openRefundFlow() async {
    final reasons = [
      _txt('Service quality issue', 'සේවා ගුණාත්මක ගැටලුව', 'சேவை தர பிரச்சனை'),
      _txt(
        'Overcharged amount',
        'අධික මුදල අය කර ඇත',
        'அதிகமாக கட்டணம் வசூலிக்கப்பட்டது',
      ),
      _txt('Duplicate payment', 'අනුපිටපත් ගෙවීම', 'இரட்டை கட்டணம்'),
      _txt('Work not completed', 'වැඩ නිම කර නැහැ', 'வேலை முடிக்கப்படவில்லை'),
    ];

    String selectedReason = _refundReason;

    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: widget.theme.cardBackground,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return Padding(
          padding: EdgeInsets.only(
            left: 16,
            right: 16,
            top: 16,
            bottom: MediaQuery.of(ctx).viewInsets.bottom + 16,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _txt(
                  'Request Refund',
                  'මුදල් ආපසු ඉල්ලන්න',
                  'பணத்தை திரும்ப கோரவும்',
                ),
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: widget.theme.textPrimary,
                ),
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                value: selectedReason,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                items: reasons
                    .map(
                      (value) => DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      ),
                    )
                    .toList(),
                onChanged: (value) {
                  if (value != null) {
                    selectedReason = value;
                  }
                },
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _refundDetailsController,
                minLines: 2,
                maxLines: 4,
                decoration: InputDecoration(
                  labelText: _txt(
                    'Details (optional)',
                    'විස්තර (විකල්ප)',
                    'விவரங்கள் (விருப்பம்)',
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(height: 14),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _refundReason = selectedReason;
                      _refundRequested = true;
                      _refundRequestedAt = DateTime.now();
                    });
                    Navigator.pop(ctx);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          _txt(
                            'Refund request submitted',
                            'මුදල් ආපසු ඉල්ලීම යවන ලදී',
                            'பணத்தை திரும்ப பெறும் கோரிக்கை அனுப்பப்பட்டது',
                          ),
                        ),
                        backgroundColor: Colors.green,
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0B1533),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  child: Text(
                    _txt(
                      'Submit Refund Request',
                      'ආපසු ගෙවීම් ඉල්ලීම යවන්න',
                      'பணத்தீர்வு கோரிக்கையை அனுப்பவும்',
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: widget.theme.background,
      appBar: AppBar(
        backgroundColor: const Color(0xFF0B1533),
        foregroundColor: Colors.white,
        title: Text(_txt('Checkout', 'ගෙවීම්', 'செக்அவுட்')),
      ),
      body: Column(
        children: [
          _buildStepHeader(),
          Expanded(child: _buildContent()),
        ],
      ),
    );
  }

  Widget _buildContent() {
    if (_currentStep == 0) {
      return _buildStepDetails();
    }

    if (_currentStep == 1) {
      return _buildStepPaymentMethod();
    }

    if (_currentStep == 2) {
      return _buildStepConfirm();
    }

    return _buildStepResult();
  }

  Widget _buildStepHeader() {
    final labels = [
      _txt('Details', 'විස්තර', 'விவரங்கள்'),
      _txt('Method', 'ක්රමය', 'முறை'),
      _txt('Confirm', 'තහවුරු', 'உறுதி'),
      _txt('Result', 'ප්රතිඵලය', 'முடிவு'),
    ];
    final totalSteps = labels.length;
    final progress = ((_currentStep + 1) / totalSteps).clamp(0.0, 1.0);

    return Container(
      color: widget.theme.cardBackground,
      padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  labels[_currentStep],
                  style: TextStyle(
                    color: widget.theme.textPrimary,
                    fontWeight: FontWeight.w700,
                    fontSize: 13,
                  ),
                ),
              ),
              Text(
                '${_currentStep + 1}/$totalSteps',
                style: TextStyle(
                  color: widget.theme.textSecondary,
                  fontWeight: FontWeight.w600,
                  fontSize: 12,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(999),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 10,
              backgroundColor: widget.theme.border,
              valueColor: const AlwaysStoppedAnimation<Color>(
                Color(0xFF0B1533),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStepDetails() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            _txt('Payment Details', 'ගෙවීම් විස්තර', 'கட்டண விவரங்கள்'),
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: widget.theme.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: widget.theme.cardBackground,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: widget.theme.border),
            ),
            child: Column(
              children: [
                _invoiceRow(_txt('Work', 'වැඩ', 'வேலை'), widget.jobTitle),
                _invoiceRow(
                  _txt('Worker', 'සේවකයා', 'பணியாளர்'),
                  widget.workerName,
                ),
                _invoiceRow(
                  _txt('Amount', 'මුදල', 'தொகை'),
                  'LKR ${widget.amount}',
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Text(
            _txt('Promo Code', 'ප්රවර්ධන කේතය', 'சலுகை குறியீடு'),
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: widget.theme.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _promoController,
                  textCapitalization: TextCapitalization.characters,
                  decoration: InputDecoration(
                    hintText: _txt(
                      'Enter code (SAVE10, SAVE20, NOFEE)',
                      'කේතය ඇතුලත් කරන්න',
                      'குறியீட்டை உள்ளிடவும்',
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              ElevatedButton(
                onPressed: _applyPromoCode,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0B1533),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 16,
                  ),
                ),
                child: Text(_txt('Apply', 'යොදන්න', 'பயன்படுத்து')),
              ),
            ],
          ),
          if (_promoMessage.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Text(
                _promoMessage,
                style: TextStyle(
                  color: (_discountAmount > 0 || _feeWaived)
                      ? Colors.green
                      : Colors.red,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          const SizedBox(height: 14),
          Text(
            _txt('Fee Breakdown', 'ගාස්තු විස්තරය', 'கட்டண விவரம்'),
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: widget.theme.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: widget.theme.cardBackground,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: widget.theme.border),
            ),
            child: Column(
              children: [
                _invoiceRow(
                  _txt('Service Amount', 'සේවා මුදල', 'சேவை தொகை'),
                  'LKR $_subtotal',
                ),
                _invoiceRow(
                  _txt('Service Fee', 'සේවා ගාස්තුව', 'சேவை கட்டணம்'),
                  'LKR $_serviceFee',
                ),
                _invoiceRow(
                  _txt('Platform Fee', 'වේදිකා ගාස්තුව', 'தளம் கட்டணம்'),
                  'LKR $_platformFee',
                ),
                _invoiceRow(
                  _txt('Promo Discount', 'ප්රවර්ධන වට්ටම', 'சலுகை தள்ளுபடி'),
                  '- LKR $_discountAmount',
                ),
                const Divider(height: 20),
                _invoiceRow(
                  _txt('Total', 'එකතුව', 'மொத்தம்'),
                  'LKR $_total',
                  bold: true,
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => setState(() => _currentStep = 1),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF0B1533),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 15),
              ),
              child: Text(_txt('Next', 'ඊළඟ', 'அடுத்து')),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStepPaymentMethod() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            _txt(
              'Select Payment Method',
              'ගෙවීමේ ක්රමය තෝරන්න',
              'கட்டண முறையை தேர்வு செய்க',
            ),
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: widget.theme.textPrimary,
            ),
          ),
          const SizedBox(height: 10),
          _methodTile(_PaymentMethod.card, Icons.credit_card_outlined),
          _methodTile(
            _PaymentMethod.wallet,
            Icons.account_balance_wallet_outlined,
          ),
          _methodTile(_PaymentMethod.cash, Icons.payments_outlined),
          if (_selectedMethod == _PaymentMethod.card) ...[
            const SizedBox(height: 10),
            SegmentedButton<_CardInputMode>(
              showSelectedIcon: false,
              style: SegmentedButton.styleFrom(
                selectedBackgroundColor: const Color(0xFF0B1533),
                selectedForegroundColor: Colors.white,
                foregroundColor: widget.theme.textPrimary,
              ),
              segments: [
                ButtonSegment<_CardInputMode>(
                  value: _CardInputMode.enterDetails,
                  label: Text(
                    _txt('1. Enter Card', '1. කාඩ් විස්තර', '1. அட்டை விவரம்'),
                  ),
                  icon: const Icon(Icons.edit_outlined),
                ),
                ButtonSegment<_CardInputMode>(
                  value: _CardInputMode.savedCards,
                  label: Text(
                    _txt(
                      '2. Saved Cards',
                      '2. සුරැකි කාඩ්',
                      '2. சேமித்த அட்டைகள்',
                    ),
                  ),
                  icon: const Icon(Icons.credit_card_outlined),
                ),
              ],
              selected: {_cardInputMode},
              onSelectionChanged: (selection) {
                if (selection.isNotEmpty) {
                  setState(() => _cardInputMode = selection.first);
                }
              },
            ),
            const SizedBox(height: 8),
            if (_cardInputMode == _CardInputMode.enterDetails)
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: widget.theme.cardBackground,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: widget.theme.border),
                ),
                child: Column(
                  children: [
                    TextField(
                      controller: _newCardNumberController,
                      keyboardType: TextInputType.number,
                      onChanged: (value) {
                        final formatted = _formatCardNumber(value);
                        if (formatted != value) {
                          _newCardNumberController.value = TextEditingValue(
                            text: formatted,
                            selection: TextSelection.collapsed(
                              offset: formatted.length,
                            ),
                          );
                        }
                      },
                      decoration: InputDecoration(
                        labelText: _txt(
                          'Card Number',
                          'කාඩ් අංකය',
                          'அட்டை எண்',
                        ),
                        hintText: '4111 1111 1111 1111',
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _newCardHolderController,
                      textCapitalization: TextCapitalization.words,
                      decoration: InputDecoration(
                        labelText: _txt(
                          'Cardholder Name',
                          'කාඩ් හිමියාගේ නම',
                          'அட்டைதாரர் பெயர்',
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _newCardExpiryController,
                            keyboardType: TextInputType.number,
                            onChanged: (value) {
                              final formatted = _formatExpiry(value);
                              if (formatted != value) {
                                _newCardExpiryController.value =
                                    TextEditingValue(
                                      text: formatted,
                                      selection: TextSelection.collapsed(
                                        offset: formatted.length,
                                      ),
                                    );
                              }
                            },
                            decoration: InputDecoration(
                              labelText: _txt(
                                'Expiry (MM/YY)',
                                'කල් ඉකුත් වන දිනය (MM/YY)',
                                'காலாவதி (MM/YY)',
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: TextField(
                            controller: _newCardCvvController,
                            keyboardType: TextInputType.number,
                            obscureText: true,
                            maxLength: 4,
                            decoration: const InputDecoration(
                              counterText: '',
                              labelText: 'CVV',
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            if (_cardInputMode == _CardInputMode.savedCards)
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: widget.theme.cardBackground,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: widget.theme.border),
                ),
                child: Column(
                  children: [
                    ..._savedCards.map(
                      (card) => Container(
                        margin: const EdgeInsets.only(bottom: 8),
                        decoration: BoxDecoration(
                          color: widget.theme.cardBackground,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: widget.theme.border),
                        ),
                        child: RadioListTile<String>(
                          value: card.id,
                          groupValue: _selectedCardId,
                          onChanged: (value) =>
                              setState(() => _selectedCardId = value),
                          title: Text(
                            '${_brandLabel(card.brand)} •••• ${card.last4}',
                            style: TextStyle(
                              color: widget.theme.textPrimary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          subtitle: Text(
                            '${card.holderName}  |  Exp ${card.expiry}',
                            style: TextStyle(color: widget.theme.textSecondary),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
          ],
          if (_selectedMethod == _PaymentMethod.wallet) ...[
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: widget.theme.cardBackground,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: widget.theme.border),
              ),
              child: Column(
                children: [
                  RadioListTile<_WalletProvider>(
                    value: _WalletProvider.sevixWallet,
                    groupValue: _selectedWallet,
                    onChanged: (v) {
                      if (v != null) {
                        setState(() => _selectedWallet = v);
                      }
                    },
                    title: const Text('Sevix Wallet'),
                  ),
                  RadioListTile<_WalletProvider>(
                    value: _WalletProvider.genie,
                    groupValue: _selectedWallet,
                    onChanged: (v) {
                      if (v != null) {
                        setState(() => _selectedWallet = v);
                      }
                    },
                    title: const Text('GENIE Wallet'),
                  ),
                ],
              ),
            ),
          ],
          const SizedBox(height: 18),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => setState(() => _currentStep = 0),
                  child: Text(_txt('Back', 'ආපසු', 'பின்')),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    if (_selectedMethod == _PaymentMethod.card) {
                      if (_cardInputMode == _CardInputMode.savedCards &&
                          _selectedCardId == null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              _txt(
                                'Please select a saved card to continue',
                                'කරුණාකර ඉදිරියට යාමට සුරකින ලද කාඩ්පතක් තෝරන්න',
                                'தொடர சேமிக்கப்பட்ட அட்டையை தேர்ந்தெடுக்கவும்',
                              ),
                            ),
                          ),
                        );
                        return;
                      }

                      if (_cardInputMode == _CardInputMode.enterDetails &&
                          !_validateEnteredCardDetails(showMessage: true)) {
                        return;
                      }
                    }
                    setState(() => _currentStep = 2);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0B1533),
                    foregroundColor: Colors.white,
                  ),
                  child: Text(_txt('Next', 'ඊළඟ', 'அடுத்து')),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStepConfirm() {
    final methodText = _selectedMethod == _PaymentMethod.card
        ? _cardMethodSummary()
        : _selectedMethod == _PaymentMethod.wallet
        ? '${_methodLabel(_selectedMethod)} (${_selectedWallet == _WalletProvider.sevixWallet ? 'Sevix Wallet' : 'GENIE Wallet'})'
        : _methodLabel(_selectedMethod);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            _txt(
              'Confirm Payment',
              'ගෙවීම තහවුරු කරන්න',
              'கட்டணத்தை உறுதிப்படுத்தவும்',
            ),
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: widget.theme.textPrimary,
            ),
          ),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: widget.theme.cardBackground,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: widget.theme.border),
            ),
            child: Column(
              children: [
                _invoiceRow(_txt('Work', 'වැඩ', 'வேலை'), widget.jobTitle),
                _invoiceRow(
                  _txt('Worker', 'සේවකයා', 'பணியாளர்'),
                  widget.workerName,
                ),
                _invoiceRow(
                  _txt('Payment Method', 'ගෙවීම් ක්රමය', 'கட்டண முறை'),
                  methodText,
                ),
                _invoiceRow(
                  _txt('Subtotal', 'උප එකතුව', 'துணை மொத்தம்'),
                  'LKR $_subtotal',
                ),
                _invoiceRow(
                  _txt('Service Fee', 'සේවා ගාස්තුව', 'சேவை கட்டணம்'),
                  'LKR $_serviceFee',
                ),
                _invoiceRow(
                  _txt('Platform Fee', 'වේදිකා ගාස්තුව', 'தளம் கட்டணம்'),
                  'LKR $_platformFee',
                ),
                _invoiceRow(
                  _txt('Discount', 'වට්ටම', 'தள்ளுபடி'),
                  '- LKR $_discountAmount',
                ),
                const Divider(height: 20),
                _invoiceRow(
                  _txt(
                    'Total to Pay',
                    'ගෙවිය යුතු එකතුව',
                    'செலுத்த வேண்டிய மொத்தம்',
                  ),
                  'LKR $_total',
                  bold: true,
                ),
              ],
            ),
          ),
          if (_selectedMethod == _PaymentMethod.card ||
              _selectedMethod == _PaymentMethod.wallet) ...[
            const SizedBox(height: 12),
            TextField(
              controller: _otpController,
              keyboardType: TextInputType.number,
              maxLength: 6,
              onChanged: (_) {
                if (_otpError.isNotEmpty) {
                  setState(() => _otpError = '');
                }
              },
              decoration: InputDecoration(
                labelText: _txt(
                  'OTP Verification Code',
                  'OTP තහවුරු කිරීමේ කේතය',
                  'OTP சரிபார்ப்பு குறியீடு',
                ),
                hintText: _txt(
                  'Enter 6-digit OTP',
                  'ඉලක්කම් 6 OTP',
                  '6 இலக்க OTP',
                ),
                errorText: _otpError.isEmpty ? null : _otpError,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ],
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => setState(() => _currentStep = 1),
                  child: Text(_txt('Back', 'ආපසු', 'பின்')),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: _payNow,
                  icon: const Icon(Icons.lock_outline),
                  label: Text(
                    _txt(
                      'Confirm & Pay',
                      'තහවුරු කර ගෙවන්න',
                      'உறுதி செய்து செலுத்து',
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0B1533),
                    foregroundColor: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStepResult() {
    if (_paymentState == _PaymentState.processing) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircularProgressIndicator(),
            const SizedBox(height: 14),
            Text(
              _txt(
                'Processing payment...',
                'ගෙවීම සිදු කරමින්...',
                'கட்டணம் செயல்படுத்தப்படுகிறது...',
              ),
              style: TextStyle(color: widget.theme.textPrimary),
            ),
          ],
        ),
      );
    }

    if (_paymentState == _PaymentState.failure) {
      return Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(Icons.error_outline, color: Colors.red.shade600, size: 48),
            const SizedBox(height: 12),
            Text(
              _txt(
                'Payment Failed',
                'ගෙවීම අසාර්ථකයි',
                'கட்டணம் தோல்வியடைந்தது',
              ),
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w700,
                color: widget.theme.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              _failureReason,
              style: TextStyle(color: widget.theme.textSecondary),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => setState(() {
                  _paymentState = _PaymentState.checkout;
                  _currentStep = 2;
                }),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0B1533),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                child: Text(
                  _txt(
                    'Try Again',
                    'නැවත උත්සාහ කරන්න',
                    'மீண்டும் முயற்சிக்கவும்',
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    }

    if (_paymentState == _PaymentState.success) {
      return SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.green.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.green.withOpacity(0.4)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.check_circle, color: Colors.green),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      _txt(
                        'Payment Successful',
                        'ගෙවීම සාර්ථකයි',
                        'கட்டணம் வெற்றி',
                      ),
                      style: TextStyle(
                        color: widget.theme.textPrimary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Text(
              _txt('Invoice', 'ඉන්වොයිසිය', 'விலைப்பட்டியல்'),
              style: TextStyle(
                color: widget.theme.textPrimary,
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: widget.theme.cardBackground,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: widget.theme.border),
              ),
              child: Column(
                children: [
                  _invoiceRow(
                    _txt('Invoice ID', 'ඉන්වොයිස් අංකය', 'விலைப்பட்டியல் எண்'),
                    _transactionId,
                  ),
                  _invoiceRow(_txt('Job', 'රැකියාව', 'வேலை'), widget.jobTitle),
                  _invoiceRow(
                    _txt('Worker', 'සේවකයා', 'பணியாளர்'),
                    widget.workerName,
                  ),
                  _invoiceRow(
                    _txt('Method', 'ගෙවීමේ ක්රමය', 'கட்டண முறை'),
                    _selectedMethod == _PaymentMethod.card
                        ? _cardMethodSummary()
                        : _selectedMethod == _PaymentMethod.wallet
                        ? '${_methodLabel(_selectedMethod)} (${_selectedWallet == _WalletProvider.sevixWallet ? 'Sevix Wallet' : 'GENIE Wallet'})'
                        : _methodLabel(_selectedMethod),
                  ),
                  _invoiceRow(
                    _txt('Date', 'දිනය', 'தேதி'),
                    _formatDate(_paidAt ?? DateTime.now()),
                  ),
                  const Divider(height: 20),
                  _invoiceRow(
                    _txt('Subtotal', 'උප එකතුව', 'துணை மொத்தம்'),
                    'LKR $_subtotal',
                  ),
                  _invoiceRow(
                    _txt('Service Fee', 'සේවා ගාස්තුව', 'சேவை கட்டணம்'),
                    'LKR $_serviceFee',
                  ),
                  _invoiceRow(
                    _txt('Platform Fee', 'වේදිකා ගාස්තුව', 'தளம் கட்டணம்'),
                    'LKR $_platformFee',
                  ),
                  _invoiceRow(
                    _txt('Discount', 'වට්ටම', 'தள்ளுபடி'),
                    '- LKR $_discountAmount',
                  ),
                  const Divider(height: 20),
                  _invoiceRow(
                    _txt('Total Paid', 'ගෙවූ එකතුව', 'மொத்த கட்டணம்'),
                    'LKR $_total',
                    bold: true,
                  ),
                ],
              ),
            ),
            if (_refundRequested) ...[
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.amber.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.amber.withOpacity(0.5)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _txt(
                        'Refund Requested',
                        'මුදල් ආපසු ඉල්ලීම යැවී ඇත',
                        'பணத்தீர்வு கோரப்பட்டது',
                      ),
                      style: TextStyle(
                        color: widget.theme.textPrimary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${_txt('Reason', 'හේතුව', 'காரணம்')}: $_refundReason',
                      style: TextStyle(color: widget.theme.textSecondary),
                    ),
                    if (_refundRequestedAt != null)
                      Text(
                        '${_txt('Submitted', 'යවන ලදී', 'அனுப்பப்பட்டது')}: ${_formatDate(_refundRequestedAt!)}',
                        style: TextStyle(color: widget.theme.textSecondary),
                      ),
                  ],
                ),
              ),
            ],
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _downloadSlip,
                icon: const Icon(Icons.download_outlined),
                label: Text(
                  _txt(
                    'Download Slip',
                    'ස්ලිප් බාගත කරන්න',
                    'ஸ்லிப் பதிவிறக்கவும்',
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0B1533),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
              ),
            ),
            if (_downloadedSlipPath.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(
                  '${_txt('Saved to', 'සුරකිණු ස්ථානය', 'சேமிக்கப்பட்ட இடம்')}: $_downloadedSlipPath',
                  style: TextStyle(
                    color: widget.theme.textSecondary,
                    fontSize: 12,
                  ),
                ),
              ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: widget.theme.cardBackground,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: widget.theme.border),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _txt(
                      'Refund Details',
                      'ආපසු ගෙවීම් විස්තර',
                      'பணத்தீர்வு விவரங்கள்',
                    ),
                    style: TextStyle(
                      color: widget.theme.textPrimary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    _txt(
                      'Eligible within 7 days after payment. Average processing time: 3-5 business days.',
                      'ගෙවීමෙන් පසු දින 7 ක් ඇතුළත සුදුසුකම් ඇත. සාමාන්ය සැකසුම් කාලය: ව්යාපාරික දින 3-5.',
                      'கட்டணத்திற்கு பின் 7 நாட்களுக்குள் தகுதி. சராசரி செயலாக்க நேரம்: 3-5 வேலை நாட்கள்.',
                    ),
                    style: TextStyle(color: widget.theme.textSecondary),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: _openRefundFlow,
                icon: const Icon(Icons.request_quote_outlined),
                label: Text(
                  _txt(
                    'Request Refund',
                    'මුදල් ආපසු ඉල්ලන්න',
                    'பணத்தை திரும்ப கோரவும்',
                  ),
                ),
                style: OutlinedButton.styleFrom(
                  foregroundColor: const Color(0xFF0B1533),
                  side: BorderSide(color: widget.theme.border),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
              ),
            ),
          ],
        ),
      );
    }

    return Center(
      child: Text(
        _txt(
          'Ready to process payment',
          'ගෙවීම සදහා සූදානම්',
          'கட்டணம் செயலாக்க தயாராக உள்ளது',
        ),
        style: TextStyle(color: widget.theme.textSecondary),
      ),
    );
  }

  Widget _methodTile(_PaymentMethod method, IconData icon) {
    final selected = _selectedMethod == method;
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: () => setState(() => _selectedMethod = method),
        child: Ink(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          decoration: BoxDecoration(
            color: selected
                ? const Color(0xFF0B1533).withOpacity(0.06)
                : widget.theme.cardBackground,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: selected ? const Color(0xFF0B1533) : widget.theme.border,
            ),
          ),
          child: Row(
            children: [
              Icon(icon, color: const Color(0xFF0B1533)),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  _methodLabel(method),
                  style: TextStyle(
                    color: widget.theme.textPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              if (selected)
                const Icon(Icons.check_circle, color: Color(0xFF0B1533)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _invoiceRow(String label, String value, {bool bold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                color: widget.theme.textSecondary,
                fontWeight: bold ? FontWeight.w700 : FontWeight.w500,
              ),
            ),
          ),
          Text(
            value,
            style: TextStyle(
              color: widget.theme.textPrimary,
              fontWeight: bold ? FontWeight.w700 : FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

enum _PaymentMethod { card, wallet, cash }

enum _PaymentState { checkout, processing, success, failure }

enum _CardInputMode { enterDetails, savedCards }

enum _WalletProvider { sevixWallet, genie }

enum _CardBrand { visa, mastercard, amex, unknown }

class _StoredCard {
  const _StoredCard({
    required this.id,
    required this.brand,
    required this.last4,
    required this.holderName,
    required this.expiry,
  });

  final String id;
  final _CardBrand brand;
  final String last4;
  final String holderName;
  final String expiry;
}
