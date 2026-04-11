import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'chat_detail_screen.dart';
import 'chat_screen.dart';
import 'main.dart' show AppTheme;

class LiveJobTrackingScreen extends StatefulWidget {
  final AppTheme theme;
  final String language;
  final String bookingId;
  final String workerId;
  final String workerName;
  final String workerPhone;
  final String jobTitle;
  final String? chatId;
  final int submittedEtaMinutes;
  final double customerLatitude;
  final double customerLongitude;

  const LiveJobTrackingScreen({
    super.key,
    required this.theme,
    required this.language,
    required this.bookingId,
    required this.workerId,
    required this.workerName,
    required this.workerPhone,
    required this.jobTitle,
    required this.submittedEtaMinutes,
    required this.customerLatitude,
    required this.customerLongitude,
    this.chatId,
  });

  @override
  State<LiveJobTrackingScreen> createState() => _LiveJobTrackingScreenState();
}

class _LiveJobTrackingScreenState extends State<LiveJobTrackingScreen> {
  GoogleMapController? _mapController;
  Timer? _ticker;
  DateTime _now = DateTime.now();

  @override
  void initState() {
    super.initState();
    _ticker = Timer.periodic(const Duration(seconds: 30), (_) {
      if (!mounted) return;
      setState(() {
        _now = DateTime.now();
      });
    });
  }

