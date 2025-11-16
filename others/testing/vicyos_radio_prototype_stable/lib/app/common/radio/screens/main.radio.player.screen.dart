import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';
import 'package:vicyos_music/app/common/color_palette/color_extension.dart';
import 'package:vicyos_music/app/common/music_player/music.player.dart';
import 'package:vicyos_music/app/common/radio/bottomsheet/radio.bottom.sheet.speed.rate.dart';
import 'package:vicyos_music/app/common/radio/radio.functions.dart';
import 'package:vicyos_music/app/common/radio/radio.stream.notifiers.dart';
import 'package:vicyos_music/app/common/radio/widgets/radio.appbar.dart';
import 'package:vicyos_music/app/common/radio/widgets/radio.music.visualizer.dart';
import 'package:vicyos_music/app/common/screen_orientation/screen.orientation.dart';
import 'package:vicyos_music/app/common/widgets/show.top.message.dart';
import 'package:vicyos_music/app/is_smartphone/widgets/marquee.text.dart';
import 'package:wave_progress_widget/wave_progress.dart';

final List<Color> colors = [
  TColor.focus,
  TColor.secondaryEnd,
  TColor.focusStart,
  Colors.blue[900]!,
];

final List<int> duration = [900, 700, 600, 800, 500];

class MainRadioPlayerView extends StatelessWidget {
  const MainRadioPlayerView({super.key});

