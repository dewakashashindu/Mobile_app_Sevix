import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

class BookingScreen extends StatefulWidget {
  const BookingScreen({
    super.key,
    required this.initialWorkerCategory,
    required this.language,
    required this.currentTheme,
    required this.translateCategory,
    required this.onBack,
    required this.onPostJobRequest,
  });

  final String initialWorkerCategory;
  final String language; // en | si | ta
  final String currentTheme; // light | dark
  final String Function(String categoryName, String language) translateCategory;

  final VoidCallback onBack;
  final void Function(Map<String, dynamic> jobRequest) onPostJobRequest;

  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  static const int _maxPhotos = 5;

  DateTime _selectedDate = DateTime.now();
  TimeOfDay _selectedTime = TimeOfDay.now();

  String _selectedWorkerType = '';
  String _selectedAddress = 'No.13/Basil House, Colombo';
  double? _selectedLatitude;
  double? _selectedLongitude;
  bool _locating = false;

  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _minBudgetController = TextEditingController();
  final TextEditingController _maxBudgetController = TextEditingController();

  final List<XFile> _selectedPhotos = [];
  final ImagePicker _imagePicker = ImagePicker();

  final List<String> _savedAddresses = const [
    'No.13/Basil House, Colombo',
    'No.22/Flower Road, Dehiwala',
    'Apartment 5B, Main Street, Nugegoda',
    '45/2, Galle Road, Mount Lavinia',
  ];

  final List<Map<String, dynamic>> _workerTypes = const [
    {'name': 'Plumber', 'icon': Icons.plumbing, 'color': Color(0xFF3498DB)},
    {
      'name': 'Electrician',
      'icon': Icons.electrical_services,
      'color': Color(0xFFF39C12),
    },
    {'name': 'Mason', 'icon': Icons.handyman, 'color': Color(0xFFE74C3C)},
    {'name': 'Carpenter', 'icon': Icons.carpenter, 'color': Color(0xFF8E44AD)},
    {'name': 'Painter', 'icon': Icons.brush, 'color': Color(0xFF2ECC71)},
    {
      'name': 'Cleaner',
      'icon': Icons.cleaning_services,
      'color': Color(0xFF1ABC9C),
    },
  ];

  @override
  void initState() {
    super.initState();
    _selectedWorkerType = widget.initialWorkerCategory;
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    _minBudgetController.dispose();
    _maxBudgetController.dispose();
    super.dispose();
  }

  bool get _isDark => widget.currentTheme == 'dark';

