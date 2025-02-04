import 'package:audioplayers/audioplayers.dart' as audio_players;
import 'package:flutter/material.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';
import 'package:vicyos_music/app/common/color_extension.dart';
import 'package:vicyos_music/app/functions/folders.and.files.related.dart';
import 'package:vicyos_music/app/functions/music_player.dart';
import 'package:vicyos_music/app/widgets/marquee.text.dart';
import 'package:wave_progress_widget/wave_progress.dart';

import 'delete.song.confirmation.dialog.dart';

late bool audioPlayerWasPlaying;

class SongPreviewDialog extends StatefulWidget {
  final String songPath;
  const SongPreviewDialog({super.key, required this.songPath});

  @override
  State<SongPreviewDialog> createState() => _SongPreviewDialogState();
}

class _SongPreviewDialogState extends State<SongPreviewDialog> {
  @override
  void initState() {
    super.initState();
    previewSong(widget.songPath);
    if (audioPlayer.playerState.playing) {
      audioPlayerWasPlaying = true;
    } else {
      audioPlayerWasPlaying = false;
    }
  }

  @override
  void dispose() {
    audioPlayerPreview.stop();
    audioPlayerPreview.release();
    if (audioPlayerWasPlaying) {
      Future.microtask(() async {
        await audioPlayer.play();
      });
    }
    // hideButtonSheetStreamListener(false);
    super.dispose();
  }

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
        height: media.height * 0.6, // Adjust the height as needed
        padding: const EdgeInsets.fromLTRB(0, 5, 0, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 6),
            Text(
              "SONG PREVIEW",
              style: TextStyle(
                fontWeight: FontWeight.w900,
                color: TColor.org,
                fontSize: 19,
              ),
            ),
            const SizedBox(height: 12),
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(media.width * 0.5),
                  child: StreamBuilder<bool>(
                      stream: albumArtStreamController.stream,
                      builder: (context, snapshot) {
                        return Image.asset(
                          // isFirstArtDemoCover
                          //     ?
                          "assets/img/lofi-woman-album-cover-art_10.png",
                          // : "assets/img/lofi-woman-album-cover-art.png",
                          width: media.width * 0.42,
                          height: media.width * 0.42,
                          fit: BoxFit.cover,
                        );
                      }),
                ),
                ClipRRect(
                  borderRadius: BorderRadius.circular(media.width * 0.5),
                  child: WaveProgress(
                    size: 163.9,
                    borderColor: Colors.transparent,
                    fillColor: Colors.blueAccent,
                    progress: 9.0,
                  ),
                ),
                // GestureDetector(
                //   onTapCancel: () {
                //     print(isFirstArtDemoCover);
                //     albumArtStreamControllerStreamListener(
                //         isFirstArtDemoCover = !isFirstArtDemoCover);
                //   },
                //   child:
                SizedBox(
                  width: media.width * 0.42,
                  height: media.width * 0.42,
                  child: StreamBuilder<Duration>(
                      stream: audioPlayerPreview.onPositionChanged,
                      builder: (context, snapshot) {
                        return SleekCircularSlider(
                          appearance: CircularSliderAppearance(
                              customWidths: CustomSliderWidths(
                                  trackWidth: 4,
                                  progressBarWidth: 6,
                                  shadowWidth: 30),
                              customColors: CustomSliderColors(
                                  dotFillColor: const Color(0xffFFB1B2),
                                  trackColor: const Color(0xffffffff)
                                      .withValues(alpha: 0.3),
                                  progressBarColors: [
                                    const Color(0xffFB9967),
                                    const Color(0xffE9585A)
                                  ],
                                  shadowColor: const Color(0xffFFB1B2),
                                  shadowMaxOpacity: 0.05),
                              infoProperties: InfoProperties(
                                topLabelStyle: const TextStyle(
                                    color: Colors.transparent,
                                    fontSize: 0,
                                    fontWeight: FontWeight.w400),
                                topLabelText: 'Elapsed',
                                bottomLabelStyle: const TextStyle(
                                    color: Colors.transparent,
                                    fontSize: 0,
                                    fontWeight: FontWeight.w400),
                                bottomLabelText: 'time',
                                mainLabelStyle: const TextStyle(
                                    color: Colors.transparent,
                                    fontSize: 0,
                                    fontWeight: FontWeight.w600),
                                // modifier: (double value) {
                                //   final time =
                                //       print(Duration(seconds: value.toInt()));
                                //   return '$time';
                                // },
                              ),
                              startAngle: 270,
                              angleRange: 360,
                              size: 350.0),
                          min: 0,
                          max: sleekCircularSliderDurationPreview,

                          // The initValue has been renamed to value.
                          value: sleekCircularSliderPositionPreview,
                          onChange: (value) {
                            if (value < 0) {
                              return;
                            } else {
                              audioPlayerPreview
                                  .seek(Duration(seconds: value.toInt()));
                            }

                            // callback providing a value while its being changed (with a pan gesture)
                          },
                          // onChangeStart: (double startValue) {
                          //   // callback providing a starting value (when a pan gesture starts)
                          // },
                          // onChangeEnd: (double endValue) {
                          //   // ucallback providing an ending value (when a pan gesture ends)
                          // },
                        );
                      }),
                ),
              ],
            ),
            const SizedBox(
              height: 13,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                StreamBuilder<Duration>(
                    stream: audioPlayerPreview.onPositionChanged,
                    builder: (context, snapshot) {
                      final position = snapshot.data ?? Duration.zero;
                      return Text(
                        (audio_players.PlayerState.completed != false ||
                                audio_players.PlayerState.disposed != false)
                            ? formatDuration(position)
                            : formatDuration(Duration.zero),
                        style: TextStyle(
                            color: TColor.secondaryText, fontSize: 15),
                      );
                    }),
                Text(
                  " | ",
                  style: TextStyle(color: TColor.secondaryText, fontSize: 15),
                ),
                StreamBuilder<Duration?>(
                    stream: audioPlayerPreview.onDurationChanged,
                    builder: (context, snapshot) {
                      final duration = snapshot.data ?? Duration.zero;

                      return Text(
                        formatDuration(duration),
                        style: TextStyle(
                            color: TColor.secondaryText, fontSize: 15),
                      );
                    }),
              ],
            ),
            const SizedBox(
              height: 1,
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(29, 0, 29, 0),
              child: SizedBox(
                height: 45,
                child: Column(
                  children: [
                    Container(
                      // color: Colors.grey,
                      width: media.width * 0.9,
                      height: media.width * 0.07,
                      child: LayoutBuilder(builder: (context, constraints) {
                        // Gets the width of Expanded
                        final double width = constraints.maxWidth;
                        return MarqueeText(
                          centerText: true,
                          // Forces rebuild when song changes
                          key: ValueKey(songName(widget.songPath)),
                          // Set dynamically based on layout
                          maxWidth: width,
                          text: songName(widget.songPath),
                          style: TextStyle(
                            color: TColor.primaryText.withValues(alpha: 0.9),
                            fontSize: 19,
                            fontWeight: FontWeight.w600,
                          ),
                        );
                      }),
                    ),

                    // Text(
                    //   songName(widget.songPath),
                    //   maxLines: 1,
                    //   textAlign: TextAlign.center,
                    //   overflow: TextOverflow.ellipsis,
                    //   style: TextStyle(
                    //       color: TColor.primaryText.withValues(alpha: 0.9),
                    //       fontSize: 19,
                    //       fontWeight: FontWeight.w600),
                    // ),
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 3,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 55,
                  height: 55,
                  child: IconButton(
                    iconSize: 25,
                    onPressed: () async {
                      showModalBottomSheet<void>(
                        backgroundColor: Colors.transparent,
                        context: context,
                        builder: (BuildContext context) {
                          return const DeleteSongConfirmationDialog(
                              songPath: "");
                        },
                      );
                      // audioPlayerPreview.seek(
                      //     (await audioPlayerPreview.getCurrentPosition() ??
                      //             Duration.zero) +
                      //         Duration(seconds: 5));
                    },
                    icon: Icon(Icons.delete_forever),
                    color: TColor.primaryText80,
                  ),
                ),
                SizedBox(
                  width: 55,
                  height: 55,
                  child: IconButton(
                    iconSize: 10,
                    onPressed: () async {
                      audioPlayerPreview.seek(
                          (await audioPlayerPreview.getCurrentPosition() ??
                                  Duration.zero) -
                              Duration(seconds: 5));
                    },
                    icon: Image.asset(
                      "assets/img/backward-5-seconds.png",
                      color: TColor.primaryText80,
                    ),
                  ),
                ),
                const SizedBox(
                  width: 0,
                ),
                StreamBuilder<audio_players.PlayerState>(
                  stream: audioPlayerPreview.onPlayerStateChanged,
                  builder: (context, snapshot) {
                    final playerState = snapshot.data;

                    // final playing = playerState?.playing;
                    if (playerState == audio_players.PlayerState.stopped ||
                        playerState == audio_players.PlayerState.paused ||
                        playerState == audio_players.PlayerState.completed ||
                        playerState == null) {
                      return SizedBox(
                        width: 62,
                        height: 62,
                        child: IconButton(
                          iconSize: 45,
                          onPressed: () async {
                            if (audioPlayerWasPlaying) {
                              await audioPlayer.pause();
                            }
                            if (playerState ==
                                    audio_players.PlayerState.stopped ||
                                playerState ==
                                    audio_players.PlayerState.completed ||
                                playerState == null) {
                              if (audioPlayer.playing == true) {
                                audioPlayer.pause();
                              }
                              audioPlayerPreview.resume();
                            } else if (playerState ==
                                audio_players.PlayerState.paused) {
                              if (audioPlayer.playing == true) {
                                audioPlayer.pause();
                              }
                              audioPlayerPreview.resume();
                            }
                            ;
                          },
                          icon: Image.asset(
                            "assets/img/round-play-button_icon.png",
                          ),
                        ),
                      );
                    } else {
                      return SizedBox(
                        width: 62,
                        height: 62,
                        child: IconButton(
                          iconSize: 45,
                          onPressed: () {
                            audioPlayerPreview.pause();
                          },
                          icon: Image.asset(
                            "assets/img/round-pause-button_icon.png",
                            color: TColor.primaryText80,
                          ),
                        ),
                      );
                    }
                  },
                ),
                const SizedBox(
                  width: 1,
                ),
                SizedBox(
                  width: 55,
                  height: 55,
                  child: IconButton(
                    iconSize: 10,
                    onPressed: () async {
                      audioPlayerPreview.seek(
                          (await audioPlayerPreview.getCurrentPosition() ??
                                  Duration.zero) +
                              Duration(seconds: 5));
                    },
                    icon: Image.asset(
                      "assets/img/forward-5-seconds.png",
                      color: TColor.primaryText80,
                    ),
                  ),
                ),
                SizedBox(
                  width: 55,
                  height: 55,
                  child: IconButton(
                    iconSize: 25,
                    onPressed: () async {
                      audioPlayerPreview.seek(
                          (await audioPlayerPreview.getCurrentPosition() ??
                                  Duration.zero) +
                              Duration(seconds: 5));
                    },
                    icon: Icon(Icons.share),
                    color: TColor.primaryText80,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 20,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FloatingActionButton.extended(
                  label: Padding(
                    padding: const EdgeInsets.only(left: 15, right: 15),
                    child: Text(
                      'ADD TO PLAYLIST',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: TColor.focusStart,
                        fontSize: 17,
                      ),
                    ),
                  ),
                  onPressed: () {
                    addSongToPlaylist(widget.songPath);
                  },
                  backgroundColor: TColor.darkGray,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// Como executar o código assíncrono antes de chamar super.dispose()
//
// @override
// void dispose() {
//   if (audioPlayerWasPlaying) {
//     Future.microtask(() async {
//       await audioPlayer.play();
//     });
//   }
//   super.dispose();
// }
//
// Future<void> _handleAudio() async {
//   if (audioPlayerWasPlaying) {
//     await audioPlayer.play();
//   }
// }
//
// @override
// void dispose() {
//   _handleAudio(); // Chama a função assíncrona sem `await`
//   super.dispose();
// }
