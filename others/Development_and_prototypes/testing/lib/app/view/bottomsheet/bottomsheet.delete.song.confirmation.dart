import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_media_delete/flutter_media_delete.dart';
import 'package:vicyos_music/app/color_palette/color_extension.dart';
import 'package:vicyos_music/app/components/show.top.message.dart';
import 'package:vicyos_music/app/files_and_folders_handler/folders.and.files.related.dart';
import 'package:vicyos_music/app/models/audio.info.dart';
import 'package:vicyos_music/app/music_player/music.player.functions.and.more.dart';
import 'package:vicyos_music/database/database.dart';
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
                              //////////////////////////////////////////////////
                              if (songPath.contains(
                                  "/storage/emulated/0/Music/Vicyos Radio Recordings/")) {
                                final file = File(songPath.toString());

                                final fileFolder = Directory(songPath).parent;

                                if (await file.exists()) {
                                  await file.delete();
                                  if (context.mounted) {
                                    await deleteSongFromStorage(
                                        context: context,
                                        wasDeleted:
                                            "Files deleted successfully",
                                        songPath: songPath);
                                  }

                                  final folderContentLength = await AppDatabase
                                      .instance
                                      .getFolderContentByPath(
                                          fileFolder.absolute.path);

                                  if (await fileFolder.exists()) {
                                    if (folderContentLength.isEmpty) {
                                      if (context.mounted) {
                                        Navigator.pop(context);
                                      }
                                    }
                                  }
                                }

                                await AppDatabase.instance
                                    .removeEmptyFoldersAndDeletedFolders();
                                rebuildSongsListScreenNotifier();

                                ////////////////////////////////////////////////
                              } else {
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

                                ////////////////// TESTING /////////////////////
                                final folderContentLength = await AppDatabase
                                    .instance
                                    .getFolderContentByPath(
                                        songPath.absolute.path);

                                if (await songPath.exists()) {
                                  if (folderContentLength.isEmpty) {
                                    if (context.mounted) {
                                      Navigator.pop(context);
                                    }
                                  }
                                }

                                await AppDatabase.instance
                                    .removeEmptyFoldersAndDeletedFolders();
                                rebuildSongsListScreenNotifier();
                                ////////////////////////////////////////////////
                              }
                            } else if (songPath is Set<AudioInfo>) {
                              //////////////////////////////////////////////////

                              if (songPath.contains(
                                  "/storage/emulated/0/Music/Vicyos Radio Recordings/")) {
                                final fileFolder =
                                    Directory(songPath.first.path).parent;

                                // print("aaaa SET $songPath");
                                Set<AudioInfo> selectedItemsTemp = {};

                                for (final song in songPath) {
                                  final songPathString = song.path;
                                  final file = File(songPathString.toString());

                                  selectedItemsTemp.add(song);

                                  await file.delete();

                                  if (context.mounted) {
                                    await deleteSongFromStorage(
                                        context: context,
                                        wasDeleted:
                                            "Files deleted successfully",
                                        songPath: song.path,
                                        multipleFiles: true);
                                  }
                                }

                                final folderContentLength = await AppDatabase
                                    .instance
                                    .getFolderContentByPath(
                                        fileFolder.absolute.path);
                                print("oooooo ${folderContentLength.length}");

                                if (context.mounted) {
                                  showFileDeletedMessageSnackBar(
                                    context,
                                    AppLocalizations.of(context)!
                                        .song_plural(songPath.length),
                                    AppLocalizations.of(context)!
                                        .deleted_successfully_plural(
                                            songPath.length),
                                  );
                                }
                                if (await fileFolder.exists()) {
                                  if (folderContentLength.isEmpty) {
                                    if (context.mounted) {
                                      Navigator.pop(context);
                                    }
                                  }
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
                                //==============================================
                                ////////////////////////////////////////////////
                                await AppDatabase.instance
                                    .removeEmptyFoldersAndDeletedFolders();
                                rebuildSongsListScreenNotifier();
                              } else {
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
                                  showFileDeletedMessageSnackBar(
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
                                ////////////////// TESTING /////////////////////
                                final folderContentLength = await AppDatabase
                                    .instance
                                    .getFolderContentByPath(
                                        songPath.absolute.path);

                                if (await songPath.exists()) {
                                  if (folderContentLength.isEmpty) {
                                    if (context.mounted) {
                                      Navigator.pop(context);
                                    }
                                  }
                                }
                                await AppDatabase.instance
                                    .removeEmptyFoldersAndDeletedFolders();
                                rebuildSongsListScreenNotifier();
                                ////////////////////////////////////////////////
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
