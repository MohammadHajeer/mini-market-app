class Utils {
  bool isNumeric(String value) {
    final numericRegex = RegExp(r'^\d+(\.\d+)?$');
    return numericRegex.hasMatch(value);
  }

  String formatPrice(double price) {
    return convertNumberToArabic(price);
    // final formatter = NumberFormat("#,##0.##");
    // return price == price.toInt()
    //     ? formatter.format(price.toInt())
    //     : formatter.format(price);
  }

  String convertNumberToArabic(double number) {
    // Convert the number to an integer or keep it as a double based on the value
    String numberStr = number.toInt() == number ? number.toInt().toString() : number.toStringAsFixed(2);

    // Add commas for thousands, millions, etc.
    String formattedNumber = numberStr.replaceAllMapped(
      RegExp(r'\B(?=(\d{3})+(?!\d))'),
          (match) => ',',
    );

    // Define the Arabic numerals
    const arabicNumerals = ['٠', '١', '٢', '٣', '٤', '٥', '٦', '٧', '٨', '٩'];

    // Replace each Western numeral with the corresponding Arabic numeral
    String arabicNumberStr = formattedNumber.replaceAllMapped(
      RegExp(r'[0-9]'),
          (match) => arabicNumerals[int.parse(match.group(0)!)],
    );

    // Replace the Western decimal point with the Arabic decimal point
    arabicNumberStr = arabicNumberStr.replaceAll('.', '،');

    return arabicNumberStr;
  }

}
