import 'package:flutter/material.dart';
import 'package:vicyos_music/app/color_palette/color_extension.dart';
import 'package:vicyos_music/app/components/show.top.message.dart';
import 'package:vicyos_music/app/models/playlists.dart';
import 'package:vicyos_music/app/music_player/music.player.functions.and.more.dart';
import 'package:vicyos_music/app/music_player/music.player.stream.controllers.dart';
import 'package:vicyos_music/database/database.dart';
import 'package:vicyos_music/l10n/app_localizations.dart';

class DeletePlaylistBottomSheet extends StatelessWidget {
  const DeletePlaylistBottomSheet({
    super.key,
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
        height: 350, // Adjust the height as needed
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
                                AppLocalizations.of(context)!.delete_a_playlist,
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
                                  AppLocalizations.of(context)!
                                      .choose_a_playlist,
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
                                        if (deviceTypeIsSmartphone()) {
                                          hideMiniPlayerNotifier(false);
                                        }
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
              child: StreamBuilder<void>(
                stream: rebuildPlaylistScreenStreamController.stream,
                builder: (context, snapshot) {
                  return FutureBuilder<List<Playlists>>(
                      future: AppDatabase.instance.getAllPlaylists(),
                      builder: (context, snapshot) {
                        final playlists = snapshot.data ?? [];

                        return ListView.separated(
                          padding: const EdgeInsets.only(
                            bottom: 50,
                          ),
                          itemCount: playlists.length,
                          itemBuilder: (context, index) {
                            final playlist = playlists[index];

                            return SizedBox(
                              height: 70,
                              child: GestureDetector(
                                child: ListTile(
                                  leading: Icon(
                                    Icons.queue_music_rounded,
                                    color: TColor.focusSecondary,
                                    size: 44,
                                  ),
                                  title: Text(
                                    playlist.playlistName,
                                    textAlign: TextAlign.start,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      color: TColor.lightGray,
                                      fontSize: 20,
                                    ),
                                  ),
                                  subtitle: Text(
                                    "${playlist.playlistSongs.length} ${AppLocalizations.of(context)!.playlist_total_of_songs(playlist.playlistSongs.length)}",
                                    style: const TextStyle(
                                        fontFamily: "Circular Std",
                                        fontSize: 15,
                                        color: Colors.white70),
                                  ),
                                  trailing: Material(
                                    color: Colors.transparent,
                                    child: IconButton(
                                      splashRadius: 20,
                                      iconSize: 26,
                                      onPressed: () async {
                                        if (!context.mounted) return;
                                        deletePlaylistSnackBar(
                                            context: context,
                                            text: playlist.playlistName,
                                            message: AppLocalizations.of(
                                                    context)!
                                                .playlist_deleted_successfully);

                                        await AppDatabase.instance
                                            .deletePlaylist(
                                                playlist.playlistName);
                                        rebuildPlaylistScreenSNotifier();
                                      },
                                      icon: Icon(
                                        Icons.delete_forever_rounded,
                                        size: 26,
                                        color: TColor.focusSecondary,
                                      ),
                                    ),
                                  ),
                                  onTap: null,
                                ),
                              ),
                            );
                          },
                          separatorBuilder: (BuildContext context, int index) {
                            return Container();
                          },
                        );
                      });
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
