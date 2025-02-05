import 'package:flutter/material.dart';
import 'package:flutter_media_delete/flutter_media_delete.dart';
import 'package:just_audio/just_audio.dart';
import 'package:vicyos_music/app/common/color_extension.dart';
import 'package:vicyos_music/app/functions/folders.and.files.related.dart';
import 'package:vicyos_music/app/functions/music_player.dart';

late bool audioPlayerWasPlaying;

class DeleteSongConfirmationDialog extends StatelessWidget {
  final String songPath;

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
                        Navigator.pop(context);
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
                          final wasDeleted =
                              await FlutterMediaDelete.deleteMediaFile(
                                  songPath);

                          if (wasDeleted == "Files deleted successfully") {
                            // ----------------------------------------------------------
                            musicFolderPaths.clear();
                            folderSongList.clear();

                            // Re sync the folder list
                            await listMusicFolders();

                            // Check if the file is present on the playlist...
                            // If it is, remove it from the playlist.
                            final int index = playlist.children.indexWhere(
                                (audio) =>
                                    (audio as UriAudioSource)
                                        .uri
                                        .toFilePath() ==
                                    songPath);

                            if (index != -1) {
                              await playlist.removeAt(index);
                              // Update the playlist length...
                              await playlistLengthStreamListener();

                              // Update get the name of the song from the current index
                              // And update the screen
                              await getCurrentSongFullPathStreamControllerListener(
                                  "");

                              // Get the name of the current playlist index
                              String newCurrentSongFullPath = Uri.decodeFull(
                                  ((playlist.children[index] as UriAudioSource)
                                      .uri
                                      .toString()));

                              // Update the current song name
                              currentSongName =
                                  await songName(newCurrentSongFullPath);

                              // Send a signal to the stream builders to update the screen
                              await currentSongNameStreamListener("update");
                            }

                            // ----------------------------------------------------------

                            Navigator.pop(
                                context, "close_song_preview_bottom_sheet");
                          }
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
