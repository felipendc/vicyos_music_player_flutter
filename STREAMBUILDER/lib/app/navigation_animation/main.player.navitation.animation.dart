import 'package:flutter/material.dart';

PageRouteBuilder slideUpDownTransition(Widget page) {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => page,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      const begin = Offset(0.0, 1.0); // Começa de baixo para cima
      const end = Offset.zero;
      const exitBegin = Offset.zero;
      const exitEnd = Offset(0.0, 1.0); // Sai deslizando para baixo
      const curve = Curves.easeOut;

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
