import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';
import 'package:vicyos_music/app/common/color_extension.dart';
import 'package:vicyos_music/app/functions/music_player.dart';
import 'package:vicyos_music/app/functions/screen.orientation.dart';
import 'package:vicyos_music/app/view/bottom.sheet.playlist.dart';
import 'package:vicyos_music/app/view/bottom.sheet.speed.rate.dart';
import 'package:vicyos_music/app/widgets/appbars.dart';
import 'package:vicyos_music/app/widgets/marquee.text.dart';
import 'package:vicyos_music/app/widgets/music_visualizer.dart';
import 'package:wave_progress_widget/wave_progress.dart';

final List<Color> colors = [
  TColor.focus,
  TColor.secondaryEnd,
  TColor.focusStart,
  Colors.blue[900]!,
  // TColor.lightGray,
  // TColor.bgMiniPlayer
];

final List<int> duration = [900, 700, 600, 800, 500];

class MainPlayerView extends StatelessWidget {
  const MainPlayerView({super.key});

  @override
  Widget build(BuildContext context) {
    // Set the preferred orientations to portrait mode when this screen is built
    screenOrientationPortrait();

    var media = MediaQuery.sizeOf(context);
    return Scaffold(
      appBar: mainPlayerViewAppBar(context),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(
              height: 20,
            ),
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(media.width * 0.7),
                  child: StreamBuilder<bool>(
                      stream: albumArtStreamController.stream,
                      builder: (context, snapshot) {
                        return Image.asset(
                          // isFirstArtDemoCover
                          //     ?
                          "assets/img/lofi-woman-album-cover-art_10.png",
                          // : "assets/img/lofi-woman-album-cover-art.png",
                          width: media.width * 0.6,
                          height: media.width * 0.6,
                          fit: BoxFit.cover,
                        );
                      }),
                ),
                ClipRRect(
                  borderRadius: BorderRadius.circular(media.width * 0.7),
                  child: WaveProgress(
                    size: 235.0,
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
                  width: media.width * 0.6,
                  height: media.width * 0.6,
                  child: StreamBuilder<void>(
                      stream: clearCurrentPlaylistStreamController.stream,
                      builder: (context, snapshot) {
                        return StreamBuilder<Duration>(
                            stream: audioPlayer.positionStream,
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
                                          fontSize: 16,
                                          fontWeight: FontWeight.w400),
                                      topLabelText: 'Elapsed',
                                      bottomLabelStyle: const TextStyle(
                                          color: Colors.transparent,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w400),
                                      bottomLabelText: 'time',
                                      mainLabelStyle: const TextStyle(
                                          color: Colors.transparent,
                                          fontSize: 50.0,
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
                                max: sleekCircularSliderDuration,

                                // The initValue has been renamed to value.
                                value: sleekCircularSliderPosition,
                                onChange: (value) {
                                  if (value < 0) {
                                    return;
                                  } else {
                                    audioPlayer
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
                            });
                      }),
                ),
                // ),
              ],
            ),
            const SizedBox(
              height: 15,
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                StreamBuilder<void>(
                    stream: clearCurrentPlaylistStreamController.stream,
                    builder: (context, snapshot) {
                      return StreamBuilder<Duration>(
                          stream: audioPlayer.positionStream,
                          builder: (context, snapshot) {
                            final position = snapshot.data ?? Duration.zero;
                            return Text(
                              (audioPlayer.processingState !=
                                      ProcessingState.idle)
                                  ? formatDuration(position)
                                  : formatDuration(Duration.zero),
                              style: TextStyle(
                                  color: TColor.secondaryText, fontSize: 15),
                            );
                          });
                    }),
                Text(
                  " | ",
                  style: TextStyle(color: TColor.secondaryText, fontSize: 15),
                ),
                StreamBuilder<Duration?>(
                    stream: audioPlayer.durationStream,
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

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                StreamBuilder<PlaybackEvent>(
                    stream: audioPlayer.playbackEventStream,
                    builder: (context, snapshot) {
                      // Check if snapshot has data
                      if (!snapshot.hasData) {
                        return Text(
                          '0',
                          style: TextStyle(
                              color: TColor.secondaryText, fontSize: 15),
                        );
                      }
                      final eventState = snapshot.data!;
                      final index = eventState.currentIndex;
                      final playerState = audioPlayer.processingState;

                      return Text(
                        (playerState == ProcessingState.idle ||
                                playlist.children.isEmpty)
                            ? '0'
                            : "${index! + 1}",
                        style: TextStyle(
                            color: TColor.secondaryText, fontSize: 15),
                      );
                    }),
                StreamBuilder<int>(
                    stream: playlistLengthStreamController.stream,
                    builder: (context, snapshot) {
                      return Text(
                        " of $playlistLengths",
                        style: TextStyle(
                            color: TColor.secondaryText, fontSize: 15),
                      );
                    }),
              ],
            ),

            const SizedBox(
              height: 15,
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(29, 0, 29, 0),
              child: SizedBox(
                height: 65,
                child: StreamBuilder<void>(
                    stream: currentSongNameStreamController.stream,
                    builder: (context, snapshot) {
                      return Column(
                        children: [
                          // Text(
                          //   currentSongName,
                          //   maxLines: 1,
                          //   textAlign: TextAlign.center,
                          //   overflow: TextOverflow.ellipsis,
                          //   style: TextStyle(
                          //       color: TColor.primaryText.withValues(alpha: 0.9),
                          //       fontSize: 19,
                          //       fontWeight: FontWeight.w600),
                          // ),
                          Container(
                            // color: Colors.grey,
                            width: media.width * 0.9,
                            height: media.width * 0.07,
                            child:
                                LayoutBuilder(builder: (context, constraints) {
                              // Gets the width of Expanded
                              final double width = constraints.maxWidth;
                              return MarqueeText(
                                centerText: true,
                                // Forces rebuild when song changes
                                key: ValueKey(currentSongName),
                                // Set dynamically based on layout
                                maxWidth: width,
                                text: currentSongName,
                                style: TextStyle(
                                  color:
                                      TColor.primaryText.withValues(alpha: 0.9),
                                  fontSize: 19,
                                  fontWeight: FontWeight.w600,
                                ),
                              );
                            }),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(35, 0, 35, 0),
                            child: Text(
                              currentFolderPath,
                              textAlign: TextAlign.center,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: TColor.secondaryText,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ],
                      );
                    }),
              ),
            ),

            // Text(
            //   currentSongName.length > 29
            //       ? "${currentSongName.substring(0, 28)}..."
            //       : currentSongName,
            //   style: TextStyle(
            //       color: TColor.primaryText.withValues(alpha: 0.9),
            //       fontSize: 19,
            //       fontWeight: FontWeight.w600),
            // ),

            const SizedBox(
              height: 28,
            ),
            // SizedBox(
            //   height: 90,
            //   width: media.width * 0.6,
            //   child: MusicVisualizer(
            //     barCount: 30,
            //     colors: colors,
            //     duration: duration,
            //   ),
            // ),

            // Image.asset(
            //   "assets/img/eq_display.png",
            //   height: 60,
            //   fit: BoxFit.fitHeight,
            // ),

            SizedBox(
              height: 50,
              width: media.width * 0.5,
              child: MusicVisualizer(
                barCount: 26,
                colors: [
                  TColor.focus,
                  TColor.secondaryEnd,
                  TColor.focusStart,
                  Colors.blue[900]!,
                  // TColor.lightGray,
                  // TColor.bgMiniPlayer
                ],
                duration: const [900, 700, 600, 800, 500],
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Column(children: [
              Padding(
                padding: const EdgeInsets.all(9.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
                      child: Column(
                        children: [
                          SizedBox(
                            width: 45,
                            height: 45,
                            child: IconButton(
                              onPressed: () {
                                showModalBottomSheet<void>(
                                  backgroundColor: Colors.transparent,
                                  context: context,
                                  builder: (BuildContext context) {
                                    return const PlaylistBottomSheet();
                                  },
                                );
                              },
                              icon: Image.asset(
                                "assets/img/playlist.png",
                                // width: 60,
                                // height: 60,
                                color: TColor.primaryText80,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                      child: Column(
                        children: [
                          IconButton(
                            onPressed: () {
                              showModalBottomSheet<void>(
                                backgroundColor: Colors.transparent,
                                context: context,
                                builder: (BuildContext context) {
                                  return const SpeedRateBottomSheet();
                                },
                              );
                            },
                            icon: Image.asset(
                              'assets/img/speed-one.png',
                              width: 40,
                              height: 40,
                              color: TColor.primaryText80,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
                      child: Column(
                        children: [
                          SizedBox(
                            width: 45,
                            height: 40,
                            child: IconButton(
                              onPressed: () {
                                repeatMode();
                              },
                              icon: StreamBuilder<LoopMode>(
                                  stream: repeatModeStreamController.stream,
                                  builder: (context, snapshot) {
                                    return Image.asset(
                                      currentLoopModeIcon,
                                      width: 30,
                                      height: 30,
                                      color: TColor.primaryText80,
                                    );
                                  }),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ]),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: const EdgeInsets.only(
                    right: 10,
                    left: 10,
                    top: 2,
                    bottom: 2,
                  ),
                  child: StreamBuilder<Object>(
                      stream: systemVolumeStreamController.stream,
                      builder: (context, snapshot) {
                        return SliderTheme(
                          data: SliderTheme.of(context).copyWith(
                            trackHeight: 5,
                            trackShape: const RoundedRectSliderTrackShape(),
                            activeTrackColor: Colors.purple.shade800,
                            inactiveTrackColor: Colors.purple.shade200,
                            thumbShape: const RoundSliderThumbShape(
                              elevation: BorderSide.strokeAlignOutside,
                              enabledThumbRadius: 5.0,
                              pressedElevation: 8.0,
                            ),
                            thumbColor: Colors.pinkAccent,
                            overlayColor: Colors.pinkAccent,
                            overlayShape: const RoundSliderOverlayShape(
                                overlayRadius: 15),
                            tickMarkShape: const RoundSliderTickMarkShape(),
                            activeTickMarkColor: Colors.purple.shade800,
                            // activeTickMarkColor: Colors.pinkAccent,
                            inactiveTickMarkColor: Colors.purple.shade200,
                            // inactiveTickMarkColor: Colors.white,
                            valueIndicatorShape:
                                const PaddleSliderValueIndicatorShape(),
                            valueIndicatorColor: Colors.black,

                            valueIndicatorTextStyle: const TextStyle(
                              color: Colors.white,
                              fontSize: 16.0,
                            ),
                          ),
                          child: Slider(
                            min: 0.0,
                            max: 100.0,
                            value: volumeSliderValue,
                            divisions: 20,
                            label: '${volumeSliderValue.round()}',
                            onChanged: (value) {
                              systemVolumeStreamListener(value);
                              setVolumeJustAudio(value);
                              // setVolume(value);
                            },
                          ),

                          // Slider(
                          //   min: 0.0,
                          //   max: 100.0,
                          //   value: volumeSliderValue,
                          //   divisions: 20,
                          //   label: '${volumeSliderValue.round()}',
                          //   onChanged: (value) {
                          //     systemVolumeStreamListener(
                          //         volumeSliderValue = value);

                          //     // setVolume(value);
                          //     setVolume(value);
                          //   },
                          // ),
                        );
                      }),
                )
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 60,
                  height: 60,
                  child: IconButton(
                    iconSize: 10,
                    onPressed: () async {
                      await previousSong();
                    },
                    icon: Image.asset(
                      "assets/img/previous_song.png",
                    ),
                  ),
                ),
                SizedBox(
                  width: 65,
                  height: 65,
                  child: IconButton(
                    iconSize: 10,
                    onPressed: () {
                      rewind();
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
                  stream: audioPlayer.playerStateStream,
                  builder: (context, snapshot) {
                    final playerState = snapshot.data;

                    final playing = playerState?.playing;
                    if (playing != true) {
                      return SizedBox(
                        width: 82,
                        height: 82,
                        child: IconButton(
                          iconSize: 45,
                          onPressed: () {
                            if (playlist.children.isNotEmpty) {
                              audioPlayer.play();
                            }
                          },
                          icon: Image.asset(
                            "assets/img/play.png",
                          ),
                        ),
                      );
                    } else {
                      return SizedBox(
                        width: 82,
                        height: 82,
                        child: IconButton(
                          iconSize: 45,
                          onPressed: () {
                            audioPlayer.pause();
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
                  width: 65,
                  height: 65,
                  child: IconButton(
                    iconSize: 10,
                    onPressed: () {
                      forward();
                    },
                    icon: Image.asset(
                      "assets/img/forward-5-seconds.png",
                      color: TColor.primaryText80,
                    ),
                  ),
                ),
                SizedBox(
                  width: 60,
                  height: 60,
                  child: IconButton(
                    onPressed: () async {
                      await nextSong();
                    },
                    icon: Image.asset(
                      "assets/img/next_song.png",
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
