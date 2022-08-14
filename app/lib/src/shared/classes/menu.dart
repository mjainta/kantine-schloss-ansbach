class Menu {
  const Menu({
    required this.id,
    required this.year,
    required this.calendarWeek,
    required this.imageAssetPath,
  });

  final String id;
  final int year;
  final int calendarWeek;
  final String imageAssetPath;
}
