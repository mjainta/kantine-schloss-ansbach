import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../features/home/home.dart';

class App extends StatefulWidget {
  App({Key? key}) : super(key: key);

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  final GoRouter _router = GoRouter(
    routes: <GoRoute>[
      GoRoute(
        path: '/',
        builder: (context, state) =>
            const HomeScreen(title: 'Kantine Ansbach Speisepläne'),
      ),
    ],
  );

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routeInformationProvider: _router.routeInformationProvider,
      routeInformationParser: _router.routeInformationParser,
      routerDelegate: _router.routerDelegate,
      title: 'Kantine Ansbach Speisepläne App',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
    );
  }
}
