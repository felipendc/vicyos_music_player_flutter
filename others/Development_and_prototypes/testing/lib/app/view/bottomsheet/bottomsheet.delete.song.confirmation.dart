import 'package:flutter/material.dart';
import 'package:flutter_media_delete/flutter_media_delete.dart';
import 'package:vicyos_music/app/color_palette/color_extension.dart';
import 'package:vicyos_music/app/components/show.top.message.dart';
import 'package:vicyos_music/app/files_and_folders_handler/folders.and.files.related.dart';
import 'package:vicyos_music/app/models/audio.info.dart';
import 'package:vicyos_music/app/music_player/music.player.functions.and.more.dart';
import 'package:vicyos_music/l10n/app_localizations.dart';

import '../../music_player/music.player.stream.controllers.dart';

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
              AppLocalizations.of(context)!.delete_from_device_all_capitalized,
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
                  AppLocalizations.of(context)!.are_you_sure,
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
                          AppLocalizations.of(context)!.cancel,
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
                          AppLocalizations.of(context)!.delete,
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: TColor.primaryText,
                            fontSize: 17,
                          ),
                        ),
                      ),
                      onPressed: () async {
                        Future.microtask(
                          () async {
                            if (songPath is String) {
                              print("xxxxxxx STRING  ${songPath}");

                              FlutterMediaDelete.deleteMediaFile(
                                      songPath.toString())
                                  .then(
                                (wasDeleted) async {
                                  if (context.mounted) {
                                    await deleteSongFromStorage(
                                        context: context,
                                        wasDeleted: wasDeleted,
                                        songPath: songPath);
                                  }
                                },
                              );
                            } else if (songPath is Set<AudioInfo>) {
                              print("xxxxxxx DYNAMIC  ${songPath}");

                              Set<AudioInfo> selectedItemsTemp = {};

                              for (AudioInfo song in songPath) {
                                selectedItemsTemp.add(song);

                                await FlutterMediaDelete.deleteMediaFile(
                                        song.path.toString())
                                    .then(
                                  (wasDeleted) async {
                                    if (context.mounted) {
                                      await deleteSongFromStorage(
                                          context: context,
                                          wasDeleted: wasDeleted,
                                          songPath: song.path,
                                          multipleFiles: true);
                                    }
                                  },
                                );
                              }

                              if (context.mounted) {
                                showFileDeletedMessage(
                                  context,
                                  AppLocalizations.of(context)!
                                      .song_plural(songPath.length),
                                  AppLocalizations.of(context)!
                                      .deleted_successfully_plural(
                                          songPath.length),
                                );
                              }

                              //------------------------------------------
                              for (AudioInfo song in selectedItemsTemp) {
                                selectedItemsFromMultiselectionScreen
                                    .remove(song);
                                songModelListGlobal.remove(song);

                                // Rebuild the top Container and the listview only
                                rebuildMultiSelectionScreenNotifier();
                              }
                              //-----------------------------------------

                              if (context.mounted) {
                                Navigator.pop(context);
                              }
                            }
                          },
                        );
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
