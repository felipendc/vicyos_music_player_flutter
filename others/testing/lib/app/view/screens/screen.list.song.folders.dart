import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:vicyos_music/app/build_flags/build.flags.dart';
import 'package:vicyos_music/app/color_palette/color_extension.dart';
import 'package:vicyos_music/app/files_and_folders_handler/folders.and.files.related.dart';
import 'package:vicyos_music/app/lifecycle_handler/permission.lifecycle.handler.dart';
import 'package:vicyos_music/app/models/folder.sources.dart';
import 'package:vicyos_music/app/music_player/music.player.functions.and.more.dart';
import 'package:vicyos_music/app/music_player/music.player.stream.controllers.dart';
import 'package:vicyos_music/app/navigation_animation/song.files.screen.navigation.animation.dart';
import 'package:vicyos_music/app/radio_player/functions_and_streams/radio.functions.and.more.dart';
import 'package:vicyos_music/app/radio_player/functions_and_streams/radio.stream.controllers.dart';
import 'package:vicyos_music/app/radio_player/screens/radio.station.list.screen.dart';
import 'package:vicyos_music/app/screen_orientation/screen.orientation.dart';
import 'package:vicyos_music/app/view/bottomsheet/bottom.sheet.folders.to.playlist.dart';
import 'package:vicyos_music/app/view/screens/favorite.song.screen.dart';
import 'package:vicyos_music/app/view/screens/list.songs.screen.dart';
import 'package:vicyos_music/app/view/screens/loading.screen.dart';
import 'package:vicyos_music/app/view/screens/playlists.screen.dart';
import 'package:vicyos_music/app/view/screens/show.all.songs.screen.dart';
import 'package:vicyos_music/app/view/screens/song.search.screen.dart';
import 'package:vicyos_music/app/widgets/music_visualizer.dart';
import 'package:vicyos_music/database/database.dart';
import 'package:vicyos_music/l10n/app_localizations.dart';

