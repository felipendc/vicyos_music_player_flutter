import 'package:flutter/material.dart';
import 'package:vicyos_music/app/color_palette/color_extension.dart';
import 'package:vicyos_music/app/components/show.top.message.dart';
import 'package:vicyos_music/app/models/audio.info.dart';
import 'package:vicyos_music/app/models/playlists.dart';
import 'package:vicyos_music/app/music_player/music.player.functions.and.more.dart';
import 'package:vicyos_music/app/music_player/music.player.stream.controllers.dart';
import 'package:vicyos_music/database/database.dart';
import 'package:vicyos_music/l10n/app_localizations.dart';

class CreatePlaylistAndAddSongBottomSheet extends StatelessWidget {
  final AudioInfo addSong;
  const CreatePlaylistAndAddSongBottomSheet({
    super.key,
    required this.addSong,
  });

  @override
  Widget build(BuildContext context) {
    TextEditingController playlistNameController = TextEditingController();

    return Padding(
      padding: const EdgeInsets.only(bottom: 20, left: 10, right: 10),
      child: ClipRRect(
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(25),
          bottom: Radius.circular(25),
        ),
        child: Container(
          color: TColor.bg,
          height: 228, // Adjust the height as needed
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
                                  AppLocalizations.of(context)!.new_playlist,
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
                                    AppLocalizations.of(context)!.choose_a_name,
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
                child: Column(
                  children: [
                    Container(
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

                            return Padding(
                              padding:
                                  EdgeInsetsGeometry.only(left: 18, right: 18),
                              child: TextField(
                                textCapitalization:
                                    TextCapitalization.sentences,
                                onChanged: null,
                                controller: playlistNameController,
                                decoration: InputDecoration(
                                  hintText: AppLocalizations.of(context)!
                                      .create_a_playlist_text_field_hint,
                                  hintStyle:
                                      const TextStyle(color: Colors.white60),
                                  labelStyle:
                                      const TextStyle(color: Colors.white70),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(26),
                                    borderSide: BorderSide(
                                      color: TColor.focusSecondary
                                          .withValues(alpha: 80),
                                      width: 3,
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(26),
                                    borderSide: BorderSide(
                                      color: TColor.focusSecondary
                                          .withValues(alpha: 80),
                                      width: 3,
                                    ),
                                  ),
                                ),
                                style: const TextStyle(color: Colors.white),
                              ),
                            );
                          }),
                    ),
                    SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          child: Text(
                            AppLocalizations.of(context)!.cancel,
                            style: TextStyle(
                              fontSize: 16,
                            ),
                          ),
                          onPressed: () {
                            Navigator.pop(context, "");
                          },
                        ),
                        TextButton(
                          child: Text(
                            AppLocalizations.of(context)!.create,
                            style: TextStyle(
                              fontSize: 16,
                            ),
                          ),
                          onPressed: () async {
                            if (await playlistNameAlreadyExist(
                                playlistNameController.text)) {
                              if (context.mounted) {
                                renamePlaylistSnackBar(
                                    context: context,
                                    text: AppLocalizations.of(context)!
                                        .this_name_has_already_been_used,
                                    message: AppLocalizations.of(context)!
                                        .please_try_another_one);
                              }
                            } else {
                              if (playlistNameController.text.isNotEmpty) {
                                // Create a empty playlist
                                await AppDatabase.instance.createEmptyPlaylist(
                                    playlistNameController.text);

                                // Add a song to this playlist
                                await AppDatabase.instance.addAudioToPlaylist(
                                    playlistName: playlistNameController.text,
                                    audio: addSong);
                                rebuildPlaylistScreenSNotifier();

                                if (context.mounted) {
                                  createPlaylistSnackBar(
                                      context: context,
                                      text: playlistNameController.text,
                                      message: AppLocalizations.of(context)!
                                          .added_successfully);
                                }
                                playlistNameController.clear();
                                if (context.mounted) {
                                  Navigator.pop(context, "");
                                }
                              }
                            }
                          },
                        ),
                        SizedBox(width: 15),
                      ],
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
