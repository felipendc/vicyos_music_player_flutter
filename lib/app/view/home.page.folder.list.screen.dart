import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:vicyos_music_player/app/common/color_extension.dart';
import 'package:vicyos_music_player/app/controller/home.controller.dart';
import 'package:vicyos_music_player/app/functions/folders.and.files.related.dart';
import 'package:vicyos_music_player/app/functions/screen.orientation.dart';
import 'package:vicyos_music_player/app/view/main.sync.screen.dart';
import 'package:vicyos_music_player/app/view/songs.list.screen.dart';
import 'package:vicyos_music_player/app/widgets/bottom.player.dart';

final HomeController controller = Get.find<HomeController>();
// final folderPaths = controller.musicFolderPaths
//     .map((index) => index as FolderSources)
//     .map((index) => index.path)
//     .toList()
//     .toList();

// final totalSongs = controller.musicFolderPaths
//     .map((index) => index as FolderSources)
//     .map((index) => index.songs)
//     .toList()
//     .toList();

class HomePageFolderList extends StatelessWidget {
  const HomePageFolderList({super.key});

  @override
  Widget build(BuildContext context) {
    // Set the preferred orientations to portrait mode when this screen is built
    screenOrientationPortrait();

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
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: TColor.org,
                      // color: TColor.lightGray,
                      fontSize: 20,
                    ),
                  ),
                ),
              )
            : null,
        body: controller.musicFolderPaths.isEmpty
            ? const MainSyncScreen()
            : Stack(
                children: [
                  Column(
                    children: [
                      Expanded(
                        child: ListView.separated(
                          padding: const EdgeInsets.only(bottom: 130),
                          itemCount: controller.musicFolderPaths.length,
                          itemBuilder: (context, index) {
                            return SizedBox(
                              // color: TColor.darkGray,
                              height: 70,
                              // margin: const EdgeInsets.all(10),
                              child: ListTile(
                                leading: Icon(
                                  Icons.folder,
                                  color: TColor.focus,
                                  size: 40,
                                ),

                                // Image.asset(
                                //   "assets/img/m_hidden_folder.png",
                                //   width: 35,
                                //   height: 35,
                                //   color: TColor.focus,
                                // ),
                                title: Text(
                                  folderName(
                                      controller.musicFolderPaths[index].path),
                                  textAlign: TextAlign.start,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    color: TColor.lightGray,
                                    fontSize: 20,
                                  ),
                                ),
                                subtitle: Text(
                                  '${controller.musicFolderPaths[index].songs} songs',
                                  style: const TextStyle(
                                      fontFamily: "Circular Std",
                                      fontSize: 15,
                                      color: Colors.white70),
                                ),
                                trailing: IconButton(
                                  splashRadius: 24,
                                  iconSize: 30,
                                  icon: Icon(
                                    Icons.playlist_add_rounded,
                                    color: TColor.focusSecondary,
                                  ),
                                  onPressed: () {},
                                ),

                                onTap: () {
                                  Get.to(() => SongsListScreen(
                                      folderPath: controller
                                          .musicFolderPaths[index].path));
                                  // Handle tile tap
                                  print(
                                      'Tapped on ${controller.musicFolderPaths[index].path}');
                                },
                              ),
                            );
                          },
                          separatorBuilder: (BuildContext context, int index) {
                            return Container();
                            // const Divider(
                            //   color: Colors.white12,
                            //   indent: 58,
                            //   endIndent: 10,
                            //   height: 1,
                            // );
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
        floatingActionButton: controller.musicFolderPaths.isNotEmpty
            ? Stack(
                children: [
                  Positioned(
                    bottom: 100,
                    right: 4,
                    child: SizedBox(
                      height: 55,
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
                  ),
                ],
              )
            : Container(),
      ),
    );
  }
}
