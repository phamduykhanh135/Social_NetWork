import 'package:intl/intl.dart';
import '../app/time_messages.dart'; // Import lớp TimeMessages

class DateTimeUtils {
  static String timeAgo(DateTime? dateTime) {
    if (dateTime == null) {
      return TimeMessages.unknownTime; // Sử dụng chuỗi từ TimeMessages
    }

    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inSeconds < 60) {
      return TimeMessages.justNow; // Sử dụng chuỗi từ TimeMessages
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}${TimeMessages.minuteAgo}'; // Sử dụng chuỗi từ TimeMessages
    } else if (difference.inHours < 24) {
      return '${difference.inHours}${TimeMessages.hourAgo}'; // Sử dụng chuỗi từ TimeMessages
    } else if (difference.inDays < 7) {
      return '${difference.inDays}${TimeMessages.dayAgo}'; // Sử dụng chuỗi từ TimeMessages
    } else {
      return DateFormat('yyyy-MM-dd').format(dateTime);
    }
  }
}
