import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';
import 'package:vicyos_music/app/color_palette/color_extension.dart';
import 'package:vicyos_music/app/components/appbars.dart';
import 'package:vicyos_music/app/components/marquee.text.dart';
import 'package:vicyos_music/app/components/music_visualizer.dart';
import 'package:vicyos_music/app/music_player/music.player.functions.and.more.dart';
import 'package:vicyos_music/app/music_player/music.player.stream.controllers.dart';
import 'package:vicyos_music/app/radio_player/bottomsheet/radio.bottom.sheet.speed.rate.dart';
import 'package:vicyos_music/app/radio_player/functions_and_streams/radio.functions.and.more.dart';
import 'package:vicyos_music/app/radio_player/functions_and_streams/radio.stream.controllers.dart';
import 'package:vicyos_music/app/radio_player/widgets/radio.music.visualizer.dart';
import 'package:vicyos_music/app/radio_player/widgets/show.radio.top.message.dart';
import 'package:vicyos_music/app/screen_orientation/screen.orientation.dart';
import 'package:vicyos_music/app/view/bottomsheet/bottom.sheet.playing.queue.dart';
import 'package:vicyos_music/app/view/bottomsheet/bottom.sheet.speed.rate.dart';
import 'package:vicyos_music/l10n/app_localizations.dart';
import 'package:wave_progress_widget/wave_progress.dart';

final List<Color> colors = [
  TColor.focus,
  TColor.secondaryEnd,
  TColor.focusStart,
  Colors.blue[900]!,
];

BuildContext? playlistBottomSheetTabletContext;
BuildContext? radioPlayerPlaybackSpeedBottomSheetTabletContext;
BuildContext? audioPlayerPlaybackSpeedBottomSheetTabletContext;

final List<int> duration = [900, 700, 600, 800, 500];
final GlobalKey mainPlayerViewTabletKey = GlobalKey();

class MainPlayerViewTablet extends StatelessWidget {
  final GlobalKey scaffoldKey;
  const MainPlayerViewTablet({
    super.key,
    required this.scaffoldKey,
  });

