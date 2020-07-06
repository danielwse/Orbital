import 'package:intl/intl.dart';

String switchDays(i) {
  switch (i) {
    case '1':
      return 'Monday';
      break;
    case '2':
      return 'Tuesday';
      break;
    case '3':
      return 'Wednesday';
      break;
    case '4':
      return 'Thursday';
      break;
    case '5':
      return 'Friday';
      break;
    case '6':
      return 'Saturday';
      break;
    case '7':
      return 'Sunday';
      break;
    default:
      return '';
  }
}

String getIndex(DateTime dt){
  String i;
  switch (DateFormat('EEEE').format(dt).toString()) {
    case 'Monday': i = '1'; break;
    case 'Tuesday': i = '2'; break;
    case 'Wednesday': i = '3'; break;
    case 'Thursday': i = '4'; break;
    case 'Friday': i = '5'; break;
    case 'Saturday': i = '6'; break;
    case 'Sunday': i = '7'; break;
  }
  return i;
}