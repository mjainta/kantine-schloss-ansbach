import 'dart:io';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import '../../../shared/classes/classes.dart';
import '../../../shared/providers/providers.dart';
import 'view.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final menus = ValueNotifier(MenuProvider.shared.menus);

  @override
  Widget build(BuildContext context) {
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
