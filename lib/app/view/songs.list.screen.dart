import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vicyos_music_player/app/common/color_extension.dart';
import 'package:vicyos_music_player/app/controller/home.controller.dart';
import 'package:vicyos_music_player/app/functions/folders.and.files.related.dart';
import 'package:vicyos_music_player/app/functions/screen.orientation.dart';
import 'package:vicyos_music_player/app/widgets/appbars.dart';
import 'package:vicyos_music_player/app/widgets/bottom.player.dart';
import 'package:vicyos_music_player/app/widgets/snackbar.dart';

final HomeController controller = Get.find<HomeController>();

class SongsListScreen extends StatelessWidget {
  final String folderPath;
  const SongsListScreen({super.key, required this.folderPath});

  @override
  Widget build(BuildContext context) {
    // Filter all songs from folderPath and add them to controller.folderSongList
    filterSongsOnlyToList(folderPath: folderPath);

    // Set the preferred orientations to portrait mode when this screen is built
    screenOrientationPortrait();

    return Scaffold(
      appBar: songsListAppBar(folderPath: folderPath),
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
                      height: 67,
                      // margin: const EdgeInsets.all(10),
                      child: ListTile(
                        leading: Icon(
                          Icons.music_note_rounded,
                          color: TColor.focus,
                          size: 40,
                        ),
                        // Image.asset(
                        //   "assets/img/songs_tab.png",
                        //   width: 35,
                        //   height: 35,
                        //   color: TColor.focus,
                        // ),
                        title: Text(
                          controller.folderSongList[index].name,
                          textAlign: TextAlign.start,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            color: TColor.lightGray,
                            fontSize: 18,
                          ),
                        ),
                        subtitle: Text(
                          "${controller.folderSongList[index].size!} MB  |  ${controller.folderSongList[index].format!}",
                          textAlign: TextAlign.start,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: TColor.secondaryText,
                            fontSize: 15,
                          ),
                        ),
                        trailing: IconButton(
                          splashRadius: 24,
                          iconSize: 30,
                          icon: Icon(
                            Icons.playlist_add_rounded,
                            color: TColor.focusSecondary,
                          ),
                          onPressed: () {
                            controller.addSongToPlaylist(
                                controller.folderSongList[index].path);

                            addPlaylistSnackbar(
                              title: controller.folderSongList[index].name,
                              message:
                                  'This song has been added to the playlist',
                            );
                          },
                        ),

                        onTap: () {
                          controller.setFolderAsPlaylist(
                              controller.folderSongList, index);
                          print(
                              'Tapped on ${controller.folderSongList[index].path}');
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
    );
  }
}
