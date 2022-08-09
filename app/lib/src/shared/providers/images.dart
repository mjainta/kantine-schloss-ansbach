import 'package:app/src/shared/classes/classes.dart';

import 'providers.dart';
import '../classes/classes.dart';

class ImagesProvider {
  static ImagesProvider get shared => ImagesProvider();
  List<MenuImage> get images => _images;
}

final _images = <MenuImage>[
  const MenuImage(
    image: 'Speiseplan KW32',
    sourceName: 'speiseplan_2022_32.png',
    sourceLink:
        'https://scontent-frt3-1.xx.fbcdn.net/v/t39.30808-6/296130818_100190229471643_2907289627164208554_n.jpg?_nc_cat=107&ccb=1-7&_nc_sid=0debeb&_nc_ohc=pwlXolabnMoAX8UUYJ0&_nc_ht=scontent-frt3-1.xx&oh=00_AT8rULQanz0X8GCtOKUXde-MqcZ9_y-0YlQmF5Tvl1miUQ&oe=62F7B9E2',
  ),
  const MenuImage(
    image: 'Speiseplan KW33',
    sourceName: 'speiseplan_2022_33.png',
    sourceLink:
        'https://scontent-frt3-2.xx.fbcdn.net/v/t39.30808-6/295959126_100190226138310_1630930600202112984_n.jpg?_nc_cat=109&ccb=1-7&_nc_sid=0debeb&_nc_ohc=fxp1dNpFTI8AX-6AXFU&tn=OWulbf_8iAhk97MV&_nc_ht=scontent-frt3-2.xx&oh=00_AT-v8w3Efc3cnC4AkAFaIXSFqnNj1LE0-MPS3UJowf7sTQ&oe=62F6A9B7',
  ),
];
