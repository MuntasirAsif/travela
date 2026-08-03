// import 'package:intl/intl.dart';

// enum DateFormatType {
//   time12,
//   time24,
//   fullDate,
//   fullDateTime,
//   weekday,
//   shortWeekday,
//   monthYear,
//   dayMonth,
//   isoDate,
// }

// extension DateTimeFormatter on DateTime {
//   String format(DateFormatType type) {
//     return DateFormat(_pattern(type)).format(this);
//   }

//   String _pattern(DateFormatType type) {
//     switch (type) {
//       case DateFormatType.time12:
//         return 'hh:mm a';

//       case DateFormatType.time24:
//         return 'HH:mm';

//       case DateFormatType.fullDate:
//         return 'dd MMM yyyy';

//       case DateFormatType.fullDateTime:
//         return 'dd MMM yyyy, hh:mm a';

//       case DateFormatType.weekday:
//         return 'EEEE';

//       case DateFormatType.shortWeekday:
//         return 'EEE';

//       case DateFormatType.monthYear:
//         return 'MMM yyyy';

//       case DateFormatType.dayMonth:
//         return 'dd MMM';

//       case DateFormatType.isoDate:
//         return 'yyyy-MM-dd';
//     }
//   }
// }
