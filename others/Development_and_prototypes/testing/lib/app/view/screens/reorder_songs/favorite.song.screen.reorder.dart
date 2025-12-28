import 'package:audioplayers/audioplayers.dart' as audio_players;
import 'package:flutter/material.dart';
import 'package:vicyos_music/app/color_palette/color_extension.dart';
import 'package:vicyos_music/app/components/music_visualizer.player.preview.dart';
import 'package:vicyos_music/app/files_and_folders_handler/folders.and.files.related.dart';
import 'package:vicyos_music/app/music_player/music.player.functions.and.more.dart';
import 'package:vicyos_music/app/music_player/music.player.stream.controllers.dart';
import 'package:vicyos_music/app/radio_player/functions_and_streams/radio.functions.and.more.dart';
import 'package:vicyos_music/app/screen_orientation/screen.orientation.dart';
import 'package:vicyos_music/database/database.dart';
import 'package:vicyos_music/l10n/app_localizations.dart';

class FavoriteSongsScreenReorder extends StatelessWidget {
  const FavoriteSongsScreenReorder({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    // Set the preferred orientations to portrait mode when this screen is built
    setScreenOrientation();

    var media = MediaQuery.sizeOf(context);

    String currentSongPreview = "";

    return StreamBuilder<void>(
      stream: rebuildFavoriteScreenStreamController.stream,
      builder: (context, snapshot) {
        return SafeArea(
          child: Scaffold(
            body: Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                    // color: Colors.grey,
                    color: Color(0xff181B2C),
                  ),
                  // height: deviceTypeIsTablet() ? 140 : 135,
                  // Loading enabled
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(20, 0, 8, 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      height: 30,
                                      // color: Colors.grey,
                                      child: Text(
                                        folderName(
                                          AppLocalizations.of(context)!
                                              .favorites,
                                        ),
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
                                    Text(
                                      AppLocalizations.of(context)!
                                          .reorder_songs,
                                      style: TextStyle(
                                        color: TColor.primaryText28
                                            .withValues(alpha: 0.84),
                                        fontSize: 15,
                                        fontWeight: FontWeight.w400,
                                        shadows: [
                                          Shadow(
                                            color: Colors.black
                                                .withValues(alpha: 0.2),
                                            offset: Offset(1, 1),
                                            blurRadius: 3,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Row(
                                children: [
                                  Material(
                                    color: Colors.transparent,
                                    child: SizedBox(
                                      width: 35,
                                      height: 35,
                                      child: IconButton(
                                        splashRadius: 20,
                                        iconSize: 10,
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        icon: Image.asset(
                                          "assets/img/menu/arrow_back_ios.png",
                                          color: TColor.lightGray,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(9, 0, 8, 0),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(
                                            media.width * 0.2),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.black
                                                .withValues(alpha: 0.2),
                                            spreadRadius: 5,
                                            blurRadius: 8,
                                            offset: Offset(2, 4),
                                          ),
                                        ],
                                      ),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(
                                            media.width * 0.2),
                                        child: StreamBuilder<void>(
                                          stream: null,
                                          builder: (context, snapshot) {
                                            return Image.asset(
                                              "assets/img/pics/default.png",
                                              width: deviceTypeIsTablet()
                                                  ? 130 * 0.44
                                                  : media.width * 0.13,
                                              height: deviceTypeIsTablet()
                                                  ? 130 * 0.44
                                                  : media.width * 0.13,
                                              fit: BoxFit.cover,
                                            );
                                          },
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                StreamBuilder<void>(
                    stream: currentSongNameStreamController.stream,
                    builder: (context, snapshot) {
                      return FutureBuilder(
                          future: AppDatabase.instance.getFavorites(),
                          builder: (context, snapshot) {
                            final favoriteSongs = snapshot.data ?? [];

                            return Expanded(
                              child: StreamBuilder<audio_players.PlayerState>(
                                  stream:
                                      audioPlayerPreview.onPlayerStateChanged,
                                  builder: (context, snapshot) {
                                    final playerState = snapshot.data;
                                    return ReorderableListView.builder(
                                      padding:
                                          const EdgeInsets.only(bottom: 112),
                                      itemCount: favoriteSongs.length,
                                      onReorder: (oldIndex, newIndex) async {
                                        if (newIndex > oldIndex) newIndex--;

                                        final item =
                                            favoriteSongs.removeAt(oldIndex);
                                        favoriteSongs.insert(newIndex, item);

                                        // Saves the new order in the database
                                        await AppDatabase.instance
                                            .updateFavoritesOrder(
                                                favoriteSongs);

                                        rebuildFavoriteScreenNotifier();
                                      },
                                      itemBuilder: (context, index) {
                                        final song = favoriteSongs[index];
                                        return Container(
                                          color: TColor.bg,
                                          key: ValueKey(song.path),
                                          height: 67,
                                          child: Material(
                                            color: Colors.transparent,
                                            child: ListTile(
                                              key: ValueKey(song.path),
                                              leading: (song.path ==
                                                      currentSongPreview)
                                                  ? Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              top: 10.0,
                                                              left: 5.0,
                                                              bottom: 10.0),
                                                      child: SizedBox(
                                                        height: 27,
                                                        width: 30,
                                                        child:
                                                            MusicVisualizerPlayerPreview(
                                                          barCount: 6,
                                                          colors: [
                                                            TColor.focus,
                                                            TColor.secondaryEnd,
                                                            TColor.focusStart,
                                                            Colors.blue[900]!,
                                                          ],
                                                          duration: const [
                                                            900,
                                                            700,
                                                            600,
                                                            800,
                                                            500
                                                          ],
                                                        ),
                                                      ),
                                                    )
                                                  : Icon(
                                                      Icons.music_note_rounded,
                                                      color: TColor.focus,
                                                      size: 36,
                                                    ),
                                              title: Text(
                                                song.name,
                                                textAlign: TextAlign.start,
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(
                                                  fontWeight: FontWeight.w500,
                                                  color: TColor.lightGray,
                                                  fontSize: 18,
                                                ),
                                              ),
                                              subtitle: Text(
                                                "${song.size} MB  •  ${song.format}",
                                                textAlign: TextAlign.start,
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(
                                                  color: TColor.secondaryText,
                                                  fontSize: 15,
                                                ),
                                              ),
                                              trailing: IconButton(
                                                splashRadius: 24,
                                                iconSize: 25,
                                                icon: Icon(
                                                  Icons.reorder_sharp,
                                                  color: TColor.secondaryText,
                                                ),

                                                // Image.asset(
                                                //   "assets/img/menu/more_vert.png",
                                                //   color: TColor.lightGray,
                                                // ),
                                                onPressed: null,
                                              ),
                                              onTap: () async {
                                                ///////// CONTROLLING THE PREVIEW PLAYER //////

                                                if (radioPlayer.playing) {
                                                  radioPlayer.pause();
                                                }
                                                if (audioPlayerWasPlaying) {
                                                  await audioPlayer.pause();
                                                }

                                                if (currentSongPreview !=
                                                    song.path) {
                                                  previewSong(song.path);
                                                  audioPlayerPreview.resume();
                                                  currentSongPreview =
                                                      song.path;
                                                } else {
                                                  if (playerState ==
                                                      audio_players
                                                          .PlayerState.paused) {
                                                    audioPlayerPreview.resume();
                                                  }
                                                  if (playerState ==
                                                      audio_players.PlayerState
                                                          .playing) {
                                                    audioPlayerPreview.pause();
                                                  }
                                                }
                                                ///////////////////////////////////////////////
                                              },
                                            ),
                                          ),
                                        );
                                      },
                                    );
                                  }),
                            );
                          });
                    }),
              ],
            ),
          ),
        );
      },
    );
  }
}
