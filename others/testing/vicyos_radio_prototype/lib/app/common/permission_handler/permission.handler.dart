import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:permission_handler/permission_handler.dart';
// String internalStorage = '/storage/emulated/0/Music/';



Future<void> requestAudioPermission() async {
  Permission permission;

  // Determine which permission to request based on Android version
  if (!kIsWeb && Platform.isAndroid) {
    int sdkInt = await _getAndroidSdkInt();

    if (sdkInt >= 33) {
      // Android 13+ requires READ_MEDIA_AUDIO
      permission = Permission.audio;
    } else {
      // Android 12 and below
      permission = Permission.storage;
    }
  } else {
    // iOS or web fallback
    permission = Permission.storage;
  }

  // Check current permission status
  var status = await permission.status;
  debugPrint("Current permission status: $status");

  // Request permission if not granted
  if (!status.isGranted) {
    status = await permission.request();
  }

  // If permanently denied, open the app permission settings
  if (status.isPermanentlyDenied) {
    debugPrint("Permission permanently denied, opening app settings...");
    await openAppSettings();
  }

}

// Function to get Android SDK version
Future<int> _getAndroidSdkInt() async {
  try {
    final result = await Process.run('getprop', ['ro.build.version.sdk']);
    if (result.exitCode == 0) {
      return int.tryParse(result.stdout.toString().trim()) ?? 0;
    }
  } catch (e) {
    debugPrint("Error getting Android SDK: $e");
  }
  return 0;
}
