import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';
import 'package:vicyos_music_player/app/common/color_extension.dart';
import 'package:vicyos_music_player/app/functions/music_player.dart';
import 'package:vicyos_music_player/app/view/main.player.view.screen.dart';

class BottomPlayer extends StatelessWidget {
  const BottomPlayer({super.key});

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
                color: TColor.darkGraySecond,
                boxShadow: [
                  BoxShadow(
                    color: const Color.fromARGB(255, 0, 0, 0).withOpacity(0.2),
                    spreadRadius: 1,
                    blurRadius: 4,
                    offset: const Offset(0, 0), // changes position of shadow
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
                          Padding(
                            padding: const EdgeInsets.fromLTRB(0, 0, 7, 0),
                            child: Stack(
                              children: [
                                ClipRRect(
                                  borderRadius:
                                      BorderRadius.circular(media.width * 0.7),
                                  child: StreamBuilder<bool>(
                                      stream: albumArtStreamController.stream,
                                      builder: (context, snapshot) {
                                        return Image.asset(
                                          isFirstArtDemoCover
                                              ? "assets/img/lofi-woman-album-cover-art_10.png"
                                              : "assets/img/lofi-woman-album-cover-art.png",
                                          width: media.width * 0.15,
                                          height: media.width * 0.15,
                                          fit: BoxFit.cover,
                                        );
                                      }),
                                ),
                                StreamBuilder<Duration>(
                                    stream: audioPlayer.positionStream,
                                    builder: (context, snapshot) {
                                      return SizedBox(
                                        width: media.width * 0.15,
                                        height: media.width * 0.15,
                                        child: SleekCircularSlider(
                                          appearance: CircularSliderAppearance(
                                              customWidths: CustomSliderWidths(
                                                  trackWidth: 3.5,
                                                  progressBarWidth: 3.5,
                                                  shadowWidth: 10),
                                              customColors: CustomSliderColors(
                                                  dotColor:
                                                      const Color(0xffFFB1B2),
                                                  trackColor:
                                                      const Color(0xffffffff)
                                                          .withOpacity(0.3),
                                                  progressBarColors: [
                                                    TColor.focusStart,
                                                    TColor.focusStart
                                                  ],
                                                  shadowColor:
                                                      const Color(0xffFFB1B2),
                                                  shadowMaxOpacity: 0.05),
                                              infoProperties: InfoProperties(
                                                topLabelStyle: const TextStyle(
                                                    color: Colors.transparent,
                                                    fontSize: 0,
                                                    fontWeight:
                                                        FontWeight.w400),
                                                topLabelText: 'Elapsed',
                                                bottomLabelStyle:
                                                    const TextStyle(
                                                        color:
                                                            Colors.transparent,
                                                        fontSize: 0,
                                                        fontWeight:
                                                            FontWeight.w400),
                                                bottomLabelText: 'time',
                                                mainLabelStyle: const TextStyle(
                                                    color: Colors.transparent,
                                                    fontSize: 00,
                                                    fontWeight:
                                                        FontWeight.w600),
                                                // modifier: (double value) {
                                                //   final time = print(Duration(
                                                //       seconds: value.toInt()));
                                                //   return '$time';
                                                // },
                                              ),
                                              startAngle: 270,
                                              angleRange: 360,
                                              size: 350.0),
                                          min: 0,
                                          max: sleekCircularSliderDuration,
                                          initialValue:
                                              sleekCircularSliderPosition,
                                          onChange: (value) {
                                            if (value < 0) {
                                              return;
                                            } else {
                                              audioPlayer.seek(Duration(
                                                  seconds: value.toInt()));
                                            }

                                            // callback providing a value while its being changed (with a pan gesture)
                                          },
                                          onChangeStart: (double startValue) {
                                            // callback providing a starting value (when a pan gesture starts)
                                          },
                                          onChangeEnd: (double endValue) {
                                            // ucallback providing an ending value (when a pan gesture ends)
                                          },
                                        ),
                                      );
                                    }),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              // crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            const MainPlayerView(),
                                      ),
                                    );
                                  },
                                  child: StreamBuilder<String>(
                                      stream: currentSongNameStreamController
                                          .stream,
                                      builder: (context, snapshot) {
                                        return Column(
                                          children: [
                                            SizedBox(
                                              width: media.width * 0.35,
                                              child: Text(
                                                currentSongName,
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    color: TColor.primaryText
                                                        .withOpacity(0.9),
                                                    fontSize: 16,
                                                    fontWeight:
                                                        FontWeight.w600),
                                              ),
                                            ),
                                            SizedBox(
                                              width: media.width * 0.30,
                                              // color: Colors.amber,
                                              child: Text(
                                                currentSongAlbumName,
                                                maxLines: 1,
                                                textAlign: TextAlign.center,
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
                              ],
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          SizedBox(
                            width: 40,
                            height: 40,
                            child: IconButton(
                              splashRadius: 20,

                              // iconSize: 10,
                              onPressed: () async {
                                await previousSong();
                              },
                              icon: Image.asset(
                                "assets/img/prev_small.png",
                                color: TColor.lightGray,
                              ),
                            ),
                          ),
                          StreamBuilder<PlayerState>(
                            stream: audioPlayer.playerStateStream,
                            builder: (context, snapshot) {
                              final playerState = snapshot.data;

                              final playing = playerState?.playing;
                              if (playing != true) {
                                return SizedBox(
                                  width: 45,
                                  height: 45,
                                  child: IconButton(
                                    splashRadius: 20,
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
                                  width: 45,
                                  height: 45,
                                  child: IconButton(
                                    splashRadius: 20,
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
                          SizedBox(
                            width: 40,
                            height: 40,
                            child: IconButton(
                              splashRadius: 20,
                              onPressed: () async {
                                await nextSong();
                              },
                              icon: Image.asset(
                                "assets/img/next_small.png",
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
