// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Tamil (`ta`).
class AppLocalizationsTa extends AppLocalizations {
  AppLocalizationsTa([String locale = 'ta']) : super(locale);

  @override
  String get bookings => 'முன்பதிவுகள்';

  @override
  String get bids => 'ஏலங்கள்';

  @override
  String get accepted => 'ஏற்றுக்கொள்ளப்பட்டது';

  @override
  String get history => 'வரலாறு';

  @override
  String get noBids => 'இன்னும் செயலில் உள்ள ஏலங்கள் இல்லை';

  @override
  String get noBidsDesc =>
      'தொழிலாளர்களிடமிருந்து ஏலங்களைப் பெற வேலை கோரிக்கையை இடுகையிடவும்';

  @override
  String get accept => 'ஏற்றுக்கொள்';

  @override
  String get decline => 'மறுக்கிறேன்';

  @override
  String get jobs => 'வேலைகள்';

  @override
  String get estimatedTime => 'மதிப்பிடப்பட்ட நேரம்';

  @override
  String get bidAcceptedWorkerWillContact =>
      'ஏலம் ஏற்றுக்கொள்ளப்பட்டது! பணியாளர் விரைவில் உங்களை தொடர்பு கொள்வார்.';

  @override
  String get bidDeclined => 'ஏலம் நிராகரிக்கப்பட்டது';

  @override
  String get bidAmount => 'ஏலத் தொகை';

  @override
  String get amount => 'தொகை';

  @override
  String get noAccepted => 'ஏற்றுக்கொள்ளப்பட்ட ஏலங்கள் இல்லை';

  @override
  String get noAcceptedDesc =>
      'நீங்கள் ஏற்றுக்கொள்ளும் ஏலங்கள் வேலை முடியும் வரை இங்கே தோன்றும்';

  @override
  String get inProgress => 'செயலில்';

  @override
  String get scheduled => 'திட்டமிடப்பட்டது';

  @override
  String get contactWorker => 'பணியாளரை தொடர்பு கொள்ளுங்கள்';

  @override
  String get markComplete => 'முடிந்ததாக குறிக்கவும்';

  @override
  String get acceptedOn => 'ஏற்றுக்கொள்ளப்பட்ட தேதி';

  @override
  String get scheduledFor => 'திட்டமிடப்பட்ட தேதி';

  @override
  String get workCompletedTitle => 'வேலை முடிந்ததா?';

  @override
  String get workCompletedQuestion =>
      'இந்த வேலை வெற்றிகரமாக முடிந்ததை உறுதிப்படுத்தவா?';

  @override
  String get cancel => 'ரத்து செய்';

  @override
  String get confirm => 'உறுதிப்படுத்து';

  @override
  String get bookingCompletedAddedHistory =>
      'முன்பதிவு முடிந்தது! வரலாற்றில் சேர்க்கப்பட்டது.';

  @override
  String calling(Object phone) {
    return 'அழைக்கிறது: $phone';
  }

  @override
  String get noHistory => 'முன்பதிவு வரலாறு இல்லை';

  @override
  String get noHistoryDesc =>
      'உங்கள் நிறைவு செய்யப்பட்ட மற்றும் ரத்து செய்யப்பட்ட முன்பதிவுகள் இங்கே தோன்றும்';

  @override
  String get completed => 'முடிந்தது';

  @override
  String get cancelled => 'ரத்து செய்யப்பட்டது';

  @override
  String get totalAmount => 'மொத்த தொகை';

  @override
  String minutesAgo(int count) {
    return '${count}m முன்';
  }

  @override
  String hoursAgo(int count) {
    return '${count}h முன்';
  }

  @override
  String daysAgo(int count) {
    return '${count}d முன்';
  }
}
