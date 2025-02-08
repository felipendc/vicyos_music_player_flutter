import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:vicyos_music/app/common/color_extension.dart';
import 'package:vicyos_music/app/functions/folders.and.files.related.dart';
import 'package:vicyos_music/app/functions/music_player.dart';
import 'package:vicyos_music/app/functions/screen.orientation.dart';
import 'package:vicyos_music/app/navigation_animation/song.files.screen.navigation.animation.dart';
import 'package:vicyos_music/app/view/bottom.sheet.folders.to.playlist.dart';
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
          return Scaffold(
            body: Center(
              child: LoadingAnimationWidget.staggeredDotsWave(
                size: 40,
              ),
            ),
          );
        } else {
          return SafeArea(
            child: Scaffold(
              // appBar: homePageAppBar(),
              body: musicFolderPaths.isEmpty
                  ? Container()
                  // ? const MainSyncScreen()
                  : Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Color(0xff181B2C),
                              // boxShadow: [
                              //   BoxShadow(
                              //     color: Color(0xff0F1120).withValues(
                              //         alpha:
                              //             0.7), // Tom mais escuro com transparência
                              //     spreadRadius:
                              //         0, // Define o quanto a sombra se espalha
                              //     blurRadius: 17, // Deixa a sombra mais suave
                              //     offset:
                              //         Offset(0, 5), // Move a sombra para baixo
                              //   ),
                              // ],
                            ),
                            height: 82, // Loading enabled
                            child: Column(
                              // mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                // -------- Loading Widget ----------
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(8, 10, 8, 0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    // crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      // Center(
                                      //   child: LoadingAnimationWidget
                                      //       .staggeredDotsWave(
                                      //     size: 50,
                                      //   ),
                                      // ),
                                    ],
                                  ),
                                ),
                                // ----------------------------------

                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(20, 0, 8, 20),
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
                                                      .withOpacity(
                                                          0.2), // Sombra suave
                                                  offset: Offset(1,
                                                      1), // Deslocamento leve
                                                  blurRadius:
                                                      3, // Suavização da sombra
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
                                          Material(
                                            color: Colors.transparent,
                                            child: SizedBox(
                                              width: 38,
                                              height: 38,
                                              child: IconButton(
                                                splashRadius: 20,
                                                iconSize: 10,
                                                onPressed: () async {
                                                  await previousSong();
                                                },
                                                icon: Image.asset(
                                                  "assets/img/search.png",
                                                  color: TColor.lightGray,
                                                ),
                                              ),
                                            ),
                                          ),
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
                              ],
                            ),
                          ),
                        ),
                        StreamBuilder<void>(
                          stream: getCurrentSongFullPathStreamController.stream,
                          builder: (context, snapshot) {
                            return Expanded(
                              child: ListView.separated(
                                padding:
                                    const EdgeInsets.only(bottom: 130, top: 10),
                                itemCount: musicFolderPaths.length,
                                itemBuilder: (context, index) {
                                  return SizedBox(
                                    height: 70,
                                    child: ListTile(
                                      leading: (musicFolderPaths[index].path ==
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
                                      trailing: IconButton(
                                        splashRadius: 24,
                                        iconSize: 30,
                                        icon: Icon(
                                          Icons.playlist_add_rounded,
                                          color: TColor.focusSecondary,
                                        ),
                                        onPressed: () {
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
