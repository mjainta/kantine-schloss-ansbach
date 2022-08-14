import 'dart:io';

import 'package:app/src/shared/classes/classes.dart';
import 'package:path_provider/path_provider.dart';
import '../classes/classes.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class ImagesProvider {
  static ImagesProvider get shared => ImagesProvider();
  List<MenuImage> get images => _images;

  void createFromJson(Map<String, dynamic> json) async {
    final String link = json['link'];
    final String name = json['name'];
    final String id = json['id'];
    final nameSplitted = name.split(' ');
    final int year = int.parse(nameSplitted[1]);
    final int week = int.parse(nameSplitted[2].substring(2));

    String url =
        '${link}&access_token=EAAKjZAN43CO0BABnaLXsh33pc8pVtAlZB66B2WWAGfOoMZAOxvLhs1MM1Yl6GgEPFqgYcxNjztPoJrdcZBJy1qUYsM92lRAWmPe3shDhWpuKIBPwv28UN9gpM2vV3MrvZBTLkXCRZBnJM2Qjhccsb9Dng72HAOZAq6ZBVzPQX9NLjQF0OomEyu4sJYSKjFtXBq0KHCkT6XJxIwZDZD';
    http.Client client = new http.Client();
    var req = await client.get(Uri.parse(url));
    var bytes = req.bodyBytes;
    String dir = (await getApplicationDocumentsDirectory()).path;
    // Directory directory = new Directory(dir);
    // List<FileSystemEntity> syncList = directory.listSync();
    // for (var element in syncList) {
    //   print('loooopy');
    //   print(element.path);
    // }

    File file = new File('$dir/menus/${year}_${week}.jpg');
    await file.writeAsBytes(bytes);
    print(file.path);
    print(file.uri);
    print(file.parent);

    // final response = await http.get(Uri.parse(
    //     '${link}&access_token=EAAKjZAN43CO0BABnaLXsh33pc8pVtAlZB66B2WWAGfOoMZAOxvLhs1MM1Yl6GgEPFqgYcxNjztPoJrdcZBJy1qUYsM92lRAWmPe3shDhWpuKIBPwv28UN9gpM2vV3MrvZBTLkXCRZBnJM2Qjhccsb9Dng72HAOZAq6ZBVzPQX9NLjQF0OomEyu4sJYSKjFtXBq0KHCkT6XJxIwZDZD'));
    // print(response.body);
    // if (response.statusCode == 200) {
    //   // If the server did return a 200 OK response,
    //   // then parse the JSON.
    //   dynamic responseJson = jsonDecode(response.body);
    //   print(responseJson);
    //   // List<dynamic> photos = responseJson['photos']['data'];
    //   // print(photos[0]);
    //   // MenuImage image = MenuImage.fromJson(photos[0]);
    //   // print(image);
    // } else {
    //   // If the server did not return a 200 OK response,
    //   // then throw an exception.
    //   throw Exception('Failed to load album');
    // }
  }

  void loadImages() async {
    String dir = (await getApplicationDocumentsDirectory()).path;
    Directory directory = Directory(dir);
    List<FileSystemEntity> syncList = directory.listSync();
    for (var element in syncList) {
      print('loooopy');
      print(element.path);
    }
  }
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
