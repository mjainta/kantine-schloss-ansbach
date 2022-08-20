import 'dart:collection';
import 'dart:math';

import 'package:file/file.dart';
import 'package:file/memory.dart';
import 'package:http/testing.dart';
import 'package:path_provider/path_provider.dart';
import 'package:schlosskantine_menu_app/src/shared/classes/menu.dart';
import 'package:schlosskantine_menu_app/src/shared/providers/menus.dart';
import 'package:schlosskantine_menu_app/src/shared/providers/facebook_api.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:week_of_year/week_of_year.dart';
import 'package:http/http.dart' as http;
import 'dart:io' as io;

@GenerateMocks([http.Client])
void main() {
  String _getFileIdentifier(int diffDays) {
    final date = DateTime.now().add(Duration(days: diffDays));
    String identifier = '${date.year}_${date.weekOfYear}';
    return identifier;
  }

  String _getFileName(int diffDays) {
    String fileName = '${_getFileIdentifier(diffDays)}_123abc.jpg';
    return fileName;
  }

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

  group('loadMenus', () {
    test('5 menus in the file system', () async {
      FileSystem fileSystem = MemoryFileSystem();
      var menuProviderUnderTest = MenuProvider(fileSystem: fileSystem);
      String testPath = '/menus';
      fileSystem.directory(testPath).createSync(recursive: true);
      fileSystem.file('/menus/2022_33_123abc.jpg').createSync();
      fileSystem.file('/menus/2022_34_123abc.jpg').createSync();
      fileSystem.file('/menus/2022_35_123abc.jpg').createSync();
      fileSystem.file('/menus/2022_36_123abc.jpg').createSync();
      fileSystem.file('/menus/2022_37_123abc.jpg').createSync();
      SplayTreeMap<String, Menu> menus =
          await menuProviderUnderTest.loadMenus(fromPath: testPath);

      expect(menus.length, 5);
    });

    test('directory does not exist', () async {
      FileSystem fileSystem = MemoryFileSystem();
      var menuProviderUnderTest = MenuProvider(fileSystem: fileSystem);
      String testPath = '/menus';
      SplayTreeMap<String, Menu> menus =
          await menuProviderUnderTest.loadMenus(fromPath: testPath);

      expect(menus.length, 0);
    });

    test('directory is empty', () async {
      FileSystem fileSystem = MemoryFileSystem();
      var menuProviderUnderTest = MenuProvider(fileSystem: fileSystem);
      String testPath = '/menus';
      fileSystem.directory(testPath).createSync(recursive: true);
      SplayTreeMap<String, Menu> menus =
          await menuProviderUnderTest.loadMenus(fromPath: testPath);

      expect(menus.length, 0);
    });
  });

  group('identifyShowMenus', () {
    test('both weeks exist', () async {
      FileSystem fileSystem = MemoryFileSystem();
      var menuProviderUnderTest = MenuProvider(fileSystem: fileSystem);
      String testPath = '/menus';
      fileSystem.directory(testPath).createSync(recursive: true);
      fileSystem.file('/menus/${_getFileName(-14)}').createSync();
      fileSystem.file('/menus/${_getFileName(-7)}').createSync();
      fileSystem.file('/menus/${_getFileName(0)}').createSync();
      fileSystem.file('/menus/${_getFileName(7)}').createSync();
      fileSystem.file('/menus/${_getFileName(14)}').createSync();

      SplayTreeMap<String, Menu> allMenus =
          await menuProviderUnderTest.loadMenus(fromPath: testPath);
      SplayTreeMap<String, Menu> showMenus =
          menuProviderUnderTest.identifyShowMenus(fromMenus: allMenus);

      expect(showMenus.length, 2);
      expect(showMenus[_getFileIdentifier(0)]?.imageAssetPath,
          '/menus/${_getFileName(0)}');
      expect(showMenus[_getFileIdentifier(7)]?.imageAssetPath,
          '/menus/${_getFileName(7)}');
    });

    test('no weeks exist', () async {
      FileSystem fileSystem = MemoryFileSystem();
      var menuProviderUnderTest = MenuProvider(fileSystem: fileSystem);

      SplayTreeMap<String, Menu> showMenus = menuProviderUnderTest
          .identifyShowMenus(fromMenus: SplayTreeMap<String, Menu>());

      expect(showMenus.length, 2);
      expect(showMenus[_getFileIdentifier(0)]?.imageAssetPath, null);
      expect(showMenus[_getFileIdentifier(7)]?.imageAssetPath, null);
    });

    test('only first week exists', () async {
      FileSystem fileSystem = MemoryFileSystem();
      var menuProviderUnderTest = MenuProvider(fileSystem: fileSystem);
      String testPath = '/menus';
      fileSystem.directory(testPath).createSync(recursive: true);
      fileSystem.file('/menus/${_getFileName(-14)}').createSync();
      fileSystem.file('/menus/${_getFileName(-7)}').createSync();
      fileSystem.file('/menus/${_getFileName(0)}').createSync();

      SplayTreeMap<String, Menu> allMenus =
          await menuProviderUnderTest.loadMenus(fromPath: testPath);
      SplayTreeMap<String, Menu> showMenus =
          menuProviderUnderTest.identifyShowMenus(fromMenus: allMenus);

      expect(showMenus.length, 2);
      expect(showMenus[_getFileIdentifier(0)]?.imageAssetPath,
          '/menus/${_getFileName(0)}');
      expect(showMenus[_getFileIdentifier(7)]?.imageAssetPath, null);
    });

    test('only second week exists', () async {
      FileSystem fileSystem = MemoryFileSystem();
      var menuProviderUnderTest = MenuProvider(fileSystem: fileSystem);
      String testPath = '/menus';
      fileSystem.directory(testPath).createSync(recursive: true);
      fileSystem.file('/menus/${_getFileName(-14)}').createSync();
      fileSystem.file('/menus/${_getFileName(-7)}').createSync();
      fileSystem.file('/menus/${_getFileName(7)}').createSync();

      SplayTreeMap<String, Menu> allMenus =
          await menuProviderUnderTest.loadMenus(fromPath: testPath);
      SplayTreeMap<String, Menu> showMenus =
          menuProviderUnderTest.identifyShowMenus(fromMenus: allMenus);

      expect(showMenus.length, 2);
      expect(showMenus[_getFileIdentifier(0)]?.imageAssetPath, null);
      expect(showMenus[_getFileIdentifier(7)]?.imageAssetPath,
          '/menus/${_getFileName(7)}');
    });
  });
}