  _Theme get _theme {
    if (_isDark) {
      return const _Theme(
        background: Color(0xFF121212),
        card: Color(0xFF1E1E1E),
        textPrimary: Colors.white,
        textSecondary: Color(0xFFAAAAAA),
        border: Color(0xFF333333),
        divider: Color(0xFF2A2A2A),
        primary: Color(0xFF4A90E2),
        inputBackground: Color(0xFF2A2A2A),
        inputBorder: Color(0xFF444444),
        inputPlaceholder: Color(0xFF777777),
      );
    }
    return const _Theme(
      background: Color(0xFFF8F9FA),
      card: Colors.white,
      textPrimary: Color(0xFF2A2A2A),
      textSecondary: Color(0xFF888888),
      border: Color(0xFFECECEC),
      divider: Color(0xFFF0F0F0),
      primary: Color(0xFF0B1533),
      inputBackground: Color(0xFFF8F9FA),
      inputBorder: Color(0xFFE8EAF0),
      inputPlaceholder: Color(0xFF999999),
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

  String _formatDate(DateTime date) {
    const months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];
    return '${months[date.month - 1]} ${date.day}, ${date.year}';
  }

  String _formatTime(TimeOfDay time) {
    final hour12 = time.hourOfPeriod == 0 ? 12 : time.hourOfPeriod;
    final minute = time.minute.toString().padLeft(2, '0');
    final period = time.period == DayPeriod.am ? 'AM' : 'PM';
    return '$hour12:$minute $period';
  }

  int? _parseBudget(String input) {
    final cleaned = input.replaceAll(RegExp(r'[^0-9]'), '');
    if (cleaned.isEmpty) return null;
    return int.tryParse(cleaned);
  }

  String _formatCurrency(int amount) {
    return NumberFormat.currency(
      locale: 'en_LK',
      symbol: 'LKR ',
      decimalDigits: 0,
    ).format(amount);
  }

  String? _getBudgetValidationError() {
    final minBudget = _parseBudget(_minBudgetController.text.trim());
    final maxBudget = _parseBudget(_maxBudgetController.text.trim());

    if (minBudget == null || maxBudget == null) {
      return _txt(
        'Please specify a valid budget range',
        'කරුණාකර වලංගු අයවැය පරාසයක් සඳහන් කරන්න',
        'சரியான வரவு செலவுத் திட்ட வரம்பைக் குறிப்பிடவும்',
      );
    }

    if (minBudget <= 0 || maxBudget <= 0) {
      return _txt(
        'Budget values must be greater than 0',
        'අයවැය අගයන් 0 ට වඩා වැඩි විය යුතුය',
        'வரவு செலவுத் தொகைகள் 0 ஐ விட பெரியதாக இருக்க வேண்டும்',
      );
    }

    if (minBudget > maxBudget) {
      return _txt(
        'Minimum budget cannot be greater than maximum budget',
        'අවම අයවැය උපරිම අයවැයට වඩා වැඩි විය නොහැක',
        'குறைந்தபட்ச வரவு செலவு, அதிகபட்சத்தை விட அதிகமாக இருக்க முடியாது',
      );
    }

    return null;
  }

  bool _isFormValid() {
    final budgetError = _getBudgetValidationError();
    return _selectedWorkerType.isNotEmpty &&
        _selectedAddress.isNotEmpty &&
        _descriptionController.text.trim().isNotEmpty &&
        _minBudgetController.text.trim().isNotEmpty &&
        _maxBudgetController.text.trim().isNotEmpty &&
        budgetError == null;
  }

  Future<void> _pickPhotos() async {
    try {
      final List<XFile> images = await _imagePicker.pickMultiImage();
      if (images.isNotEmpty) {
        final beforeCount = _selectedPhotos.length;
        final remainingSlots = _maxPhotos - beforeCount;
        if (remainingSlots <= 0) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  _txt(
                    'You can upload up to 5 photos only',
                    'ඔබට උඩුගත කළ හැක්කේ උපරිම ඡායාරූප 5 ක් පමණි',
                    'நீங்கள் அதிகபட்சம் 5 புகைப்படங்கள் மட்டுமே பதிவேற்றலாம்',
                  ),
                ),
              ),
            );
          }
          return;
        }

        setState(() {
          _selectedPhotos.addAll(images.take(remainingSlots));
        });

        if (beforeCount + images.length > _maxPhotos && mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                _txt(
                  'You can upload up to 5 photos only',
                  'ඔබට උඩුගත කළ හැක්කේ උපරිම ඡායාරූප 5 ක් පමණි',
                  'நீங்கள் அதிகபட்சம் 5 புகைப்படங்கள் மட்டுமே பதிவேற்றலாம்',
                ),
              ),
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              _txt(
                'Error selecting photos',
                'ඡායාරූප තෝරාගැනීමේ දෝෂයකි',
                'புகைப்படங்களைத் தேர்ந்தெடுப்பதில் பிழை',
              ),
            ),
          ),
        );
      }
    }
  }

  void _removePhoto(int index) {
    setState(() {
      _selectedPhotos.removeAt(index);
    });
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() => _selectedDate = picked);
    }
  }

  Future<void> _pickTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
    );
    if (picked != null) {
      setState(() => _selectedTime = picked);
    }
  }

  Future<void> _openAddressSheet() async {
    await showModalBottomSheet<void>(
      context: context,
      backgroundColor: _theme.card,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      _txt(
                        'Select Location',
                        'ස්ථානය තෝරන්න',
                        'இடத்தைத் தேர்ந்தெடுக்கவும்',
                      ),
                      style: TextStyle(
                        color: _theme.textPrimary,
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: Icon(Icons.close, color: _theme.textSecondary),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              ListTile(
                leading: const CircleAvatar(
                  backgroundColor: Color(0xFF0B1533),
                  child: Icon(Icons.near_me, color: Colors.white),
                ),
                title: Text(
                  _txt(
                    'Use Current Location',
                    'වත්මන් ස්ථානය භාවිත කරන්න',
                    'தற்போதைய இடத்தை பயன்படுத்தவும்',
                  ),
                ),
                subtitle: _locating
                    ? Text(
                        _txt(
                          'Detecting your location...',
                          'ඔබගේ ස්ථානය හඳුනා ගනිමින්...',
                          'உங்கள் இடம் கண்டறியப்படுகிறது...',
                        ),
                      )
                    : null,
                onTap: _locating
                    ? null
                    : () async {
                        await _useCurrentLocation();
                        if (!mounted) return;
                        Navigator.of(this.context).pop();
                      },
              ),
              ListTile(
                leading: const CircleAvatar(
                  backgroundColor: Color(0xFFECEFF3),
                  child: Icon(
                    Icons.edit_location_alt,
                    color: Color(0xFF0B1533),
                  ),
                ),
                title: Text(
                  _txt(
                    'Enter Location Manually',
                    'ස්ථානය අතින් ඇතුලත් කරන්න',
                    'இடத்தை கைமுறையாக உள்ளிடவும்',
                  ),
                ),
                onTap: () async {
                  Navigator.pop(context);
                  await _openManualLocationDialog();
                },
              ),
              const SizedBox(height: 8),
              Flexible(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: _savedAddresses.length,
                  itemBuilder: (_, index) {
                    final address = _savedAddresses[index];
                    final selected = _selectedAddress == address;
                    return ListTile(
                      leading: const Icon(Icons.home_outlined),
                      title: Text(address),
                      trailing: selected
                          ? const Icon(
                              Icons.check_circle,
                              color: Color(0xFF0B1533),
                            )
                          : null,
                      onTap: () {
                        setState(() => _selectedAddress = address);
                        Navigator.pop(context);
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _openManualLocationDialog() async {
    final controller = TextEditingController(
      text: _selectedAddress == 'Current Location' ? '' : _selectedAddress,
    );

    await showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(
          _txt(
            'Enter Service Location',
            'සේවා ස්ථානය ඇතුලත් කරන්න',
            'சேவை இடத்தை உள்ளிடவும்',
          ),
        ),
        content: TextField(
          controller: controller,
          autofocus: true,
          maxLines: 2,
          decoration: InputDecoration(
            hintText: _txt(
              'House No, Street, City',
              'නිවසේ අංකය, වීදිය, නගරය',
              'வீட்டு எண், தெரு, நகரம்',
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(_txt('Cancel', 'අවලංගු කරන්න', 'ரத்து செய்')),
          ),
          FilledButton(
            onPressed: () async {
              final value = controller.text.trim();
              if (value.isEmpty) {
                return;
              }

              double? latitude;
              double? longitude;
              try {
                final locations = await locationFromAddress(value);
                if (locations.isNotEmpty) {
                  latitude = locations.first.latitude;
                  longitude = locations.first.longitude;
                }
              } catch (_) {
                // Keep null coordinates when geocoding fails.
              }

              if (!mounted) return;
              setState(() {
                _selectedAddress = value;
                _selectedLatitude = latitude;
                _selectedLongitude = longitude;
              });
              if (!ctx.mounted) return;
              Navigator.of(ctx).pop();
            },
            child: Text(_txt('Save', 'සුරකින්න', 'சேமி')),
          ),
        ],
      ),
    );
  }

  Future<void> _useCurrentLocation() async {
    setState(() => _locating = true);

    try {
      final serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                _txt(
                  'Location services are disabled. Please enable GPS.',
                  'ස්ථාන සේවාව අක්‍රියයි. කරුණාකර GPS සක්‍රීය කරන්න.',
                  'இட சேவைகள் முடக்கப்பட்டுள்ளது. தயவுசெய்து GPS ஐ இயக்கவும்.',
                ),
              ),
            ),
          );
        }
        return;
      }

      var permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                _txt(
                  'Location permission is required to use current location.',
                  'වත්මන් ස්ථානය භාවිත කිරීමට ස්ථාන අවසරය අවශ්‍යයි.',
                  'தற்போதைய இடத்தை பயன்படுத்த இட அனுமதி தேவை.',
                ),
              ),
            ),
          );
        }
        return;
      }

      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      String resolvedAddress =
          'Lat ${position.latitude.toStringAsFixed(5)}, Lng ${position.longitude.toStringAsFixed(5)}';
      try {
        final placemarks = await placemarkFromCoordinates(
          position.latitude,
          position.longitude,
        );
        if (placemarks.isNotEmpty) {
          final p = placemarks.first;
          final parts = [
            p.name,
            p.street,
            p.subLocality,
            p.locality,
            p.administrativeArea,
          ].where((e) => e != null && e.trim().isNotEmpty).toSet().toList();
          if (parts.isNotEmpty) {
            resolvedAddress = parts.join(', ');
          }
        }
      } catch (_) {
        // Keep coordinate fallback if reverse geocoding is unavailable.
      }

      if (mounted) {
        setState(() {
          _selectedAddress = resolvedAddress;
          _selectedLatitude = position.latitude;
          _selectedLongitude = position.longitude;
        });
      }
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              _txt(
                'Unable to fetch current location. Try manual location.',
                'වත්මන් ස්ථානය ලබාගත නොහැක. අතින් ස්ථානය එක් කරන්න.',
                'தற்போதைய இடத்தை பெற முடியவில்லை. கைமுறை இடத்தை பயன்படுத்தவும்.',
              ),
            ),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _locating = false);
      }
    }
  }

  Future<void> _openWorkerTypeSheet() async {
    await showModalBottomSheet<void>(
      context: context,
      backgroundColor: _theme.card,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      _txt(
                        'Select Worker Type',
                        'සේවක වර්ගය තෝරන්න',
                        'பணியாளர் வகையைத் தேர்ந்தெடுக்கவும்',
                      ),
                      style: TextStyle(
                        color: _theme.textPrimary,
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: Icon(Icons.close, color: _theme.textSecondary),
                  ),
                ],
              ),
              Flexible(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: _workerTypes.length,
                  itemBuilder: (_, index) {
                    final type = _workerTypes[index];
                    final name = type['name'] as String;
                    final icon = type['icon'] as IconData;
                    final color = type['color'] as Color;
                    final selected = _selectedWorkerType == name;

                    return ListTile(
                      leading: CircleAvatar(
                        backgroundColor: color.withValues(alpha: 0.15),
                        child: Icon(icon, color: color),
                      ),
                      title: Text(
                        widget.translateCategory(name, widget.language),
                      ),
                      trailing: selected
                          ? const Icon(
                              Icons.check_circle,
                              color: Color(0xFF0B1533),
                            )
                          : null,
                      onTap: () {
                        setState(() => _selectedWorkerType = name);
                        Navigator.pop(context);
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _handleSubmit() {
    if (_descriptionController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            _txt(
              'Please add a service description',
              'කරුණාකර සේවා විස්තරයක් එක් කරන්න',
              'சேவை விவரத்தை சேர்க்கவும்',
            ),
          ),
        ),
      );
      return;
    }

    if (_minBudgetController.text.trim().isEmpty ||
        _maxBudgetController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            _txt(
              'Please specify your budget range',
              'කරුණාකර ඔබගේ අයවැය පරාසය සඳහන් කරන්න',
              'உங்கள் வரவு செலவுத் திட்ட வரம்பைக் குறிப்பிடவும்',
            ),
          ),
        ),
      );
      return;
    }

    final budgetError = _getBudgetValidationError();
    if (budgetError != null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(budgetError)));
      return;
    }

    final minBudget = _parseBudget(_minBudgetController.text.trim())!;
    final maxBudget = _parseBudget(_maxBudgetController.text.trim())!;

    final jobRequest = {
      'workerType': _selectedWorkerType,
      'address': _selectedAddress,
      'latitude': _selectedLatitude,
      'longitude': _selectedLongitude,
      'date': _formatDate(_selectedDate),
      'timeSlot': _formatTime(_selectedTime),
      'serviceDescription': _descriptionController.text.trim(),
      'minBudget': minBudget,
      'maxBudget': maxBudget,
      'photos': _selectedPhotos.map((photo) => photo.path).toList(),
      'timestamp': DateTime.now().toIso8601String(),
    };

    widget.onPostJobRequest(jobRequest);

    // Show success message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          _txt(
            'Job request posted! Workers will start bidding soon.',
            'රැකියා ඉල්ලීම පළ කරන ලදී! කම්කරුවන් ඉක්මනින් ලංසු තැබීම ආරම්භ කරනු ඇත.',
            'வேலை கோரிக்கை வெளியிடப்பட்டது! பணியாளர்கள் விரைவில் ஏலம் எடுக்கத் தொடங்குவார்கள்.',
          ),
        ),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _theme.background,
      body: SafeArea(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              decoration: BoxDecoration(
                color: _theme.card,
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
                      _txt(
                        'Post Job Request',
                        'රැකියා ඉල්ලීම පළ කරන්න',
                        'வேலை கோரிக்கையை இடுங்கள்',
                      ),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: _theme.textPrimary,
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
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
                  _infoCard(
                    title: _txt('Worker Type', 'සේවක වර්ගය', 'பணியாளர் வகை'),
                    value: widget.translateCategory(
                      _selectedWorkerType,
                      widget.language,
                    ),
                    icon: Icons.badge_outlined,
                    onTap: _openWorkerTypeSheet,
                  ),
                  _infoCard(
                    title: _txt('Service Location', 'සේවා ස්ථානය', 'சேவை இடம்'),
                    value: _selectedAddress,
                    icon: Icons.location_on_outlined,
                    onTap: _openAddressSheet,
                  ),
                  _infoCard(
                    title: _txt('Date', 'දිනය', 'தேதி'),
                    value: _formatDate(_selectedDate),
                    icon: Icons.calendar_today_outlined,
                    onTap: _pickDate,
                  ),
                  _infoCard(
                    title: _txt('Time', 'වේලාව', 'நேரம்'),
                    value: _formatTime(_selectedTime),
                    icon: Icons.access_time,
                    onTap: _pickTime,
                  ),
                  Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: _theme.card,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.attach_money, color: _theme.primary),
                            const SizedBox(width: 8),
                            Text(
                              _txt(
                                'Budget Range',
                                'අයවැය පරාසය',
                                'வரவு செலவுத் திட்ட வரம்பு',
                              ),
                              style: TextStyle(
                                color: _theme.textPrimary,
                                fontWeight: FontWeight.w700,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Expanded(
                              child: TextField(
                                controller: _minBudgetController,
                                keyboardType: TextInputType.number,
                                onChanged: (_) => setState(() {}),
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly,
                                ],
                                decoration: InputDecoration(
                                  labelText: _txt(
                                    'Min (Rs.)',
                                    'අවම (රු.)',
                                    'குறைந்தபட்சம் (ரூ.)',
                                  ),
                                  labelStyle: TextStyle(
                                    color: _theme.textSecondary,
                                  ),
                                  filled: true,
                                  fillColor: _theme.inputBackground,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: BorderSide(
                                      color: _theme.inputBorder,
                                    ),
                                  ),
                                  contentPadding: const EdgeInsets.all(12),
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: TextField(
                                controller: _maxBudgetController,
                                keyboardType: TextInputType.number,
                                onChanged: (_) => setState(() {}),
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly,
                                ],
                                decoration: InputDecoration(
                                  labelText: _txt(
                                    'Max (Rs.)',
                                    'උපරිම (රු.)',
                                    'அதிகபட்சம் (ரூ.)',
                                  ),
                                  labelStyle: TextStyle(
                                    color: _theme.textSecondary,
                                  ),
                                  filled: true,
                                  fillColor: _theme.inputBackground,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: BorderSide(
                                      color: _theme.inputBorder,
                                    ),
                                  ),
                                  contentPadding: const EdgeInsets.all(12),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Builder(
                          builder: (context) {
                            final minBudget = _parseBudget(
                              _minBudgetController.text.trim(),
                            );
                            final maxBudget = _parseBudget(
                              _maxBudgetController.text.trim(),
                            );
                            final error = _getBudgetValidationError();

                            if (error != null &&
                                (_minBudgetController.text.isNotEmpty ||
                                    _maxBudgetController.text.isNotEmpty)) {
                              return Text(
                                error,
                                style: const TextStyle(
                                  color: Colors.red,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                              );
                            }

                            if (minBudget != null && maxBudget != null) {
                              return Text(
                                _txt(
                                  'Selected range: ${_formatCurrency(minBudget)} - ${_formatCurrency(maxBudget)}',
                                  'තෝරාගත් පරාසය: ${_formatCurrency(minBudget)} - ${_formatCurrency(maxBudget)}',
                                  'தேர்ந்தெடுக்கப்பட்ட வரம்பு: ${_formatCurrency(minBudget)} - ${_formatCurrency(maxBudget)}',
                                ),
                                style: TextStyle(
                                  color: _theme.textSecondary,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                              );
                            }

                            return const SizedBox.shrink();
                          },
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: _theme.card,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.photo_library, color: _theme.primary),
                            const SizedBox(width: 8),
                            Text(
                              _txt('Photos', 'ඡායාරූප', 'புகைப்படங்கள்'),
                              style: TextStyle(
                                color: _theme.textPrimary,
                                fontWeight: FontWeight.w700,
                                fontSize: 16,
                              ),
                            ),
                            const Spacer(),
                            Text(
                              '${_selectedPhotos.length}/$_maxPhotos',
                              style: TextStyle(
                                color: _theme.textSecondary,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: [
                            ..._selectedPhotos.asMap().entries.map((entry) {
                              final index = entry.key;
                              final photo = entry.value;
                              return Stack(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: Image.file(
                                      File(photo.path),
                                      width: 80,
                                      height: 80,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  Positioned(
                                    top: 2,
                                    right: 2,
                                    child: GestureDetector(
                                      onTap: () => _removePhoto(index),
                                      child: Container(
                                        decoration: const BoxDecoration(
                                          color: Colors.black54,
                                          shape: BoxShape.circle,
                                        ),
                                        padding: const EdgeInsets.all(4),
                                        child: const Icon(
                                          Icons.close,
                                          color: Colors.white,
                                          size: 16,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            }),
                            if (_selectedPhotos.length < _maxPhotos)
                              InkWell(
                                onTap: _pickPhotos,
                                borderRadius: BorderRadius.circular(8),
                                child: Container(
                                  width: 80,
                                  height: 80,
                                  decoration: BoxDecoration(
                                    color: _theme.inputBackground,
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(
                                      color: _theme.inputBorder,
                                      width: 2,
                                      style: BorderStyle.solid,
                                    ),
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.add_photo_alternate,
                                        color: _theme.textSecondary,
                                        size: 32,
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        _txt('Add', 'එකතු', 'சேர்'),
                                        style: TextStyle(
                                          color: _theme.textSecondary,
                                          fontSize: 10,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(bottom: 16),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: _theme.card,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _txt(
                            'Service Description',
                            'සේවා විස්තරය',
                            'சேவை விவரம்',
                          ),
                          style: TextStyle(
                            color: _theme.textPrimary,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 10),
                        TextField(
                          controller: _descriptionController,
                          minLines: 4,
                          maxLines: 6,
                          onChanged: (_) => setState(() {}),
                          decoration: InputDecoration(
                            hintText: _txt(
                              'Describe the service you need...',
                              'ඔබට අවශ්‍ය සේවාව විස්තර කරන්න...',
                              'உங்களுக்கு தேவையான சேவையை விவரிக்கவும்...',
                            ),
                            hintStyle: TextStyle(
                              color: _theme.inputPlaceholder,
                            ),
                            filled: true,
                            fillColor: _theme.inputBackground,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(color: _theme.inputBorder),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.fromLTRB(16, 10, 16, 16),
              decoration: BoxDecoration(
                color: _theme.card,
                border: Border(top: BorderSide(color: _theme.border)),
              ),
              child: SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  onPressed: _isFormValid() ? _handleSubmit : null,
                  style: FilledButton.styleFrom(
                    backgroundColor: const Color(0xFF0B1533),
                    disabledBackgroundColor: const Color(0xFFE8EAF0),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 16,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  icon: Icon(
                    Icons.send,
                    color: _isFormValid() ? Colors.white : _theme.textSecondary,
                  ),
                  label: Text(
                    _txt(
                      'Post Job Request',
                      'රැකියා ඉල්ලීම පළ කරන්න',
                      'வேலை கோரிக்கையை இடுங்கள்',
                    ),
                    style: TextStyle(
                      color: _isFormValid()
                          ? Colors.white
                          : _theme.textSecondary,
                      fontWeight: FontWeight.w700,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _infoCard({
    required String title,
    required String value,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: _theme.card,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: _theme.divider,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: _theme.primary),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(color: _theme.textSecondary, fontSize: 12),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    value,
                    style: TextStyle(
                      color: _theme.textPrimary,
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            Icon(Icons.chevron_right, color: _theme.textSecondary),
          ],
        ),
      ),
    );
  }
}

class _Theme {
  const _Theme({
    required this.background,
    required this.card,
    required this.textPrimary,
    required this.textSecondary,
    required this.border,
    required this.divider,
    required this.primary,
    required this.inputBackground,
    required this.inputBorder,
    required this.inputPlaceholder,
  });

  final Color background;
  final Color card;
  final Color textPrimary;
  final Color textSecondary;
  final Color border;
  final Color divider;
  final Color primary;
  final Color inputBackground;
  final Color inputBorder;
  final Color inputPlaceholder;
}
