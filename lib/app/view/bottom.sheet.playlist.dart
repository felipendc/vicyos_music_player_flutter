import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';

import 'package:vicyos_music_player/app/common/color_extension.dart';
import 'package:vicyos_music_player/app/controller/home.controller.dart';
import 'package:vicyos_music_player/app/reusable_functions/get.folders.with.audio.files.dart';

final HomeController controller = Get.find<HomeController>();
final List<String> playlistCurrentPosition = controller.playlist.children
    .map((audioSource) =>
        Uri.decodeFull((audioSource as UriAudioSource).uri.toString()))
    .toList();

class PlaylistBottomSheet extends StatelessWidget {
  const PlaylistBottomSheet({super.key});

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
            // Text(
            //   "________",
            //   style: TextStyle(
            //     fontWeight: FontWeight.w900,
            //     color: TColor.org,
            //     fontSize: 19,
            //   ),
            // ),
            const SizedBox(height: 20),
            // Content
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.only(bottom: 0 /*130*/),
                itemCount: controller.playlist.children.length,
                itemBuilder: (context, index) {
                  return SizedBox(
                    // color: TColor.darkGray,
                    height: 70,
                    // margin: const EdgeInsets.all(10),
                    child: ListTile(
                      leading: Image.asset(
                        "assets/img/songs_tab.png",
                        width: 35,
                        height: 35,
                        color: TColor.focus,
                      ),
                      title: Text(
                        textAlign: TextAlign.start,
                        songName(playlistCurrentPosition[index]),
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          color: TColor.lightGray,
                          fontSize: 18,
                        ),
                      ),
                      onTap: () {
                        print(
                            'Tapped on ${controller.audioSources.elementAt(index).toString()}');
                      },
                    ),
                  );
                },
                separatorBuilder: (BuildContext context, int index) {
                  return const Divider(
                    color: Colors.white12,
                    indent: 58,
                    endIndent: 10,
                    height: 1,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
