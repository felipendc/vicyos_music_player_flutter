import 'package:audioplayers/audioplayers.dart' as audio_players;
import 'package:flutter/material.dart';
import 'package:vicyos_music/app/color_palette/color_extension.dart';
import 'package:vicyos_music/app/components/music_visualizer.player.preview.dart';
import 'package:vicyos_music/app/models/audio.info.dart';
import 'package:vicyos_music/app/music_player/music.player.functions.and.more.dart';
import 'package:vicyos_music/app/radio_player/functions_and_streams/radio.functions.and.more.dart';
import 'package:vicyos_music/app/screen_orientation/screen.orientation.dart';
import 'package:vicyos_music/l10n/app_localizations.dart';

class MultiSelectionScreen extends StatelessWidget {
  final bool isFavoriteScreen;
  final bool isSongScreen;
  final bool isPlaylistScreen;
  final List<AudioInfo> songModelList;
  const MultiSelectionScreen({
    super.key,
    required this.isFavoriteScreen,
    required this.isSongScreen,
    required this.isPlaylistScreen,
    required this.songModelList,
  });

  @override
  Widget build(BuildContext context) {
    // Set the preferred orientations to portrait mode when this screen is built
    setScreenOrientation();

    final bool thisIsSelectionScreen = true;
    String currentSongPreview = "";

    var media = MediaQuery.sizeOf(context);

    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 13.0),
              child: Container(
                decoration: BoxDecoration(
                  // color: Colors.grey,
                  color: Color(0xff181B2C),
                ),
                // height: deviceTypeIsTablet() ? 135 : 130, // Loading enabled
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
                              SizedBox(
                                height: 30,
                                width: 208,
                                // color: Colors.grey,
                                child: Text(
                                  AppLocalizations.of(context)!.select_files,
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
                              SizedBox(
                                width: 200,
                                child: Text(
                                  "100 Músicas selecionadas",
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
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
                              ),
                            ],
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
                                    onPressed: () async {
                                      Navigator.pop(context);
                                    },
                                    icon: Image.asset(
                                      "assets/img/menu/arrow_back_ios.png",
                                      color: TColor.lightGray,
                                    ),
                                  ),
                                ),
                              ),
                              // Material(
                              //   color: Colors.transparent,
                              //   child: SizedBox(
                              //     width: 45,
                              //     height: 45,
                              //     child: IconButton(
                              //       splashRadius: 20,
                              //       iconSize: 10,
                              //       onPressed: () {},
                              //       icon: Icon(
                              //         Icons.info_outline,
                              //         color: TColor.lightGray,
                              //         size: 26,
                              //       ),
                              //
                              //       // Image.asset(
                              //       //   "assets/img/menu/menu_open.png",
                              //       //   color: TColor.lightGray,
                              //       // ),
                              //     ),
                              //   ),
                              // ),
                              Padding(
                                padding: const EdgeInsets.fromLTRB(9, 0, 8, 0),
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(
                                        media.width * 0.2),
                                    boxShadow: [
                                      BoxShadow(
                                        color:
                                            Colors.black.withValues(alpha: 0.2),
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
            ///////////////////
            Expanded(
              child: StreamBuilder<audio_players.PlayerState>(
                  stream: audioPlayerPreview.onPlayerStateChanged,
                  builder: (context, snapshot) {
                    final playerState = snapshot.data;
                    return ListView.separated(
                      padding: const EdgeInsets.only(bottom: 112),
                      itemCount: songModelList.length,
                      itemBuilder: (context, index) {
                        final song = songModelList[index];
                        return SizedBox(
                          height: 67,
                          child: GestureDetector(
                            child: ListTile(
                              key: ValueKey(song.path),
                              leading: (song.path == currentSongPreview)
                                  ? Padding(
                                      padding: const EdgeInsets.only(
                                          top: 10.0, left: 5.0, bottom: 10.0),
                                      child: SizedBox(
                                        height: 27,
                                        width: 30,
                                        child: MusicVisualizerPlayerPreview(
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
                                iconSize: 20,
                                icon: Image.asset(
                                  "assets/img/menu/more_vert.png",
                                  color: TColor.lightGray,
                                ),
                                onPressed: () async {
                                  // todo:
                                },
                              ),
                              onTap: () async {
                                if (radioPlayer.playing) {
                                  radioPlayer.pause();
                                }
                                if (audioPlayerWasPlaying) {
                                  await audioPlayer.pause();
                                }

                                ///////// CONTROLLING THE PREVIEW PLAYER
                                if (currentSongPreview != song.path) {
                                  previewSong(song.path);
                                  audioPlayerPreview.resume();
                                  currentSongPreview = song.path;
                                } else {
                                  if (playerState ==
                                      audio_players.PlayerState.paused) {
                                    audioPlayerPreview.resume();
                                  }
                                  if (playerState ==
                                      audio_players.PlayerState.playing) {
                                    audioPlayerPreview.pause();
                                  }
                                }
                                /////////
                              },
                            ),
                          ),
                        );
                      },
                      separatorBuilder: (BuildContext context, int index) {
                        return Container();
                      },
                    );
                  }),
            ),

            ///////////////////
            SizedBox(
              height: 70,
              // color: Colors.white24,
              child: Center(
                child: TextButton(
                  onPressed: () async {
                    print("Oque fazer");
                    // showModalBottomSheet<String>(
                    //   isScrollControlled: true,
                    //   backgroundColor: Colors.transparent,
                    //   context: context,
                    //   builder: (BuildContext context) {
                    //     return Padding(
                    //       padding: EdgeInsets.only(
                    //         bottom: MediaQuery.of(context).viewInsets.bottom,
                    //       ),
                    //       child: CreatePlaylistAndAddSongBottomSheet(
                    //         addSong: songModel,
                    //       ),
                    //     );
                    //   },
                    // );
                  },
                  style: TextButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    foregroundColor: Theme.of(context).colorScheme.onPrimary,
                    padding: EdgeInsets.only(
                        left: 20, right: 20, top: 10, bottom: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: Text(
                    "Oque fazer?",
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
    );
  }
}
