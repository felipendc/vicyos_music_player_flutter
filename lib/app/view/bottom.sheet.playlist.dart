import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:vicyos_music_player/app/common/color_extension.dart';
import 'package:vicyos_music_player/app/controller/home.controller.dart';
import 'package:vicyos_music_player/app/functions/get.folders.with.audio.files.dart';
import 'package:vicyos_music_player/app/functions/music_player.dart';

final HomeController controller = Get.find<HomeController>();

class PlaylistBottomSheet extends StatelessWidget {
  const PlaylistBottomSheet({super.key});

  Future<void> _onReorder(int oldIndex, int newIndex) async {
    if (newIndex > oldIndex) {
      newIndex -= 1;
    }
    controller.playlist.move(oldIndex, newIndex);
    audioPlayer.currentIndexStream.listen((index) {
      controller.currentIndex.value = audioPlayer.sequence![index!] as int;
    });
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
        height: media.height * 0.5, // Adjust the height as needed
        padding: const EdgeInsets.fromLTRB(0, 5, 0, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Top button indicator
            Container(
              width: 100,
              margin: const EdgeInsets.only(top: 10, bottom: 10),
              height: 5,
              decoration: BoxDecoration(
                color: TColor.secondaryText,
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            const SizedBox(height: 10),
            Text(
              "PLAYLIST",
              style: TextStyle(
                fontWeight: FontWeight.w900,
                color: TColor.org,
                fontSize: 19,
              ),
            ),

            const SizedBox(height: 20),
            // Content
            Expanded(
              child: Obx(
                () => ReorderableListView.builder(
                  itemCount: controller.playlist.children.length,
                  onReorder: _onReorder,
                  itemBuilder: (BuildContext context, int index) {
                    return Container(
                      padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                      color: TColor.bg,
                      key: ValueKey(
                        controller.playlist.children[index].sequence
                            .map((audioSource) => [audioSource].map(
                                  (audioSource) => Uri.decodeFull(
                                    (audioSource as UriAudioSource)
                                        .uri
                                        .toString(),
                                  ),
                                ))
                            .toString(),
                      ),
                      child: Column(
                        children: [
                          Material(
                            color: Colors.transparent,
                            child: Obx(
                              () => ListTile(
                                key: Key(
                                  controller.playlist.children[index].sequence
                                      .map((audioSource) => [audioSource].map(
                                            (audioSource) => Uri.decodeFull(
                                              (audioSource as UriAudioSource)
                                                  .uri
                                                  .toString(),
                                            ),
                                          ))
                                      .toString(),
                                ),
                                leading: controller.currentIndex.value == index
                                    ? Image.asset(
                                        "assets/img/m_eq.png",
                                        // color: TColor.focusSecondary,
                                        width: media.width * 0.058,
                                        height: media.width * 0.058,
                                        color: TColor.focusSecondary,
                                      )
                                    : Image.asset(
                                        "assets/img/play_btn.png",
                                        // color: TColor.focusSecondary,
                                        width: media.width * 0.065,
                                        height: media.width * 0.065,
                                        color: TColor.focusSecondary,
                                      ),
                                title: Text(
                                  songName(
                                    controller.playlist.children[index].sequence
                                        .map((audioSource) => [audioSource].map(
                                              (audioSource) => Uri.decodeFull(
                                                (audioSource as UriAudioSource)
                                                    .uri
                                                    .toString(),
                                              ),
                                            ))
                                        .toString(),
                                  ),
                                  style: TextStyle(
                                    color: TColor.primaryText,
                                    fontFamily: "Circular Std",
                                    fontSize: 17,
                                  ),
                                ),
                                subtitle: Text(
                                  'Index: ${index + 1}  ',
                                  style: const TextStyle(
                                      fontFamily: "Circular Std",
                                      fontSize: 15,
                                      color: Colors.white70),
                                ),
                                trailing: IconButton(
                                  splashRadius: 26,
                                  iconSize: 26,
                                  icon:
                                      const Icon(Icons.delete_forever_rounded),
                                  color: TColor.focusSecondary,
                                  onPressed: () {
                                    controller.playlist.removeAt(index);
                                    controller.playlistLength.value =
                                        controller.audioSources.length;
                                    if (controller.currentIndex.value ==
                                        index) {
                                      preLoadSongName();
                                    }
                                  },
                                ),
                                onTap: () async {
                                  if (controller.currentIndex.value == index) {
                                    if (controller.songIsPlaying.value) {
                                      audioPlayer.pause();
                                      controller.songIsPlaying.value = false;
                                    } else {
                                      audioPlayer.play();
                                      controller.songIsPlaying.value = true;
                                    }
                                  } else {
                                    audioPlayer.setAudioSource(
                                        controller.playlist,
                                        initialIndex: index,
                                        preload: false);

                                    audioPlayer.play();
                                    controller.songIsPlaying.value = true;
                                  }
                                },
                              ),
                            ),
                          ),
                          // const Divider(
                          //   color: Colors.white12,
                          //   indent: 87,
                          //   endIndent: 10,
                          //   height: 1,
                          // ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
