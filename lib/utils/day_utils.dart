class DayUtils {
  ///Returns the name of the day based on the current weekday.
  static String get({int daysAhead = 0}) {
    DateTime now = DateTime.now();
    int dayNum = now.weekday + daysAhead;
    dayNum > 7 ? dayNum -= 7 : dayNum;
    switch (dayNum) {
      case 1:
        return 'Mon';
      case 2:
        return 'Tue';
      case 3:
        return 'Wed';
      case 4:
        return 'Thu';
      case 5:
        return 'Fri';
      case 6:
        return 'Sat';
      case 7:
        return 'Sun';
      default:
        return '';
    }
  }
///Returns the path to an image based on the time of day.
  static String getImage() {
    DateTime now = DateTime.now();
    int hour = now.hour;
    if (hour < 6 || hour >= 18) {
      return 'images/night.gif';
    } else {
      return 'images/day.gif';
    }
  }
}
