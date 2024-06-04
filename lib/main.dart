// ignore_for_file: avoid_print
// Run flutter clean in case of running this code in another computer.
// flutter run -d windows, if you are having problems to run this file.

import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:vicyos_music_player/app/view/home.view.dart';
import 'package:vicyos_music_player/app/controller/home.controller.dart';

void main() {
  Get.put(HomeController());
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const GetMaterialApp(
      home: AudioPlayerScreen(),
    );
  }
}
