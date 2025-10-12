import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

// Set the preferred orientations to portrait mode when this screen is built
// Widget build(BuildContext context) {put it here...}

enum DeviceType {
  isSmartphone,
  isTablet,
  isWindows,
}

late DeviceType deviceType;

void getScreenOrientation() {
  if (deviceType == DeviceType.isTablet || deviceType == DeviceType.isWindows) {
    screenOrientationLandscape();
    debugPrint("Device type: Tablet or Windows");
  } else {
    screenOrientationPortrait();
    debugPrint("Device type: Smartphone");
  }
}

void screenOrientationPortrait() {
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
}

void screenOrientationLandscape() {
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ]);
}
