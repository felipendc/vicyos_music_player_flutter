import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';
import 'package:vicyos_music_player/app/common/color_extension.dart';
import 'package:vicyos_music_player/app/controller/home.controller.dart';
import 'package:vicyos_music_player/app/functions/music_player.dart';
import 'package:vicyos_music_player/app/functions/screen.orientation.dart';
import 'package:vicyos_music_player/app/view/bottom.sheet.playlist.dart';
import 'package:vicyos_music_player/app/view/bottom.sheet.speed.rate.dart';
import 'package:vicyos_music_player/app/widgets/appbars.dart';
import 'package:music_visualizer/music_visualizer.dart';

final HomeController controller = Get.find<HomeController>();

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
      appBar: mainPlayerViewAppBar(),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(
              height: 20,
            ),
            Stack(
              children: [
                Obx(
                  () => ClipRRect(
                    borderRadius: BorderRadius.circular(media.width * 0.7),
                    child: Image.asset(
                      controller.isFirstArtDemoCover.value
                          ? "assets/img/lofi-woman-album-cover-art_10.png"
                          : "assets/img/lofi-woman-album-cover-art.png",
                      width: media.width * 0.6,
                      height: media.width * 0.6,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                GestureDetector(
                  onTapCancel: () {
                    print(controller.isFirstArtDemoCover.value);
                    controller.isFirstArtDemoCover.value =
                        !controller.isFirstArtDemoCover.value;
                  },
                  child: SizedBox(
                    width: media.width * 0.6,
                    height: media.width * 0.6,
                    child: Obx(
                      () => SleekCircularSlider(
                        appearance: CircularSliderAppearance(
                            customWidths: CustomSliderWidths(
                                trackWidth: 4,
                                progressBarWidth: 6,
                                shadowWidth: 30),
                            customColors: CustomSliderColors(
                                dotColor: const Color(0xffFFB1B2),
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
                        max: controller.sleekCircularSliderDuration.value,
                        initialValue:
                            controller.sleekCircularSliderPosition.value,
                        onChange: (value) {
                          if (value < 0) {
                            return;
                          } else {
                            audioPlayer.seek(Duration(seconds: value.toInt()));
                          }

                          // callback providing a value while its being changed (with a pan gesture)
                        },
                        // onChangeStart: (double startValue) {
                        //   // callback providing a starting value (when a pan gesture starts)
                        // },
                        // onChangeEnd: (double endValue) {
                        //   // ucallback providing an ending value (when a pan gesture ends)
                        // },
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 15,
            ),
            Obx(
              () => Text(
                "${formatDuration(controller.currentSongDurationPostion.value)} | ${formatDuration(controller.currentSongTotalDuration.value)}",
                style: TextStyle(color: TColor.secondaryText, fontSize: 15),
              ),
            ),
            const SizedBox(
              height: 1,
            ),
            Obx(
              () => Text(
                "${controller.audioSources.isEmpty ? controller.currentIndex.value : controller.currentIndex.value == controller.audioSources.length ? controller.currentIndex.value : controller.currentIndex.value + 1} of ${controller.playlistLength.value}",
                style: TextStyle(color: TColor.secondaryText, fontSize: 15),
              ),
            ),
            const SizedBox(
              height: 28,
            ),
            Obx(
              () => Padding(
                padding: const EdgeInsets.fromLTRB(29, 0, 29, 0),
                child: Text(
                  controller.currentSongName.value,
                  maxLines: 1,
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                      color: TColor.primaryText.withOpacity(0.9),
                      fontSize: 19,
                      fontWeight: FontWeight.w600),
                ),
              ),

              // Text(
              //   controller.currentSongName.value.length > 29
              //       ? "${controller.currentSongName.value.substring(0, 28)}..."
              //       : controller.currentSongName.value,
              //   style: TextStyle(
              //       color: TColor.primaryText.withOpacity(0.9),
              //       fontSize: 19,
              //       fontWeight: FontWeight.w600),
              // ),
            ),
            const SizedBox(
              height: 10,
            ),
            Obx(
              () => Padding(
                padding: const EdgeInsets.fromLTRB(60, 0, 60, 0),
                child: Text(
                  controller.currentSongAlbumName.value,
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: TColor.secondaryText,
                    fontSize: 14,
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            SizedBox(
              height: 90,
              width: media.width * 0.6,
              child: MusicVisualizer(
                barCount: 30,
                colors: colors,
                duration: duration,
              ),
            ),

            // Image.asset(
            //   "assets/img/eq_display.png",
            //   height: 60,
            //   fit: BoxFit.fitHeight,
            // ),
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
                                Get.bottomSheet(
                                  const PlaylistBottomSheet(),
                                  // backgroundColor: TColor.bg,
                                  isScrollControlled: true,
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
                    // Padding(
                    //   padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
                    //   child: Column(
                    //     children: [
                    //       SizedBox(
                    //         width: 45,
                    //         height: 40,
                    //         child: IconButton(
                    //           onPressed: () {
                    //             Get.bottomSheet(
                    //               const ImportFilesBottomSheet(),
                    //               // backgroundColor: TColor.bg,
                    //               isScrollControlled: true,
                    //             );
                    //           },
                    //           icon: Image.asset(
                    //             "assets/img/add_song_icon.png",
                    //             width: 30,
                    //             height: 30,
                    //             color: TColor.primaryText80,
                    //           ),
                    //         ),
                    //       ),
                    //     ],
                    //   ),
                    // ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                      child: Column(
                        children: [
                          IconButton(
                            onPressed: () {
                              Get.bottomSheet(
                                const SpeedRateBottomSheet(),
                                // backgroundColor: TColor.bg,
                                isScrollControlled: true,
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
                            child: Obx(
                              () => IconButton(
                                onPressed: () {
                                  repeatMode();
                                },
                                icon: Image.asset(
                                  controller.currentLoopModeIcone.value,
                                  width: 30,
                                  height: 30,
                                  color: TColor.primaryText80,
                                ),
                              ),
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
                  child: SliderTheme(
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
                    child: Obx(
                      () => Slider(
                        min: 0.0,
                        max: 100.0,
                        value: controller.volumeSliderValue.value,
                        divisions: 20,
                        label: '${controller.volumeSliderValue.value.round()}',
                        onChanged: (value) {
                          controller.volumeSliderValue.value = value;
                          // setVolume(value);
                          setVolume(value);
                        },
                      ),
                    ),
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
                SizedBox(
                  width: 82,
                  height: 82,
                  child: Obx(
                    () => IconButton(
                      iconSize: 45,
                      onPressed: () {
                        playOrPause();
                      },
                      icon: controller.songIsPlaying.value
                          ? Image.asset(
                              "assets/img/round-pause-button_icon.png",
                              color: TColor.primaryText80,
                            )
                          : Image.asset(
                              "assets/img/play.png",
                            ),
                    ),
                  ),
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
