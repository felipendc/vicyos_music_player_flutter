import 'package:flutter/services.dart';

// Set the preferred orientations to portrait mode when this screen is built
// Widget build(BuildContext context) {put it here...}

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

void screenOrientationLandscapeLeft() {
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.landscapeLeft,
  ]);
}

void screenOrientationLandscapeRight() {
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.landscapeRight,
  ]);
}
