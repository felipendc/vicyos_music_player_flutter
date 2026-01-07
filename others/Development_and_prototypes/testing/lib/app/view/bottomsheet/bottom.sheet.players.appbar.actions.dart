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

class PlayerPreviewAppBarActionsBottomSheet extends StatelessWidget {
  final bool songIsFavorite;
  final dynamic fullFilePath;
  final String audioRoute;
  const PlayerPreviewAppBarActionsBottomSheet({
    super.key,
    required this.fullFilePath,
    required this.audioRoute,
    required this.songIsFavorite,
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
        height: isSongPreviewBottomSheetOpen ? 430 : 365, // Adjust the height
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
                                AppLocalizations.of(context)!.song_name,
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
                                  folderName(fullFilePath),
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

                          // Icon(
                          //   Icons.library_music,
                          //   color: TColor.focusSecondary,
                          //   size: 30,
                          // ),
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
                          List<AudioInfo> songModel = await AppDatabase.instance
                              .returnSongPathAsModel(fullFilePath);
                          if (context.mounted) {
                            Navigator.pop(context, "hide_bottom_player");
                          }

                          hideMiniPlayerNotifier(true);

                          if (context.mounted) {
                            final result = await showModalBottomSheet<String>(
                                isScrollControlled: true,
                                backgroundColor: Colors.transparent,
                                context: context,
                                builder: (BuildContext context) {
                                  return AddSongToPlaylistBottomSheet(
                                    songModels: songModel.first,
                                  );
                                });

                            if (result == "hide_bottom_player") {
                              hideMiniPlayerNotifier(true);
                            } else {
                              hideMiniPlayerNotifier(false);
                            }
                          }
                        },
                      ),
                    ),
                    (songIsFavorite)
                        ? Material(
                            color: Colors.transparent,
                            child: ListTile(
                              leading: Padding(
                                padding: const EdgeInsets.only(left: 17),
                                child: ImageIcon(
                                  AssetImage(
                                      "assets/img/bottomsheet/love_flaticone.png"),
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

                                await AppDatabase.instance.removeFromFavorites(
                                  context: context,
                                  songPath: fullFilePath,
                                );
                                rebuildFavoriteScreenNotifier();

                                if (context.mounted) {
                                  showFileDeletedMessage(
                                    context,
                                    songName(fullFilePath),
                                    AppLocalizations.of(context)!
                                        .removed_from_favorites,
                                  );
                                }
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
                                      "assets/img/bottomsheet/love_flaticone.png"),
                                  color: TColor.focus,
                                  size: 29,
                                ),
                              ),
                              title: Text(
                                AppLocalizations.of(context)!.add_to_favorites,
                                style: TextStyle(
                                  color: TColor.primaryText80,
                                  fontSize: 18,
                                ),
                              ),
                              contentPadding:
                                  const EdgeInsets.fromLTRB(0, 4, 0, 4),
                              onTap: () async {
                                Navigator.pop(context);

                                // Get the AudioInfo model of the file path from db
                                final songPathAsModel = await AppDatabase
                                    .instance
                                    .returnSongPathAsModel(fullFilePath);

                                await AppDatabase.instance
                                    .addToFavorites(songPathAsModel.first);
                                rebuildFavoriteScreenNotifier();

                                if (context.mounted) {
                                  addedToFavoritesSnackBar(
                                    context: context,
                                    text: songPathAsModel.first.name,
                                    message: AppLocalizations.of(context)!
                                        .added_to_favorites,
                                  );
                                }
                              },
                            ),
                          ),
                    if (isSongPreviewBottomSheetOpen)
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
                              playNextFilePath: fullFilePath,
                              context: context,
                              audioRoute: audioRoute,
                              audioRouteEmptyPlaylist: audioRoute,
                            );
                            Navigator.pop(context);
                            showAddedToPlaylist(
                                context,
                                "Song",
                                songName(fullFilePath),
                                AppLocalizations.of(context)!
                                    .added_to_play_next);
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
                          await sharingFiles(fullFilePath, context);
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
                          final result = await showModalBottomSheet<String>(
                            backgroundColor: Colors.transparent,
                            context: context,
                            builder: (BuildContext context) {
                              return DeleteSongConfirmationDialog(
                                  songPath: fullFilePath);
                            },
                          );

                          if (result == "close_song_preview_bottom_sheet") {
                            if (context.mounted) {
                              Navigator.pop(
                                  context, "close_song_preview_bottom_sheet");
                            }
                          } else {
                            if (context.mounted) {
                              Navigator.pop(context);
                            }
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
