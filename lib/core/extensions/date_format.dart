import 'package:intl/intl.dart';

extension FancyDateFormat on String {
  String toPrettyArabicDateTime() {
    try {
      // تحويل النص إلى DateTime
      final dateTime = DateFormat("yyyy-MM-dd hh:mm a").parse(this);

      // أسماء الشهور بالعربي
      const months = [
        "يناير", "فبراير", "مارس", "أبريل", "مايو", "يونيو",
        "يوليو", "أغسطس", "سبتمبر", "أكتوبر", "نوفمبر", "ديسمبر"
      ];

      final day = dateTime.day;
      final month = months[dateTime.month - 1];
      final year = dateTime.year;

      // تحويل الوقت لصيغة 24h أو 12h بشكل بسيط
      final hour = dateTime.hour == 0
          ? 12
          : (dateTime.hour > 12 ? dateTime.hour - 12 : dateTime.hour);

      final minute = dateTime.minute.toString().padLeft(2, '0');

      final period = dateTime.hour < 12 ? "صباحًا" : "مساءً";

      return " $day $month $year  $hour:$minute $period";
    } catch (e) {
      return this;
    }
  }
}