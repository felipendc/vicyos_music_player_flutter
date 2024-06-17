// ignore_for_file: avoid_print, unused_element

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vicyos_music_player/app/common/color_extension.dart';
import 'package:vicyos_music_player/app/controller/home.controller.dart';
import 'package:vicyos_music_player/app/reusable_functions/get.folders.with.audio.files.dart';
import 'package:vicyos_music_player/app/view/main.player.view.screen.dart';
import 'package:vicyos_music_player/app/view/songs.list.screen.dart';

final HomeController controller = Get.find<HomeController>();

class HomePageFolderList extends StatefulWidget {
  const HomePageFolderList({super.key});

  @override
  State<HomePageFolderList> createState() => _HomePageFolderListState();
}

class _HomePageFolderListState extends State<HomePageFolderList> {
  @override
  Widget build(BuildContext context) {
    Future<void> listMusicFolders() async {
      final audioFolders =
          await getFoldersWithAudioFiles('/storage/emulated/0/Music/');
      for (var folder in audioFolders) {
        controller.musicFolderPaths.add(folder);
      }
      print(audioFolders);
    }

    @override
    void initState() async {
      super.initState();
      await listMusicFolders();
    }

    return Obx(
      () => Scaffold(
        appBar: controller.musicFolderPaths.isNotEmpty
            ? AppBar(
                shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(5))),
                toolbarHeight: 60,

                elevation: 0,
                backgroundColor: TColor.bg, // TColor.darkGray,
                title: Center(
                  child: Text(
                    ' MUSIC FOLDERS ',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: TColor.org,
                      // color: TColor.lightGray,
                      fontSize: 20,
                    ),
                  ),
                ),
              )
            : AppBar(
                backgroundColor: TColor.bg,
                elevation: 0,
              ),
        body: controller.musicFolderPaths.isEmpty
            ? Center(
                child: FloatingActionButton.extended(
                  label: const Text('Sync Music Folder'),
                  icon: const Icon(Icons.add),
                  onPressed: () {
                    listMusicFolders();
                    print(controller.musicFolderPaths);
                  },
                  backgroundColor: TColor.darkGray,
                ),
              )
            : ListView.separated(
                itemCount: controller.musicFolderPaths.length,
                itemBuilder: (context, index) {
                  return SizedBox(
                    // color: TColor.darkGray,
                    height: 70,
                    // margin: const EdgeInsets.all(10),
                    child: ListTile(
                      leading: Image.asset(
                        "assets/img/m_hidden_folder.png",
                        width: 35,
                        height: 35,
                        color: TColor.focus,
                      ),
                      title: Text(
                        textAlign: TextAlign.start,
                        folderName(controller.musicFolderPaths[index]),
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          color: TColor.lightGray,
                          fontSize: 20,
                        ),
                      ),
                      onTap: () {
                        Get.to(() => SongsListScreen(
                            folderPath: controller.musicFolderPaths[index]));
                        // Handle tile tap
                        print(
                            'Tapped on ${controller.musicFolderPaths[index]}');
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
        floatingActionButton: controller.musicFolderPaths.isNotEmpty
            ? Stack(
                children: [
                  Positioned(
                    bottom: 95,
                    right: 10,
                    child: FloatingActionButton(
                      backgroundColor: TColor.darkGray,
                      heroTag: "fab1",
                      onPressed: () {
                        Get.to(() => const MainPlayerView());
                      },
                      child: Image.asset(
                        "assets/img/m_eq.png",
                        width: 25,
                        height: 25,
                        color: TColor.focusStart,
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 20,
                    right: 10,
                    child: FloatingActionButton(
                      backgroundColor: TColor.darkGray,
                      heroTag: "fab2",
                      onPressed: () {
                        controller.musicFolderPaths.clear();
                        listMusicFolders();
                      },
                      child: Icon(
                        Icons.sync_rounded,
                        color: TColor.focusStart,
                      ),
                    ),
                  ),
                ],
              )
            : Container(),
      ),
    );
  }
}
