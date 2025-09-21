import "package:flutter/material.dart";
import "package:vicyos_music/app/is_tablet/functions/music_player.dart";

// IMPORTANT NOTE:
// This music_visualizer was created by Rajkumar07793,
// Original link: https://github.com/Rajkumar07793/music_visualizer_package

// The error: '_debugLifecycleState != _ElementLifecycle.defunct': is not true error
// was fixed thanks to https://github.com/AsjadSiddiqui

// I've just applied the fix and adapted it to my music app.

class MusicVisualizer extends StatelessWidget {
  final List<Color>? colors;
  final List<int>? duration;
  final int? barCount;
  final Curve? curve;

  const MusicVisualizer({
    super.key,
    @required this.colors,
    @required this.duration,
    @required this.barCount,
    this.curve = Curves.easeInQuad,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: List<Widget>.generate(
            barCount!,
            (index) => VisualComponent(
                curve: curve!,
                duration: duration![index % 5],
                color: colors![index % 4])));
  }
}

class VisualComponent extends StatefulWidget {
  final int? duration;
  final Color? color;
  final Curve? curve;

  const VisualComponent(
      {super.key,
      @required this.duration,
      @required this.color,
      @required this.curve});

  @override
  VisualComponentState createState() => VisualComponentState();
}

class VisualComponentState extends State<VisualComponent>
    with SingleTickerProviderStateMixin {
  Animation<double>? animation;
  Animation<double>? animationStop;
  AnimationController? animationController;

  @override
  void initState() {
    super.initState();
    animate();
  }

  @override
  void dispose() {
    animation!.removeListener(() {});
    animation!.removeStatusListener((status) {});
    animationController!.stop();
    animationController!.reset();
    animationController!.dispose();
    super.dispose();
  }

  void animate() {
    animationController = AnimationController(
        duration: Duration(milliseconds: widget.duration!), vsync: this);
    final curvedAnimation =
        CurvedAnimation(parent: animationController!, curve: widget.curve!);

    animation = Tween<double>(begin: 0, end: 50).animate(curvedAnimation)
      ..addListener(() {
        update();
      });

    animationStop = Tween<double>(begin: 10, end: 20).animate(curvedAnimation)
      ..addListener(() {
        update();
      });

    animationController!.repeat(reverse: true);
  }

  void update() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if (mounted) setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 3,
      height: audioPlayer.playing ? animation!.value : animationStop!.value,
      decoration: BoxDecoration(
          color: widget.color, borderRadius: BorderRadius.circular(5)),
    );
  }
}
