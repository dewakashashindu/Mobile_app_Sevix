// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get bookings => 'Bookings';

  @override
  String get bids => 'Bids';

  @override
  String get accepted => 'Accepted';

  @override
  String get history => 'History';

  @override
  String get noBids => 'No active bids yet';

  @override
  String get noBidsDesc =>
      'Post a job request to start receiving bids from workers';

  @override
  String get accept => 'Accept';

  @override
  String get decline => 'Decline';

  @override
  String get jobs => 'jobs';

  @override
  String get estimatedTime => 'Estimated time';

  @override
  String get bidAcceptedWorkerWillContact =>
      'Bid accepted! Worker will contact you soon.';

  @override
  String get bidDeclined => 'Bid declined';

  @override
  String get bidAmount => 'Bid Amount';

  @override
  String get amount => 'Amount';

  @override
  String get noAccepted => 'No accepted bids';

  @override
  String get noAcceptedDesc =>
      'Bids you accept will appear here until work is completed';

  @override
  String get inProgress => 'In Progress';

  @override
  String get scheduled => 'Scheduled';

  @override
  String get contactWorker => 'Contact Worker';

  @override
  String get markComplete => 'Mark Complete';

  @override
  String get acceptedOn => 'Accepted on';

  @override
  String get scheduledFor => 'Scheduled for';

  @override
  String get workCompletedTitle => 'Work Completed?';

  @override
  String get workCompletedQuestion =>
      'Confirm that this work has been completed successfully?';

  @override
  String get cancel => 'Cancel';

  @override
  String get confirm => 'Confirm';

  @override
  String get bookingCompletedAddedHistory =>
      'Booking completed! Added to history.';

  @override
  String calling(Object phone) {
    return 'Calling: $phone';
  }

  @override
  String get noHistory => 'No booking history';

  @override
  String get noHistoryDesc =>
      'Your completed and cancelled bookings will appear here';

  @override
  String get completed => 'Completed';

  @override
  String get cancelled => 'Cancelled';

  @override
  String get totalAmount => 'Total Amount';

  @override
  String minutesAgo(int count) {
    return '${count}m ago';
  }

  @override
  String hoursAgo(int count) {
    return '${count}h ago';
  }

  @override
  String daysAgo(int count) {
    return '${count}d ago';
  }
}
