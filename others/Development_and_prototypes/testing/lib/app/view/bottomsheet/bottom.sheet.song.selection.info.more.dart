import 'package:flutter/material.dart';
import 'package:vicyos_music/app/color_palette/color_extension.dart';
import 'package:vicyos_music/app/components/show.top.message.dart';
import 'package:vicyos_music/app/files_and_folders_handler/folders.and.files.related.dart';
import 'package:vicyos_music/app/models/audio.info.dart';
import 'package:vicyos_music/app/music_player/music.player.functions.and.more.dart';
import 'package:vicyos_music/app/music_player/music.player.stream.controllers.dart';
import 'package:vicyos_music/app/view/bottomsheet/playlist_bottomsheets/bottom.sheet.add.song.to.playlist.dart';
import 'package:vicyos_music/database/database.dart';
import 'package:vicyos_music/l10n/app_localizations.dart';

import 'bottomsheet.delete.song.confirmation.dart';

class SongSelectionInfoMoreBottomSheet extends StatelessWidget {
  final bool isSongFavoriteScreen;

  final bool isFromFavoriteScreen;
  final bool isFromPlaylistSongScreen;
  final bool isFromSongsScreen;
  final NavigationButtons audioRoute;
  final String? playListName;
  final int? playlistSongIndex;
  final Set<AudioInfo> selectedItems;

