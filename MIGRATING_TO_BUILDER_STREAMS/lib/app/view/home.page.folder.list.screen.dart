import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vicyos_music_player/app/common/color_extension.dart';
import 'package:vicyos_music_player/app/controller/home.controller.dart';
import 'package:vicyos_music_player/app/functions/folders.and.files.related.dart';
import 'package:vicyos_music_player/app/functions/screen.orientation.dart';
import 'package:vicyos_music_player/app/view/bottom.sheet.folders.to.playlist.dart';
// import 'package:vicyos_music_player/app/view/main.sync.screen.dart';
import 'package:vicyos_music_player/app/view/songs.list.screen.dart';
import 'package:vicyos_music_player/app/widgets/appbars.dart';
import 'package:vicyos_music_player/app/widgets/bottom.player.dart';

final HomeController controller = Get.find<HomeController>();

class HomePageFolderList extends StatefulWidget {
  const HomePageFolderList({super.key});

  @override
  State<HomePageFolderList> createState() => _HomePageFolderListState();
}

class _HomePageFolderListState extends State<HomePageFolderList> {
  @override
  void initState() {
    super.initState();
    listMusicFolders();
  }

  @override
  Widget build(BuildContext context) {
    // Set the preferred orientations to portrait mode when this screen is built
    screenOrientationPortrait();

    return Obx(
      () => Scaffold(
        appBar: homePageAppBar(),
        body:
            //  controller.musicFolderPaths.isEmpty
            //     ? const MainSyncScreen()
            //     :
            Stack(
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
                            folderName(controller.musicFolderPaths[index].path),
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
                            controller.musicFolderPaths[index].songs > 1
                                ? '${controller.musicFolderPaths[index].songs.toString()} songs'
                                : '${controller.musicFolderPaths[index].songs.toString()} song',
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
                            onPressed: () {
                              Get.bottomSheet(
                                FolderToPlaylistBottomSheet(
                                    folderPath: controller
                                        .musicFolderPaths[index].path),
                                // backgroundColor: TColor.bg,
                                isScrollControlled: true,
                              );
                            },
                          ),

                          onTap: () {
                            Get.to(() => SongsListScreen(
                                folderPath:
                                    controller.musicFolderPaths[index].path));
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
