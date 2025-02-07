import 'package:flutter/material.dart';

PageRouteBuilder slideRightLeftTransition(Widget page) {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) =>
        page, // The page to be displayed after the transition
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      const begin = Offset(1.0, 0.0); // Starts from the right
      const end = Offset.zero; // Ends at the center
      const exitBegin = Offset.zero; // Start position for the exit animation
      const exitEnd = Offset(-1.0, 0.0); // Exits to the left
      const curve = Curves.easeInOut; // Smooth curve for the transition

      var enterTween = Tween(begin: begin, end: end)
          .chain(CurveTween(curve: curve)); // Tween for the entry animation
      var exitTween = Tween(begin: exitBegin, end: exitEnd)
          .chain(CurveTween(curve: curve)); // Tween for the exit animation

      var offsetAnimation =
          animation.drive(enterTween); // Drive the enter animation
      var exitAnimation =
          secondaryAnimation.drive(exitTween); // Drive the exit animation

      return SlideTransition(
          position: offsetAnimation, // Apply the entry transition
          child: SlideTransition(
              position: exitAnimation,
              child: child)); // Apply the exit transition
    },
  );
}
