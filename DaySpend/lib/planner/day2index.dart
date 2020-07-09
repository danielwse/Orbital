import 'package:intl/intl.dart';
import 'package:random_string/random_string.dart';

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

int idCreator(DateTime dt) {
  String min = DateFormat('m').format(dt).toString();
  String hour = DateFormat('H').format(dt).toString();
  String day = DateFormat('d').format(dt).toString();
  String month = DateFormat('M').format(dt).toString();
  String year = DateFormat('y').format(dt).toString();
  if (day.length < 2) {
    day = "0" + day;
  }
  if (month.length < 2) {
    month = "0" + month;
  }
  String output = (year + month + day + hour + min);
  return int.parse(randomNumeric(5) + output);
}

String convertIndex(String index) {
  int currIndex = int.parse(getIndex(DateTime.now()));
  int n = currIndex - 1;
  int inputIndex = int.parse(index);
  int output = inputIndex - n;
  if (inputIndex <= n) {
    output += 7;
  }
  return output.toString();
}

String revertIndex(String index) {
  int currIndex = int.parse(getIndex(DateTime.now()));
  int n = currIndex - 1;
  int inputIndex = int.parse(index);
  int output = inputIndex + n;
  if (output > 7) {
    output -= 7;
  }
  return output.toString();
}