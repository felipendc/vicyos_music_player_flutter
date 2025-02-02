import 'package:flutter/material.dart';
import 'package:vicyos_music/app/common/color_extension.dart';
import 'package:vicyos_music/app/functions/folders.and.files.related.dart';
import 'package:vicyos_music/app/functions/music_player.dart';
import 'package:vicyos_music/app/functions/screen.orientation.dart';
import 'package:vicyos_music/app/navigation_animation/song.files.screen.navigation.animation.dart';
import 'package:vicyos_music/app/view/bottom.sheet.folders.to.playlist.dart';
import 'package:vicyos_music/app/view/main.sync.screen.dart';
import 'package:vicyos_music/app/view/songs.list.screen.dart';
import 'package:vicyos_music/app/widgets/appbars.dart';

import '../widgets/music_visualizer.dart';

class HomePageFolderList extends StatefulWidget {
  const HomePageFolderList({super.key});

  @override
  State<HomePageFolderList> createState() => _HomePageFolderListState();
}

class _HomePageFolderListState extends State<HomePageFolderList> {
  @override
  void initState() {
    super.initState();
    listMusicFolders();
  }

  @override
  Widget build(BuildContext context) {
    // Set the preferred orientations to portrait mode when this screen is built
    screenOrientationPortrait();

    return StreamBuilder<int>(
        stream: listPlaylistFolderStreamController.stream,
        builder: (context, snapshot) {
          return Scaffold(
            appBar: homePageAppBar(),
            body: musicFolderPaths.isEmpty
                ? const MainSyncScreen()
                : Stack(children: [
                    Column(
                      children: [
                        StreamBuilder<void>(
                            stream:
                                getCurrentSongFullPathStreamController.stream,
                            builder: (context, snapshot) {
                              return Expanded(
                                child: ListView.separated(
                                  padding: const EdgeInsets.only(bottom: 130),
                                  itemCount: musicFolderPaths.length,
                                  itemBuilder: (context, index) {
                                    return SizedBox(
                                      // color: TColor.darkGray,
                                      height: 70,
                                      // margin: const EdgeInsets.all(10),
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
                                                          // TColor.lightGray,
                                                          // TColor.bgMiniPlayer
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

                                        // Image.asset(
                                        //   "assets/img/m_hidden_folder.png",
                                        //   width: 35,
                                        //   height: 35,
                                        //   color: TColor.focus,
                                        // ),
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
                                            showModalBottomSheet<void>(
                                              backgroundColor:
                                                  Colors.transparent,
                                              context: context,
                                              builder: (BuildContext context) {
                                                return FolderToPlaylistBottomSheet(
                                                    folderPath:
                                                        musicFolderPaths[index]
                                                            .path);
                                              },
                                            );
                                          },
                                        ),

                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            slideRightLeftTransition(
                                              SongsListScreen(
                                                  folderPath:
                                                      musicFolderPaths[index]
                                                          .path),
                                            ),
                                            // MaterialPageRoute(
                                            //   builder: (context) =>
                                            //       SongsListScreen(
                                            //           folderPath:
                                            //               musicFolderPaths[
                                            //                       index]
                                            //                   .path),
                                            //
                                            // ),
                                          );
                                          // Handle tile tap
                                        },
                                      ),
                                    );
                                  },
                                  separatorBuilder:
                                      (BuildContext context, int index) {
                                    return Container();
                                    // const Divider(
                                    //   color: Colors.white12,
                                    //   indent: 58,
                                    //   endIndent: 10,
                                    //   height: 1,
                                    // );
                                  },
                                ),
                              );
                            }),
                      ],
                    ),
                  ]),
            floatingActionButton: musicFolderPaths.isNotEmpty
                ? Stack(
                    children: [
                      Positioned(
                        bottom: 100,
                        right: 4,
                        child: SizedBox(
                          height: 55,
                          child: FloatingActionButton(
                            backgroundColor: TColor.darkGray,
                            heroTag: "fab2",
                            onPressed: () {
                              musicFolderPaths.clear();
                              listPlaylistFolderStreamListener();
                            },
                            child: Icon(
                              Icons.sync_rounded,
                              color: TColor.focusStart,
                            ),
                          ),
                        ),
                      ),
                    ],
                  )
                : Container(),
          );
        });
  }
}
