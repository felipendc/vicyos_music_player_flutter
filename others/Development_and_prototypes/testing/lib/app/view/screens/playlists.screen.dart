import 'package:flutter/material.dart';
import 'package:vicyos_music/app/color_palette/color_extension.dart';
import 'package:vicyos_music/app/components/bottom.fade.dart';
import 'package:vicyos_music/app/files_and_folders_handler/folders.and.files.related.dart';
import 'package:vicyos_music/app/lifecycle_handler/permission.lifecycle.handler.dart';
import 'package:vicyos_music/app/models/folder.sources.dart';
import 'package:vicyos_music/app/music_player/music.player.functions.and.more.dart';
import 'package:vicyos_music/app/music_player/music.player.stream.controllers.dart';
import 'package:vicyos_music/app/navigation_animation/song.files.screen.navigation.animation.dart';
import 'package:vicyos_music/app/screen_orientation/screen.orientation.dart';
import 'package:vicyos_music/app/view/screens/song.search.screen.dart';
import 'package:vicyos_music/database/database.dart';
import 'package:vicyos_music/l10n/app_localizations.dart';

class PlaylistsScreen extends StatelessWidget {
  PlaylistsScreen({super.key}) {
    _lifecycle = PermissionLifecycleHandler(
      onResume: () async {
        if (appSettingsWasOpened) {
          await getMusicFoldersContent();
        }

        appSettingsWasOpened = false;
      },
    );
  }

  // ignore: unused_field
  late final PermissionLifecycleHandler _lifecycle;

  @override
  Widget build(BuildContext context) {
    // Set the preferred orientations to portrait mode when this screen is built
    setScreenOrientation();

    var media = MediaQuery.sizeOf(context);

    // Fetch the songs folders
    // todo
    getMusicFoldersContent();

    return StreamBuilder<FetchingSongs>(
      stream: rebuildHomePageFolderListStreamController.stream,
      builder: (context, snapshot) {
        final FetchingSongs fetchingResult =
            snapshot.data ?? FetchingSongs.nullValue;

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
                                    "Total: 0 playlists",
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
                //

                StreamBuilder<void>(
                  stream: currentSongNameStreamController.stream,
                  builder: (context, snapshot) {
                    return FutureBuilder<List<FolderSources>>(
                        future: AppDatabase.instance.getFolders(),
                        builder: (context, snapshot) {
                          final songFolderList = snapshot.data ?? [];

                          return Expanded(
                            flex: 1,
                            child: Stack(
                              children: [
                                GridView.builder(
                                  padding: const EdgeInsets.fromLTRB(
                                      16, 16, 16, 120),
                                  itemCount: 5,
                                  gridDelegate:
                                      const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2,
                                    childAspectRatio: 0.9,
                                    crossAxisSpacing: 16,
                                    mainAxisSpacing: 16,
                                  ),
                                  itemBuilder: (context, index) {
                                    return PlaylistCard(
                                        playlistModelTest:
                                            playlistModelTest[index]);
                                  },
                                ),

                                /// OVERLAY WITH GRADIENT
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

class PlaylistCard extends StatelessWidget {
  final PlaylistModelTest playlistModelTest;

  const PlaylistCard({super.key, required this.playlistModelTest});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xff272A3E),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.06),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.18),
            blurRadius: 10,
            offset: const Offset(0, 6),
          ),

          // subtle top highlight
          BoxShadow(
            color: Colors.white.withValues(alpha: 0.03),
            blurRadius: 4,
            offset: const Offset(0, -1),
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            child:
                // Play
                Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: Colors.white10,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.play_arrow,
                size: 20,
                color: Colors.white70,
              ),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 10),

              /// Image
              Expanded(
                child: Center(
                  child: Image.asset(
                    playlistModelTest.image,
                    height: 90,
                    fit: BoxFit.contain,
                    // color: TColor.focus,
                  ),
                ),
              ),

              const SizedBox(height: 10),

              /// name
              Text(
                playlistModelTest.name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: TColor.lightGray,
                ),
              ),

              const SizedBox(height: 0),

              /// Total songs
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Text(
                        '10',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: Colors.white60,
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(width: 4),
                      Text(
                        'músicas',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: Colors.white60,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// To be deleted!
class PlaylistModelTest {
  final String image;
  final String name;

  PlaylistModelTest({
    required this.image,
    required this.name,
  });
}

// To be deleted!
List<PlaylistModelTest> playlistModelTest = [
  PlaylistModelTest(
    image: "assets/img/playlist/playlist_flaticon.png",
    name: "As melhores",
  ),
  PlaylistModelTest(
    image: "assets/img/playlist/playlist_flaticon.png",
    name: "Praticar inglês Angela",
  ),
  PlaylistModelTest(
    image: "assets/img/playlist/playlist_flaticon.png",
    name: "Áudio livros",
  ),
  PlaylistModelTest(
    image: "assets/img/playlist/playlist_flaticon.png",
    name: "name",
  ),
  PlaylistModelTest(
    image: "assets/img/playlist/playlist_flaticon.png",
    name: "name",
  ),
  PlaylistModelTest(
    image: "assets/img/playlist/playlist_flaticon.png",
    name: "name",
  ),
];
