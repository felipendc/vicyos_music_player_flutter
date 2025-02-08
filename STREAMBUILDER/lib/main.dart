import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:path_provider/path_provider.dart';
import 'package:vicyos_music/app/common/color_extension.dart';
import 'package:vicyos_music/app/navigation_animation/some.screen.navigation.animation.dart';
import 'package:vicyos_music/app/status_bar_theme/status.bar.theme.color.matching.dart';
import 'package:vicyos_music/app/view/home.screen.dart';

import 'app/functions/music_player.dart';

// flutter clean; flutter pub get; flutter build apk --release

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await JustAudioBackground.init(
    androidNotificationChannelId: 'com.ryanheise.bg_demo.channel.audio',
    androidNotificationChannelName: 'Vicyos Music',
    androidNotificationOngoing: true,
  );

  await onInitPlayer();

  runApp(const MyApp());

// Set the status bar and system navigation bar color to match the app theme
  systemStatusAndNavigationBarMainTheme();
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    clearCache(); // Clears the cache when the app starts
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      clearCache(); // Clears the cache when the app goes to the background
    } else if (state == AppLifecycleState.resumed) {
      clearCache(); // Clears the cache when the app comes back to the foreground
    } else if (state == AppLifecycleState.detached) {
      clearCache(); // Clears the cache when the app is closed (detached)
    }
  }

  Future<void> clearCache() async {
    await DefaultCacheManager().emptyCache();
    final tempDir = await getTemporaryDirectory();
    if (tempDir.existsSync()) {
      tempDir.deleteSync(recursive: true);
      print("Cache cleared!");
    }
  }

  @override
  Widget build(BuildContext context) {
    final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop && navigatorKey.currentState!.canPop()) {
          navigatorKey.currentState!.pop();
        }
      },
      child: MaterialApp(
        title: 'Vicyos Music',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          fontFamily: "Circular Std",
          scaffoldBackgroundColor: TColor.bg,
          textTheme: Theme.of(context).textTheme.apply(
                bodyColor: TColor.primaryText,
                displayColor: TColor.primaryText,
              ),
          colorScheme: ColorScheme.fromSeed(
            brightness: Brightness.dark,
            seedColor: TColor.primary,
          ),
          useMaterial3: false,
        ),
        home: SplashScreen(),
      ),
    );
  }
}

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
