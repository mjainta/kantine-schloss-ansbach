import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../features/home/home.dart';
import 'providers/app_theme.dart';

class App extends StatefulWidget {
  const App({Key? key}) : super(key: key);

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
  final settings = ValueNotifier(ThemeSettings(
    sourceColor: Color.fromARGB(72, 236, 11, 11),
    themeMode: ThemeMode.system,
  ));

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return DynamicColorBuilder(
      builder: (ColorScheme? lightDynamic, ColorScheme? darkDynamic) =>
          ThemeProvider(
        lightDynamic: lightDynamic,
        darkDynamic: darkDynamic,
        settings: settings,
        child: NotificationListener<ThemeSettingChange>(
          onNotification: (notification) {
            settings.value = notification.settings;
            return true;
          },
          child: ValueListenableBuilder<ThemeSettings>(
            valueListenable: settings,
            builder: (context, value, _) {
              final theme = ThemeProvider.of(context);
              print('Building DynamicColorBuilder');
              print(theme.lightDynamic?.primary.toString());
              return MaterialApp.router(
                routeInformationProvider: _router.routeInformationProvider,
                routeInformationParser: _router.routeInformationParser,
                routerDelegate: _router.routerDelegate,
                title: 'Kantine Ansbach Speisepläne App',
                theme: theme.light(settings.value.sourceColor),
                darkTheme: theme.dark(settings.value.sourceColor),
                themeMode: theme.themeMode(),
              );
            },
          ),
        ),
      ),
    );
  }
}
