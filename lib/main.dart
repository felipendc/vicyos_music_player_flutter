import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
// import 'package:just_audio_background/just_audio_background.dart';
import 'package:vicyos_music_player/app/common/color_extension.dart';
import 'package:vicyos_music_player/app/controller/home.controller.dart';
import 'package:vicyos_music_player/app/view/home.page.folder.list.screen.dart';

// vicyos_music_player_flutter> flutter build apk --split-per-abi

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // await JustAudioBackground.init(
  //   androidNotificationChannelId: 'com.ryanheise.bg_demo.channel.audio',
  //   androidNotificationChannelName: 'Audio playback',
  //   androidNotificationOngoing: true,
  // );
  Get.put(HomeController());

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
    return GetMaterialApp(
      title: 'Vicyos Music Player',
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
