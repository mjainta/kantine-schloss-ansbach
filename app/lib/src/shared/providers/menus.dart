import 'dart:collection';
import 'dart:convert';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/material.dart';
import 'providers.dart';
import '../classes/classes.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'package:week_of_year/week_of_year.dart';

class MenuProvider {
  static MenuProvider get shared => MenuProvider();
  SplayTreeMap<String, Menu> get menus => _menus;
  SplayTreeMap<String, Menu> get showMenus => _showMenus;
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
        final String identifier = '${year}_$week';

        if (!_menus.containsKey(identifier)) {
          await downloadPhoto(link, year, week, id);
        }
      }
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load album');
    }

    _menus = await loadMenus();
    _showMenus = identifyShowMenus();

    return _showMenus;
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
    return file.path;
  }

  Future<SplayTreeMap<String, Menu>> initialLoad() async {
    _menus = await loadMenus();
    _showMenus = identifyShowMenus();
    return _showMenus;
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
      menus['${year}_$week'] = menu;
    }
    return menus;
  }

  SplayTreeMap<String, Menu> identifyShowMenus() {
    SplayTreeMap<String, Menu> showMenus = SplayTreeMap<String, Menu>();
    final today = DateTime.now();
    final nextWeek = DateTime.now().add(const Duration(days: 7));
    final String todayIdentifier = '${today.year}_${today.weekOfYear}';
    bool foundTodaysMenu = false;
    bool foundNextWeeksMenu = false;
    final String nextWeekIdentifier = '${nextWeek.year}_${nextWeek.weekOfYear}';

    _menus.forEach(
      (identifier, menu) {
        if (identifier == todayIdentifier) {
          showMenus[identifier] = menu;
          foundTodaysMenu = true;
        } else if (identifier == nextWeekIdentifier) {
          showMenus[identifier] = menu;
          foundNextWeeksMenu = true;
        }
      },
    );

    if (!foundTodaysMenu) {
      showMenus[todayIdentifier] = Menu(
        id: todayIdentifier,
        year: today.year,
        calendarWeek: today.weekOfYear,
      );
    }

    if (!foundNextWeeksMenu) {
      showMenus[nextWeekIdentifier] = Menu(
        id: nextWeekIdentifier,
        year: nextWeek.year,
        calendarWeek: nextWeek.weekOfYear,
      );
    }

    return showMenus;
  }
}

SplayTreeMap<String, Menu> _menus = SplayTreeMap<String, Menu>();
SplayTreeMap<String, Menu> _showMenus = SplayTreeMap<String, Menu>();

class MenusChange extends Notification {
  MenusChange({required this.menus});
  final SplayTreeMap<String, Menu> menus;
}
