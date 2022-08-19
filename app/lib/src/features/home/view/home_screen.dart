import 'dart:collection';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
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
  final menus = ValueNotifier(MenuProvider.shared.showMenus);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return NotificationListener<MenusChange>(
          onNotification: (notification) {
            menus.value = notification.menus;
            return true;
          },
          child: ValueListenableBuilder<SplayTreeMap<String, Menu>>(
            valueListenable: menus,
            builder: (context, value, child) {
              if (value.isEmpty) {
                Future<SplayTreeMap<String, Menu>> future =
                    MenuProvider.shared.initialLoad();
                future.then((menus) {
                  bool needRefresh = false;

                  for (var menu in menus.values) {
                    if (menu.imageAssetPath == null) {
                      needRefresh = true;
                    }
                  }

                  if (needRefresh) {
                    Future<SplayTreeMap<String, Menu>> future =
                        MenuProvider.shared.refresh();
                    future.then(
                        (menus) => MenusChange(menus: menus).dispatch(context));
                  } else {
                    MenusChange(menus: menus).dispatch(context);
                  }
                });
                // Display message when no menu is there, yet
                return Scaffold(
                  appBar: AppBar(
                    title: GestureDetector(
                      child: Text(widget.title),
                      onTap: () {
                        return GoRouter.of(context).go('/settings');
                      },
                    ),
                    actions: const [BrightnessToggle()],
                  ),
                  body: LayoutBuilder(
                    builder: (context, constraints) => Center(
                      child: Container(
                        padding: const EdgeInsets.all(64),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Text(
                              'Prüfe nach neuen Speiseplänen...',
                              textScaleFactor: 1.3,
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(
                              height: 32,
                            ),
                            CircularProgressIndicator(),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              } else {
                return DefaultTabController(
                  length: value.length,
                  child: Scaffold(
                    appBar: AppBar(
                      title: GestureDetector(
                        child: Text(widget.title),
                        onTap: () {
                          return GoRouter.of(context).go('/settings');
                        },
                      ),
                      actions: const [BrightnessToggle()],
                      bottom: TabBar(
                        labelStyle: GoogleFonts.montserrat(),
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
              }
            },
          ),
        );
      },
    );
  }

  List<Tab> buildImageTabs(SplayTreeMap<String, Menu> menus) {
    List<Tab> tabs = [];

    for (var menu in menus.values) {
      String text = 'KW ${menu.calendarWeek}';
      // String text = menu.weekSpanString();
      tabs.add(
        Tab(
          text: text,
          key: Key('cw_${menu.calendarWeek}_tab'),
        ),
      );
    }

    return tabs;
  }

  List<Widget> buildImageViews(SplayTreeMap<String, Menu> menus) {
    List<Widget> views = [];

    for (var menu in menus.values) {
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
            final image = menu.imageAssetPath != null
                ? FileImage(File(menu.imageAssetPath ?? ''))
                : Image.asset(
                    'assets/hungry_cat.png',
                  ).image;
            if (menu.imageAssetPath == null) {
              return Container(
                decoration: BoxDecoration(color: theme.dividerColor),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image(
                      image: Image.asset('assets/hungry_cat.png').image,
                      fit: BoxFit.scaleDown,
                      height: MediaQuery.of(context).size.height * 0.2,
                    ),
                    const SizedBox(
                      height: 32,
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 0),
                      child: const Text(
                        'Kein Speiseplan für diese Woche vorhanden.',
                        textScaleFactor: 1.3,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              );
            }

            return PhotoView(
              backgroundDecoration: BoxDecoration(color: theme.dividerColor),
              imageProvider: image,
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
