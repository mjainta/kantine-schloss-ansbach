import 'dart:collection';
import 'dart:convert';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/material.dart';
import 'providers.dart';
import '../classes/classes.dart';
import 'package:http/http.dart' as http;
import 'dart:io';

class MenuProvider {
  static MenuProvider get shared => MenuProvider();
  SplayTreeMap<String, Menu> get menus => _menus;
  String accessToken = FacebookApi.shared.accessToken;

  Future<SplayTreeMap<String, Menu>> refresh() async {
    final response = await http.get(Uri.parse(
        'https://graph.facebook.com/v14.0/100190636138269?fields=photos%7Bimages%2Cname%7D&access_token=${accessToken}'));

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      dynamic responseJson = jsonDecode(response.body);
      List<dynamic> photos = responseJson['photos']['data'];
      for (var photo in photos) {
        dynamic json = photo;
        final String link = json['images'][0]['source'];
        final String name = json['name'];
        final String id = json['id'];
        final nameSplitted = name.split(' ');
        final int year = int.parse(nameSplitted[1]);
        final int week = int.parse(nameSplitted[2].substring(2));

        String imagePath = await downloadPhoto(link, year, week, id);

        Menu menu = Menu(
          calendarWeek: week,
          year: year,
          imageAssetPath: imagePath,
          id: id,
        );
        // Menu menu = Menu.fromJson(photos[0]);
        print(menu);
      }
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load album');
    }
    _menus = await loadMenus();
    return _menus;
  }

  Future downloadPhoto(String link, int year, int week, String id) async {
    String url = '$link&access_token=$accessToken';
    http.Client client = http.Client();
    var req = await client.get(Uri.parse(url));
    var bytes = req.bodyBytes;
    String dir = (await getApplicationDocumentsDirectory()).path;

    File file = File('$dir/menus/${year}_${week}_$id.jpg');
    await file.create(recursive: true);
    await file.writeAsBytes(bytes);
    print('Photo downloaded into: ${file.path}');
    return file.path;
  }

  Future<SplayTreeMap<String, Menu>> loadMenus() async {
    SplayTreeMap<String, Menu> menus = SplayTreeMap<String, Menu>();
    String dir = (await getApplicationDocumentsDirectory()).path;
    Directory directory = Directory('$dir/menus');
    List<FileSystemEntity> syncList = directory.listSync();
    for (var element in syncList) {
      final filename = element.path.split('/').last;
      final filenameSplitted = filename.split('_');
      final int year = int.parse(filenameSplitted[0]);
      final int week = int.parse(filenameSplitted[1]);
      final String id = filenameSplitted[2];

      String imagePath = element.path;

      Menu menu = Menu(
        calendarWeek: week,
        year: year,
        imageAssetPath: imagePath,
        id: id,
      );
      print('Adding menu');
      print(menu);
      menus['${year}_$week'] = menu;
    }
    return menus;
  }
}

SplayTreeMap<String, Menu> _menus = SplayTreeMap<String, Menu>();

class MenusChange extends Notification {
  MenusChange({required this.menus});
  final SplayTreeMap<String, Menu> menus;
}
