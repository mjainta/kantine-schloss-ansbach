import 'dart:convert';
import '../classes/classes.dart';
import 'package:http/http.dart' as http;

class MenuImage {
  const MenuImage(
      {required this.image,
      required this.sourceName,
      required this.sourceLink});

  final String image;
  final String sourceName;
  final String sourceLink;

  factory MenuImage.fromJson(Map<String, dynamic> json) {
    final String link = json['link'];
    final String name = json['name'];
    final String id = json['id'];
    final nameSplitted = name.split(' ');
    final int year = int.parse(nameSplitted[1]);
    final int week = int.parse(nameSplitted[2].substring(2));

    MenuImage image = MenuImage(
      image: id,
      sourceName: name,
      sourceLink: link,
    );
    print('Generated image');
    print(image);
    return image;
  }
}
