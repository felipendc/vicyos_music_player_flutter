import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:vicyos_music/app/build_flags/build.flags.dart';
import 'package:vicyos_music/app/color_palette/color_extension.dart';
import 'package:vicyos_music/app/files_and_folders_handler/folders.and.files.related.dart';
import 'package:vicyos_music/app/music_player/music.player.functions.and.more.dart';
import 'package:vicyos_music/app/music_player/music.player.stream.controllers.dart';
import 'package:vicyos_music/app/navigation_animation/song.files.screen.navigation.animation.dart';
import 'package:vicyos_music/app/radio_player/functions_and_streams/radio.functions.and.more.dart';
import 'package:vicyos_music/app/radio_player/functions_and_streams/radio.stream.controllers.dart';
import 'package:vicyos_music/app/radio_player/screens/radio.station.list.screen.dart';
import 'package:vicyos_music/app/screen_orientation/screen.orientation.dart';
import 'package:vicyos_music/app/view/screens/song.search.screen.dart';
import 'package:vicyos_music/l10n/app_localizations.dart';

class PlaylistsScreen extends StatelessWidget {
  const PlaylistsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Set the preferred orientations to portrait mode when this screen is built
    setScreenOrientation();

    var media = MediaQuery.sizeOf(context);

    return StreamBuilder<FetchingSongs>(
      stream: null, // todo
      builder: (context, snapshot) {
        return SafeArea(
          child: Scaffold(
            body: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 13.0),
                  child: Container(
                    decoration: BoxDecoration(
                        // color: Colors.grey,
                        // color: Color(0xff181B2C),
                        ),
                    // height: deviceTypeIsTablet()
                    //     ? 132 /*129*/
                    //     : 127 /*124*/, // Loading enabled
                    child: Column(
                      // mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(20, 0, 8, 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    AppLocalizations.of(context)!.playlists,
                                    style: TextStyle(
                                      color: TColor.primaryText
                                          .withValues(alpha: 0.84),
                                      fontSize: 20,
                                      fontWeight: FontWeight.w600,
                                      shadows: [
                                        BoxShadow(
                                          color: Colors.black
                                              .withValues(alpha: 0.2),
                                          spreadRadius: 5,
                                          blurRadius: 8,
                                          offset: Offset(2, 4),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Text(
                                    AppLocalizations.of(context)!.welcome_to,
                                    style: TextStyle(
                                      color: TColor.primaryText28
                                          .withValues(alpha: 0.84),
                                      fontSize: 15,
                                      fontWeight: FontWeight.w400,
                                      shadows: [
                                        Shadow(
                                          color: Colors.black
                                              .withValues(alpha: 0.2),
                                          offset: Offset(1, 1),
                                          blurRadius: 3,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Material(
                                    color: Colors.transparent,
                                    child: SizedBox(
                                      width: deviceTypeIsTablet()
                                          ? 130 * 0.32
                                          : 40,
                                      height: deviceTypeIsTablet()
                                          ? 130 * 0.32
                                          : 40,
                                      child: IconButton(
                                        splashRadius: 20,
                                        iconSize: 10,
                                        onPressed: () async {
                                          getMusicFoldersContent();
                                        },
                                        icon: Image.asset(
                                          "assets/img/menu/autorenew.png",
                                          color: TColor.lightGray,
                                        ),
                                      ),
                                    ),
                                  ),
                                  (vicyosMusicAppHasRadio)
                                      ? StreamBuilder(
                                          stream:
                                              updateRadioScreensStreamController
                                                  .stream,
                                          builder: (context, asyncSnapshot) {
                                            return Stack(
                                              children: [
                                                Positioned(
                                                  height: 78,
                                                  child: (isRadioOn)
                                                      ? Padding(
                                                          padding: EdgeInsets.only(
                                                              left:
                                                                  deviceTypeIsTablet()
                                                                      ? 11
                                                                      : 9.2),
                                                          child: LoadingAnimationWidget
                                                              .progressiveDots(
                                                            color: TColor
                                                                .lightGray, // Colors.green,
                                                            size: 20,
                                                          ),
                                                        )
                                                      : Container(),
                                                ),
                                                Material(
                                                  color: Colors.transparent,
                                                  // color: Colors.white30,
                                                  child: SizedBox(
                                                    width: deviceTypeIsTablet()
                                                        ? 43
                                                        : 40,
                                                    height: 43,
                                                    child: IconButton(
                                                      splashRadius: 20,
                                                      iconSize: 20,
                                                      onPressed: () async {
                                                        if (deviceTypeIsSmartphone()) {
                                                          // Show Radio Mini Player
                                                          hideMiniRadioPlayerNotifier(
                                                              false);

                                                          // Hide Mini Player
                                                          hideMiniPlayerNotifier(
                                                              true);
                                                        }

                                                        Navigator.push(
                                                          context,
                                                          slideRightLeftTransition(
                                                            RadioStationsScreen(
                                                              scaffoldKey:
                                                                  mainRadioScreenKey,
                                                            ),
                                                          ),
                                                        ).whenComplete(
                                                          () {
                                                            if (deviceTypeIsSmartphone()) {
                                                              // Hide radio mini player if it is open
                                                              hideMiniRadioPlayerNotifier(
                                                                  true);
                                                              // "When the bottom sheet is closed, send a signal to show the mini player again."
                                                              hideMiniPlayerNotifier(
                                                                  false);
                                                            }
                                                          },
                                                        );
                                                      },
                                                      icon: SizedBox(
                                                        height: 60,
                                                        child: Image.asset(
                                                          "assets/img/radio/radio_icon.png",
                                                          color:
                                                              TColor.lightGray,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            );
                                          },
                                        )
                                      : Container(),
                                  Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(9, 0, 8, 0),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(
                                            media.width * 0.2),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.black
                                                .withValues(alpha: 0.2),
                                            spreadRadius: 5,
                                            blurRadius: 8,
                                            offset: Offset(2, 4),
                                          ),
                                        ],
                                      ),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(
                                            media.width * 0.2),
                                        child: StreamBuilder<void>(
                                          stream: null,
                                          builder: (context, snapshot) {
                                            return Image.asset(
                                              "assets/img/pics/default.png",
                                              width: deviceTypeIsTablet()
                                                  ? 130 * 0.44
                                                  : media.width * 0.13,
                                              height: deviceTypeIsTablet()
                                                  ? 130 * 0.44
                                                  : media.width * 0.13,
                                              fit: BoxFit.cover,
                                            );
                                          },
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),

                        // Search
                        Padding(
                          padding: const EdgeInsets.fromLTRB(10, 5, 10, 8),
                          child: GestureDetector(
                            onTap: () async {
                              Navigator.push(
                                context,
                                slideRightLeftTransition(
                                  const SearchScreen(),
                                ),
                              ).whenComplete(
                                () {
                                  searchBoxController.dispose();
                                },
                              );
                            },
                            child: Container(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16),
                              decoration: BoxDecoration(
                                color: const Color(0xff24273A),
                                // Background color of the container
                                borderRadius: BorderRadius.circular(30),
                              ),
                              child: TextField(
                                // Attach FocusNode to the TextField
                                autofocus: false,
                                // Ensure the TextField doesn't autofocus
                                enabled: false,
                                // Disable the TextField to avoid interaction
                                style: const TextStyle(color: Colors.white),
                                decoration: InputDecoration(
                                  hintText: AppLocalizations.of(context)!
                                      .search_with_ellipsis,
                                  hintStyle:
                                      const TextStyle(color: Colors.white60),
                                  filled: false,
                                  fillColor: Colors.transparent,
                                  // Transparent background for TextField
                                  contentPadding: const EdgeInsets.symmetric(
                                      vertical: 12, horizontal: 0),
                                  border: InputBorder.none,
                                  // Removing border from TextField
                                  suffixIcon: Padding(
                                    padding: const EdgeInsets.only(left: 50),
                                    child: const Icon(Icons.search,
                                        color: Colors.white70),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // ========================================================================
              ],
            ),
          ),
        );
      },
    );
  }
}
