import 'package:flutter/material.dart';
import 'package:marquee/marquee.dart';

class MarqueeText extends StatelessWidget {
  final String text;
  final bool centerText;

  final TextStyle style;
  final double maxWidth;

  const MarqueeText({
    super.key,
    required this.centerText,
    required this.text,
    required this.style,
    required this.maxWidth,
  });

  @override
  Widget build(BuildContext context) {
    // Measure text width
    final textSpan = TextSpan(text: text, style: style);
    final textPainter = TextPainter(
      text: textSpan,
      maxLines: 1,
      textDirection: TextDirection.ltr,
    )..layout();

    // If text fits, center it. Otherwise, use Marquee.
    if (textPainter.width <= maxWidth) {
      return SizedBox(
        width: maxWidth, // Keeps alignment consistent
        child: Text(
          text,
          style: style,
          overflow: TextOverflow.ellipsis,
          textAlign: centerText ? TextAlign.center : TextAlign.start,
        ),
      );
    } else {
      return SizedBox(
        width: maxWidth,
        child: Marquee(
          fadingEdgeStartFraction: 0.1,
          fadingEdgeEndFraction: 0.1,
          showFadingOnlyWhenScrolling: true,
          text: text,
          style: style,
          scrollAxis: Axis.horizontal,
          blankSpace: 80.0,
          velocity: 40.0,
          pauseAfterRound: const Duration(seconds: 3),
          startPadding: 0,
          accelerationDuration: const Duration(seconds: 1),
          accelerationCurve: Curves.easeOutExpo,
          decelerationDuration: const Duration(milliseconds: 500),
          decelerationCurve: Curves.easeInBack,
          startAfter: Duration(seconds: 5),
        ),
      );
    }
  }
}
