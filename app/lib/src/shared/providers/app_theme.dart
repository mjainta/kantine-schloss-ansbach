// import 'package:flutter/material.dart';

// class AppTheme {
//   static ThemeData lightTheme(ColorScheme? lightColorScheme) {
//     ColorScheme scheme = lightColorScheme ??
//         ColorScheme.fromSeed(
//           seedColor: const Color(0xFFF47C7C),
//         );
//     return ThemeData(
//       colorScheme: scheme,
//     );
//   }

//   static ThemeData darkTheme(ColorScheme? darkColorScheme) {
//     ColorScheme scheme = darkColorScheme ??
//         ColorScheme.fromSeed(
//           seedColor: const Color(0xFFF47C7C),
//           brightness: Brightness.dark,
//         );
//     return ThemeData(
//       colorScheme: scheme,
//     );
//   }
// }

// class ThemeSettingChange extends Notification {
//   ThemeSettingChange({required this.settings});
//   final ThemeSettings settings;
// }

// class ThemeSettings {
//   ThemeSettings({
//     required this.themeMode,
//   });

//   ThemeMode themeMode;
// }

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:material_color_utilities/material_color_utilities.dart';

class NoAnimationPageTransitionsBuilder extends PageTransitionsBuilder {
  const NoAnimationPageTransitionsBuilder();

  @override
  Widget buildTransitions<T>(
    PageRoute<T> route,
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    return child;
  }
}

class ThemeSettingChange extends Notification {
  ThemeSettingChange({required this.settings});
  final ThemeSettings settings;
}

class ThemeProvider extends InheritedWidget {
  const ThemeProvider(
      {super.key,
      required this.settings,
      required this.lightDynamic,
      required this.darkDynamic,
      required super.child});

  final ValueNotifier<ThemeSettings> settings;
  final ColorScheme? lightDynamic;
  final ColorScheme? darkDynamic;

  final pageTransitionsTheme = const PageTransitionsTheme(
    builders: <TargetPlatform, PageTransitionsBuilder>{
      TargetPlatform.android: FadeUpwardsPageTransitionsBuilder(),
      TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
      TargetPlatform.linux: NoAnimationPageTransitionsBuilder(),
      TargetPlatform.macOS: NoAnimationPageTransitionsBuilder(),
      TargetPlatform.windows: NoAnimationPageTransitionsBuilder(),
    },
  );

  Color custom(CustomColor custom) {
    if (custom.blend) {
      return blend(custom.color);
    } else {
      return custom.color;
    }
  }

  Color blend(Color targetColor) {
    return Color(
        Blend.harmonize(targetColor.value, settings.value.sourceColor.value));
  }

  Color source(Color? target) {
    Color source = settings.value.sourceColor;
    if (target != null) {
      source = blend(target);
    }
    return source;
  }

  ColorScheme colors(Brightness brightness, Color? targetColor) {
    // final dynamicPrimary = brightness == Brightness.light
    //     ? lightDynamic?.primary
    //     : darkDynamic?.primary;
    // return ColorScheme.fromSeed(
    //   seedColor: dynamicPrimary ?? source(targetColor),
    //   brightness: brightness,
    // );

    if (brightness == Brightness.light) {
      return const ColorScheme(
        brightness: Brightness.light,
        primary: Color(0xFF9B4051),
        onPrimary: Color(0xFFFFFFFF),
        primaryContainer: Color(0xFFFFD9DD),
        onPrimaryContainer: Color(0xFF400012),
        secondary: Color(0xFF9C4143),
        onSecondary: Color(0xFFFFFFFF),
        secondaryContainer: Color(0xFFFFDAD8),
        onSecondaryContainer: Color(0xFF410008),
        tertiary: Color(0xFFB6212C),
        onTertiary: Color(0xFFFFFFFF),
        tertiaryContainer: Color(0xFFFFDAD8),
        onTertiaryContainer: Color(0xFF410006),
        error: Color(0xFFBA1A1A),
        errorContainer: Color(0xFFFFDAD6),
        onError: Color(0xFFFFFFFF),
        onErrorContainer: Color(0xFF410002),
        background: Color(0xFFFFFBFF),
        onBackground: Color(0xFF410001),
        surface: Color(0xFFFFFBFF),
        onSurface: Color(0xFF410001),
        surfaceVariant: Color(0xFFF3DDDF),
        onSurfaceVariant: Color(0xFF524345),
        outline: Color(0xFF847374),
        onInverseSurface: Color(0xFFFFEDEA),
        inverseSurface: Color(0xFF5F150F),
        inversePrimary: Color(0xFFFFB2BC),
        shadow: Color(0xFF000000),
        surfaceTint: Color(0xFF9B4051),
      );
    } else {
      return const ColorScheme(
        brightness: Brightness.dark,
        primary: Color(0xFFFFB2BC),
        onPrimary: Color(0xFF5F1125),
        primaryContainer: Color(0xFF7D293B),
        onPrimaryContainer: Color(0xFFFFD9DD),
        secondary: Color(0xFFFFB3B1),
        onSecondary: Color(0xFF5F1319),
        secondaryContainer: Color(0xFF7E2A2D),
        onSecondaryContainer: Color(0xFFFFDAD8),
        tertiary: Color(0xFFFFB3AF),
        onTertiary: Color(0xFF68000E),
        tertiaryContainer: Color(0xFF930019),
        onTertiaryContainer: Color(0xFFFFDAD8),
        error: Color(0xFFFFB4AB),
        errorContainer: Color(0xFF93000A),
        onError: Color(0xFF690005),
        onErrorContainer: Color(0xFFFFDAD6),
        background: Color(0xFF410001),
        onBackground: Color(0xFFFFDAD5),
        surface: Color(0xFF410001),
        onSurface: Color(0xFFFFDAD5),
        surfaceVariant: Color(0xFF524345),
        onSurfaceVariant: Color(0xFFD7C1C3),
        outline: Color(0xFF9F8C8E),
        onInverseSurface: Color(0xFF410001),
        inverseSurface: Color(0xFFFFDAD5),
        inversePrimary: Color(0xFF9B4051),
        shadow: Color(0xFF000000),
        surfaceTint: Color(0xFFFFB2BC),
      );
    }
  }

