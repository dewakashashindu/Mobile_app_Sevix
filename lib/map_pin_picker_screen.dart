import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapPinSelection {
  final String address;
  final double latitude;
  final double longitude;

  const MapPinSelection({
    required this.address,
    required this.latitude,
    required this.longitude,
  });
}

class MapPinPickerScreen extends StatefulWidget {
  final String language;
  final bool isDark;
  final double? initialLatitude;
  final double? initialLongitude;

  const MapPinPickerScreen({
    super.key,
    required this.language,
    required this.isDark,
    this.initialLatitude,
    this.initialLongitude,
  });

  @override
  State<MapPinPickerScreen> createState() => _MapPinPickerScreenState();
}

class _MapPinPickerScreenState extends State<MapPinPickerScreen> {
  static const LatLng _defaultCenter = LatLng(6.9271, 79.8612);

  late LatLng _cameraTarget;
  String _resolvedAddress = '';
  bool _resolvingAddress = false;

  @override
  void initState() {
    super.initState();
    _cameraTarget =
        (widget.initialLatitude != null && widget.initialLongitude != null)
        ? LatLng(widget.initialLatitude!, widget.initialLongitude!)
        : _defaultCenter;
    _resolveAddressForTarget();
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

  Future<void> _resolveAddressForTarget() async {
    setState(() => _resolvingAddress = true);

    String address =
        'Lat ${_cameraTarget.latitude.toStringAsFixed(5)}, Lng ${_cameraTarget.longitude.toStringAsFixed(5)}';

    try {
      final placemarks = await placemarkFromCoordinates(
        _cameraTarget.latitude,
        _cameraTarget.longitude,
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
          address = parts.join(', ');
        }
      }
    } catch (_) {
      // Keep coordinate fallback if reverse geocoding fails.
    }

    if (!mounted) return;
    setState(() {
      _resolvedAddress = address;
      _resolvingAddress = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final background = widget.isDark ? const Color(0xFF121212) : Colors.white;
    final textPrimary = widget.isDark ? Colors.white : const Color(0xFF2A2A2A);
    final textSecondary = widget.isDark
        ? const Color(0xFFAAAAAA)
        : const Color(0xFF666666);

    return Scaffold(
      backgroundColor: background,
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: CameraPosition(
              target: _cameraTarget,
              zoom: 16,
            ),
            myLocationButtonEnabled: true,
            myLocationEnabled: true,
            zoomControlsEnabled: false,
            onCameraMove: (position) {
              _cameraTarget = position.target;
            },
            onCameraIdle: _resolveAddressForTarget,
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [
                  Material(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    elevation: 4,
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(14),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black26,
                            blurRadius: 8,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Text(
                        _txt(
                          'Pick Service Location',
                          'සේවා ස්ථානය තෝරන්න',
                          'சேவை இடத்தைத் தேர்ந்தெடுக்கவும்',
                        ),
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF0B1533),
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          IgnorePointer(
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.location_on,
                    size: 52,
                    color: Color(0xFF0B1533),
                  ),
                  Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(
                      color: Color(0xFF0B1533),
                      shape: BoxShape.circle,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: background,
                borderRadius: BorderRadius.circular(16),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 10,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _txt(
                      'Selected Address',
                      'තෝරාගත් ලිපිනය',
                      'தேர்ந்தெடுக்கப்பட்ட முகவரி',
                    ),
                    style: TextStyle(
                      color: textSecondary,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    _resolvingAddress
                        ? _txt(
                            'Resolving address...',
                            'ලිපිනය සොයමින්...',
                            'முகவரி கண்டறியப்படுகிறது...',
                          )
                        : _resolvedAddress,
                    style: TextStyle(
                      color: textPrimary,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton.icon(
                      onPressed: _resolvingAddress
                          ? null
                          : () {
                              Navigator.of(context).pop(
                                MapPinSelection(
                                  address: _resolvedAddress,
                                  latitude: _cameraTarget.latitude,
                                  longitude: _cameraTarget.longitude,
                                ),
                              );
                            },
                      icon: const Icon(Icons.check_circle_outline),
                      label: Text(
                        _txt(
                          'Use This Location',
                          'මෙම ස්ථානය භාවිත කරන්න',
                          'இந்த இடத்தை பயன்படுத்தவும்',
                        ),
                      ),
                      style: FilledButton.styleFrom(
                        backgroundColor: const Color(0xFF0B1533),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
