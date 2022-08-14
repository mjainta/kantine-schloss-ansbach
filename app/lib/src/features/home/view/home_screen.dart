import 'dart:io';

import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import '../../../shared/classes/classes.dart';
import '../../../shared/providers/providers.dart';
import 'view.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key, required this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final menus = ValueNotifier(MenuProvider.shared.menus);
  // Menu? _menu;

  @override
  Widget build(BuildContext context) {
    // _menu ??= menus[0];

    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return LayoutBuilder(
      builder: (context, constraints) {
        return NotificationListener<MenusChange>(
          onNotification: (notification) {
            print('IM DONE WITH UPDATING MENUS');
            menus.value = notification.menus;
            return true;
          },
          child: ValueListenableBuilder<List<Menu>>(
            valueListenable: menus,
            builder: (context, value, child) {
              return DefaultTabController(
                length: value.length,
                child: Scaffold(
                  appBar: AppBar(
                    // Here we take the value from the HomeScreen object that was created by
                    // the App.build method, and use it to set our appbar title.
                    title: Text(widget.title),
                    leading: const RefreshMenusButton(),
                    actions: const [BrightnessToggle()],
                    bottom: TabBar(
                      tabs: buildImageTabs(value),
                    ),
                  ),
                  body: LayoutBuilder(
                    builder: (context, constraints) => TabBarView(
                      physics: const NeverScrollableScrollPhysics(),
                      children: buildImageViews(value),
                    ),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  List<Tab> buildImageTabs(List<Menu> menus) {
    List<Tab> tabs = [];

    for (var menu in menus) {
      String text = 'KW ${menu.calendarWeek}';
      tabs.add(
        Tab(text: text),
      );
    }

    return tabs;
  }

  List<Widget> buildImageViews(menus) {
    List<Widget> views = [];

    for (var menu in menus) {
      views.add(
        // InteractiveViewer(
        //   maxScale: 6,
        //   child: Image.asset(
        //     menu.image.sourceLink,
        //     fit: BoxFit.fitWidth,
        //   ),
        // ),
        OrientationBuilder(
          builder: (context, orientation) {
            var initialScale = orientation == Orientation.portrait
                ? PhotoViewComputedScale.contained
                : PhotoViewComputedScale.covered;
            var basePosition = orientation == Orientation.portrait
                ? Alignment.center
                : Alignment.topCenter;
            final theme = ThemeProvider.of(context).theme(context);
            return PhotoView(
              backgroundDecoration: BoxDecoration(color: theme.dividerColor),
              imageProvider: FileImage(File(menu.imageAssetPath)),
              basePosition: basePosition,
              initialScale: initialScale,
              minScale: PhotoViewComputedScale.contained,
              maxScale: PhotoViewComputedScale.covered * 2,
            );
          },
        ),
      );
    }

    return views;
  }
}
