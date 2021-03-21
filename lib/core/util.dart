String dateFromString(DateTime date) {
 
  String formattedDate = date.day.toString() +
      '-' +
      date.month.toString() +
      '-' +
      date.year.toString();
  String hourString =
      (date.hour > 12 ? (date.hour - 12).toString() : date.hour.toString());
  if (date.hour < 10) hourString = '0' + hourString;
  String minuteString = (date.minute < 10
      ? '0' + date.minute.toString()
      : date.minute.toString());
  String amOrPm = (date.hour >= 12 ? 'PM' : 'AM');
  return formattedDate + ' - ' + hourString + ':' + minuteString + amOrPm;
}