import 'package:intl/intl.dart';

class HelperFunctions {
  HelperFunctions._();
  // Add your helper functions here
 static String formatDateToMonthDay(DateTime date) {
    final DateFormat formatter = DateFormat('MMMM d');
    return formatter.format(date);
  }

 static String getFormattedDateTime(date) {

    final formatter = DateFormat("dd MMM, h:mm a");
    return formatter.format(date);
  }

  static String formatDate(DateTime date) {
    return DateFormat('d MMMM yyyy').format(date);
  }
}