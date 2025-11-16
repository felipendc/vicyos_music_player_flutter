import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:vicyos_music/app/common/music_player/music.player.dart';
import 'package:vicyos_music/app/common/radio/radio.stream.notifiers.dart';
import 'package:vicyos_music/app/common/radio/widgets/radio.bottom.player.dart'
    show RadioBottomPlayer;
import 'package:vicyos_music/app/common/screen_orientation/screen.orientation.dart';
import 'package:vicyos_music/app/is_smartphone/view/screens/screen.list.song.folders.dart';
import 'package:vicyos_music/app/is_smartphone/widgets/bottom.player.dart';
import 'package:vicyos_music/app/is_tablet/view/screens/main.player.view.screen.dart';
import 'package:vicyos_music/app/is_tablet/view/screens/screen.list.song.folders.dart';

import '../files_and_folders_handler/folders.and.files.related.dart';

ValueNotifier<String> activeSide = ValueNotifier("left"); // "left" or "right"

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  final GlobalKey<NavigatorState> navigatorKeySmartphone =
      GlobalKey<NavigatorState>();

  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  final GlobalKey<NavigatorState> navigatorKey2 = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    // Set the preferred orientations to landscape mode when this screen is built
    setScreenOrientation();

    // Fetch the songs folders first, if it's a tablet
    if (deviceType == DeviceType.tablet) {
      listMusicFolders(); // must return a Widget
    }

    return deviceType == DeviceType.smartphone
        ? PopScope(
            canPop: false, // Prevents back navigation
            onPopInvokedWithResult: (_, __) async {
              // If there are no more screens in the navigation stack (on the home screen), close the app
              if (!navigatorKeySmartphone.currentState!.canPop()) {
                // Here, we close the app with SystemNavigator.pop()
                SystemNavigator.pop();
              } else {
                // Otherwise, just go back to the previous screen
                navigatorKeySmartphone.currentState!.pop();
              }
            },
            child: Scaffold(
              body: Stack(
                children: [
                  Navigator(
                    key: navigatorKeySmartphone,
                    onGenerateRoute: (RouteSettings settings) {
                      return MaterialPageRoute(
                        builder: (context) {
                          return HomePageFolderList();
                        },
                      );
                    },
                  ),
                  StreamBuilder<bool>(
                    stream: hideBottonSheetStreamController.stream,
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
                                child: BottomPlayer(),
                              );
                            }
                          },
                        );
                      }
                    },
                  ),
                  StreamBuilder<bool>(
                    stream: hideMiniRadioPlayerStreamController.stream,
                    initialData: true,
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
                                child: RadioBottomPlayer(),
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
          )
        : PopScope(
            canPop: false, // Prevents back navigation
            onPopInvokedWithResult: (_, __) async {
              final rootNavigator = Navigator.of(
                  context); // root navigator, includes bottom sheets and dialogs
              final nav1 = navigatorKey.currentState!;
              final nav2 = navigatorKey2.currentState!;

              if (rootNavigator.canPop()) {
                // This closes any global route (e.g., bottom sheet, dialog, full-screen modal)
                rootNavigator.pop();
              } else if (nav1.canPop()) {
                // Closes the top route from the first nested Navigator (left side)
                nav1.pop();
              } else if (nav2.canPop()) {
                // Closes the top route from the second nested Navigator (right side)
                nav2.pop();
              } else {
                // No routes left anywhere -> exit the app
                SystemNavigator.pop();
              }

              //
              // // If there are no more screens in the navigation stack (on the home screen), close the app
              // if (!navigatorKey.currentState!.canPop()) {
              //   // Here, we close the app with SystemNavigator.pop()
              //   SystemNavigator.pop();
              // } else {
              //   // Otherwise, just go back to the previous screen
              //   navigatorKey.currentState!.pop();
              //
              // }
            },
            child: Scaffold(
                body: Row(
              children: [
                Expanded(
                  flex: 1,
                  child: GestureDetector(
                    onTap: () {
                      activeSide.value = "left"; // user touched the left side
                    },
                    child: Navigator(
                      key: navigatorKey,
                      onGenerateRoute: (settings) => MaterialPageRoute(
                        builder: (_) => HomePageFolderListTablet(),
                      ),
                    ),
                  ),
                ),
                const VerticalDivider(
                  indent: 34,
                  endIndent: 20,
                  width: 0.1, // total width of the divider (including spacing)
                  thickness: 1, // thickness of the line itself
                  color: Colors.grey, // line color
                ),
                Expanded(
                  flex: 1,
                  child: GestureDetector(
                    onTap: () {
                      activeSide.value = "right"; // user touched the right side
                    },
                    child: Navigator(
                      key: navigatorKey2,
                      onGenerateRoute: (settings) => MaterialPageRoute(
                        builder: (_) => MainPlayerViewTablet(),
                      ),
                    ),
                  ),
                ),
              ],
            )),
          );
  }
}
