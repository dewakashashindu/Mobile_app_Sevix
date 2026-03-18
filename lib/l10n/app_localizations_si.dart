// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Sinhala Sinhalese (`si`).
class AppLocalizationsSi extends AppLocalizations {
  AppLocalizationsSi([String locale = 'si']) : super(locale);

  @override
  String get bookings => 'වෙන්කිරීම්';

  @override
  String get bids => 'ලංසු';

  @override
  String get accepted => 'පිළිගත්';

  @override
  String get history => 'ඉතිහාසය';

  @override
  String get noBids => 'තවමත් ක්‍රියාකාරී ලංසු නැත';

  @override
  String get noBidsDesc =>
      'සේවකයන්ගෙන් ලංසු ලැබීම ආරම්භ කිරීමට රැකියා ඉල්ලීමක් පළ කරන්න';

  @override
  String get accept => 'පිළිගන්න';

  @override
  String get decline => 'ප්‍රතික්ෂේප කරන්න';

  @override
  String get jobs => 'රැකියා';

  @override
  String get estimatedTime => 'ඇස්තමේන්තුගත කාලය';

  @override
  String get bidAcceptedWorkerWillContact =>
      'ලංසුව පිළිගන්නා ලදී! සේවකයා ඔබව ඉක්මනින් සම්බන්ධ කර ගනු ඇත.';

  @override
  String get bidDeclined => 'ලංසුව ප්‍රතික්ෂේප කරන ලදී';

  @override
  String get bidAmount => 'ලංසු මුදල';

  @override
  String get amount => 'මුදල';

  @override
  String get noAccepted => 'පිළිගත් ලංසු නැත';

  @override
  String get noAcceptedDesc =>
      'ඔබ පිළිගන්නා ලංසු වැඩ අවසන් වන තුරු මෙහි පෙන්වයි';

  @override
  String get inProgress => 'ප්‍රගතියෙන්';

  @override
  String get scheduled => 'සැලසුම් කළා';

  @override
  String get contactWorker => 'සේවකයා අමතන්න';

  @override
  String get markComplete => 'සම්පූර්ණ ලෙස සලකුණු කරන්න';

  @override
  String get acceptedOn => 'පිළිගත් දිනය';

  @override
  String get scheduledFor => 'සැලසුම් කළ දිනය';

  @override
  String get workCompletedTitle => 'වැඩ අවසන්ද?';

  @override
  String get workCompletedQuestion =>
      'මෙම වැඩ සාර්ථකව අවසන් වී ඇති බව තහවුරු කරන්නද?';

  @override
  String get cancel => 'අවලංගු කරන්න';

  @override
  String get confirm => 'තහවුරු කරන්න';

  @override
  String get bookingCompletedAddedHistory =>
      'වෙන්කිරීම සම්පූර්ණ කළා! ඉතිහාසයට එකතු කරන ලදි.';

  @override
  String calling(Object phone) {
    return 'අමතමින්: $phone';
  }

  @override
  String get noHistory => 'වෙන්කිරීම් ඉතිහාසයක් නැත';

  @override
  String get noHistoryDesc =>
      'ඔබගේ සම්පූර්ණ කළ සහ අවලංගු කළ වෙන්කිරීම් මෙහි පෙන්වයි';

  @override
  String get completed => 'සම්පූර්ණයි';

  @override
  String get cancelled => 'අවලංගු කළා';

  @override
  String get totalAmount => 'මුළු මුදල';

  @override
  String minutesAgo(int count) {
    return '${count}m පෙර';
  }

  @override
  String hoursAgo(int count) {
    return '${count}h පෙර';
  }

  @override
  String daysAgo(int count) {
    return '${count}d පෙර';
  }
}
