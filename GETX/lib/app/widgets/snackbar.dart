import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vicyos_music/app/common/color_extension.dart';
import 'package:vicyos_music/app/functions/folders.and.files.related.dart';

SnackbarController addPlaylistSnackbar({
  required String title,
  required String message,
}) =>
    Get.snackbar(
      songName(title), // title
      message, // message
      snackPosition: SnackPosition.TOP, // position of snackbar
      backgroundColor: TColor.focusSecondary,
      colorText: Colors.white,
      borderRadius: 10,
      margin: const EdgeInsets.all(10),
      duration:
          const Duration(seconds: 3), // how long the snackbar should be visible
      icon: const Icon(Icons.info, color: Colors.white),

      shouldIconPulse: true,
    );

SnackbarController bottomSheetPlaylistSnackbar({
  required String title,
  required String message,
}) =>
    Get.snackbar(
      songName(title), // title
      message, // message
      snackPosition: SnackPosition.TOP, // position of snackbar
      backgroundColor: TColor.focusSecondary,
      colorText: Colors.white,
      borderRadius: 10,
      margin: const EdgeInsets.all(10),
      duration:
          const Duration(seconds: 3), // how long the snackbar should be visible
      icon: const Icon(Icons.info, color: Colors.white),

      shouldIconPulse: true,
    );

SnackbarController repeatModeSnackbar(
        {required String message, required String iconePath}) =>
    Get.snackbar(
      "PLAYBACK MODE:", // title
      message, // message
      snackPosition: SnackPosition.TOP, // position of snackbar
      backgroundColor: TColor.focusSecondary,
      colorText: Colors.white,
      borderRadius: 10,
      margin: const EdgeInsets.all(10),
      duration:
          const Duration(seconds: 3), // how long the snackbar should be visible
      icon: Padding(
        padding: const EdgeInsets.only(left: 12, right: 6),
        child: Image.asset(
          iconePath,
          width: 26,
          height: 26,
          color: Colors.white,
        ),
      ),
      shouldIconPulse: true,
    );

SnackbarController playBackSpeedSnackbar({required String message}) =>
    Get.snackbar(
      "PLAYBACK SPEED:", // title
      message, // message
      snackPosition: SnackPosition.TOP, // position of snackbar
      backgroundColor: TColor.focusSecondary,
      colorText: Colors.white,
      borderRadius: 10,
      margin: const EdgeInsets.all(10),
      duration:
          const Duration(seconds: 3), // how long the snackbar should be visible
      icon: Padding(
        padding: const EdgeInsets.only(left: 12, right: 6),
        child: Image.asset(
          "assets/img/speed-fast.png",
          width: 26,
          height: 26,
          color: Colors.white,
        ),
      ),
      shouldIconPulse: true,
    );
