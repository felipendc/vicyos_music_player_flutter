import 'package:flutter/material.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:vicyos_music/app/common/color_palette/color_extension.dart';
import 'package:vicyos_music/app/common/music_player/music.player.dart';
import 'package:vicyos_music/app/common/screen_orientation/is_tablet.dart';
import 'package:vicyos_music/app/common/screen_orientation/screen.orientation.dart';
import 'package:vicyos_music/app/common/status_bar_theme/status.bar.theme.color.matching.dart';
import 'package:vicyos_music/app/common/splash_screen/splash.screen.dart';

// flutter clean; flutter pub get; flutter build apk --release

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await JustAudioBackground.init(
    androidNotificationChannelId: 'com.ryanheise.bg_demo.channel.audio',
    androidNotificationChannelName: 'Vicyos Music',
    androidNotificationOngoing: true,
  );

  await onInitPlayer();

  runApp(const MyApp());

// Set the status bar and system navigation bar color to match the app theme
  systemStatusAndNavigationBarMainTheme();

}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

    // Getting device type
    isTablet(context) ? deviceType = DeviceType.tablet : deviceType = DeviceType.smartphone;


    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop && navigatorKey.currentState!.canPop()) {
          navigatorKey.currentState!.pop();
        }
      },
      child: MaterialApp(
        title: 'Vicyos Music',
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
