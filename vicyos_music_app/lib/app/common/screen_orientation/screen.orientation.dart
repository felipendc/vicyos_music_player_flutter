import 'package:flutter/services.dart';

// Set the preferred orientations to portrait mode when this screen is built
// Widget build(BuildContext context) {put it here...}

enum DeviceType {
  smartphone,
  tablet,
}

late DeviceType deviceType;


void getScreenOrientation() {

  if (deviceType == DeviceType.tablet){
    screenOrientationLandscape();
    print("Device type: Tablet");
  } else {
    screenOrientationPortrait();
    print("Device type: Smartphone");
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