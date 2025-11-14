import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:vicyos_music/app/common/color_palette/color_extension.dart';
import 'package:vicyos_music/app/common/music_player/music.player.dart';
import 'package:vicyos_music/app/common/radio/radio.stream.notifiers.dart';
import 'package:vicyos_music/app/common/radio/radio_stations/radio.stations.list.dart'
    show radioStationList;
import 'package:vicyos_music/app/is_smartphone/navigation_animation/main.player.navigation.animation.dart'
    show mainPlayerSlideUpDownTransition;
import 'package:vicyos_music/app/is_smartphone/view/screens/main.player.view.screen.dart';
import 'package:vicyos_music/app/is_smartphone/widgets/marquee.text.dart';

class RadioBottomPlayer extends StatelessWidget {
  const RadioBottomPlayer({super.key});

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.sizeOf(context);

    return Stack(
      children: [
        Column(
          children: [
            Container(
              width: media.width * 0.94,
              margin: const EdgeInsets.only(top: 0, bottom: 18),
              height: 72,
              decoration: BoxDecoration(
                color: Color(0xff2A2D40),
                boxShadow: [
                  BoxShadow(
                    color: Color(0xff000000).withValues(alpha: 0.5),
                    spreadRadius: 0.4,
                    blurRadius: 12,
                    offset: Offset(1, 1),
                  ),
                ],
                borderRadius: BorderRadius.circular(20),
              ),
              child: Material(
                color: Colors.transparent,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(14, 5, 10, 5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Padding(
                          //   padding: const EdgeInsets.fromLTRB(0, 0, 7, 0),
                          //   child: Stack(
                          //     children: [
                          //       ClipRRect(
                          //         borderRadius:
                          //             BorderRadius.circular(media.width * 0.7),
                          //         child: StreamBuilder<void>(
                          //           stream: null,
                          //           builder: (context, snapshot) {
                          //             return Image.asset(
                          //               "assets/img/lofi-woman-album-cover-art_10.png",
                          //               width: media.width * 0.15,
                          //               height: media.width * 0.15,
                          //               fit: BoxFit.cover,
                          //             );
                          //           },
                          //         ),
                          //       ),
                          //       StreamBuilder<Duration>(
                          //         stream: audioPlayer.positionStream,
                          //         builder: (context, snapshot) {
                          //           return SizedBox(
                          //             width: media.width * 0.15,
                          //             height: media.width * 0.15,
                          //             child: SleekCircularSlider(
                          //               appearance: CircularSliderAppearance(
                          //                   customWidths: CustomSliderWidths(
                          //                       trackWidth: 3.5,
                          //                       progressBarWidth: 3.5,
                          //                       shadowWidth: 10),
                          //                   customColors: CustomSliderColors(
                          //                       dotFillColor:
                          //                           const Color(0xffFFB1B2),
                          //                       trackColor:
                          //                           const Color(0xffffffff)
                          //                               .withValues(alpha: 0.3),
                          //                       progressBarColors: [
                          //                         TColor.focusStart,
                          //                         TColor.focusStart
                          //                       ],
                          //                       shadowColor:
                          //                           const Color(0xffFFB1B2),
                          //                       shadowMaxOpacity: 0.05),
                          //                   infoProperties: InfoProperties(
                          //                     topLabelStyle: const TextStyle(
                          //                         color: Colors.transparent,
                          //                         fontSize: 0,
                          //                         fontWeight: FontWeight.w400),
                          //                     topLabelText: 'Elapsed',
                          //                     bottomLabelStyle: const TextStyle(
                          //                         color: Colors.transparent,
                          //                         fontSize: 0,
                          //                         fontWeight: FontWeight.w400),
                          //                     bottomLabelText: 'time',
                          //                     mainLabelStyle: const TextStyle(
                          //                         color: Colors.transparent,
                          //                         fontSize: 00,
                          //                         fontWeight: FontWeight.w600),
                          //                   ),
                          //                   startAngle: 270,
                          //                   angleRange: 360,
                          //                   size: 350.0),
                          //               min: 0,
                          //               max: sleekCircularSliderDuration,
                          //
                          //               // The initValue has been renamed to value.
                          //               value: sleekCircularSliderPosition,
                          //               onChange: (value) {
                          //                 if (value < 0) {
                          //                   return;
                          //                 } else {
                          //                   audioPlayer.seek(Duration(
                          //                       seconds: value.toInt()));
                          //                 }
                          //               },
                          //             ),
                          //           );
                          //         },
                          //       ),
                          //     ],
                          //   ),
                          // ),
                          StreamBuilder(
                            stream: rebuildRadioScreenStreamController.stream,
                            builder: (context, asyncSnapshot) {
                              return Stack(
                                children: [
                                  Positioned(
                                    height: 103,
                                    child: (isRadioOn)
                                        //  flickr
                                        ? Padding(
                                            padding: const EdgeInsets.only(
                                                left: 15.2),
                                            child: LoadingAnimationWidget
                                                .progressiveDots(
                                              color: TColor
                                                  .lightGray, // Colors.green,
                                              size: 20,
                                            ),
                                            // LoadingAnimationWidget
                                            //     .newtonCradle(
                                            //   color: TColor
                                            //       .lightGray, // Colors.green,
                                            //   size: 40,
                                            // ),
                                          )
                                        : Container(),
                                  ),
                                  Material(
                                    color: Colors.transparent,
                                    // color: Colors.white30,
                                    child: SizedBox(
                                      width: 52,
                                      height: 53,
                                      child: IconButton(
                                        splashRadius: 20,
                                        iconSize: 20,
                                        onPressed: () async {
                                          // // Show Radio Mini Player
                                          // hideMiniRadioPlayerStreamNotifier(
                                          //     false);
                                          //
                                          // // Hide Mini Player
                                          // hideMiniPlayerStreamNotifier(
                                          //     true);
                                          //
                                          // Navigator.push(
                                          //   context,
                                          //   slideRightLeftTransition(
                                          //     RadioStationsScreen(),
                                          //   ),
                                          // ).whenComplete(
                                          //       () {
                                          //     hideMiniRadioPlayerStreamNotifier(
                                          //         true);
                                          //     // "When the bottom sheet is closed, send a signal to show the mini player again."
                                          //     hideMiniPlayerStreamNotifier(
                                          //         false);
                                          //   },
                                          // );
                                        },
                                        icon: SizedBox(
                                          height: 60,
                                          child: Image.asset(
                                            "assets/img/radio_icon.png",
                                            color: TColor.lightGray,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            },
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    mainPlayerIsOpen = true;

                                    Navigator.push(
                                      context,
                                      mainPlayerSlideUpDownTransition(
                                        MainPlayerView(),
                                      ),
                                    ).whenComplete(
                                      () {
                                        if (mainPlayerIsOpen) {
                                          mainPlayerIsOpen = false;
                                        }
                                        hideMiniPlayerStreamNotifier(false);
                                      },
                                    );
                                  },
                                  child: StreamBuilder<void>(
                                    stream:
                                        rebuildSongsListScreenStreamController
                                            .stream,
                                    builder: (context, snapshot) {
                                      return Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          SizedBox(
                                            width: media.width * 0.35,
                                            height: media.width * 0.06,
                                            child: LayoutBuilder(
                                              builder: (context, constraints) {
                                                // Gets the width of Expanded
                                                final double width =
                                                    constraints.maxWidth;
                                                return StreamBuilder<void>(
                                                    stream:
                                                        rebuildRadioScreenStreamController
                                                            .stream,
                                                    builder:
                                                        (context, snapshot) {
                                                      return MarqueeText(
                                                        centerText: false,
                                                        // Forces rebuild when song changes
                                                        key: ValueKey(
                                                            currentSongName),
                                                        // Set dynamically based on layout
                                                        maxWidth: width,
                                                        text: isRadioOn
                                                            ? radioStationList[
                                                                    currentRadioIndex]
                                                                .radioName
                                                            : "The radio is turned off",
                                                        style: TextStyle(
                                                          color: TColor
                                                              .primaryText
                                                              .withValues(
                                                                  alpha: 0.84),
                                                          fontSize: 16,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                        ),
                                                      );
                                                    });
                                              },
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                left: 0.0),
                                            child: SizedBox(
                                              width: media.width * 0.30,
                                              child: Row(
                                                children: [
                                                  StreamBuilder(
                                                    stream:
                                                        clearCurrentPlaylistStreamController
                                                            .stream,
                                                    builder:
                                                        (context, snapshot) {
                                                      return StreamBuilder<
                                                          PlaybackEvent>(
                                                        stream: radioPlayer
                                                            .playbackEventStream,
                                                        builder: (context,
                                                            snapshot) {
                                                          // Check if snapshot has data
                                                          if (!snapshot
                                                              .hasData) {
                                                            return Text(
                                                              '0',
                                                              style: TextStyle(
                                                                  color: TColor
                                                                      .secondaryText,
                                                                  fontSize: 15),
                                                            );
                                                          }
                                                          final eventState =
                                                              snapshot.data!;
                                                          final index =
                                                              eventState
                                                                  .currentIndex;
                                                          final playerState =
                                                              radioPlayer
                                                                  .processingState;

                                                          return Text(
                                                            (playerState ==
                                                                        ProcessingState
                                                                            .idle ||
                                                                    radioPlayer
                                                                        .audioSources
                                                                        .isEmpty)
                                                                ? '0'
                                                                : "${index! + 1}",
                                                            style: TextStyle(
                                                                color: TColor
                                                                    .secondaryText,
                                                                fontSize: 15),
                                                          );
                                                        },
                                                      );
                                                    },
                                                  ),
                                                  StreamBuilder<void>(
                                                      stream:
                                                          rebuildRadioScreenStreamController
                                                              .stream,
                                                      builder:
                                                          (context, snapshot) {
                                                        return StreamBuilder<
                                                            void>(
                                                          stream:
                                                              rebuildSongsListScreenStreamController
                                                                  .stream,
                                                          builder: (context,
                                                              snapshot) {
                                                            return Text(
                                                              isRadioOn
                                                                  ? " of ${radioPlayer.audioSources.length}"
                                                                  : " of 0",
                                                              style: TextStyle(
                                                                  color: TColor
                                                                      .secondaryText,
                                                                  fontSize: 15),
                                                            );
                                                          },
                                                        );
                                                      }),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: 40,
                            height: 40,
                            child: IconButton(
                              splashRadius: 20,
                              iconSize: 10,
                              onPressed: () async {
                                await radioPlayer.seekToPrevious();
                              },
                              icon: Image.asset(
                                "assets/img/bottom_player/skip_previous.png",
                                color: TColor.lightGray,
                              ),
                            ),
                          ),
                          StreamBuilder<PlayerState>(
                            stream: radioPlayer.playerStateStream,
                            builder: (context, snapshot) {
                              final playerState = snapshot.data;
                              final playing = playerState?.playing;
                              if (playing != true) {
                                return SizedBox(
                                  width: 45,
                                  height: 45,
                                  child: IconButton(
                                    splashRadius: 20,
                                    onPressed: () {
                                      if (radioPlayer.audioSources.isNotEmpty) {
                                        radioPlayer.play();
                                      }
                                    },
                                    icon: Image.asset(
                                      "assets/img/bottom_player/motion_play.png",
                                      color: TColor.lightGray,
                                    ),
                                  ),
                                );
                              } else {
                                return SizedBox(
                                  width: 45,
                                  height: 45,
                                  child: IconButton(
                                    splashRadius: 20,
                                    onPressed: () {
                                      radioPlayer.stop();
                                    },
                                    icon: Image.asset(
                                      "assets/img/bottom_player/motion_paused.png",
                                      color: TColor.lightGray,
                                    ),
                                  ),
                                );
                              }
                            },
                          ),
                          SizedBox(
                            width: 40,
                            height: 40,
                            child: IconButton(
                              iconSize: 10,
                              splashRadius: 20,
                              onPressed: () async {
                                await radioPlayer.seekToNext();
                              },
                              icon: Image.asset(
                                "assets/img/bottom_player/skip_next.png",
                                color: TColor.lightGray,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
