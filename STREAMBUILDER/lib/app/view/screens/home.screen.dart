import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:vicyos_music/app/functions/screen.orientation.dart';
import 'package:vicyos_music/app/view/screens/screen.list.song.folders.dart';

import '../../functions/music_player.dart';
import '../../widgets/bottom.player.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    // Set the preferred orientations to portrait mode when this screen is built
    screenOrientationPortrait();

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
        body: Stack(
          children: [
            Navigator(
              key: navigatorKey,
              onGenerateRoute: (RouteSettings settings) {
                return MaterialPageRoute(
                  builder: (context) {
                    return HomePageFolderList(
                      key: homePageFolderListScreenKey,
                    );
                  },
                );
              },
            ),
            StreamBuilder<bool>(
              stream: hideButtonSheetStreamController.stream,
              builder: (context, snapshot) {
                final hideMiniPlayer = snapshot.data ?? false;
                if (hideMiniPlayer || isSongPreviewBottomSheetOpen) {
                  return Container();
                } else {
                  return FutureBuilder(
                    future: Future.delayed(Duration(seconds: 1)),
                    builder: (context, futureSnapshot) {
                      if (futureSnapshot.connectionState ==
                          ConnectionState.waiting) {
                        return Container(); //Return a loader o an empty container.
                      } else {
                        // After one second, it will return the BottomPlayer.
                        return Positioned(
                          bottom: 0, // Default 6
                          right: 11, // Default 11
                          child: BottomPlayer(
                            key: bottomPlayerKey,
                          ),
                        );
                      }
                    },
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
