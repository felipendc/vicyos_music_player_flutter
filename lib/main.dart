// ignore_for_file: avoid_print

import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:vicyos_music_player/app/common/color_extension.dart';
// import 'package:vicyos_music_player/app/view/home.view.dart';
import 'package:vicyos_music_player/app/controller/home.controller.dart';
import 'package:vicyos_music_player/app/view/main_player_view.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

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
      title: 'Music Player',
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
      // home: const AudioPlayerScreen(), MainPlayerView
      home: const MainPlayerView(),
    );
  }
}
