import './classes.dart';
import '../providers/providers.dart';

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

  factory Menu.fromJson(Map<String, dynamic> json) {
    List<MenuImage> images = ImagesProvider.shared.images;
    final String link = json['link'];
    final String name = json['name'];
    final String id = json['id'];
    final nameSplitted = name.split(' ');
    final int year = int.parse(nameSplitted[1]);
    final int week = int.parse(nameSplitted[2].substring(2));
    ImagesProvider.shared.createFromJson(json);

    Menu menu = Menu(
      id: id,
      calendarWeek: week,
      year: year,
      imageAssetPath: 'mypath_changeme_PLEASE',
    );
    print('Generated Menu');
    print(menu);
    return menu;
  }
}
