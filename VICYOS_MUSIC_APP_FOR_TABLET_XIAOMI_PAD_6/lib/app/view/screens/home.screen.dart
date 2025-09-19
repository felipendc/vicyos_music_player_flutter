import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:vicyos_music/app/functions/screen.orientation.dart';
import 'package:vicyos_music/app/view/screens/screen.list.song.folders.dart';

import '../../functions/music_player.dart';
import '../../widgets/bottom.player.dart';
import 'main.player.view.screen.dart' show MainPlayerView;

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  final GlobalKey<NavigatorState> navigatorKey2 = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    // Set the preferred orientations to landscape mode when this screen is built
    screenOrientationLandscape();

    return PopScope(
      canPop: false, // Prevents back navigation
      onPopInvokedWithResult: (_, __) async {
        // If there are no more screens in the navigation stack (on the home screen), close the app
        if (!navigatorKey.currentState!.canPop()) {
          // Here, we close the app with SystemNavigator.pop()
          SystemNavigator.pop();
        } else {
          // Otherwise, just go back to the previous screen
          navigatorKey.currentState!.pop();

        }
      },
      child: Scaffold(
        body: Row(
          children: [
            Expanded(
              flex: 1,
              child: Navigator(
                key: navigatorKey,
                onGenerateRoute: (RouteSettings settings) {
                  return MaterialPageRoute(
                    builder: (context) {
                      return HomePageFolderList();
                    },
                  );
                },
              ),
            ),

            Expanded(
              flex: 1,
              child: Navigator(
                key: navigatorKey2,
                onGenerateRoute: (RouteSettings settings) {
                  return MaterialPageRoute(
                    builder: (context) {
                      return MainPlayerView();
                    },
                  );
                },
              ),
            ),

          ],
        ),
      ),
    );
  }
}