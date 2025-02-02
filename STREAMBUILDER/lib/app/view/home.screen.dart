import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:vicyos_music/app/view/home.page.folder.list.screen.dart';
import 'package:vicyos_music/app/widgets/bottom.player.dart';

class HomeScreen extends StatelessWidget {
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
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
                    return const HomePageFolderList();
                  },
                );
              },
            ),
            const Positioned(
              bottom: 6,
              right: 11,
              child: BottomPlayer(),
            ),
          ],
        ),
      ),
    );
  }
}
