import 'package:flutter/material.dart';

class BottomFade extends StatelessWidget {
  const BottomFade({super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: 0,
      right: 0,
      bottom: 0,
      height: 140,
      child: IgnorePointer(
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.transparent,
                const Color(0xff181B2C).withValues(alpha: 0.28), // era 0.35
                const Color(0xff181B2C),
              ],
              stops: const [0.0, 0.55, 1.0],
            ),
          ),

          // decoration: BoxDecoration(
          //   gradient: LinearGradient(
          //     begin: Alignment.topCenter,
          //     end: Alignment.bottomCenter,
          //     colors: [
          //       Colors.transparent,
          //       const Color(0xff181B2C).withValues(alpha: 0.35),
          //       const Color(0xff181B2C),
          //     ],
          //     stops: const [0.0, 0.55, 1.0],
          //   ),
          // ),
        ),
      ),
    );
  }
}
