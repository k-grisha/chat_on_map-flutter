import 'package:intl/intl.dart';

class DateTimeUtil {
  //
// static String _defaultLocale = 'en_US';
//
// static String get defaultLocale {
//   var zoneLocale = Zone.current[#Intl.locale] as String;
//   return zoneLocale == null ? _defaultLocale : zoneLocale;
// }

  static String getFormattedDateTime(DateTime dateTime) {
    var now = DateTime.now();
    if (now.difference(dateTime).inDays < 1 || now.day == dateTime.day) {
      return DateFormat.Hm().format(dateTime);
    }
    return new DateFormat('d MMM').format(dateTime);
  }

  static String getFormattedTime(DateTime dateTime){
    return DateFormat.Hm().format(dateTime);
  }

}
