import 'package:flutter/material.dart';

PageRouteBuilder slideRightLeftTransition(Widget page) {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => page,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      const begin = Offset(1.0, 0.0); // Começa da direita
      const end = Offset.zero;
      const exitBegin = Offset.zero;
      const exitEnd = Offset(-1.0, 0.0); // Sai para a direita
      const curve = Curves.easeInOut;

      var enterTween =
          Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
      var exitTween =
          Tween(begin: exitBegin, end: exitEnd).chain(CurveTween(curve: curve));

      var offsetAnimation = animation.drive(enterTween);
      var exitAnimation = secondaryAnimation.drive(exitTween);

      return SlideTransition(
          position: offsetAnimation,
          child: SlideTransition(position: exitAnimation, child: child));
    },
  );
}
