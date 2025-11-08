import 'package:flutter/material.dart';

PageRouteBuilder splashFadeTransition(BuildContext context, Widget page) {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) {
      return page; // The page that will be displayed after the transition
    },
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      const begin = 0.0;
      const end = 1.0;
      const curve = Curves.easeInOut;

      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
      var opacity = animation.drive(tween);

      return FadeTransition(
          opacity: opacity,
          child: child); // Applies the fade effect during the transition
    },
  );
}
