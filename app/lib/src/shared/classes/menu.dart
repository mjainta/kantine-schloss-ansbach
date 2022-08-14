class Menu {
  Menu({
    required this.id,
    required this.year,
    required this.calendarWeek,
    this.imageAssetPath,
  });

  final String id;
  final int year;
  final int calendarWeek;
  String? imageAssetPath;

  String weekSpanString() {
    DateTime yearDate = DateTime(year);
    DateTime weekDate = yearDate.add(Duration(days: calendarWeek * 7));
    DateTime weekStartDate =
        yearDate.subtract(Duration(days: weekDate.weekday - 1));
    DateTime weekEndDate = yearDate
        .subtract(Duration(days: DateTime.daysPerWeek - weekDate.weekday));

    return '${weekStartDate.day}.${weekStartDate.month}.${weekStartDate.year} - ${weekEndDate.day}.${weekEndDate.month}.${weekEndDate.year}';
  }
}
