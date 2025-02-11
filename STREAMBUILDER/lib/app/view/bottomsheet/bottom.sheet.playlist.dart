import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:vicyos_music/app/common/color_extension.dart';
import 'package:vicyos_music/app/functions/folders.and.files.related.dart';
import 'package:vicyos_music/app/functions/music_player.dart';
import 'package:vicyos_music/app/widgets/music_visualizer.dart';

class PlaylistBottomSheet extends StatelessWidget {
  PlaylistBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    late ScrollController _scrollController;

    Future<void> _onReorder(int oldIndex, int newIndex) async {
      if (newIndex > oldIndex) {
        newIndex -= 1;
      }
      playlist.move(oldIndex, newIndex);
      audioPlayer.currentIndexStream.listen((index) {
        currentIndex = audioPlayer.sequence![index!] as int;
      });
      rebuildPlaylistBottomSheetStreamNotifier(true);
    }

    _scrollController = ScrollController();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      double scrollPadding = 60;
      double tileHeight = 72;
      double scrollOffset = currentIndex * tileHeight - scrollPadding;

      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          scrollOffset,
          duration: Duration(seconds: 1),
          curve: Curves.easeInOut,
        );
      }
    });

    var media = MediaQuery.of(context).size;
    return ClipRRect(
      borderRadius: const BorderRadius.vertical(
        top: Radius.circular(25),
        bottom: Radius.circular(0),
      ),
      child: Container(
        color: TColor.bg,
        height: media.height * 0.5, // Adjust the height
        padding: const EdgeInsets.fromLTRB(0, 5, 0, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 10),
            // Top button indicator
            Container(
              alignment: Alignment.center,
              width: 200,
              margin: const EdgeInsets.only(top: 10, bottom: 10),
              height: 50,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
              ),
              child: Center(
                child: FloatingActionButton.extended(
                  label: Text(
                    'CLEAR PLAYLIST',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: TColor.org,
                      fontSize: 17,
                    ),
                  ),
                  onPressed: () {
                    // Clean playlist and rebuild the entire screen to clean the listview
                    cleanPlaylist();
                    rebuildPlaylistBottomSheetStreamNotifier(true);
                  },
                  backgroundColor: TColor.darkGray,
                ),
              ),
            ),
            const SizedBox(height: 15),
            StreamBuilder<bool>(
                stream: rebuildPlaylistBottomSheet.stream,
                builder: (context, snapshot) {
                  return Expanded(
                    child: ReorderableListView.builder(
                      scrollController: _scrollController,
                      itemCount: playlist.children.length,
                      onReorder: _onReorder,
                      itemBuilder: (BuildContext context, int index) {
                        return Container(
                          height: 72,
                          color: TColor.bg,
                          key: ValueKey(
                            '${songFullPath(index: index)}-$index',
                          ),
                          child: Column(
                            children: [
                              Material(
                                color: Colors.transparent,
                                child: StreamBuilder<PlaybackEvent>(
                                  stream: audioPlayer.playbackEventStream,
                                  builder: (context, snapshot) {
                                    return ListTile(
                                      leading: currentIndex == index
                                          ? SizedBox(
                                              height: 30,
                                              width: 38,
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
                                            )
                                          : Icon(
                                              Icons.play_circle_filled_rounded,
                                              color: TColor.focus,
                                              size: 28,
                                            ),
                                      title: Text(
                                        songName(
                                          songFullPath(index: index),
                                        ),
                                        textAlign: TextAlign.start,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          color: TColor.primaryText,
                                          fontFamily: "Circular Std",
                                          fontSize: 17,
                                        ),
                                      ),
                                      subtitle: Text(
                                        /*${index + 1}*/ '${getFileSize(songFullPath(index: index))}MB  |  ${getFileExtension(songFullPath(index: index))}',
                                        style: const TextStyle(
                                            fontFamily: "Circular Std",
                                            fontSize: 15,
                                            color: Colors.white70),
                                      ),
                                      trailing: IconButton(
                                        splashRadius: 26,
                                        iconSize: 26,
                                        icon: const Icon(
                                            Icons.delete_forever_rounded),
                                        color: TColor.focusSecondary,
                                        onPressed: () {
                                          playlist.removeAt(index);
                                          rebuildPlaylistBottomSheetStreamNotifier(
                                              true);

                                          playlistLength =
                                              playlist.children.length;
                                          if (currentIndex == index) {
                                            preLoadSongName();
                                          }
                                          playlistLengthStreamNotifier();
                                        },
                                      ),
                                      onTap: () async {
                                        if (currentIndex == index) {
                                          if (songIsPlaying) {
                                            audioPlayer.pause();
                                            songIsPlaying = false;
                                          } else {
                                            audioPlayer.play();
                                            songIsPlaying = true;
                                          }
                                        } else {
                                          audioPlayer.setAudioSource(playlist,
                                              initialIndex: index,
                                              preload: false);

                                          audioPlayer.play();
                                          rebuildPlaylistBottomSheetStreamNotifier(
                                              true);

                                          songIsPlaying = true;
                                        }
                                      },
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  );
                }),
          ],
        ),
      ),
    );
  }
}