  @override
  Widget build(BuildContext context) {
    // Set the preferred orientations to landscape mode when this screen is built
    setScreenOrientation();

    var media = MediaQuery.sizeOf(context);
    return Scaffold(
      appBar: mainPlayerViewAppBarTablet(
        context: context,
        audioRoute: songCurrentRouteType,
      ),
      body: StreamBuilder(
        stream: switchingToRadioStreamController.stream,
        builder: (context, asyncSnapshot) {
          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(
                  height: 10,
                ),
                Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(media.width * 0.19),
                      child: StreamBuilder<void>(
                        stream: null,
                        builder: (context, snapshot) {
                          return Image.asset(
                            "assets/img/default_album_art/lofi-woman-album-cover-art_10.png",
                            width: media.width * 0.19,
                            height: media.width * 0.19,
                            fit: BoxFit.cover,
                          );
                        },
                      ),
                    ),
                    WaveProgress(
                      size: 218.0,
                      borderColor: Colors.transparent,
                      fillColor: Colors.blueAccent,
                      progress: 10.0,
                    ),
                    SizedBox(
                      width: media.width * 0.19,
                      height: media.width * 0.19,
                      child: StreamBuilder<void>(
                        stream: clearCurrentPlaylistStreamController.stream,
                        builder: (context, snapshot) {
                          return StreamBuilder<Duration>(
                            stream: audioPlayer.positionStream,
                            builder: (context, snapshot) {
                              if (audioPlayer.audioSources.isEmpty) {
                                sleekCircularSliderPosition =
                                    Duration.zero.inSeconds.toDouble();
                              }
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
                                },
                              );
                            },
                          );
                        },
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: isRadioOn ? 14 : 15,
                ),
                isRadioOn
                    ? Text(
                        AppLocalizations.of(context)!.streaming_all_capitalized,
                        style: TextStyle(
                            color: TColor.secondaryText, fontSize: 14),
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          StreamBuilder<void>(
                            stream: clearCurrentPlaylistStreamController.stream,
                            builder: (context, snapshot) {
                              return StreamBuilder<Duration>(
                                stream: audioPlayer.positionStream,
                                builder: (context, snapshot) {
                                  final position =
                                      snapshot.data ?? Duration.zero;
                                  return Text(
                                    // (audioPlayer.processingState !=
                                    //         ProcessingState.idle)
                                    //     ? formatDuration(position)
                                    //     :
                                    audioPlayer.audioSources.isEmpty
                                        ? formatDuration(Duration.zero)
                                        : formatDuration(position),
                                    style: TextStyle(
                                        color: TColor.secondaryText,
                                        fontSize: 14),
                                  );
                                },
                              );
                            },
                          ),
                          Text(
                            " | ",
                            style: TextStyle(
                                color: TColor.secondaryText, fontSize: 14),
                          ),
                          StreamBuilder(
                            stream: clearCurrentPlaylistStreamController.stream,
                            builder: (context, snapshot) {
                              return StreamBuilder<Duration?>(
                                stream: audioPlayer.durationStream,
                                builder: (context, snapshot) {
                                  final duration =
                                      snapshot.data ?? Duration.zero;

                                  return Text(
                                    (audioPlayer.audioSources.isEmpty)
                                        ? formatDuration(Duration.zero)
                                        : formatDuration(duration),
                                    style: TextStyle(
                                        color: TColor.secondaryText,
                                        fontSize: 14),
                                  );
                                },
                              );
                            },
                          ),
                        ],
                      ),
                const SizedBox(
                  height: 1,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    isRadioOn
                        ? StreamBuilder<void>(
                            stream: updateRadioScreensStreamController.stream,
                            builder: (context, snapshot) {
                              // Check if snapshot has data
                              if (!isRadioOn) {
                                return Text(
                                  '0',
                                  style: TextStyle(
                                      color: TColor.secondaryText,
                                      fontSize: 15),
                                );
                              }

                              return Text(
                                "${currentRadioIndex + 1}",
                                style: TextStyle(
                                    color: TColor.secondaryText, fontSize: 15),
                              );
                            },
                          )
                        : StreamBuilder<void>(
                            stream: currentSongNameStreamController.stream,
                            builder: (context, snapshot) {
                              return Text(
                                (audioPlayer.audioSources.isEmpty)
                                    ? '0'
                                    : '${currentIndex + 1}',
                                style: TextStyle(
                                    color: TColor.secondaryText, fontSize: 14),
                              );
                            }),
                    isRadioOn
                        ? StreamBuilder<void>(
                            stream: updateRadioScreensStreamController.stream,
                            builder: (context, snapshot) {
                              return Text(
                                isRadioOn
                                    ? " ${AppLocalizations.of(context)!.prepositionOf} ${radioPlayer.audioSources.length}"
                                    : " ${AppLocalizations.of(context)!.prepositionOf} 0",
                                style: TextStyle(
                                    color: TColor.secondaryText, fontSize: 15),
                              );
                            },
                          )
                        : StreamBuilder<void>(
                            stream:
                                rebuildPlaylistCurrentLengthController.stream,
                            builder: (context, snapshot) {
                              return Text(
                                " ${AppLocalizations.of(context)!.prepositionOf} $playlistCurrentLength",
                                style: TextStyle(
                                    color: TColor.secondaryText, fontSize: 14),
                              );
                            },
                          ),
                  ],
                ),
                SizedBox(
                  // height: audioPlayer.audioSources.isEmpty ? 15 : 10,
                  height: 15,
                ),
                isRadioOn
                    ? Padding(
                        padding: const EdgeInsets.fromLTRB(29, 0, 29, 0),
                        child: StreamBuilder<void>(
                          stream: updateRadioScreensStreamController.stream,
                          builder: (context, snapshot) {
                            return Column(
                              children: [
                                SizedBox(
                                  width: isRadioOn
                                      ? media.width * 0.8
                                      : media.width * 0.9,
                                  height: isRadioOn
                                      ? media.width * 0.03
                                      : media.width * 0.07,
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
                                            : "The radio_player is turned off",
                                        style: TextStyle(
                                          color: TColor.primaryText
                                              .withValues(alpha: 0.9),
                                          fontSize: 19,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      );
                                    },
                                  ),
                                ),
                                // const SizedBox(
                                //   height: 10,
                                // ),
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(35, 0, 35, 0),
                                  child: Text(
                                    isRadioOn
                                        ? currentRadioStationLocation
                                        : AppLocalizations.of(context)!
                                            .ellipsis,
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
                      )
                    : Padding(
                        padding: const EdgeInsets.fromLTRB(29, 0, 29, 0),
                        child: StreamBuilder<void>(
                          stream: currentSongNameStreamController.stream,
                          builder: (context, snapshot) {
                            return StreamBuilder<void>(
                                stream:
                                    clearCurrentPlaylistStreamController.stream,
                                builder: (context, snapshot) {
                                  return Column(
                                    children: [
                                      SizedBox(
                                        width: media.width * 0.8,
                                        height: media.width * 0.03,
                                        child: LayoutBuilder(
                                          builder: (context, constraints) {
                                            // Gets the width of Expanded
                                            final double width =
                                                constraints.maxWidth;
                                            return MarqueeText(
                                              centerText: true,
                                              // Forces rebuild when song changes
                                              key: ValueKey(currentSongName),
                                              // Set dynamically based on layout
                                              maxWidth: width,
                                              text: audioPlayer
                                                      .audioSources.isEmpty
                                                  ? AppLocalizations.of(
                                                          context)!
                                                      .the_playlist_is_empty
                                                  : currentSongName,
                                              style: TextStyle(
                                                color: TColor.primaryText
                                                    .withValues(alpha: 0.9),
                                                fontSize: 19,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                      // const SizedBox(
                                      //   height: 5,
                                      // ),
                                      Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            35, 0, 35, 0),
                                        child: Text(
                                          audioPlayer.audioSources.isEmpty
                                              ? AppLocalizations.of(context)!
                                                  .the_song_folder_will_be_displayed_here
                                              : currentFolderPath,
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
                                });
                          },
                        ),
                      ),
                const SizedBox(
                  height: 28,
                ),
                isRadioOn
                    ? SizedBox(
                        height: 40,
                        width: media.width * 0.24,
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
                      )
                    : SizedBox(
                        height: 40,
                        width: media.width * 0.24,
                        child: MusicVisualizer(
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
                isRadioOn
                    ? Column(
                        children: [
                          Padding(
                            padding:
                                const EdgeInsets.fromLTRB(9.0, 9.0, 9.0, 5.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(6, 0, 8, 0),
                                  child: Column(
                                    children: [
                                      SizedBox(
                                        width: 42,
                                        height: 42,
                                        child: IconButton(
                                          onPressed: () {
                                            if (radioPlayer
                                                .audioSources.isNotEmpty) {
                                              if (stationHasBeenSearched) {
                                                reLoadRatioStationCurrentIndex(
                                                    context);
                                              } else {
                                                playRadioStation(context,
                                                    (currentRadioIndex));
                                              }
                                            }
                                          },
                                          icon: Image.asset(
                                            "assets/img/radio/reload-two-streamline-tabler.png",
                                            width: 30,
                                            height: 30,
                                            color: TColor.primaryText80,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(10, 0, 10, 0),
                                  child: Column(
                                    children: [
                                      IconButton(
                                        onPressed: () {
                                          showModalBottomSheet<void>(
                                            backgroundColor: Colors.transparent,
                                            context: context,
                                            builder: (BuildContext context) {
                                              radioPlayerPlaybackSpeedBottomSheetTabletContext =
                                                  context;
                                              return const RadioSpeedRateBottomSheet();
                                            },
                                          ).whenComplete(() {
                                            radioPlayerPlaybackSpeedBottomSheetTabletContext =
                                                null;
                                          });
                                        },
                                        icon: Image.asset(
                                          'assets/img/speed_rate/speed-one.png',
                                          width: 25,
                                          height: 25,
                                          color: TColor.primaryText80,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(6, 0, 8, 0),
                                  child: Column(
                                    children: [
                                      StreamBuilder<void>(
                                        stream: radioShuffleModeStreamController
                                            .stream,
                                        builder: (context, snapshot) {
                                          return SizedBox(
                                            width:
                                                radioPlayer.shuffleModeEnabled
                                                    ? 45
                                                    : 45,
                                            height:
                                                radioPlayer.shuffleModeEnabled
                                                    ? 44
                                                    : 40,
                                            child: IconButton(
                                              onPressed: () async {
                                                if (radioPlayer
                                                    .shuffleModeEnabled) {
                                                  await radioPlayer
                                                      .setShuffleModeEnabled(
                                                          false);
                                                  if (context.mounted) {
                                                    showRadioLoopMode(
                                                        context,
                                                        AppLocalizations.of(
                                                                context)!
                                                            .repeating_all);
                                                  }
                                                } else {
                                                  await radioPlayer
                                                      .setShuffleModeEnabled(
                                                          true);
                                                  if (context.mounted) {
                                                    showRadioLoopMode(
                                                        context,
                                                        AppLocalizations.of(
                                                                context)!
                                                            .playback_is_shuffled);
                                                  }
                                                }
                                                radioShuffleModeNotifier();
                                              },
                                              icon: Image.asset(
                                                radioPlayer.shuffleModeEnabled
                                                    ? "assets/img/repeat_mode/shuffle_1.png"
                                                    : "assets/img/repeat_mode/repeat_all.png",
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
                      )
                    : Column(
                        children: [
                          Padding(
                            padding:
                                const EdgeInsets.fromLTRB(9.0, 9.0, 9.0, 5.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(8, 0, 8, 0),
                                  child: Column(
                                    children: [
                                      SizedBox(
                                        width: 40,
                                        height: 40,
                                        child: IconButton(
                                          onPressed: () {
                                            showModalBottomSheet<void>(
                                              backgroundColor:
                                                  Colors.transparent,
                                              context: context,
                                              builder: (BuildContext context) {
                                                playlistBottomSheetTabletContext =
                                                    context;
                                                return PlayingQueueBottomSheet();
                                              },
                                            ).whenComplete(() {
                                              playlistBottomSheetTabletContext =
                                                  null;
                                            });
                                          },
                                          icon: Image.asset(
                                            "assets/img/bottomsheet/playlist.png",
                                            color: TColor.primaryText80,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(10, 0, 10, 0),
                                  child: Column(
                                    children: [
                                      IconButton(
                                        onPressed: () {
                                          showModalBottomSheet<void>(
                                            backgroundColor: Colors.transparent,
                                            context: context,
                                            builder: (BuildContext context) {
                                              audioPlayerPlaybackSpeedBottomSheetTabletContext =
                                                  context;
                                              return const SpeedRateBottomSheet();
                                            },
                                          ).whenComplete(() {
                                            audioPlayerPlaybackSpeedBottomSheetTabletContext =
                                                null;
                                          });
                                        },
                                        icon: Image.asset(
                                          'assets/img/speed_rate/speed-one.png',
                                          width: 25,
                                          height: 25,
                                          color: TColor.primaryText80,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(6, 0, 8, 0),
                                  child: Column(
                                    children: [
                                      StreamBuilder<void>(
                                        stream:
                                            repeatModeStreamController.stream,
                                        builder: (context, snapshot) {
                                          return SizedBox(
                                            width:
                                                audioPlayer.shuffleModeEnabled
                                                    ? 45
                                                    : 45,
                                            height: (currentLoopMode ==
                                                    CurrentLoopMode.shuffle)
                                                ? 40
                                                : 40,
                                            child: IconButton(
                                              onPressed: () {
                                                repeatMode(context);
                                              },
                                              icon: Image.asset(
                                                currentLoopModeIcon,
                                                width: 22,
                                                height: 22,
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
                        top: 0,
                        bottom: 0,
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
                              overlayShape: const RoundSliderOverlayShape(
                                  overlayRadius: 15),
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
                                systemVolumeNotifier();

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
                  height: 5,
                ),
                isRadioOn
                    ? Row(
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
                                "assets/img/player/previous_song.png",
                              ),
                            ),
                          ),
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
                                      "assets/img/player/round-play-button_icon.png",
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
                                      "assets/img/player/round-pause-button_icon.png",
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
                          SizedBox(
                            width: 60,
                            height: 60,
                            child: IconButton(
                              onPressed: () async {
                                await radioSeekToNext();
                              },
                              icon: Image.asset(
                                "assets/img/player/next_song.png",
                              ),
                            ),
                          ),
                        ],
                      )
                    : Row(
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
                                "assets/img/player/previous_song.png",
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
                                "assets/img/player/backward-5-seconds.png",
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
                                      if (audioPlayer.audioSources.isNotEmpty) {
                                        audioPlayer.play();
                                      }
                                    },
                                    icon: Image.asset(
                                      "assets/img/player/round-play-button_icon.png",
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
                                      "assets/img/player/round-pause-button_icon.png",
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
                                "assets/img/player/forward-5-seconds.png",
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
                                "assets/img/player/next_song.png",
                              ),
                            ),
                          ),
                        ],
                      ),
              ],
            ),
          );
        },
      ),
    );
  }
}
