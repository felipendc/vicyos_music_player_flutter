import 'package:flutter/material.dart';

class AuroraBar extends StatefulWidget {
  const AuroraBar({super.key, this.height = 6});
  final double height;

  @override
  State<AuroraBar> createState() => _AuroraBarState();
}

class _AuroraBarState extends State<AuroraBar>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final baseColors = const [
      Color(0xffD9519D),
      Color(0xff657DDF),
      Color(0xffED8770),
      Color(0xff0D47A1),
    ];

    return SizedBox(
      height: widget.height,
      width: double.infinity,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, _) {
          final t = _controller.value;
          final shift = (t * baseColors.length).floor();
          final localT = (t * baseColors.length) % 1;

          List<Color> animatedColors = List.generate(
            baseColors.length,
            (i) {
              final from = baseColors[(i + shift) % baseColors.length];
              final to = baseColors[(i + shift + 1) % baseColors.length];
              return Color.lerp(from, to, localT)!;
            },
          );

          return DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: animatedColors,
              ),
            ),
          );
        },
      ),
    );
  }
}

// USO:
// const AuroraBar(height: 8),
