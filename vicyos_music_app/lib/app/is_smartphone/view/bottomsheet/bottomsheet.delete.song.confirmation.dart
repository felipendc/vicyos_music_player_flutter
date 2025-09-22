import 'package:flutter/material.dart';
import 'package:flutter_media_delete/flutter_media_delete.dart';
import 'package:just_audio/just_audio.dart';
import 'package:vicyos_music/app/common/color_palette/color_extension.dart';
import 'package:vicyos_music/app/common/files_and_folders_handler/folders.and.files.related.dart';
import 'package:vicyos_music/app/common/music_player/music.player.dart';
import '../../widgets/show.top.message.dart';

class DeleteSongConfirmationDialog extends StatelessWidget {
  final dynamic songPath;
  const DeleteSongConfirmationDialog({super.key, required this.songPath});

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    return ClipRRect(
      borderRadius: const BorderRadius.vertical(
        top: Radius.circular(25),
        bottom: Radius.circular(0),
      ),
      child: Container(
        color: TColor.bg,
        height: media.height * 0.3, // Adjust the height as needed
        padding: const EdgeInsets.fromLTRB(0, 5, 0, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            Text(
              "DELETE FILE FROM DEVICE",
              style: TextStyle(
                fontWeight: FontWeight.w900,
                color: TColor.org,
                fontSize: 19,
              ),
            ),
            const SizedBox(height: 30),
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Are you sure?",
                  style: TextStyle(
                    fontWeight: FontWeight.w900,
                    color: TColor.primaryText80,
                    fontSize: 19,
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    FloatingActionButton.extended(
                      label: Padding(
                        padding: const EdgeInsets.only(left: 15, right: 15),
                        child: Text(
                          'Cancel',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: TColor.primaryText80,
                            fontSize: 17,
                          ),
                        ),
                      ),
                      onPressed: () {
                        Navigator.pop(context, "canceled");
                      },
                      backgroundColor: TColor.darkGray,
                    ),
                    const SizedBox(width: 20),
                    FloatingActionButton.extended(
                      label: Padding(
                        padding: const EdgeInsets.only(left: 15, right: 15),
                        child: Text(
                          'Delete',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: TColor.primaryText,
                            fontSize: 17,
                          ),
                        ),
                      ),
                      onPressed: () async {
                        Future.microtask(() async {
                          FlutterMediaDelete.deleteMediaFile(songPath)
                              .then((wasDeleted) async {
                            if (wasDeleted == "Files deleted successfully") {
                              // ----------------------------------------------------------
                              musicFolderPaths.clear();
                              folderSongList.clear();

                              // Re sync the folder list
                              await listMusicFolders();

                              // Check if the file is present on the playlist...
                              final int index = audioPlayer.audioSources.indexWhere(
                                  (audio) =>
                                      (audio as UriAudioSource)
                                          .uri
                                          .toFilePath() ==
                                      songPath);

                              if (index != -1) {
                                await audioPlayer
                                    .removeAudioSourceAt(index);
                                rebuildPlaylistCurrentLengthStreamNotifier();
                                await getCurrentSongFullPathStreamControllerNotifier();


                                // Update the current song name
                                if (index < audioPlayer.audioSources.length) {
                                  String newCurrentSongFullPath =
                                      Uri.decodeFull((audioPlayer.audioSources[index]
                                              as UriAudioSource)
                                          .uri
                                          .toString());
                                  currentSongName =
                                      songName(newCurrentSongFullPath);
                                } else {
                                  currentSongName = "";
                                }

                                currentSongNameStreamNotifier();
                              }
                              // ----------------------------------------------------------
                              rebuildSongsListScreenStreamNotifier();
                              rebuildHomePageFolderListStreamNotifier(
                                  "fetching_files_done");
                              if (context.mounted) {
                                Navigator.pop(
                                    context, "close_song_preview_bottom_sheet");
                              }
                            } else if (wasDeleted !=
                                "Files deleted successfully") {
                              if (context.mounted) {
                                Navigator.pop(context);
                              }
                            }
                            if (context.mounted) {
                              showFileDeletedMessage(context, songName(songPath),
                                  "Has been deleted successfully");
                            }
                          },
                          );
                        });
                      },
                      backgroundColor: TColor.darkGray,
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
