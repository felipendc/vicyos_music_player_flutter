import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:vicyos_music/app/functions/screen.orientation.dart';
import 'package:vicyos_music/app/view/screens/screen.list.song.folders.dart';
import 'main.player.view.screen.dart' show MainPlayerView;

ValueNotifier<String> activeSide = ValueNotifier("left"); // "left" or "right"

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

        final rootNavigator = Navigator.of(context); // root navigator, includes bottom sheets and dialogs
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
                    builder: (_) => HomePageFolderList(),
                  ),
                ),
              ),
            ),
            const VerticalDivider(
              indent: 34,
              endIndent: 20,
              width: 0.1,          // total width of the divider (including spacing)
              thickness: 1,      // thickness of the line itself
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
                    builder: (_) => MainPlayerView(),
                  ),
                ),
              ),
            ),
          ],
        )
      ),
    );
  }
}