  ShapeBorder get shapeMedium => RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      );

  CardTheme cardTheme() {
    return CardTheme(
      elevation: 0,
      shape: shapeMedium,
      clipBehavior: Clip.antiAlias,
    );
  }

  ListTileThemeData listTileTheme(ColorScheme colors) {
    return ListTileThemeData(
      shape: shapeMedium,
      selectedColor: colors.secondary,
    );
  }

  AppBarTheme appBarTheme(ColorScheme colors) {
    return AppBarTheme(
      elevation: 0,
      backgroundColor: colors.surface,
      foregroundColor: colors.onSurface,
    );
  }

  TabBarTheme tabBarTheme(ColorScheme colors) {
    return TabBarTheme(
      labelColor: colors.secondary,
      unselectedLabelColor: colors.onSurfaceVariant,
      indicator: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: colors.secondary,
            width: 2,
          ),
        ),
      ),
    );
  }

  BottomAppBarTheme bottomAppBarTheme(ColorScheme colors) {
    return BottomAppBarTheme(
      color: colors.surface,
      elevation: 0,
    );
  }

  BottomNavigationBarThemeData bottomNavigationBarTheme(ColorScheme colors) {
    return BottomNavigationBarThemeData(
      type: BottomNavigationBarType.fixed,
      backgroundColor: colors.surfaceVariant,
      selectedItemColor: colors.onSurface,
      unselectedItemColor: colors.onSurfaceVariant,
      elevation: 0,
      landscapeLayout: BottomNavigationBarLandscapeLayout.centered,
    );
  }

  NavigationRailThemeData navigationRailTheme(ColorScheme colors) {
    return const NavigationRailThemeData();
  }

  DrawerThemeData drawerTheme(ColorScheme colors) {
    return DrawerThemeData(
      backgroundColor: colors.surface,
    );
  }

  ThemeData light([Color? targetColor]) {
    final colorScheme = colors(Brightness.light, targetColor);
    return ThemeData.light().copyWith(
      // Add page transitions
      pageTransitionsTheme: pageTransitionsTheme,
      colorScheme: colorScheme,
      appBarTheme: appBarTheme(colorScheme),
      cardTheme: cardTheme(),
      listTileTheme: listTileTheme(colorScheme),
      bottomAppBarTheme: bottomAppBarTheme(colorScheme),
      bottomNavigationBarTheme: bottomNavigationBarTheme(colorScheme),
      navigationRailTheme: navigationRailTheme(colorScheme),
      tabBarTheme: tabBarTheme(colorScheme),
      drawerTheme: drawerTheme(colorScheme),
      scaffoldBackgroundColor: colorScheme.background,
      useMaterial3: true,
    );
  }

  ThemeData dark([Color? targetColor]) {
    final colorScheme = colors(Brightness.dark, targetColor);
    return ThemeData.dark().copyWith(
      // Add page transitions
      pageTransitionsTheme: pageTransitionsTheme,
      colorScheme: colorScheme,
      appBarTheme: appBarTheme(colorScheme),
      cardTheme: cardTheme(),
      listTileTheme: listTileTheme(colorScheme),
      bottomAppBarTheme: bottomAppBarTheme(colorScheme),
      bottomNavigationBarTheme: bottomNavigationBarTheme(colorScheme),
      navigationRailTheme: navigationRailTheme(colorScheme),
      tabBarTheme: tabBarTheme(colorScheme),
      drawerTheme: drawerTheme(colorScheme),
      scaffoldBackgroundColor: colorScheme.background,
      useMaterial3: true,
    );
  }

  ThemeMode themeMode() {
    return settings.value.themeMode;
  }

  ThemeData theme(BuildContext context, [Color? targetColor]) {
    final brightness = MediaQuery.of(context).platformBrightness;
    return brightness == Brightness.light
        ? light(targetColor)
        : dark(targetColor);
  }

  static ThemeProvider of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<ThemeProvider>()!;
  }

  @override
  bool updateShouldNotify(covariant ThemeProvider oldWidget) {
    return oldWidget.settings != settings;
  }
}

class ThemeSettings {
  ThemeSettings({
    required this.sourceColor,
    required this.themeMode,
  });

  final Color sourceColor;
  final ThemeMode themeMode;
}

Color randomColor() {
  return Color(Random().nextInt(0xFFFFFFFF));
}

// Custom Colors
const linkColor = CustomColor(
  name: 'Link Color',
  color: Color(0xFF00B0FF),
);

class CustomColor {
  const CustomColor({
    required this.name,
    required this.color,
    this.blend = true,
  });

  final String name;
  final Color color;
  final bool blend;

  Color value(ThemeProvider provider) {
    return provider.custom(this);
  }
}