  @override
  Widget build(BuildContext context) {
    // Set the preferred orientations to portrait mode when this screen is built
    setScreenOrientation();

    var media = MediaQuery.sizeOf(context);
    return Scaffold(
      appBar: mainRadioPlayerViewAppBar(context),
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
                  child: StreamBuilder<void>(
                    stream: null,
                    builder: (context, snapshot) {
                      return Image.asset(
                        "assets/img/lofi-woman-album-cover-art_10.png",
                        width: media.width * 0.6,
                        height: media.width * 0.6,
                        fit: BoxFit.cover,
                      );
                    },
                  ),
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
                SizedBox(
                  width: media.width * 0.6,
                  height: media.width * 0.6,
                  child: SleekCircularSlider(
                    appearance: CircularSliderAppearance(
                        customWidths: CustomSliderWidths(
                            trackWidth: 4,
                            progressBarWidth: 6,
                            shadowWidth: 30),
                        customColors: CustomSliderColors(
                            dotFillColor: const Color(0xffFFB1B2),
                            trackColor:
                                const Color(0xffffffff).withValues(alpha: 0.3),
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
                        ),
                        startAngle: 270,
                        angleRange: 360,
                        size: 350.0),
                    min: 0,
                    max: 100,

                    // The initValue has been renamed to value.
                    value: 0,
                    onChange: null,
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 15,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "STREAMING",
                  style: TextStyle(color: TColor.secondaryText, fontSize: 15),
                ),
              ],
            ),
            const SizedBox(
              height: 5,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                StreamBuilder<PlaybackEvent>(
                  stream: radioPlayer.playbackEventStream,
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
                    final index = eventState.currentIndex ?? -1;
                    final playerState = radioPlayer.processingState;

                    return Text(
                      (playerState == ProcessingState.idle ||
                              radioPlayer.audioSources.isEmpty)
                          ? '0'
                          : (index < 0)
                              ? '0'
                              : '${index + 1}',
                      style:
                          TextStyle(color: TColor.secondaryText, fontSize: 15),
                    );
                  },
                ),
                StreamBuilder<void>(
                  stream: radioPlayer.playbackEventStream,
                  builder: (context, snapshot) {
                    return StreamBuilder<void>(
                      stream: rebuildSongsListScreenStreamController.stream,
                      builder: (context, snapshot) {
                        return Text(
                          isRadioOn
                              ? " of ${radioPlayer.audioSources.length}"
                              : " of 0",
                          style: TextStyle(
                              color: TColor.secondaryText, fontSize: 15),
                        );
                      },
                    );
                  },
                ),
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
                  stream: radioPlayer.sequenceStateStream,
                  builder: (context, snapshot) {
                    return Column(
                      children: [
                        SizedBox(
                          width: media.width * 0.9,
                          height: media.width * 0.07,
                          child: LayoutBuilder(
                            builder: (context, constraints) {
                              // Gets the width of Expanded
                              final double width = constraints.maxWidth;
                              return MarqueeText(
                                centerText: true,
                                // Forces rebuild when song changes
                                key: ValueKey(currentRadioStationID),
                                // Set dynamically based on layout
                                maxWidth: width,
                                text: isRadioOn
                                    ? currentRadioStationName
                                    : "The radio is turned off",
                                style: TextStyle(
                                  color:
                                      TColor.primaryText.withValues(alpha: 0.9),
                                  fontSize: 19,
                                  fontWeight: FontWeight.w600,
                                ),
                              );
                            },
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(35, 0, 35, 0),
                          child: Text(
                            isRadioOn ? currentRadioStationLocation : "...",
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
                  },
                ),
              ),
            ),
            const SizedBox(
              height: 28,
            ),
            SizedBox(
              height: 50,
              width: media.width * 0.5,
              child: RadioMusicVisualizer(
                barCount: 26,
                colors: [
                  TColor.focus,
                  TColor.secondaryEnd,
                  TColor.focusStart,
                  Colors.blue[900]!,
                ],
                duration: const [900, 700, 600, 800, 500],
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Column(
              children: [
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
                              width: 49,
                              height: 49,
                              child: IconButton(
                                onPressed: () {
                                  if (radioPlayer.audioSources.isNotEmpty) {
                                    playRadioStation(
                                        context, (currentRadioIndex - 1));
                                  }
                                },
                                icon: Image.asset(
                                  "assets/img/radio/reload-two-streamline-tabler.png",
                                  width: 40,
                                  height: 40,
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
                                    return const RadioSpeedRateBottomSheet();
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
                        padding: const EdgeInsets.fromLTRB(6, 0, 8, 0),
                        child: Column(
                          children: [
                            StreamBuilder<void>(
                              stream: radioShuffleModeStreamController.stream,
                              builder: (context, snapshot) {
                                return SizedBox(
                                  width:
                                      radioPlayer.shuffleModeEnabled ? 45 : 45,
                                  height: (currentLoopMode ==
                                          CurrentLoopMode.shuffle)
                                      ? 48
                                      : 40,
                                  child: IconButton(
                                    onPressed: () async {
                                      if (radioPlayer.shuffleModeEnabled) {
                                        await radioPlayer
                                            .setShuffleModeEnabled(false);
                                        if (context.mounted) {
                                          showLoopMode(
                                              context, "Repeating all");
                                        }
                                      } else {
                                        await radioPlayer
                                            .setShuffleModeEnabled(true);
                                        if (context.mounted) {
                                          showLoopMode(
                                              context, "Playback is shuffled");
                                        }
                                      }
                                      radioShuffleModeStreamNotifier();
                                    },
                                    icon: Image.asset(
                                      radioPlayer.shuffleModeEnabled
                                          ? "assets/img/shuffle_1.png"
                                          : "assets/img/repeat_all.png",
                                      width: 30,
                                      height: 30,
                                      color: TColor.primaryText80,
                                    ),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
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
                  child: StreamBuilder<void>(
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
                          overlayShape:
                              const RoundSliderOverlayShape(overlayRadius: 15),
                          tickMarkShape: const RoundSliderTickMarkShape(),
                          activeTickMarkColor: Colors.purple.shade800,
                          inactiveTickMarkColor: Colors.purple.shade200,
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
                            systemVolumeStreamNotifier();

                            setVolume(value);
                          },
                        ),
                      );
                    },
                  ),
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
                      await radioSeekToPrevious();
                    },
                    icon: Image.asset(
                      "assets/img/previous_song.png",
                    ),
                  ),
                ),
                // SizedBox(
                //   width: 65,
                //   height: 65,
                //   child: IconButton(
                //     iconSize: 10,
                //     onPressed: () {
                //       rewind();
                //     },
                //     icon: Image.asset(
                //       "assets/img/backward-5-seconds.png",
                //       color: TColor.primaryText80,
                //     ),
                //   ),
                // ),
                const SizedBox(
                  width: 10,
                ),
                StreamBuilder<PlayerState>(
                  stream: radioPlayer.playerStateStream,
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
                            radioPlayOrPause();
                          },
                          icon: Image.asset(
                            "assets/img/round-play-button_icon.png",
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
                            radioPlayOrPause();
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
                  width: 10,
                ),
                // SizedBox(
                //   width: 65,
                //   height: 65,
                //   child: IconButton(
                //     iconSize: 10,
                //     onPressed: () {
                //       forward();
                //     },
                //     icon: Image.asset(
                //       "assets/img/forward-5-seconds.png",
                //       color: TColor.primaryText80,
                //     ),
                //   ),
                // ),
                SizedBox(
                  width: 60,
                  height: 60,
                  child: IconButton(
                    onPressed: () async {
                      await radioSeekToNext();
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
