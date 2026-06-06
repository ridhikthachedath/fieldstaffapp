import 'package:intl/intl.dart';

class DateFormatter {
  static final DateFormat display = DateFormat('dd MMM yyyy');
  static final DateFormat displayLong = DateFormat('EEE, MMM dd, yyyy');
  static final DateFormat api = DateFormat('yyyy-MM-dd');
  static final DateFormat input = DateFormat('dd/MM/yyyy');
  static final DateFormat time = DateFormat('h:mm a');
  static final DateFormat monthYear = DateFormat('MMMM');

  static String formatDisplay(DateTime date) => display.format(date);
  static String formatApi(DateTime date) => api.format(date);
  static String formatInput(DateTime date) => input.format(date);
  static String formatMonth(DateTime date) => monthYear.format(date);
}
