import 'dart:io';

import 'package:flutter/material.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:vicyos_music/app/common/color_palette/color_extension.dart';
import 'package:vicyos_music/app/common/music_player/music.player.dart';
import 'package:vicyos_music/app/common/screen_orientation/get_screen_size.dart';
import 'package:vicyos_music/app/common/screen_orientation/screen.orientation.dart';
import 'package:vicyos_music/app/common/splash_screen/splash.screen.dart';
import 'package:vicyos_music/app/common/status_bar_theme/status.bar.theme.color.matching.dart';
import 'package:window_size/window_size.dart' as window_size;

// flutter clean; flutter pub get; flutter build apk --release

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (Platform.isWindows) {
    const windowWidth = 1167.0;
    const windowHeight = 734.0;

    // Get the main window size
    final screen = await window_size.getScreenList();
    final screenFrame = screen.first.frame;

    // Calculate the center position
    final left = (screenFrame.width - windowWidth) / 2;
    final top = (screenFrame.height - windowHeight) / 2;

    // Define the window size and position
    window_size
        .setWindowFrame(Rect.fromLTWH(left, top, windowWidth, windowHeight));

    // Locks the window size (fixed)
    window_size.setWindowMinSize(const Size(windowWidth, windowHeight));
    window_size.setWindowMaxSize(const Size(windowWidth, windowHeight));
  }

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
    if (isNotSmartphoneScreenSize(context) && Platform.isWindows) {
      deviceType = DeviceType.isWindows;
    } else if (isNotSmartphoneScreenSize(context) && !Platform.isWindows) {
      deviceType = DeviceType.isTablet;
    } else {
      deviceType = DeviceType.isSmartphone;
    }

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
