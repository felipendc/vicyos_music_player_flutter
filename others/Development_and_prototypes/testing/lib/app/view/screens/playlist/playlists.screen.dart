import 'package:flutter/material.dart';
import 'package:vicyos_music/app/color_palette/color_extension.dart';
import 'package:vicyos_music/app/components/bottom.fade.dart';
import 'package:vicyos_music/app/components/playlist.card.dart';
import 'package:vicyos_music/app/models/playlists.dart';
import 'package:vicyos_music/app/music_player/music.player.functions.and.more.dart';
import 'package:vicyos_music/app/music_player/music.player.stream.controllers.dart';
import 'package:vicyos_music/app/navigation_animation/song.files.screen.navigation.animation.dart';
import 'package:vicyos_music/app/screen_orientation/screen.orientation.dart';
import 'package:vicyos_music/app/view/bottomsheet/playlist_bottomsheets/bottomsheet.playlist.screen.dart';
import 'package:vicyos_music/app/view/screens/playlist/playlist.songs.dart';
import 'package:vicyos_music/app/view/screens/song.search.screen.dart';
import 'package:vicyos_music/database/database.dart';
import 'package:vicyos_music/l10n/app_localizations.dart';

class PlaylistsScreen extends StatelessWidget {
  const PlaylistsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Set the preferred orientations to portrait mode when this screen is built
    setScreenOrientation();

    var media = MediaQuery.sizeOf(context);

    return StreamBuilder<void>(
      stream: rebuildPlaylistScreenStreamController.stream,
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
                                  FutureBuilder<List<Playlists>>(
                                      future: AppDatabase.instance
                                          .getAllPlaylists(),
                                      builder: (context, snapshot) {
                                        final playlists = snapshot.data ?? [];
                                        return Text(
                                          AppLocalizations.of(context)!
                                              .total_of_playlist(
                                                  playlists.length),
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
                                        );
                                      }),
                                ],
                              ),
                              Row(
                                children: [
                                  Material(
                                    color: Colors.transparent,
                                    child: SizedBox(
                                      width: 35,
                                      height: 35,
                                      child: IconButton(
                                        splashRadius: 20,
                                        iconSize: 10,
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        icon: Image.asset(
                                          "assets/img/menu/arrow_back_ios.png",
                                          color: TColor.lightGray,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Material(
                                    color: Colors.transparent,
                                    child: SizedBox(
                                      width: 45,
                                      height: 45,
                                      child: FutureBuilder<List<Playlists>>(
                                          future: AppDatabase.instance
                                              .getAllPlaylists(),
                                          builder: (context, musicSnapshot) {
                                            // Treating the waiting
                                            if (musicSnapshot.connectionState ==
                                                ConnectionState.waiting) {
                                              return const SizedBox();
                                            }

                                            // If has error show a blank screen
                                            if (musicSnapshot.hasError) {
                                              return const SizedBox();
                                            }

                                            return IconButton(
                                              splashRadius: 20,
                                              iconSize: 10,
                                              onPressed: () async {
                                                if (deviceTypeIsSmartphone()) {
                                                  hideMiniPlayerNotifier(true);
                                                }

                                                final result =
                                                    await showModalBottomSheet<
                                                        String>(
                                                  backgroundColor:
                                                      Colors.transparent,
                                                  context: context,
                                                  builder:
                                                      (BuildContext context) {
                                                    return PlaylistScreenBottomSheet();
                                                  },
                                                ).whenComplete(
                                                  () {
                                                    // if (deviceTypeIsSmartphone()) {
                                                    //   // "When the bottom sheet is closed, send a signal to show the mini player again."
                                                    //
                                                    //   hideMiniPlayerNotifier(
                                                    //       false);
                                                    // }
                                                  },
                                                );

                                                if (result ==
                                                    "hide_bottom_player") {
                                                  if (deviceTypeIsSmartphone()) {
                                                    // "When the bottom sheet is closed, send a signal to show the mini player again."
                                                    hideMiniPlayerNotifier(
                                                        true);
                                                  }
                                                } else {
                                                  if (deviceTypeIsSmartphone()) {
                                                    // "When the bottom sheet is closed, send a signal to show the mini player again."
                                                    hideMiniPlayerNotifier(
                                                        false);
                                                  }
                                                }
                                              },
                                              icon: Image.asset(
                                                "assets/img/menu/menu_open.png",
                                                color: TColor.lightGray,
                                              ),
                                            );
                                          }),
                                    ),
                                  ),
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

                // List of playlist in Grid view
                StreamBuilder<void>(
                  stream: currentSongNameStreamController.stream,
                  builder: (context, snapshot) {
                    return FutureBuilder<List<Playlists>>(
                        future: AppDatabase.instance.getAllPlaylists(),
                        builder: (context, snapshot) {
                          final playlists = snapshot.data ?? [];

                          return Expanded(
                            flex: 1,
                            child: Stack(
                              children: [
                                GridView.builder(
                                  padding: const EdgeInsets.fromLTRB(
                                      16, 16, 16, 120),
                                  itemCount: playlists.length,
                                  gridDelegate:
                                      const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2,
                                    childAspectRatio: 0.9,
                                    crossAxisSpacing: 16,
                                    mainAxisSpacing: 16,
                                  ),
                                  itemBuilder: (context, index) {
                                    return GestureDetector(
                                      child: PlaylistCard(
                                        playlistModel: playlists,
                                        index: index,
                                      ),
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          slideRightLeftTransition(
                                            PlaylistSongs(
                                              playlistModelIndex: index,
                                              playlistModel: playlists,
                                            ),
                                          ),
                                        );
                                      },
                                    );
                                  },
                                ),

                                // OVERLAY WITH GRADIENT ONLY FOR SMARTPHONE
                                if (deviceType == DeviceType.smartphone)
                                  const BottomFade(),
                              ],
                            ),
                          );
                        });
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
