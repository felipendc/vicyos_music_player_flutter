import 'package:flutter/services.dart';

// Set the status bar and system navigation bar color to match the app theme
void systemStatusAndNavigationBarMainTheme() {
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Color(0xff181B2C),
      systemNavigationBarColor: Color(0xff181B2C),
      systemNavigationBarIconBrightness: Brightness.dark,
      statusBarIconBrightness: Brightness.light,
    ),
  );
}
