import 'package:flutter/material.dart';
import 'package:vicyos_music/app/color_palette/color_extension.dart';
import 'package:vicyos_music/app/on_init_app/on.init.app.dart';
import 'package:vicyos_music/app/screen_orientation/is_tablet.dart';
import 'package:vicyos_music/app/screen_orientation/screen.orientation.dart';
import 'package:vicyos_music/app/splash_screen/splash.screen.dart';
import 'package:vicyos_music/app/status_bar_theme/status.bar.theme.color.matching.dart';
import 'package:vicyos_music/l10n/get_system_locale.dart';

import 'l10n/app_localizations.dart';

// flutter clean; flutter pub get; flutter build apk --release
// flutter gen-l10n

void main() async {
  systemStatusAndNavigationBarMainTheme();
  await onInitPlayer();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

    // Getting device type
    isTablet(context)
        ? deviceType = DeviceType.tablet
        : deviceType = DeviceType.smartphone;

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop && navigatorKey.currentState!.canPop()) {
          navigatorKey.currentState!.pop();
        }
      },
      child: MaterialApp(
        locale: getAppLocale(), // Set the app default language
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        title: "Vicyos Music",
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          fontFamily: "Circular Std",
          scaffoldBackgroundColor: TColor.bg,
          textTheme: Theme.of(context).textTheme.apply(
                bodyColor: TColor.primaryText,
                displayColor: TColor.primaryText,
              ),
          colorScheme: ColorScheme.fromSeed(
            brightness: Brightness.dark,
            seedColor: TColor.primary,
          ),
          useMaterial3: false,
        ),
        home: SplashScreen(),
      ),
    );
  }
}
