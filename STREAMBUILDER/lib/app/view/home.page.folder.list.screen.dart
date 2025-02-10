import 'package:flutter/material.dart';
import 'package:vicyos_music/app/common/color_extension.dart';
import 'package:vicyos_music/app/functions/folders.and.files.related.dart';
import 'package:vicyos_music/app/functions/music_player.dart';
import 'package:vicyos_music/app/functions/screen.orientation.dart';
import 'package:vicyos_music/app/navigation_animation/song.files.screen.navigation.animation.dart';
import 'package:vicyos_music/app/view/bottom.sheet.folders.to.playlist.dart';
import 'package:vicyos_music/app/view/loading.screen.dart';
import 'package:vicyos_music/app/view/search.screen.dart';
import 'package:vicyos_music/app/view/songs.list.screen.dart';

import '../widgets/music_visualizer.dart';

final GlobalKey homePageFolderListScreenKey = GlobalKey();

class HomePageFolderList extends StatelessWidget {
  const HomePageFolderList({super.key});

  @override
  Widget build(BuildContext context) {
    // Set the preferred orientations to portrait mode when this screen is built
    screenOrientationPortrait();

    var media = MediaQuery.sizeOf(context);

    // Fetch the songs folders
    listMusicFolders();

    return StreamBuilder<bool>(
      stream: rebuildHomePageFolderListStreamController.stream,
      builder: (context, snapshot) {
        if (snapshot.data == false) {
          return LoadingScreen();
        } else {
          return SafeArea(
            child: Scaffold(
              // appBar: homePageAppBar(),
              body: musicFolderPaths.isEmpty
                  ? LoadingScreen()
                  // ? const MainSyncScreen()
                  : Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 10.0),
                          child: Container(
                            decoration: BoxDecoration(
                              // color: Colors.grey,
                              color: Color(0xff181B2C),
                            ),
                            height: 130, // Loading enabled
                            child: Column(
                              // mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(20, 0, 8, 10),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "Welcome to...",
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
                                            "Vicyos Music",
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
                                              width: 40,
                                              height: 40,
                                              child: IconButton(
                                                splashRadius: 20,
                                                iconSize: 10,
                                                onPressed: () async {
                                                  musicFolderPaths.clear();
                                                  listMusicFolders();
                                                  listPlaylistFolderStreamNotifier();
                                                },
                                                icon: Image.asset(
                                                  "assets/img/autorenew.png",
                                                  color: TColor.lightGray,
                                                ),
                                              ),
                                            ),
                                          ),
                                          // Material(
                                          //   color: Colors.transparent,
                                          //   child: SizedBox(
                                          //     width: 38,
                                          //     height: 38,
                                          //     child: IconButton(
                                          //       splashRadius: 20,
                                          //       iconSize: 10,
                                          //       onPressed: () async {
                                          //         //TODO
                                          //         Navigator.push(
                                          //           context,
                                          //           slideRightLeftTransition(
                                          //             const SearchScreen(),
                                          //           ),
                                          //         );
                                          //       },
                                          //       icon: Image.asset(
                                          //         "assets/img/search.png",
                                          //         color: TColor.lightGray,
                                          //       ),
                                          //     ),
                                          //   ),
                                          // ),
                                          Padding(
                                              padding:
                                                  const EdgeInsets.fromLTRB(
                                                      9, 0, 8, 0),
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          media.width * 0.2),
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color: Colors.black
                                                          .withValues(
                                                              alpha: 0.2),
                                                      spreadRadius: 5,
                                                      blurRadius: 8,
                                                      offset: Offset(2, 4),
                                                    ),
                                                  ],
                                                ),
                                                child: ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          media.width * 0.2),
                                                  child: StreamBuilder<bool>(
                                                    stream:
                                                        albumArtStreamController
                                                            .stream,
                                                    builder:
                                                        (context, snapshot) {
                                                      return Image.asset(
                                                        "assets/img/pics/default.png",
                                                        width:
                                                            media.width * 0.13,
                                                        height:
                                                            media.width * 0.13,
                                                        fit: BoxFit.cover,
                                                      );
                                                    },
                                                  ),
                                                ),
                                              )),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),

                                // Search Box
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(10, 8, 10, 8),
                                  child: GestureDetector(
                                    onTap: () async {
                                      Navigator.push(
                                        context,
                                        slideRightLeftTransition(
                                          const SearchScreen(),
                                        ),
                                      ).whenComplete(() {
                                        searchBoxController.dispose();
                                        searchBoxController.dispose();
                                      });
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 16),
                                      decoration: BoxDecoration(
                                        color: const Color(
                                            0xff24273A), // Background color of the container
                                        borderRadius: BorderRadius.circular(30),
                                      ),
                                      child: TextField(
                                        // Attach FocusNode to the TextField
                                        autofocus:
                                            false, // Ensure the TextField doesn't autofocus
                                        enabled:
                                            false, // Disable the TextField to avoid interaction
                                        style: const TextStyle(
                                            color: Colors.white),
                                        decoration: InputDecoration(
                                          hintText: 'Search...',
                                          hintStyle: const TextStyle(
                                              color: Colors.white60),
                                          filled: false,
                                          fillColor: Colors
                                              .transparent, // Transparent background for TextField
                                          contentPadding:
                                              const EdgeInsets.symmetric(
                                                  vertical: 12, horizontal: 0),
                                          border: InputBorder
                                              .none, // Removing border from TextField
                                          suffixIcon: Padding(
                                            padding:
                                                const EdgeInsets.only(left: 50),
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
                        StreamBuilder<void>(
                          stream: getCurrentSongFullPathStreamController.stream,
                          builder: (context, snapshot) {
                            return Expanded(
                              child: ListView.separated(
                                padding: const EdgeInsets.only(
                                  bottom: 112,
                                ),
                                itemCount: musicFolderPaths.length,
                                itemBuilder: (context, index) {
                                  return SizedBox(
                                    height: 70,
                                    child: GestureDetector(
                                      onLongPress: () {
                                        hideButtonSheetStreamNotifier(true);
                                        showModalBottomSheet<void>(
                                          backgroundColor: Colors.transparent,
                                          context: context,
                                          builder: (BuildContext context) {
                                            return FolderToPlaylistBottomSheet(
                                                folderPath:
                                                    musicFolderPaths[index]
                                                        .path);
                                          },
                                        ).whenComplete(() {
                                          if (mainPlayerIsOpen) {
                                            mainPlayerIsOpen = false;
                                          } else {
                                            hideButtonSheetStreamNotifier(
                                                false);
                                          }

                                          // "When the bottom sheet is closed, send a signal to show the mini player again."
                                        });
                                      },
                                      child: ListTile(
                                        leading: (musicFolderPaths[index]
                                                    .path ==
                                                getCurrentSongParentFolder(
                                                    currentSongFullPath))
                                            ? Stack(
                                                children: [
                                                  Icon(
                                                    Icons.folder,
                                                    color: TColor.darkGray,
                                                    size: 47,
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            top: 20.0,
                                                            left: 8.5,
                                                            bottom: 0.0),
                                                    child: SizedBox(
                                                      height: 12,
                                                      width: 30,
                                                      child: MusicVisualizer(
                                                        barCount: 6,
                                                        colors: [
                                                          TColor.focus,
                                                          TColor.secondaryEnd,
                                                          TColor.focusStart,
                                                          Colors.blue[900]!,
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
                                                color: TColor.focusSecondary,
                                                size: 40,
                                              ),
                                        title: Text(
                                          folderName(
                                              musicFolderPaths[index].path),
                                          textAlign: TextAlign.start,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            fontWeight: FontWeight.w500,
                                            color: TColor.lightGray,
                                            fontSize: 20,
                                          ),
                                        ),
                                        subtitle: Text(
                                          musicFolderPaths[index].songs > 1
                                              ? '${musicFolderPaths[index].songs.toString()} songs'
                                              : '${musicFolderPaths[index].songs.toString()} song',
                                          style: const TextStyle(
                                              fontFamily: "Circular Std",
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
                                                        key: songsListScreenKey,
                                                        folderPath:
                                                            musicFolderPaths[
                                                                    index]
                                                                .path),
                                                  ),
                                                );

                                                //----------- BACKUP -----------
                                                // hideButtonSheetStreamNotifier(true);
                                                // showModalBottomSheet<void>(
                                                //   backgroundColor: Colors.transparent,
                                                //   context: context,
                                                //   builder: (BuildContext context) {
                                                //     return FolderToPlaylistBottomSheet(
                                                //         folderPath:
                                                //         musicFolderPaths[index]
                                                //             .path);
                                                //   },
                                                // ).whenComplete(() {
                                                //   if (mainPlayerIsOpen) {
                                                //     mainPlayerIsOpen = false;
                                                //   } else {
                                                //     hideButtonSheetStreamNotifier(
                                                //         false);
                                                //   }
                                                //
                                                //   // "When the bottom sheet is closed, send a signal to show the mini player again."
                                                // });
                                                //------------------------------
                                              },
                                              icon: Image.asset(
                                                "assets/img/arrow_forward_ios.png",
                                                color: TColor.lightGray,
                                              ),
                                            ),
                                          ),
                                        ),
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            slideRightLeftTransition(
                                              SongsListScreen(
                                                  key: songsListScreenKey,
                                                  folderPath:
                                                      musicFolderPaths[index]
                                                          .path),
                                            ),
                                          );
                                          // Handle tile tap
                                        },
                                      ),
                                    ),
                                  );
                                },
                                separatorBuilder:
                                    (BuildContext context, int index) {
                                  return Container();
                                },
                              ),
                            );
                          },
                        ),
                      ],
                    ),
            ),
          );
        }
      },
    );
  }
}
