// ignore_for_file: avoid_print

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:vicyos_music_player/app/common/color_extension.dart';
import 'package:vicyos_music_player/app/controller/home.controller.dart';
import 'package:vicyos_music_player/app/reusable_functions/get.folders.with.audio.files.dart';
import 'package:vicyos_music_player/app/widgets/bottom.player.dart';

final HomeController controller = Get.find<HomeController>();

class SongsListScreen extends StatelessWidget {
  final String folderPath;
  const SongsListScreen({super.key, required this.folderPath});

  @override
  Widget build(BuildContext context) {
    controller.folderSongList.clear();
    final Set<String> audioExtensions = {
      '.mp3',
      '.m4a',
      '.ogg',
      '.wav',
      '.aac',
      '.midi'
    };
    Directory? folderDirectory = Directory(folderPath);

    final directorySongList = folderDirectory.listSync();

    final List<String> audioFiles = directorySongList
        .where((entity) {
          if (entity is File) {
            String extension = entity.path
                .substring(entity.path.lastIndexOf('.'))
                .toLowerCase();
            return audioExtensions.contains(extension);
          }
          return false;
        })
        .map((entity) => entity.path)
        .toList();

    for (var songPath in audioFiles) {
      controller.folderSongList.add(songPath);
    }

    // Set the preferred orientations to portrait mode when this screen is built
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return Scaffold(
      appBar: AppBar(
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(5))),
        toolbarHeight: 60,
        // automaticallyImplyLeading: false

        elevation: 0,
        centerTitle: true,
        backgroundColor: TColor.bg, // TColor.darkGray,
        title: Text(
          folderName(folderPath),
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: TColor.org,
            fontSize: 22,
          ),
        ),
      ),
      body: Stack(
        children: [
          Column(
            children: [
              Expanded(
                child: ListView.separated(
                  padding: const EdgeInsets.only(bottom: 130),
                  itemCount: controller.folderSongList.length,
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
                          songName(controller.folderSongList[index]),
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            color: TColor.lightGray,
                            fontSize: 18,
                          ),
                        ),
                        onTap: () {
                          controller.setFolderAsPlaylist(
                              controller.folderSongList, index);
                          print(
                              'Tapped on ${controller.folderSongList[index]}');
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
          const Positioned(
            bottom: 6,
            right: 11,
            child: BottomPlayer(),
          ),
        ],
      ),
    );
  }
}
