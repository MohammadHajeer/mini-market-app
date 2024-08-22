import 'package:intl/intl.dart';

class Utils {
  bool isNumeric(String value) {
    final numericRegex = RegExp(r'^\d+(\.\d+)?$');
    return numericRegex.hasMatch(value);
  }

  String formatPrice(double price) {
    final formatter = NumberFormat("#,##0.##");
    return price == price.toInt()
        ? formatter.format(price.toInt())
        : formatter.format(price);
  }
}
