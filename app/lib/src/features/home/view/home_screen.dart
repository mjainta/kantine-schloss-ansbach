import 'package:flutter/material.dart';
import '../../../shared/classes/classes.dart';
import '../../../shared/providers/providers.dart';

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
  List<Menu> _menus = MenuProvider().menus;
  int _menuCursor = 0;
  Menu? _menu;

  void _switchImage() {
    setState(() {
      _menuCursor = _menuCursor == 0 ? 1 : 0;
      _menu = _menus[_menuCursor];
    });
  }

  @override
  Widget build(BuildContext context) {
    _menu ??= _menus[0];

    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return LayoutBuilder(
      builder: (context, constraints) {
        return DefaultTabController(
            length: _menus.length,
            child: Scaffold(
              appBar: AppBar(
                // Here we take the value from the HomeScreen object that was created by
                // the App.build method, and use it to set our appbar title.
                title: Text(widget.title),
                bottom: TabBar(
                  tabs: buildImageTabs(_menus),
                ),
              ),
              body: LayoutBuilder(
                builder: (context, constraints) => TabBarView(
                  children: buildImageViews(_menus),
                ),
              ),
            ));
      },
    );
  }

  List<Tab> buildImageTabs(List<Menu> menus) {
    List<Tab> tabs = [];

    for (var menu in menus) {
      String text = 'KW ' + menu.calendarWeek.toString();
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
        SingleChildScrollView(
          child: Image.network(
            menu.image.sourceLink,
            fit: BoxFit.fitWidth,
          ),
        ),
      );
    }

    return views;
  }
}
