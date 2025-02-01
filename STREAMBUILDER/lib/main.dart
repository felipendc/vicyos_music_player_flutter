import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:vicyos_music/app/common/color_extension.dart';
import 'package:vicyos_music/app/view/home.page.folder.list.screen.dart';

import 'app/functions/music_player.dart';

// flutter clean; flutter pub get; flutter build apk --release

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await JustAudioBackground.init(
    androidNotificationChannelId: 'com.ryanheise.bg_demo.channel.audio',
    androidNotificationChannelName: 'Vicyos Muzic',
    androidNotificationOngoing: true,
  );

  await onInitPlayer();

  runApp(const MyApp());

  // Set the status bar color to match the app theme
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors
        .transparent, // Set to transparent if you want the status bar to blend with the app
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
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
          seedColor: TColor.primary,
        ),
        useMaterial3: false,
      ),
      home: const HomePageFolderList(),
    );
  }
}
