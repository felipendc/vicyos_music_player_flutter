import 'package:flutter/material.dart';
import 'package:vicyos_music/app/color_palette/color_extension.dart';
import 'package:vicyos_music/app/models/playlists.dart';
import 'package:vicyos_music/app/music_player/music.player.stream.controllers.dart';
import 'package:vicyos_music/database/database.dart';
import 'package:vicyos_music/l10n/app_localizations.dart';

import 'bottom.sheet.delete.playlist.confirmation.dart';
import 'bottom.sheet.rename.playlist.dart';

class PlaylistSongMenuBottomSheet extends StatelessWidget {
  final List<Playlists> playlistModel;
  final int index;
  const PlaylistSongMenuBottomSheet({
    super.key,
    required this.playlistModel,
    required this.index,
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
        height: 300, // Adjust the height as needed
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
                                "${AppLocalizations.of(context)!.playlist}:",
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
                                  playlistModel[index].playlistName,
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
                                        Navigator.pop(context, "");
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

            // Content
            Expanded(
              child: Container(
                color: TColor.bg,
                child: FutureBuilder<List<Playlists>>(
                    future: AppDatabase.instance.getAllPlaylists(),
                    builder: (context, musicSnapshot) {
                      // Treating the waiting
                      if (musicSnapshot.connectionState ==
                          ConnectionState.waiting) {
                        return const SizedBox();
                      }

                      // If has error show a blank screen
                      if (musicSnapshot.hasError) {
                        return const SizedBox();
                      }

                      return ListView(
                        children: [
                          Material(
                            color: Colors.transparent,
                            child: ListTile(
                              leading: Padding(
                                padding: const EdgeInsets.only(left: 17),
                                child: Icon(
                                  Icons.queue_music_rounded,
                                  color: TColor.focus,
                                  size: 38,
                                ),
                              ),
                              title: Text(
                                AppLocalizations.of(context)!
                                    .rename_this_playlist,
                                style: TextStyle(
                                  color: TColor.primaryText80,
                                  fontSize: 18,
                                ),
                              ),
                              contentPadding:
                                  const EdgeInsets.fromLTRB(0, 4, 0, 4),
                              onTap: () async {
                                hideMiniPlayerNotifier(true);
                                Navigator.pop(context, "hide_bottom_player");

                                final result =
                                    await showModalBottomSheet<String>(
                                  backgroundColor: Colors.transparent,
                                  context: context,
                                  builder: (BuildContext context) {
                                    return RenamePlaylistBottomSheet(
                                      playlistName:
                                          playlistModel[index].playlistName,
                                    );
                                  },
                                );

                                if (result == "hide_bottom_player") {
                                  // "When the bottom sheet is closed, send a signal to show the mini player again."
                                  hideMiniPlayerNotifier(true);
                                } else {
                                  // "When the bottom sheet is closed, send a signal to show the mini player again."
                                  hideMiniPlayerNotifier(false);
                                }
                              },
                            ),
                          ),
                          const Divider(
                            color: Colors.white12,
                            indent: 70,
                            endIndent: 25,
                            height: 1,
                          ),
                          Material(
                            color: Colors.transparent,
                            child: ListTile(
                              leading: Padding(
                                padding: const EdgeInsets.only(left: 17),
                                child: Icon(
                                  Icons.delete_sweep_outlined,
                                  color: TColor.focus,
                                  size: 40,
                                ),
                              ),
                              title: Text(
                                AppLocalizations.of(context)!
                                    .delete_this_playlist,
                                style: TextStyle(
                                  color: TColor.primaryText80,
                                  fontSize: 18,
                                ),
                              ),
                              contentPadding:
                                  const EdgeInsets.fromLTRB(0, 4, 0, 4),
                              onTap: () async {
                                hideMiniPlayerNotifier(true);

                                final result =
                                    await showModalBottomSheet<String>(
                                  backgroundColor: Colors.transparent,
                                  context: context,
                                  builder: (BuildContext context) {
                                    return DeletePlaylistConfirmationBottomSheet(
                                      playlistName:
                                          playlistModel[index].playlistName,
                                    );
                                  },
                                );

                                if (result == "playlist_was_deleted") {
                                  if (context.mounted) {
                                    Navigator.pop(
                                        context, "playlist_was_deleted");
                                  }

                                  // "When the bottom sheet is closed, send a signal to show the mini player again."
                                  hideMiniPlayerNotifier(false);
                                } else {
                                  // "When the bottom sheet is closed, send a signal to show the mini player again."
                                  hideMiniPlayerNotifier(true);
                                }
                              },
                            ),
                          ),
                          const Divider(
                            color: Colors.white12,
                            indent: 70,
                            endIndent: 25,
                            height: 1,
                          ),
                          const SizedBox(
                            height: 30,
                          ),
                        ],
                      );
                    }),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
