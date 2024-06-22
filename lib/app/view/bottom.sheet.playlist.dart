import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:vicyos_music_player/app/common/color_extension.dart';
import 'package:vicyos_music_player/app/controller/home.controller.dart';
import 'package:vicyos_music_player/app/reusable_functions/get.folders.with.audio.files.dart';
import 'package:vicyos_music_player/app/reusable_functions/music_player.dart';

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
                      child: ListTile(
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
                        ),
                        trailing: const Icon(Icons.drag_handle),
                        onTap: () {
                          audioPlayer.setAudioSource(controller.playlist,
                              initialIndex: index, preload: false);

                          audioPlayer.play();
                          controller.songIsPlaying.value = true;
                        },
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
