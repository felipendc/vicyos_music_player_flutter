import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:vicyos_music/app/functions/screen.orientation.dart';
import 'package:vicyos_music/app/navigation_animation/some.screen.navigation.animation.dart';
import 'package:vicyos_music/app/view/screens/home.screen.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Set the preferred orientations to portrait mode when this screen is built
    screenOrientationPortrait();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.delayed(const Duration(seconds: 3), () {
        Navigator.pushReplacement(
          context,
          splashFadeTransition(context, HomeScreen()),
        );
      });
    });

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              "assets/img/vicyos_logos/vicyos_music_icon_lable_transparent_bigger.png",
              width: 200,
              height: 200,
            ),
            const SizedBox(
              height: 30,
            ),
            Center(
              child: LoadingAnimationWidget.staggeredDotsWave(
                size: 60,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
