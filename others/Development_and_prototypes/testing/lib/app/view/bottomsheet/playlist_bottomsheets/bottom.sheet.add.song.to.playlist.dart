import 'package:flutter/material.dart';
import 'package:vicyos_music/app/color_palette/color_extension.dart';
import 'package:vicyos_music/app/components/show.top.message.dart';
import 'package:vicyos_music/app/models/audio.info.dart';
import 'package:vicyos_music/app/models/playlists.dart';
import 'package:vicyos_music/app/music_player/music.player.functions.and.more.dart';
import 'package:vicyos_music/app/music_player/music.player.stream.controllers.dart';
import 'package:vicyos_music/app/view/bottomsheet/playlist_bottomsheets/bottom.sheet.create.playlist.and.add.song.dart';
import 'package:vicyos_music/database/database.dart';
import 'package:vicyos_music/l10n/app_localizations.dart';

class AddSongToPlaylistBottomSheet extends StatelessWidget {
  final dynamic songModels;

  const AddSongToPlaylistBottomSheet({
    super.key,
    required this.songModels,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.vertical(
        top: Radius.circular(25),
        bottom: Radius.circular(0),
      ),
      child: SafeArea(
        bottom: true,
        top: false,
        child: Container(
          color: TColor.bg,
          height: 400, // Adjust the height as needed
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
                                  AppLocalizations.of(context)!
                                      .add_to_a_playlist,
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
                                          color: Colors.black
                                              .withValues(alpha: 0.2),
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
                          // // Treating the waiting
                          // if (snapshot.connectionState ==
                          //     ConnectionState.waiting) {
                          //   return const SizedBox();
                          // }
                          //
                          // // If has error show a blank screen
                          // if (snapshot.hasError) {
                          //   return const SizedBox();
                          // }
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
                                          if (songModels is Set<AudioInfo>) {
                                            if (context.mounted) {
                                              addedToAPlaylistSnackBar(
                                                  context: context,
                                                  text: (songModels.length == 1)
                                                      ? songModels.first.name
                                                      : AppLocalizations.of(
                                                              context)!
                                                          .song_plural(
                                                              songModels
                                                                  .length),
                                                  message: AppLocalizations.of(
                                                          context)!
                                                      .added_successfully_plural(
                                                          songModels.length));
                                            }

                                            // Add each song<AudioInfo> from songModels to the playlist
                                            for (AudioInfo song in songModels) {
                                              await AppDatabase.instance
                                                  .addAudioToPlaylist(
                                                playlistName:
                                                    playlist.playlistName,
                                                audio: song,
                                              );
                                            }

                                            rebuildPlaylistScreenSNotifier();
                                            if (context.mounted) {
                                              Navigator.pop(context);
                                            }
                                          } else if (songModels is AudioInfo) {
                                            if (context.mounted) {
                                              addedToAPlaylistSnackBar(
                                                  context: context,
                                                  text: songModels.name,
                                                  message: AppLocalizations.of(
                                                          context)!
                                                      .added_successfully);
                                            }

                                            // Add each song<AudioInfo> from songModels to the playlist
                                            for (AudioInfo song in songModels) {
                                              await AppDatabase.instance
                                                  .addAudioToPlaylist(
                                                playlistName:
                                                    playlist.playlistName,
                                                audio: song,
                                              );
                                            }

                                            rebuildPlaylistScreenSNotifier();
                                            if (context.mounted) {
                                              Navigator.pop(context);
                                            }
                                          }
                                        },
                                        icon: Icon(
                                          Icons.add,
                                          size: 28,
                                          color: TColor.focusSecondary,
                                        ),
                                      ),
                                    ),
                                    onTap: null,
                                  ),
                                ),
                              );
                            },
                            separatorBuilder:
                                (BuildContext context, int index) {
                              return Container();
                            },
                          );
                        });
                  },
                ),
              ),
              SizedBox(
                height: 70,
                // color: Colors.white24,
                child: Center(
                  child: TextButton(
                    onPressed: () async {
                      if (deviceTypeIsSmartphone()) {
                        hideMiniPlayerNotifier(true);
                      }
                      Navigator.pop(context, "hide_bottom_player");

                      final result = await showModalBottomSheet<String>(
                        isScrollControlled: true,
                        backgroundColor: Colors.transparent,
                        context: context,
                        builder: (BuildContext context) {
                          return Padding(
                            padding: EdgeInsets.only(
                              bottom: MediaQuery.of(context).viewInsets.bottom,
                            ),
                            child: CreatePlaylistAndAddSongBottomSheet(
                              addSongs: songModels,
                            ),
                          );
                        },
                      );

                      if (result == "hide_bottom_player") {
                        if (deviceTypeIsSmartphone()) {
                          // "When the bottom sheet is closed, send a signal to show the mini player again."
                          hideMiniPlayerNotifier(true);
                        }
                      } else {
                        if (deviceTypeIsSmartphone()) {
                          // "When the bottom sheet is closed, send a signal to show the mini player again."
                          hideMiniPlayerNotifier(false);
                        }
                      }
                    },
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.only(
                          left: 20, right: 20, top: 10, bottom: 10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    child: Text(
                      AppLocalizations.of(context)!.create_a_new_playlist,
                      style: TextStyle(
                        fontSize: 18,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }
}