  const SongSelectionInfoMoreBottomSheet({
    super.key,
    required this.isFromFavoriteScreen,
    required this.audioRoute,
    required this.isFromPlaylistSongScreen,
    this.playListName,
    this.playlistSongIndex,
    required this.selectedItems,
    required this.isSongFavoriteScreen,
    required this.isFromSongsScreen,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.vertical(
        top: Radius.circular(25),
        bottom: Radius.circular(0),
      ),
      child: Container(
        color: TColor.bg,
        height: isFromPlaylistSongScreen ? 490 : 430, // Adjust the height
        padding: const EdgeInsets.fromLTRB(0, 5, 0, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 10.0),
              child: Container(
                decoration: BoxDecoration(
                  // color: Colors.grey,
                  color: Color(0xff181B2C),
                ),
                height: 73, // Loading enabled
                child: Column(
                  // mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 0, 8, 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Arquivo selecionado(s)",
                                style: TextStyle(
                                  color: TColor.primaryText28
                                      .withValues(alpha: 0.84),
                                  fontSize: 15,
                                  fontWeight: FontWeight.w400,
                                  shadows: [
                                    Shadow(
                                      color:
                                          Colors.black.withValues(alpha: 0.2),
                                      offset: Offset(1, 1),
                                      blurRadius: 3,
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 30,
                                width: 270,
                                // color: Colors.grey,
                                child: Text(
                                  "Escolha uma opção",
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    color: TColor.primaryText
                                        .withValues(alpha: 0.84),
                                    fontSize: 20,
                                    fontWeight: FontWeight.w600,
                                    shadows: [
                                      BoxShadow(
                                        color:
                                            Colors.black.withValues(alpha: 0.2),
                                        spreadRadius: 5,
                                        blurRadius: 8,
                                        offset: Offset(2, 4),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children: [
                                Material(
                                  color: Colors.transparent,
                                  child: SizedBox(
                                    width: 35,
                                    height: 35,
                                    child: IconButton(
                                      splashRadius: 20,
                                      iconSize: 10,
                                      onPressed: () async {
                                        Navigator.pop(context);
                                      },
                                      icon: Image.asset(
                                        "assets/img/menu/close.png",
                                        color: TColor.lightGray,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: Container(
                color: TColor.bg,
                child: ListView(
                  children: [
                    if (isFromPlaylistSongScreen)
                      Material(
                        color: Colors.transparent,
                        child: ListTile(
                          leading: Padding(
                            padding: const EdgeInsets.only(left: 13),
                            child: ImageIcon(
                              AssetImage(
                                  "assets/img/bottomsheet/remove_song_flaticon.png"),
                              color: TColor.focus,
                              size: 33,
                            ),

                            // Icon(
                            //   Icons.library_music,
                            //   color: TColor.focusSecondary,
                            //   size: 30,
                            // ),
                          ),
                          title: Text(
                            AppLocalizations.of(context)!
                                .removed_from_this_playlist,
                            style: TextStyle(
                              color: TColor.primaryText80,
                              fontSize: 18,
                            ),
                          ),
                          contentPadding: const EdgeInsets.fromLTRB(0, 4, 0, 4),
                          onTap: () async {
                            Set<AudioInfo> selectedItemsTemp = {};

                            // For each song in listOfSongModel,
                            // remove them from the favorite screen and form the
                            // current playlist.
                            for (AudioInfo song in selectedItems) {
                              selectedItemsTemp.add(song);

                              await AppDatabase.instance
                                  .removeAudioFromPlaylist(
                                      playlistName: playListName!,
                                      audioPath: song.path);

                              if (context.mounted) {
                                removeSongPathFromCurrentPlaylist(
                                  context: context,
                                  songPath: song.path,
                                );
                              }
                            }

                            if (context.mounted) {
                              showFileDeletedMessage(
                                context,
                                (selectedItems.length == 1)
                                    ? selectedItems.first.name
                                    : AppLocalizations.of(context)!
                                        .song_plural(selectedItems.length),
                                AppLocalizations.of(context)!
                                    .removed_from_the_playlist_plural(
                                        selectedItems.length),
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

                            rebuildPlaylistScreenSNotifier();
                            rebuildSongsListScreenNotifier();

                            if (context.mounted) {
                              Navigator.pop(context, "");
                            }
                          },
                        ),
                      ),
                    Material(
                      color: Colors.transparent,
                      child: ListTile(
                        leading: Padding(
                          padding: const EdgeInsets.only(left: 17),
                          child: ImageIcon(
                            AssetImage(
                                "assets/img/bottomsheet/add_to_playlist_flaticon.png"),
                            color: TColor.focus,
                            size: 29,
                          ),
                        ),
                        title: Text(
                          AppLocalizations.of(context)!.add_to_a_playlist,
                          style: TextStyle(
                            color: TColor.primaryText80,
                            fontSize: 18,
                          ),
                        ),
                        contentPadding: const EdgeInsets.fromLTRB(0, 4, 0, 4),
                        onTap: () async {
                          Navigator.pop(context, "hide_bottom_player");

                          // if (deviceTypeIsSmartphone()) {
                          //   await hideMiniPlayerNotifier(true);
                          // }

                          if (context.mounted) {
                            await showModalBottomSheet<String>(
                                isScrollControlled: true,
                                backgroundColor: Colors.transparent,
                                context: context,
                                builder: (BuildContext context) {
                                  return AddSongToPlaylistBottomSheet(
                                    songModels: selectedItems,
                                  );
                                });

                            // if (result == "hide_bottom_player") {
                            //   if (deviceTypeIsSmartphone()) {
                            //     await hideMiniPlayerNotifier(true);
                            //   }
                            // } else {
                            //   if (deviceTypeIsSmartphone()) {
                            //     await hideMiniPlayerNotifier(false);
                            //   }
                            // }
                          }
                        },
                      ),
                    ),
                    //
                    if (isFromFavoriteScreen)
                      Material(
                        color: Colors.transparent,
                        child: ListTile(
                          leading: Padding(
                            padding: const EdgeInsets.only(left: 17),
                            child: ImageIcon(
                              AssetImage(
                                  "assets/img/bottomsheet/star_treamline.png"),
                              color: TColor.focus,
                              size: 29,
                            ),
                          ),
                          title: Text(
                            AppLocalizations.of(context)!.remove_from_favorites,
                            style: TextStyle(
                              color: TColor.primaryText80,
                              fontSize: 18,
                            ),
                          ),
                          contentPadding: const EdgeInsets.fromLTRB(0, 4, 0, 4),
                          onTap: () async {
                            Set<AudioInfo> selectedItemsTemp = {};

                            for (AudioInfo song in selectedItems) {
                              selectedItemsTemp.add(song);

                              await AppDatabase.instance
                                  .removeFromFavorites(song.path, context);
                            }

                            if (context.mounted) {
                              showFileDeletedMessage(
                                context,
                                (selectedItems.length == 1)
                                    ? selectedItems.first.name
                                    : AppLocalizations.of(context)!
                                        .song_plural(selectedItems.length),
                                AppLocalizations.of(context)!
                                    .removed_from_the_favorite_plural(
                                        selectedItems.length),
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
                            rebuildFavoriteScreenNotifier();
                            if (context.mounted) {
                              Navigator.pop(context);
                            }
                          },
                        ),
                      ),
                    if (!isFromFavoriteScreen)
                      (isSongFavoriteScreen)
                          ? Material(
                              color: Colors.transparent,
                              child: ListTile(
                                leading: Padding(
                                  padding: const EdgeInsets.only(left: 17),
                                  child: ImageIcon(
                                    AssetImage(
                                        "assets/img/bottomsheet/star_treamline.png"),
                                    color: TColor.focus,
                                    size: 29,
                                  ),
                                ),
                                title: Text(
                                  AppLocalizations.of(context)!
                                      .remove_from_favorites,
                                  style: TextStyle(
                                    color: TColor.primaryText80,
                                    fontSize: 18,
                                  ),
                                ),
                                contentPadding:
                                    const EdgeInsets.fromLTRB(0, 4, 0, 4),
                                onTap: () async {
                                  Navigator.pop(context);

                                  for (AudioInfo song in selectedItems) {
                                    await AppDatabase.instance
                                        .removeFromFavorites(
                                            song.path, context);
                                  }

                                  if (context.mounted) {
                                    showFileDeletedMessage(
                                      context,
                                      (selectedItems.length == 1)
                                          ? selectedItems.first.name
                                          : AppLocalizations.of(context)!
                                              .song_plural(
                                                  selectedItems.length),
                                      AppLocalizations.of(context)!
                                          .removed_from_the_favorite_plural(
                                              selectedItems.length),
                                    );
                                  }

                                  // if (deviceTypeIsSmartphone()) {
                                  //   hideMiniPlayerNotifier(false);
                                  // }
                                },
                              ),
                            )
                          : Material(
                              color: Colors.transparent,
                              child: ListTile(
                                leading: Padding(
                                  padding: const EdgeInsets.only(left: 17),
                                  child: ImageIcon(
                                    AssetImage(
                                        "assets/img/bottomsheet/star_treamline.png"),
                                    color: TColor.focus,
                                    size: 29,
                                  ),
                                ),
                                title: Text(
                                  AppLocalizations.of(context)!
                                      .add_to_favorites,
                                  style: TextStyle(
                                    color: TColor.primaryText80,
                                    fontSize: 18,
                                  ),
                                ),
                                contentPadding:
                                    const EdgeInsets.fromLTRB(0, 4, 0, 4),
                                onTap: () async {
                                  Navigator.pop(context);

                                  for (AudioInfo song in selectedItems) {
                                    await AppDatabase.instance
                                        .addToFavorites(song);
                                  }

                                  if (context.mounted) {
                                    addedToAPlaylistSnackBar(
                                      context: context,
                                      text: (selectedItems.length == 1)
                                          ? selectedItems.first.name
                                          : AppLocalizations.of(context)!
                                              .song_plural(
                                                  selectedItems.length),
                                      message: AppLocalizations.of(context)!
                                          .added_successfully_plural(
                                              selectedItems.length),
                                    );
                                  }
                                },
                              ),
                            ),
                    // Material(
                    //   color: Colors.transparent,
                    //   child: ListTile(
                    //     leading: Padding(
                    //       padding: const EdgeInsets.only(left: 17),
                    //       child: ImageIcon(
                    //         AssetImage(
                    //             "assets/img/bottomsheet/sound_sampler.png"),
                    //         color: TColor.focus,
                    //         size: 32,
                    //       ),
                    //     ),
                    //     title: Text(
                    //       AppLocalizations.of(context)!.song_preview,
                    //       style: TextStyle(
                    //         color: TColor.primaryText80,
                    //         fontSize: 18,
                    //       ),
                    //     ),
                    //     contentPadding: const EdgeInsets.fromLTRB(0, 4, 0, 4),
                    //     onTap: () async {
                    //       if (audioPlayer.playerState.playing) {
                    //         audioPlayerWasPlaying = true;
                    //       } else {
                    //         audioPlayerWasPlaying = false;
                    //       }
                    //       isSongPreviewBottomSheetOpen = true;
                    //
                    //       if (deviceTypeIsSmartphone()) {
                    //         hideMiniPlayerNotifier(true);
                    //       }
                    //
                    //       Navigator.pop(context);
                    //
                    //       showModalBottomSheet<String>(
                    //           isScrollControlled: true,
                    //           backgroundColor: Colors.transparent,
                    //           context: context,
                    //           builder: (BuildContext context) {
                    //             return SongPreviewBottomSheet(
                    //               songModel: songModels,
                    //               audioRoute: audioRoute,
                    //             );
                    //           }).whenComplete(
                    //         () {
                    //           isSongPreviewBottomSheetOpen = false;
                    //
                    //           if (deviceTypeIsSmartphone()) {
                    //             // "When the bottom sheet is closed, send a signal to show the mini player again."
                    //             hideMiniPlayerNotifier(false);
                    //           }
                    //           audioPlayerPreview.stop();
                    //           audioPlayerPreview.release();
                    //
                    //           if (audioPlayerWasPlaying) {
                    //             Future.microtask(
                    //               () async {
                    //                 await audioPlayer.play();
                    //               },
                    //             );
                    //           }
                    //           if (context.mounted) {
                    //             Navigator.pop(context);
                    //           }
                    //
                    //           if (isRadioOn && isRadioPaused) {
                    //             radioPlayer.play();
                    //           }
                    //         },
                    //       );
                    //     },
                    //   ),
                    // ),
                    Material(
                      color: Colors.transparent,
                      child: ListTile(
                        leading: Padding(
                          padding: const EdgeInsets.only(left: 17),
                          child: ImageIcon(
                            AssetImage(
                                "assets/img/bottom_player/skip_next.png"),
                            color: TColor.focus,
                            size: 32,
                          ),
                        ),
                        title: Text(
                          AppLocalizations.of(context)!.add_to_play_next,
                          style: TextStyle(
                            color: TColor.primaryText80,
                            fontSize: 18,
                          ),
                        ),
                        contentPadding: const EdgeInsets.fromLTRB(0, 4, 0, 4),
                        onTap: () {
                          addToPlayNext(
                            playNextFilePath: selectedItems,
                            context: context,
                            audioRoute: audioRoute,
                            audioRouteEmptyPlaylist: audioRoute,
                          );

                          Navigator.pop(context);

                          showAddedToPlaylist(
                            context,
                            "Song",
                            (selectedItems.length == 1)
                                ? songName(selectedItems.first.path)
                                : AppLocalizations.of(context)!
                                    .song_plural(selectedItems.length),
                            AppLocalizations.of(context)!
                                .added_to_play_next_plural(
                                    selectedItems.length),
                          );
                        },
                      ),
                    ),
                    Material(
                      color: Colors.transparent,
                      child: ListTile(
                        leading: Padding(
                          padding: const EdgeInsets.only(left: 17),
                          child: ImageIcon(
                            AssetImage("assets/img/bottomsheet/share.png"),
                            color: TColor.focus,
                            size: 32,
                          ),
                        ),
                        title: Text(
                          AppLocalizations.of(context)!.share,
                          style: TextStyle(
                            color: TColor.primaryText80,
                            fontSize: 18,
                          ),
                        ),
                        contentPadding: const EdgeInsets.fromLTRB(0, 4, 0, 4),
                        onTap: () async {
                          Navigator.pop(context);
                          await sharingFiles(selectedItems, context);
                          // if (deviceTypeIsSmartphone()) {
                          //   hideMiniPlayerNotifier(false);
                          // }
                        },
                      ),
                    ),
                    Material(
                      color: Colors.transparent,
                      child: ListTile(
                        leading: Padding(
                          padding: const EdgeInsets.only(left: 17),
                          child: ImageIcon(
                            AssetImage("assets/img/menu/delete_outlined.png"),
                            color: TColor.focus,
                            size: 32,
                          ),
                        ),
                        title: Text(
                          AppLocalizations.of(context)!.delete_from_device,
                          style: TextStyle(
                            color: TColor.primaryText80,
                            fontSize: 18,
                          ),
                        ),
                        contentPadding: const EdgeInsets.fromLTRB(0, 4, 0, 4),
                        onTap: () async {
                          await showModalBottomSheet<String>(
                            backgroundColor: Colors.transparent,
                            context: context,
                            builder: (BuildContext context) {
                              return DeleteSongConfirmationDialog(
                                  songPath: selectedItems);
                            },
                          );

                          // if (result == "close_song_preview_bottom_sheet") {
                          //   if (context.mounted) {
                          //     Navigator.pop(
                          //         context, "close_song_preview_bottom_sheet");
                          //   }
                          // } else if (result == "canceled") {
                          //   if (deviceTypeIsSmartphone()) {
                          //     hideMiniPlayerNotifier(false);
                          //   }
                          // }
                          if (context.mounted) {
                            Navigator.pop(context);
                          }
                        },
                      ),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
