import 'providers.dart';
import '../classes/classes.dart';

class MenuProvider {
  static MenuProvider get shared => MenuProvider();
  List<Menu> get menus => _menus;
}

List<MenuImage> images = ImagesProvider.shared.images;

final _menus = <Menu>[
  Menu(
    title: 'Speiseplan',
    calendarWeek: 32,
    image: images[0],
  ),
  Menu(
    title: 'Speiseplan',
    calendarWeek: 33,
    image: images[1],
  ),
];
