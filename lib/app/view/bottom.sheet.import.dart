import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vicyos_music_player/app/common/color_extension.dart';
import 'package:vicyos_music_player/app/reusable_functions/music_player.dart';

class ImportFilesBottomSheet extends StatelessWidget {
  const ImportFilesBottomSheet({super.key});

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
        height: 300, // Adjust the height as needed
        padding: const EdgeInsets.fromLTRB(16, 5, 16, 16),
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
              "IMPORT AUDIOS",
              style: TextStyle(
                fontWeight: FontWeight.w900,
                color: TColor.org,
                fontSize: 19,
              ),
            ),
            Text(
              "________",
              style: TextStyle(
                fontWeight: FontWeight.w900,
                color: TColor.org,
                fontSize: 19,
              ),
            ),
            const SizedBox(height: 20),
            // Content
            Expanded(
              child: Container(
                color: TColor.bg,
                width: media.width * 0.9,
                child: ListView(
                  padding: EdgeInsets.zero,
                  children: [
                    ListTile(
                      leading: Image.asset(
                        "assets/img/add_folder_icon.png",
                        width: 35,
                        height: 35,
                        color: TColor.focus,
                      ),
                      title: Text(
                        "Import folder",
                        style: TextStyle(
                          color: TColor.primaryText80,
                          fontSize: 19,
                        ),
                      ),
                      contentPadding: const EdgeInsets.fromLTRB(0, 4, 0, 4),
                      onTap: () async {
                        Get.back();
                        await pickFolder();
                      },
                    ),
                    const Divider(
                      color: Colors.white12,
                      indent: 58,
                      endIndent: 10,
                      height: 1,
                    ),
                    ListTile(
                      leading: Image.asset(
                        "assets/img/audio_file.png",
                        width: 43,
                        height: 43,
                        color: TColor.focus,
                      ),
                      title: Text(
                        "Add songs",
                        style: TextStyle(
                          color: TColor.primaryText80,
                          fontSize: 19,
                        ),
                      ),
                      contentPadding: const EdgeInsets.fromLTRB(0, 4, 0, 4),
                      onTap: () async {
                        Get.back();
                        await pickAndPlayAudio();
                      },
                    ),
                    const Divider(
                      color: Colors.white12,
                      indent: 58,
                      endIndent: 10,
                      height: 1,
                    ),
                    // Add more list tiles or widgets as needed
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}