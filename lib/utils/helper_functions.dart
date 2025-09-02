import 'package:intl/intl.dart';

class HelperFunctions {
  HelperFunctions._();
  // Add your helper functions here
 static String formatDateToMonthDay(DateTime date) {
    final DateFormat formatter = DateFormat('MMMM d');
    return formatter.format(date);
  }
}