  @override
  void dispose() {
    _ticker?.cancel();
    _mapController?.dispose();
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

  Color _statusColor(_LiveWorkerStatus status) {
    switch (status) {
      case _LiveWorkerStatus.enRoute:
        return const Color(0xFF2563EB);
      case _LiveWorkerStatus.arrived:
        return const Color(0xFFF59E0B);
      case _LiveWorkerStatus.inProgress:
        return const Color(0xFF16A34A);
      case _LiveWorkerStatus.unknown:
        return Colors.grey;
    }
  }

  String _statusLabel(_LiveWorkerStatus status) {
    switch (status) {
      case _LiveWorkerStatus.enRoute:
        return _txt('En Route', 'ගමන් මග', 'வழியில்');
      case _LiveWorkerStatus.arrived:
        return _txt('Arrived', 'පැමිණ ඇත', 'வந்துவிட்டார்');
      case _LiveWorkerStatus.inProgress:
        return _txt('In Progress', 'ක්‍රියාත්මකයි', 'நடந்து கொண்டிருக்கிறது');
      case _LiveWorkerStatus.unknown:
        return _txt('Updating', 'යාවත්කාලීන වෙමින්', 'புதுப்பிக்கப்படுகிறது');
    }
  }

  int _etaRemainingMinutes(_LiveTrackingSnapshot snapshot) {
    if (snapshot.status == _LiveWorkerStatus.arrived ||
        snapshot.status == _LiveWorkerStatus.inProgress) {
      return 0;
    }

    final etaMinutes = snapshot.etaMinutes ?? widget.submittedEtaMinutes;
    final etaUpdatedAt = snapshot.etaUpdatedAt;

    if (etaUpdatedAt == null) {
      return etaMinutes.clamp(0, 720);
    }

    final elapsed = _now.difference(etaUpdatedAt).inMinutes;
    final remaining = etaMinutes - elapsed;
    if (remaining < 0) return 0;
    return remaining;
  }

  void _openChat() {
    if (widget.chatId != null && widget.chatId!.isNotEmpty) {
      Navigator.of(context).push(
        MaterialPageRoute<void>(
          builder: (_) => ChatDetailScreen(
            theme: widget.theme,
            language: widget.language,
            chatId: widget.chatId!,
            workerId: widget.workerId,
            workerName: widget.workerName,
            jobTitle: widget.jobTitle,
            onBack: () => Navigator.of(context).pop(),
          ),
        ),
      );
      return;
    }

    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => ChatScreen(
          theme: widget.theme,
          language: widget.language,
          onBack: () => Navigator.of(context).pop(),
        ),
      ),
    );
  }

  void _showEmergencyOptions() {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: widget.theme.cardBackground,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (sheetContext) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _txt('Emergency Support', 'හදිසි සහාය', 'அவசர ஆதரவு'),
                  style: TextStyle(
                    color: widget.theme.textPrimary,
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  _txt(
                    'If you feel unsafe, contact emergency services immediately.',
                    'ඔබට අනාරක්ෂිත බවක් දැනෙනවා නම් වහාම හදිසි සේවා අමතන්න.',
                    'நீங்கள் பாதுகாப்பாக இல்லை என்று உணர்ந்தால் உடனே அவசர சேவையை அழைக்கவும்.',
                  ),
                  style: TextStyle(color: widget.theme.textSecondary),
                ),
                const SizedBox(height: 16),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: const Icon(Icons.local_police, color: Colors.red),
                  title: Text(
                    _txt(
                      'Call Police (119)',
                      'පොලිසිය අමතන්න (119)',
                      'போலீஸை அழைக்கவும் (119)',
                    ),
                  ),
                  onTap: () {
                    Navigator.of(sheetContext).pop();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          _txt(
                            'Call 119 now',
                            'දැන් 119 අමතන්න',
                            'இப்போது 119 ஐ அழைக்கவும்',
                          ),
                        ),
                      ),
                    );
                  },
                ),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: const Icon(
                    Icons.contact_phone,
                    color: Color(0xFF2563EB),
                  ),
                  title: Text(
                    _txt('Call Worker', 'සේවකයා අමතන්න', 'பணியாளரை அழைக்கவும்'),
                  ),
                  subtitle: Text(widget.workerPhone),
                  onTap: () {
                    Navigator.of(sheetContext).pop();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Calling ${widget.workerPhone}')),
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

  @override
  Widget build(BuildContext context) {
    final trackingStream = FirebaseFirestore.instance
        .collection('job_tracking')
        .doc(widget.bookingId)
        .snapshots();

    return Scaffold(
      backgroundColor: widget.theme.background,
      appBar: AppBar(
        backgroundColor: const Color(0xFF0B1533),
        foregroundColor: Colors.white,
        title: Text(
          _txt('Live Tracking', 'සජීවී අධීක්ෂණය', 'நேரடி கண்காணிப்பு'),
        ),
      ),
      body: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
        stream: trackingStream,
        builder: (context, snapshot) {
          final trackingData = _LiveTrackingSnapshot.fromDoc(
            snapshot.data,
            fallbackCustomer: LatLng(
              widget.customerLatitude,
              widget.customerLongitude,
            ),
          );

          final workerLatLng = trackingData.workerLatLng;
          final customerLatLng = trackingData.customerLatLng;
          final workerStatus = trackingData.status;
          final etaRemaining = _etaRemainingMinutes(trackingData);

          final markers = <Marker>{
            Marker(
              markerId: const MarkerId('customer'),
              position: customerLatLng,
              icon: BitmapDescriptor.defaultMarkerWithHue(
                BitmapDescriptor.hueRed,
              ),
              infoWindow: InfoWindow(
                title: _txt('Your Location', 'ඔබේ ස්ථානය', 'உங்கள் இடம்'),
              ),
            ),
          };

          if (workerLatLng != null) {
            markers.add(
              Marker(
                markerId: const MarkerId('worker'),
                position: workerLatLng,
                icon: BitmapDescriptor.defaultMarkerWithHue(
                  BitmapDescriptor.hueAzure,
                ),
                infoWindow: InfoWindow(
                  title: widget.workerName,
                  snippet: _statusLabel(workerStatus),
                ),
              ),
            );
          }

          final polylines = <Polyline>{};
          if (workerLatLng != null) {
            polylines.add(
              Polyline(
                polylineId: const PolylineId('route_line'),
                points: [workerLatLng, customerLatLng],
                width: 4,
                color: const Color(0xFF2563EB),
              ),
            );
          }

          return Column(
            children: [
              Expanded(
                child: GoogleMap(
                  initialCameraPosition: CameraPosition(
                    target: workerLatLng ?? customerLatLng,
                    zoom: 14,
                  ),
                  markers: markers,
                  polylines: polylines,
                  myLocationEnabled: false,
                  myLocationButtonEnabled: false,
                  zoomControlsEnabled: false,
                  onMapCreated: (controller) {
                    _mapController = controller;
                  },
                ),
              ),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
                decoration: BoxDecoration(
                  color: widget.theme.cardBackground,
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(20),
                  ),
                  border: Border(top: BorderSide(color: widget.theme.border)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            widget.workerName,
                            style: TextStyle(
                              color: widget.theme.textPrimary,
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: _statusColor(
                              workerStatus,
                            ).withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            _statusLabel(workerStatus),
                            style: TextStyle(
                              color: _statusColor(workerStatus),
                              fontWeight: FontWeight.w700,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Icon(Icons.schedule, color: widget.theme.primary),
                        const SizedBox(width: 8),
                        Text(
                          etaRemaining == 0
                              ? _txt(
                                  'Worker is nearby',
                                  'සේවකයා ආසන්නයේ ඇත',
                                  'பணியாளர் அருகில் உள்ளார்',
                                )
                              : _txt(
                                  'ETA: $etaRemaining min',
                                  'ETA: මිනිත්තු $etaRemaining',
                                  'ETA: $etaRemaining நிமிடங்கள்',
                                ),
                          style: TextStyle(
                            color: widget.theme.textPrimary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      _txt(
                        'Tracking source: Firestore job_tracking/${widget.bookingId}',
                        'අධීක්ෂණ මූලාශ්‍රය: Firestore job_tracking/${widget.bookingId}',
                        'கண்காணிப்பு ஆதாரம்: Firestore job_tracking/${widget.bookingId}',
                      ),
                      style: TextStyle(
                        color: widget.theme.textSecondary,
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: 14),
                    Row(
                      children: [
                        Expanded(
                          child: FilledButton.icon(
                            onPressed: _openChat,
                            icon: const Icon(Icons.chat_bubble_outline),
                            label: Text(_txt('Chat', 'චැට්', 'அரட்டை')),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: _showEmergencyOptions,
                            icon: const Icon(
                              Icons.sos_outlined,
                              color: Colors.red,
                            ),
                            label: Text(
                              _txt('SOS', 'SOS', 'SOS'),
                              style: const TextStyle(color: Colors.red),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

enum _LiveWorkerStatus { enRoute, arrived, inProgress, unknown }

class _LiveTrackingSnapshot {
  final LatLng? workerLatLng;
  final LatLng customerLatLng;
  final int? etaMinutes;
  final DateTime? etaUpdatedAt;
  final _LiveWorkerStatus status;

  const _LiveTrackingSnapshot({
    required this.workerLatLng,
    required this.customerLatLng,
    required this.etaMinutes,
    required this.etaUpdatedAt,
    required this.status,
  });

  static _LiveTrackingSnapshot fromDoc(
    DocumentSnapshot<Map<String, dynamic>>? doc, {
    required LatLng fallbackCustomer,
  }) {
    final data = doc?.data() ?? <String, dynamic>{};

    final workerLocation = data['workerLocation'];
    final customerLocation = data['customerLocation'];

    final workerLat =
        _readDouble(workerLocation, 'lat') ??
        _readDouble(workerLocation, 'latitude') ??
        _asDouble(data['workerLat']) ??
        _asDouble(data['workerLatitude']);
    final workerLng =
        _readDouble(workerLocation, 'lng') ??
        _readDouble(workerLocation, 'longitude') ??
        _asDouble(data['workerLng']) ??
        _asDouble(data['workerLongitude']);

    final customerLat =
        _readDouble(customerLocation, 'lat') ??
        _readDouble(customerLocation, 'latitude') ??
        _asDouble(data['customerLat']) ??
        _asDouble(data['customerLatitude']) ??
        fallbackCustomer.latitude;
    final customerLng =
        _readDouble(customerLocation, 'lng') ??
        _readDouble(customerLocation, 'longitude') ??
        _asDouble(data['customerLng']) ??
        _asDouble(data['customerLongitude']) ??
        fallbackCustomer.longitude;

    final rawStatus = (data['status'] ?? '').toString().toLowerCase();
    final status = switch (rawStatus) {
      'en_route' || 'enroute' || 'on_the_way' => _LiveWorkerStatus.enRoute,
      'arrived' => _LiveWorkerStatus.arrived,
      'in_progress' ||
      'inprogress' ||
      'working' => _LiveWorkerStatus.inProgress,
      _ => _LiveWorkerStatus.unknown,
    };

    final etaMinutes =
        _asInt(data['etaMinutes']) ?? _asInt(data['workerEtaMinutes']);

    final etaUpdatedAt =
        _asDateTime(data['etaUpdatedAt']) ??
        _asDateTime(data['updatedAt']) ??
        _asDateTime(data['lastLocationUpdate']);

    return _LiveTrackingSnapshot(
      workerLatLng: workerLat != null && workerLng != null
          ? LatLng(workerLat, workerLng)
          : null,
      customerLatLng: LatLng(customerLat, customerLng),
      etaMinutes: etaMinutes,
      etaUpdatedAt: etaUpdatedAt,
      status: status,
    );
  }

  static int? _asInt(dynamic value) {
    if (value is int) return value;
    if (value is double) return value.round();
    if (value is String) return int.tryParse(value);
    return null;
  }

  static double? _asDouble(dynamic value) {
    if (value is num) return value.toDouble();
    if (value is String) return double.tryParse(value);
    return null;
  }

  static DateTime? _asDateTime(dynamic value) {
    if (value is Timestamp) return value.toDate();
    if (value is DateTime) return value;
    if (value is String) return DateTime.tryParse(value);
    return null;
  }

  static double? _readDouble(dynamic mapValue, String key) {
    if (mapValue is Map<String, dynamic>) {
      return _asDouble(mapValue[key]);
    }
    return null;
  }
}
