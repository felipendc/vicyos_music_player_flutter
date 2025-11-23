import 'package:flutter/material.dart';
import 'package:vicyos_music/app/common/color_palette/color_extension.dart';
import 'package:vicyos_music/app/common/files_and_folders_handler/folders.and.files.related.dart';
import 'package:vicyos_music/app/common/music_player/music.player.functions.and.more.dart';
import 'package:vicyos_music/app/common/widgets/show.top.message.dart';

class FolderToPlaylistBottomSheet extends StatelessWidget {
  final String folderPath;
  const FolderToPlaylistBottomSheet({super.key, required this.folderPath});

  @override
  Widget build(BuildContext context) {
    // Filter all songs from folderPath and add them to controller.folderSongList
    filterSongsOnlyToList(folderPath: folderPath);

    return ClipRRect(
      borderRadius: const BorderRadius.vertical(
        top: Radius.circular(25),
        bottom: Radius.circular(0),
      ),
      child: Container(
        color: TColor.bg,
        height: 300, // Adjust the height as needed
        padding: const EdgeInsets.fromLTRB(0, 5, 0, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 10.0),
              child: Container(
                decoration: BoxDecoration(
                  // color: Colors.grey,
                  color: Color(0xff181B2C),
                ),
                height: 73, // Loading enabled
                child: Column(
                  // mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 0, 8, 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Folder Name:",
                                style: TextStyle(
                                  color: TColor.primaryText28
                                      .withValues(alpha: 0.84),
                                  fontSize: 15,
                                  fontWeight: FontWeight.w400,
                                  shadows: [
                                    Shadow(
                                      color:
                                          Colors.black.withValues(alpha: 0.2),
                                      offset: Offset(1, 1),
                                      blurRadius: 3,
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 30,
                                width: 270,
                                // color: Colors.grey,
                                child: Text(
                                  folderName(folderPath),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    color: TColor.primaryText
                                        .withValues(alpha: 0.84),
                                    fontSize: 20,
                                    fontWeight: FontWeight.w600,
                                    shadows: [
                                      BoxShadow(
                                        color:
                                            Colors.black.withValues(alpha: 0.2),
                                        spreadRadius: 5,
                                        blurRadius: 8,
                                        offset: Offset(2, 4),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children: [
                                Material(
                                  color: Colors.transparent,
                                  child: SizedBox(
                                    width: 35,
                                    height: 35,
                                    child: IconButton(
                                      splashRadius: 20,
                                      iconSize: 10,
                                      onPressed: () async {
                                        Navigator.pop(context);
                                      },
                                      icon: Image.asset(
                                        "assets/img/close.png",
                                        color: TColor.lightGray,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // // Top button indicator
            // Container(
            //   width: 100,
            //   margin: const EdgeInsets.only(top: 10, bottom: 10),
            //   height: 5,
            //   decoration: BoxDecoration(
            //     color: TColor.secondaryText,
            //     borderRadius: BorderRadius.circular(20),
            //   ),
            // ),

            // ------------------------
            // Text(
            //   folderName(folderPath),
            //   maxLines: 1,
            //   overflow: TextOverflow.ellipsis,
            //   style: TextStyle(
            //     fontWeight: FontWeight.w900,
            //     color: TColor.org,
            //     fontSize: 19,
            //   ),
            // ),
            // --------------------------------

            // Content
            Expanded(
              child: Container(
                color: TColor.bg,
                child: ListView(
                  children: [
                    Material(
                      color: Colors.transparent,
                      child: ListTile(
                        leading: Padding(
                          padding: const EdgeInsets.only(left: 17),
                          child: Icon(
                            Icons.create_new_folder_outlined,
                            color: TColor.focus,
                            size: 38,
                          ),
                        ),
                        title: Text(
                          "Add folder to the current playlist",
                          style: TextStyle(
                            color: TColor.primaryText80,
                            fontSize: 18,
                          ),
                        ),
                        contentPadding: const EdgeInsets.fromLTRB(0, 4, 0, 4),
                        onTap: () async {
                          Navigator.pop(context);
                          addFolderToPlaylist(folderSongList);
                          showAddedToPlaylist(
                              context,
                              "Folder",
                              folderName(folderPath),
                              "Added to the current playlist");
                        },
                      ),
                    ),
                    const Divider(
                      color: Colors.white12,
                      indent: 70,
                      endIndent: 25,
                      height: 1,
                    ),
                    Material(
                      color: Colors.transparent,
                      child: ListTile(
                        leading: Padding(
                          padding: const EdgeInsets.only(left: 17),
                          child: Icon(
                            Icons.queue_music_rounded,
                            color: TColor.focus,
                            size: 40,
                          ),
                        ),
                        title: Text(
                          "Play all the songs from this folder",
                          style: TextStyle(
                            color: TColor.primaryText80,
                            fontSize: 18,
                          ),
                        ),
                        contentPadding: const EdgeInsets.fromLTRB(0, 4, 0, 4),
                        onTap: () async {
                          Navigator.pop(context);
                          setFolderAsPlaylist(folderSongList, 0);
                          showAddedToPlaylist(
                              context,
                              "Folder",
                              folderName(folderPath),
                              "Playing all the songs from this folder");
                        },
                      ),
                    ),
                    const Divider(
                      color: Colors.white12,
                      indent: 70,
                      endIndent: 25,
                      height: 1,
                    ),
                    const SizedBox(
                      height: 30,
                    ),
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
