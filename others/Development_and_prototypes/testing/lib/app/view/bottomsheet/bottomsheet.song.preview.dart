import 'package:audioplayers/audioplayers.dart' as audio_players;
import 'package:flutter/material.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';
import 'package:vicyos_music/app/color_palette/color_extension.dart';
import 'package:vicyos_music/app/components/appbars.dart';
import 'package:vicyos_music/app/components/marquee.text.dart';
import 'package:vicyos_music/app/files_and_folders_handler/folders.and.files.related.dart';
import 'package:vicyos_music/app/models/audio.info.dart';
import 'package:vicyos_music/app/music_player/music.player.functions.and.more.dart';
import 'package:vicyos_music/app/music_player/music.player.stream.controllers.dart';
import 'package:vicyos_music/app/radio_player/functions_and_streams/radio.functions.and.more.dart';
import 'package:vicyos_music/l10n/app_localizations.dart';
import 'package:wave_progress_widget/wave_progress.dart';

class SongPreviewBottomSheet extends StatelessWidget {
  final AudioInfo songModel;
  final NavigationButtons audioRoute;

  const SongPreviewBottomSheet({
    super.key,
    required this.songModel,
    required this.audioRoute,
  });

  @override
  Widget build(BuildContext context) {
    previewSong(songModel.path);
    var media = MediaQuery.of(context).size;
    return ClipRRect(
      borderRadius: const BorderRadius.vertical(
        top: Radius.circular(25),
        bottom: Radius.circular(0),
      ),
      child: Container(
        color: TColor.bg,
        height: deviceTypeIsTablet()
            ? media.height * 0.76
            : media.height * 0.62, // Adjust the height
        child: Scaffold(
          appBar: previewPlayerViewAppBar(
            context: context,
            filePath: songModel.path,
            audioRoute: audioRoute,
          ),
          body: Container(
            color: TColor.bg,
            // height:  media.height * 0.5, // Adjust the height
            padding: const EdgeInsets.fromLTRB(0, 5, 0, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 10),
                Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(deviceTypeIsTablet()
                          ? media.width * 0.2
                          : media.width * 0.5),
                      child: StreamBuilder<void>(
                        stream: null,
                        builder: (context, snapshot) {
                          return Image.asset(
                            "assets/img/default_album_art/lofi-woman-album-cover-art_10.png",
                            width: deviceTypeIsTablet()
                                ? media.width * 0.15
                                : media.width * 0.42,
                            height: deviceTypeIsTablet()
                                ? media.width * 0.15
                                : media.width * 0.42,
                            fit: BoxFit.cover,
                          );
                        },
                      ),
                    ),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(deviceTypeIsTablet()
                          ? media.width * 0.2
                          : media.width * 0.5),
                      child: WaveProgress(
                        size: deviceTypeIsTablet() ? 170.9 : 163.9,
                        borderColor: Colors.transparent,
                        fillColor: Colors.blueAccent,
                        progress: 9.0,
                      ),
                    ),
                    SizedBox(
                      width: deviceTypeIsTablet()
                          ? media.width * 0.15
                          : media.width * 0.42,
                      height: deviceTypeIsTablet()
                          ? media.width * 0.15
                          : media.width * 0.42,
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
                            },
                          );
                        },
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: deviceTypeIsTablet() ? 14 : 13,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    StreamBuilder<Duration>(
                      stream: audioPlayerPreview.onPositionChanged,
                      builder: (context, snapshot) {
                        final position = snapshot.data ?? Duration.zero;
                        return Text(
                          formatDuration(position),
                          style: TextStyle(
                              color: TColor.secondaryText, fontSize: 15),
                        );
                      },
                    ),
                    Text(
                      " | ",
                      style:
                          TextStyle(color: TColor.secondaryText, fontSize: 15),
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
                      },
                    ),
                  ],
                ),
                SizedBox(
                  height: deviceTypeIsTablet() ? 10 : 1,
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(29, 0, 29, 0),
                  child: SizedBox(
                    height: deviceTypeIsTablet() ? 50 : 45,
                    child: Column(
                      children: [
                        SizedBox(
                          width: media.width * 0.9,
                          height: deviceTypeIsTablet()
                              ? media.width * 0.04
                              : media.width * 0.07,
                          child: LayoutBuilder(
                            builder: (context, constraints) {
                              // Gets the width of Expanded
                              final double width = constraints.maxWidth;
                              return MarqueeText(
                                centerText: true,
                                // Forces rebuild when song changes
                                key: ValueKey(songName(songModel.name)),
                                maxWidth:
                                    width, // Set dynamically based on layout
                                text: songName(songModel.name),
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
                        iconSize: 10,
                        onPressed: () async {
                          audioPlayerPreview.seek(
                              (await audioPlayerPreview.getCurrentPosition() ??
                                      Duration.zero) -
                                  Duration(seconds: 5));
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
                    StreamBuilder<audio_players.PlayerState>(
                      stream: audioPlayerPreview.onPlayerStateChanged,
                      builder: (context, snapshot) {
                        final playerState = snapshot.data;

                        if (playerState == audio_players.PlayerState.stopped ||
                            playerState == audio_players.PlayerState.paused ||
                            playerState ==
                                audio_players.PlayerState.completed ||
                            playerState == null) {
                          return SizedBox(
                            width: 62,
                            height: 62,
                            child: IconButton(
                              iconSize: 45,
                              onPressed: () async {
                                if (radioPlayer.playing) {
                                  radioPlayer.pause();
                                }
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
                              },
                              icon: Image.asset(
                                "assets/img/player/play.png",
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
                          "assets/img/player/forward-5-seconds.png",
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
                        AppLocalizations.of(context)!
                            .add_to_queue_all_capitalized,
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: TColor.focusStart,
                          fontSize: 17,
                        ),
                      ),
                      onPressed: () async {
                        await addSongToPlaylist(
                          context: context,
                          songPath: songModel.path,
                          audioRoute: audioRoute,
                          audioRouteEmptyPlaylist: audioRoute,
                        );
                        rebuildPlaylistCurrentLengthNotifier();
                      },
                      backgroundColor: TColor.darkGray,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
