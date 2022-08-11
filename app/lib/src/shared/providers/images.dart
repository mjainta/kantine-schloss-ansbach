import 'package:app/src/shared/classes/classes.dart';
import '../classes/classes.dart';

class ImagesProvider {
  static ImagesProvider get shared => ImagesProvider();
  List<MenuImage> get images => _images;
}

final _images = <MenuImage>[
  const MenuImage(
    image: 'Speiseplan KW32',
    sourceName: 'speiseplan_2022_32.png',
    sourceLink: 'assets/menus/menu_2022_cw31.jpg',
  ),
  const MenuImage(
    image: 'Speiseplan KW33',
    sourceName: 'speiseplan_2022_33.png',
    sourceLink: 'assets/menus/menu_2022_cw32.jpg',
  ),
];