class HomePageFolderList extends StatelessWidget {
  HomePageFolderList({super.key}) {
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
                                  Text(
                                    AppLocalizations.of(context)!.vicyos_music,
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
                        // Search + Tabs
                        // Row(
                        //   mainAxisAlignment: MainAxisAlignment.center,
                        //   children: [
                        //     // Custom tabs
                        //
                        //     Padding(
                        //       padding: const EdgeInsets.fromLTRB(15, 0, 0, 0),
                        //       child: Container(
                        //         padding:
                        //             const EdgeInsets.symmetric(horizontal: 16),
                        //         height: 44,
                        //         // width: 350,
                        //         decoration: BoxDecoration(
                        //           color: const Color(
                        //               0xff24273A), //const Color(0xff24273A),
                        //           // Background color of the container
                        //           borderRadius: BorderRadius.circular(20),
                        //         ),
                        //         child: Row(
                        //           mainAxisAlignment: MainAxisAlignment.center,
                        //           children: [
                        //             SizedBox(width: 5),
                        //             Text(
                        //               "Músicas",
                        //               style: TextStyle(
                        //                   color: Colors.white70,
                        //                   fontSize: 16,
                        //                   fontWeight: FontWeight.w500),
                        //             ),
                        //             SizedBox(width: 20),
                        //             Text(
                        //               "Favoritos",
                        //               style: TextStyle(
                        //                   color: Colors.white70,
                        //                   fontSize: 16,
                        //                   fontWeight: FontWeight.w500),
                        //             ),
                        //             SizedBox(width: 20),
                        //             Text(
                        //               "Playlists",
                        //               style: TextStyle(
                        //                   color: Colors.white70,
                        //                   fontSize: 16,
                        //                   fontWeight: FontWeight.w500),
                        //             ),
                        //             SizedBox(width: 5),
                        //           ],
                        //         ),
                        //       ),
                        //     ),
                        //
                        //     // 🔍 Search icon
                        //     Padding(
                        //       padding: const EdgeInsets.fromLTRB(10, 5, 15, 8),
                        //       child: GestureDetector(
                        //         onTap: () {
                        //           Navigator.push(
                        //             context,
                        //             slideRightLeftTransition(
                        //               const SearchScreen(),
                        //             ),
                        //           );
                        //         },
                        //         child: Container(
                        //           width: 50,
                        //           height: 45,
                        //           decoration: BoxDecoration(
                        //             color: const Color(0xff24273A),
                        //             borderRadius: BorderRadius.circular(20),
                        //           ),
                        //           child: const Icon(
                        //             Icons.search,
                        //             color: Colors.white70,
                        //             size: 22,
                        //           ),
                        //         ),
                        //       ),
                        //     ),
                        //   ],
                        // ),

                        // ========================================================================
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
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Container(
                    height: 37,
                    // width: 350,
                    decoration: BoxDecoration(
                      // color: Colors.white54,
                      // color: const Color(
                      //     0xff24273A), //const Color(0xff24273A),
                      // Background color of the container
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        GestureDetector(
                          child: Text(
                            "Músicas",
                            style: TextStyle(
                                color: Colors.white70,
                                fontSize: 16,
                                fontWeight: FontWeight.w500),
                          ),
                          onTap: () {
                            Navigator.push(
                              context,
                              slideRightLeftTransition(
                                ShowAllSongsScreen(),
                              ),
                            );
                          },
                        ),
                        Text(
                          "  •  ",
                          style: TextStyle(
                              color: TColor.secondaryText,
                              fontSize: 16,
                              fontWeight: FontWeight.w500),
                        ),
                        GestureDetector(
                          child: Text(
                            "Favoritos",
                            style: TextStyle(
                                color: Colors.white70,
                                fontSize: 16,
                                fontWeight: FontWeight.w500),
                          ),
                          onTap: () {
                            Navigator.push(
                              context,
                              slideRightLeftTransition(
                                FavoriteSongsScreen(),
                              ),
                            );
                          },
                        ),
                        Text(
                          "  •  ",
                          style: TextStyle(
                              color: TColor.secondaryText,
                              fontSize: 16,
                              fontWeight: FontWeight.w500),
                        ),
                        GestureDetector(
                          child: Text(
                            "Playlists",
                            style: TextStyle(
                                color: Colors.white70,
                                fontSize: 16,
                                fontWeight: FontWeight.w500),
                          ),
                          onTap: () {
                            Navigator.push(
                              context,
                              slideRightLeftTransition(
                                PlaylistsScreen(),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                // ========================================================================
                StreamBuilder<void>(
                  stream: currentSongNameStreamController.stream,
                  builder: (context, snapshot) {
                    return FutureBuilder<List<FolderSources>>(
                        future: AppDatabase.instance.getFolders(),
                        builder: (context, snapshot) {
                          final songFolderList = snapshot.data ?? [];

                          return Expanded(
                            flex: 1,
                            child: (fetchingResult == FetchingSongs.done)
                                ? ListView.separated(
                                    padding: const EdgeInsets.only(
                                      bottom: 112,
                                    ),
                                    itemCount: songFolderList.length,
                                    itemBuilder: (context, index) {
                                      final folder = songFolderList[index];

                                      return SizedBox(
                                        height: 70,
                                        child: FutureBuilder(
                                            future: AppDatabase.instance
                                                .getFolderContentByPath(
                                                    folder.folderPath),
                                            builder: (context, musicSnapshot) {
                                              //
                                              final folderSongList =
                                                  musicSnapshot.data ?? [];

                                              return GestureDetector(
                                                onLongPress: () {
                                                  hideMiniPlayerNotifier(true);
                                                  showModalBottomSheet<void>(
                                                    backgroundColor:
                                                        Colors.transparent,
                                                    context: context,
                                                    builder:
                                                        (BuildContext context) {
                                                      return FolderToPlaylistBottomSheet(
                                                        folderPath:
                                                            folder.folderPath,
                                                        folderSongList:
                                                            folderSongList,
                                                        folderIndex: index,
                                                      );
                                                    },
                                                  ).whenComplete(
                                                    () {
                                                      if (deviceTypeIsSmartphone()) {
                                                        if (mainPlayerIsOpen) {
                                                          mainPlayerIsOpen =
                                                              false;
                                                        } else {
                                                          // "When the bottom sheet is closed, send a signal to show the mini player again."
                                                          hideMiniPlayerNotifier(
                                                              false);
                                                        }
                                                      }
                                                    },
                                                  );
                                                },
                                                child: ListTile(
                                                  leading: (folder.folderPath ==
                                                          getCurrentSongParentFolder(
                                                              currentSongFullPath))
                                                      ? Stack(
                                                          children: [
                                                            Icon(
                                                              Icons.folder,
                                                              color: TColor
                                                                  .darkGray,
                                                              size: 47,
                                                            ),
                                                            Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .only(
                                                                      top: 20.0,
                                                                      left: 8.5,
                                                                      bottom:
                                                                          0.0),
                                                              child: SizedBox(
                                                                height: 12,
                                                                width: 30,
                                                                child:
                                                                    MusicVisualizer(
                                                                  barCount: 6,
                                                                  colors: [
                                                                    TColor
                                                                        .focus,
                                                                    TColor
                                                                        .secondaryEnd,
                                                                    TColor
                                                                        .focusStart,
                                                                    Colors.blue[
                                                                        900]!,
                                                                  ],
                                                                  duration: const [
                                                                    900,
                                                                    700,
                                                                    600,
                                                                    800,
                                                                    500
                                                                  ],
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        )
                                                      : Icon(
                                                          Icons.folder,
                                                          color: TColor
                                                              .focusSecondary,
                                                          size: 40,
                                                        ),
                                                  title: Text(
                                                    folderName(
                                                        folder.folderPath),
                                                    textAlign: TextAlign.start,
                                                    maxLines: 1,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      color: TColor.lightGray,
                                                      fontSize: 20,
                                                    ),
                                                  ),
                                                  subtitle: Text(
                                                    AppLocalizations.of(
                                                            context)!
                                                        .number_of_songs_in_folder(
                                                            folder
                                                                .folderSongCount),
                                                    style: const TextStyle(
                                                        fontFamily:
                                                            "Circular Std",
                                                        fontSize: 15,
                                                        color: Colors.white70),
                                                  ),
                                                  trailing: Material(
                                                    color: Colors.transparent,
                                                    child: SizedBox(
                                                      width: 35,
                                                      height: 35,
                                                      child: IconButton(
                                                        splashRadius: 20,
                                                        iconSize: 10,
                                                        onPressed: () async {
                                                          Navigator.push(
                                                            context,
                                                            slideRightLeftTransition(
                                                              SongsListScreen(
                                                                folderPath: folder
                                                                    .folderPath,
                                                                folderIndex:
                                                                    index,
                                                                folderSongList:
                                                                    folder
                                                                        .songPathsList,
                                                              ),
                                                            ),
                                                          );
                                                        },
                                                        icon: Image.asset(
                                                          "assets/img/menu/arrow_forward_ios.png",
                                                          color:
                                                              TColor.lightGray,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  onTap: () {
                                                    Navigator.push(
                                                      context,
                                                      slideRightLeftTransition(
                                                        SongsListScreen(
                                                          folderPath:
                                                              folder.folderPath,
                                                          folderIndex: index,
                                                          folderSongList: folder
                                                              .songPathsList,
                                                        ),
                                                      ),
                                                    );
                                                    // Handle tile tap
                                                  },
                                                ),
                                              );
                                            }),
                                      );
                                    },
                                    separatorBuilder:
                                        (BuildContext context, int index) {
                                      return Container();
                                    },
                                  )
                                : LoadingScreen(
                                    currentStatus: fetchingResult,
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
