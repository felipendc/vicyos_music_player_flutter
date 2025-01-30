import 'package:flutter/material.dart';
import 'package:vicyos_music/app/common/color_extension.dart';
import 'package:vicyos_music/app/functions/folders.and.files.related.dart';
import 'package:vicyos_music/app/functions/music_player.dart';
import 'package:vicyos_music/app/functions/screen.orientation.dart';
import 'package:vicyos_music/app/view/song.preview.dialog.dart';
import 'package:vicyos_music/app/widgets/appbars.dart';
import 'package:vicyos_music/app/widgets/bottom.player.dart';

import '../widgets/music_visualizer.dart';

class SongsListScreen extends StatelessWidget {
  final String folderPath;
  const SongsListScreen({super.key, required this.folderPath});

  @override
  Widget build(BuildContext context) {
    // Filter all songs from folderPath and add them to folderSongList
    filterSongsOnlyToList(folderPath: folderPath);

    // Set the preferred orientations to portrait mode when this screen is built
    screenOrientationPortrait();

    return Scaffold(
      appBar: songsListAppBar(folderPath: folderPath, context: context),
      body: Stack(
        children: [
          Column(
            children: [
              StreamBuilder<void>(
                  stream: getCurrentSongFullPathStreamController.stream,
                  builder: (context, snapshot) {
                    return Expanded(
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
                                showModalBottomSheet<void>(
                                  backgroundColor: Colors.transparent,
                                  context: context,
                                  builder: (BuildContext context) {
                                    return SongPreviewDialog(
                                        songPath: folderSongList[index].path);
                                  },
                                );
                              },
                              child: ListTile(
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
                                  icon: Icon(
                                    Icons.playlist_add_rounded,
                                    color: TColor.focusSecondary,
                                  ),
                                  onPressed: () {
                                    addSongToPlaylist(
                                        folderSongList[index].path);

                                    // addPlaylistSnackbar(
                                    //   title: folderSongList[index].name,
                                    //   message:
                                    //       'This song has been added to the playlist',
                                    // );
                                  },
                                ),

                                onTap: () {
                                  setFolderAsPlaylist(folderSongList, index);
                                  print(
                                      "DIRETORIO DA MUSICA: ${getCurrentSongParentFolder(currentSongFullPath)}");
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
                    );
                  }),
            ],
          ),
          Positioned(
            bottom: 6,
            right: 11,
            child: StreamBuilder<void>(
                stream: miniPlayerStreamController.stream,
                builder: (context, snapshot) {
                  return BottomPlayer();
                }),
          ),
        ],
      ),
    );
  }
}
