import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';
import 'package:vicyos_music/app/common/color_extension.dart';
import 'package:vicyos_music/app/functions/folders.and.files.related.dart';
import 'package:vicyos_music/app/functions/music_player.dart';

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
    miniPlayerStreamControllerListener();
    audioPlayerPreview.stop();
    playlistPreview.clear();
    if (audioPlayerWasPlaying) {
      audioPlayer.play();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    return ClipRRect(
      borderRadius: const BorderRadius.vertical(
        top: Radius.circular(25),
        bottom: Radius.circular(25),
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
                      stream: audioPlayerPreview.positionStream,
                      builder: (context, snapshot) {
                        final duration = snapshot.data ?? Duration.zero;
                        return SleekCircularSlider(
                          appearance: CircularSliderAppearance(
                              customWidths: CustomSliderWidths(
                                  trackWidth: 4,
                                  progressBarWidth: 6,
                                  shadowWidth: 30),
                              customColors: CustomSliderColors(
                                  dotFillColor: const Color(0xffFFB1B2),
                                  trackColor:
                                      const Color(0xffffffff).withOpacity(0.3),
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
                          value:
                              audioPlayerPreview.position.inSeconds.toDouble(),
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
                    stream: audioPlayerPreview.positionStream,
                    builder: (context, snapshot) {
                      final position = snapshot.data ?? Duration.zero;
                      return Text(
                        (audioPlayerPreview.processingState !=
                                ProcessingState.idle)
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
                    stream: audioPlayerPreview.durationStream,
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
              height: 7,
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(29, 0, 29, 0),
              child: SizedBox(
                height: 45,
                child: Column(
                  children: [
                    Text(
                      songName(widget.songPath),
                      maxLines: 1,
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          color: TColor.primaryText.withOpacity(0.9),
                          fontSize: 19,
                          fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 55,
                  height: 55,
                  child: IconButton(
                    iconSize: 10,
                    onPressed: () {
                      audioPlayerPreview.position - Duration(seconds: 5) <
                              Duration.zero
                          ? audioPlayerPreview.seek(Duration.zero)
                          : audioPlayerPreview.seek(
                              audioPlayerPreview.position -
                                  const Duration(seconds: 5));
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
                StreamBuilder<PlayerState>(
                  stream: audioPlayerPreview.playerStateStream,
                  builder: (context, snapshot) {
                    final playerState = snapshot.data;

                    final playing = playerState?.playing;
                    if (playing != true) {
                      return SizedBox(
                        width: 62,
                        height: 62,
                        child: IconButton(
                          iconSize: 45,
                          onPressed: () async {
                            if (audioPlayerWasPlaying) {
                              await audioPlayer.pause();
                            }
                            audioPlayerPreview.play();
                          },
                          icon: Image.asset(
                            "assets/img/play.png",
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
                    onPressed: () {
                      audioPlayerPreview.position + Duration(seconds: 5) >
                              audioPlayerPreview.duration!
                          ? audioPlayerPreview.seek(audioPlayerPreview.duration)
                          : audioPlayerPreview.seek(
                              audioPlayerPreview.position +
                                  const Duration(seconds: 5));
                    },
                    icon: Image.asset(
                      "assets/img/forward-5-seconds.png",
                      color: TColor.primaryText80,
                    ),
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
                  label: Text(
                    'ADD TO PLAYLIST',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: TColor.focusStart,
                      fontSize: 17,
                    ),
                  ),
                  onPressed: () {
                    addSongToPlaylist(widget.songPath);
                    Navigator.pop(context);
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
