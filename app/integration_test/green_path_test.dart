import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:path_provider/path_provider.dart';
import 'package:photo_view/photo_view.dart';
import 'package:schlosskantine/src/shared/app.dart';
import 'package:week_of_year/week_of_year.dart';

void main() {
  Future _prepareFiles({bool thisWeek = true, bool nextWeek = true}) async {
    String dir = (await getApplicationDocumentsDirectory()).path;
    Directory menusDirectory = Directory('$dir/menus');
    menusDirectory.createSync(recursive: true);

    if (thisWeek) {
      final thisWeek = DateTime.now();
      final String thisWeekIdentifier =
          '${thisWeek.year}_${thisWeek.weekOfYear}';
      String thisWeekFilePath = '$dir/menus/${thisWeekIdentifier}_123abc.jpg';
      final byteData1 = await rootBundle.load('assets/tests/menu_1.jpg');
      final fileMenu1 = File(thisWeekFilePath);
      await fileMenu1.writeAsBytes(byteData1.buffer
          .asUint8List(byteData1.offsetInBytes, byteData1.lengthInBytes));
    }

    if (nextWeek) {
      final nextWeek = DateTime.now().add(const Duration(days: 7));
      final String nextWeekIdentifier =
          '${nextWeek.year}_${nextWeek.weekOfYear}';
      String nextWeekFilePath = '$dir/menus/${nextWeekIdentifier}_456def.jpg';
      final byteData2 = await rootBundle.load('assets/tests/menu_2.jpg');
      final fileMenu2 = File(nextWeekFilePath);
      await fileMenu2.writeAsBytes(byteData2.buffer
          .asUint8List(byteData2.offsetInBytes, byteData2.lengthInBytes));
    }
  }

  testWidgets('Green path, both weeks pre-loaded', (WidgetTester tester) async {
    await _prepareFiles();
    await tester.pumpWidget(
      const App(),
    );
    // Check home page
    await tester.pumpAndSettle();
    expect(find.text('Schlosskantine Speisepläne'), findsOneWidget);
    expect(find.byType(PhotoView), findsOneWidget);

    final thisWeek = DateTime.now();
    expect(find.byKey(Key('cw_${thisWeek.weekOfYear}_tab')), findsOneWidget);

    final nextWeek = DateTime.now().add(const Duration(days: 7));
    expect(find.byKey(Key('cw_${nextWeek.weekOfYear}_tab')), findsOneWidget);

    // Move to next weeks home page
    await tester.tap(find.byKey(Key('cw_${nextWeek.weekOfYear}_tab')).first);
    await tester.pumpAndSettle();
    expect(find.byType(PhotoView), findsOneWidget);

    // Move to settings/info page
    await tester.tap(find.text('Schlosskantine Speisepläne').first);
    await tester.pumpAndSettle();
    expect(find.text('Info'), findsOneWidget);
    expect(
        find.text(
            'Ich freue mich, dass du diese App verwendest! Vielen Dank 😊'),
        findsOneWidget);
    expect(find.text('Made with ❤️ by mjainta '), findsOneWidget);
    expect(
        find.image(const AssetImage('assets/github_logo.jpg')), findsOneWidget);

    // Move back to the home page
    await tester.tap(find.byIcon(Icons.arrow_back));
    await tester.pumpAndSettle();
    expect(find.text('Schlosskantine Speisepläne'), findsOneWidget);
  });
}
