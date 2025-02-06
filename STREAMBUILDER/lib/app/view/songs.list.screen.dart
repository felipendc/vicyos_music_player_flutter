import 'package:flutter/material.dart';
import 'package:vicyos_music/app/common/color_extension.dart';
import 'package:vicyos_music/app/functions/folders.and.files.related.dart';
import 'package:vicyos_music/app/functions/music_player.dart';
import 'package:vicyos_music/app/functions/screen.orientation.dart';
import 'package:vicyos_music/app/view/bottom.sheet.song.info.more.dart';
import 'package:vicyos_music/app/view/song.preview.dialog.dart';
import 'package:vicyos_music/app/widgets/appbars.dart';

import '../widgets/music_visualizer.dart';

final GlobalKey<_SongsListScreenState> songsListScreenKey =
    GlobalKey<_SongsListScreenState>();

class SongsListScreen extends StatefulWidget {
  final String folderPath;
  const SongsListScreen({super.key, required this.folderPath});

  @override
  State<SongsListScreen> createState() => _SongsListScreenState();
}

class _SongsListScreenState extends State<SongsListScreen> {
  @override
  Widget build(BuildContext context) {
    // Filter all songs from folderPath and add them to folderSongList
    filterSongsOnlyToList(folderPath: widget.folderPath);

    // Set the preferred orientations to portrait mode when this screen is built
    screenOrientationPortrait();

    // Filter all songs from folderPath and add them to folderSongList
    filterSongsOnlyToList(folderPath: widget.folderPath);

    // Set the preferred orientations to portrait mode when this screen is built
    screenOrientationPortrait();

    return StreamBuilder<void>(
        stream: getCurrentSongFullPathStreamController.stream,
        builder: (context, snapshot) {
          print("REBUILD LIST SONG: ${widget.folderPath}");
          return Scaffold(
            appBar: songsListAppBar(
                folderPath: widget.folderPath, context: context),
            body: Stack(
              children: [
                Column(
                  children: [
                    Expanded(
                      child: ListView.separated(
                        padding: const EdgeInsets.only(bottom: 130),
                        itemCount: folderSongList.length,
                        itemBuilder: (context, index) {
                          return SizedBox(
                            // color: TColor.darkGray,
                            height: 67,
                            // margin: const EdgeInsets.all(10),
                            child: GestureDetector(
                              onLongPress: () {
                                hideButtonSheetStreamListener(true);
                                showModalBottomSheet<void>(
                                  backgroundColor: Colors.transparent,
                                  context: context,
                                  builder: (BuildContext context) {
                                    return SongPreviewDialog(
                                        songPath: folderSongList[index].path);
                                  },
                                ).whenComplete(() {
                                  setState(() {});
                                  // "When the bottom sheet is closed, send a signal to show the mini player again."
                                  if (isSongPreviewBottomSheetOpen) {
                                    hideButtonSheetStreamListener(true);
                                  } else {
                                    hideButtonSheetStreamListener(false);
                                  }
                                });
                              },
                              child: ListTile(
                                key: ValueKey(folderSongList[index].path),
                                leading: (folderSongList[index].path ==
                                        currentSongFullPath)
                                    ? Padding(
                                        padding: const EdgeInsets.only(
                                            top: 10.0, left: 5.0, bottom: 10.0),
                                        child: SizedBox(
                                          height: 27,
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
                                      )
                                    : Icon(
                                        Icons.music_note_rounded,
                                        color: TColor.focus,
                                        size: 36,
                                      ),
                                // Image.asset(
                                //   "assets/img/songs_tab.png",
                                //   width: 35,
                                //   height: 35,
                                //   color: TColor.focus,
                                // ),
                                title: Text(
                                  folderSongList[index].name,
                                  textAlign: TextAlign.start,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    color: TColor.lightGray,
                                    fontSize: 18,
                                  ),
                                ),
                                subtitle: Text(
                                  "${folderSongList[index].size!} MB  |  ${folderSongList[index].format!}",
                                  textAlign: TextAlign.start,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    color: TColor.secondaryText,
                                    fontSize: 15,
                                  ),
                                ),
                                trailing: IconButton(
                                  splashRadius: 24,
                                  iconSize: 28,
                                  icon: Image.asset(
                                    "assets/img/more_horiz.png",
                                    color: TColor.focusSecondary,
                                  ),
                                  onPressed: () async {
                                    await hideButtonSheetStreamListener(true);
                                    showModalBottomSheet<String>(
                                      backgroundColor: Colors.transparent,
                                      context: context,
                                      builder: (BuildContext context) {
                                        return SongInfoMoreBottomSheet(
                                          fullFilePath:
                                              folderSongList[index].path,
                                        );
                                      },
                                    ).whenComplete(() {
                                      if (!Navigator.canPop(context)) {
                                        print("No other screen is open.");
                                      } else {
                                        hideButtonSheetStreamListener(false);
                                        print(
                                            " There are other open screens .");
                                      }
                                    });
                                    ;

                                    // print("lololol  ${result}");
                                    // if (result ==
                                    //     "close_song_preview_bottom_sheet") {
                                    //
                                    //   songsListScreenKey.currentState!
                                    //       .setState(() {});
                                    //   homePageFolderListScreenKey.currentState!
                                    //       .setState(() {});
                                    // }
                                  },
                                ),

                                onTap: () {
                                  setFolderAsPlaylist(folderSongList, index);
                                  print(
                                      "SONG DIRECTORY: ${getCurrentSongParentFolder(currentSongFullPath)}");
                                  print(
                                      'Tapped on ${(folderSongList[index].path)}');
                                },
                              ),
                            ),
                          );
                        },
                        separatorBuilder: (BuildContext context, int index) {
                          return Container();
                          // const Divider(
                          //   color: Colors.white12,
                          //   indent: 58,
                          //   endIndent: 10,
                          //   height: 1,
                          // );
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        });
  }
}
