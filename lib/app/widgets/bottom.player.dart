import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vicyos_music_player/app/common/color_extension.dart';
import 'package:vicyos_music_player/app/controller/home.controller.dart';
import 'package:vicyos_music_player/app/reusable_functions/music_player.dart';
import 'package:vicyos_music_player/app/view/main.player.view.screen.dart';

final HomeController controller = Get.find<HomeController>();

class BottomPlayer extends StatelessWidget {
  const BottomPlayer({super.key});

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.sizeOf(context);

    return Obx(
      () => Stack(
        children: [
          Column(
            children: [
              Container(
                // width: media.width * 0.94,
                // margin: const EdgeInsets.only(top: 10, bottom: 10),
                height: 65,
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  boxShadow: [
                    BoxShadow(
                      color:
                          const Color.fromARGB(255, 0, 0, 0).withOpacity(0.2),
                      spreadRadius: 8,
                      blurRadius: 4,
                      offset: const Offset(0, 3), // changes position of shadow
                    ),
                  ],

                  // borderRadius: BorderRadius.circular(20),
                ),
                child: Padding(
                  padding: EdgeInsets.fromLTRB(media.width * 0.19, 0, 10, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            GestureDetector(
                              onTap: () {
                                Get.to(() => const MainPlayerView());
                              },
                              child: Text(
                                controller.currentSongName.value.length > 13
                                    ? "${controller.currentSongName.value.substring(0, 13)}..."
                                    : controller.currentSongName.value,
                                style: TextStyle(
                                    color: TColor.primaryText.withOpacity(0.9),
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600),
                              ),
                            ),
                            Text(
                              controller.currentSongAlbumName.value.length > 14
                                  ? "${controller.currentSongAlbumName.value.substring(0, 14)}}..."
                                  : controller.currentSongAlbumName.value,
                              style: TextStyle(
                                color: TColor.secondaryText,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
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
                          SizedBox(
                            width: 50,
                            height: 50,
                            child: IconButton(
                              // iconSize: 10,
                              splashRadius: 26,
                              onPressed: () {
                                playOrPause();
                              },
                              icon: controller.songIsPlaying.value
                                  ? Image.asset(
                                      "assets/img/round-pause-button_icon.png",
                                      color: TColor.lightGray,
                                    )
                                  : Image.asset(
                                      "assets/img/play.png",
                                    ),
                            ),
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
            ],
          ),
        ],
      ),
    );
  }
}
