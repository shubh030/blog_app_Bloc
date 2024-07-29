import 'package:intl/intl.dart';

String formatingDateBydMMMYYYY(DateTime datetime) {
  return DateFormat("d MMM, yyyy").format(datetime);
}
