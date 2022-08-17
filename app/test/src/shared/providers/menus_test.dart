import 'package:http/testing.dart';
import 'package:schlosskantine/src/shared/providers/menus.dart';
import 'package:schlosskantine/src/shared/providers/facebook_api.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:http/http.dart' as http;
import 'dart:io' as io;

@GenerateMocks([http.Client])
void main() {
  group('downloadPhoto', () {
    test('does download successfully', () async {
      final client = MockClient(((request) async {
        expect(
            request.url,
            Uri.https('mylink.com',
                '/123&access_token=${FacebookApi.shared.accessToken}'));
        return http.Response('imagebody', 200);
      }));
      MenuProvider menuProvider = MenuProvider();
      menuProvider.setClient(client);

      final path = await menuProvider.downloadPhoto(
          'https://mylink.com/123', 2022, 31, '123abc');
      expect(true, await io.File(path).exists());
    });

    test('does throw on error', () async {
      final client = MockClient(((request) async {
        expect(
            request.url,
            Uri.https('mylink.com',
                '/123&access_token=${FacebookApi.shared.accessToken}'));
        return http.Response('Not Found', 404);
      }));
      MenuProvider menuProvider = MenuProvider();
      menuProvider.setClient(client);

      expect(
          () async => await menuProvider.downloadPhoto(
              'https://mylink.com/123', 2022, 31, '123abc'),
          throwsException);
    });
  });
}
