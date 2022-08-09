import './classes.dart';

class Menu {
  const Menu({
    required this.title,
    required this.calendarWeek,
    required this.image,
  });

  final String title;
  final int calendarWeek;
  final MenuImage image;
}
