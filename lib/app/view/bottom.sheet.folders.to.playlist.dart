import 'package:flutter/material.dart';
import 'package:vicyos_music/app/common/color_extension.dart';
import 'package:vicyos_music/app/functions/folders.and.files.related.dart';
import 'package:vicyos_music/app/functions/music_player.dart';
import 'package:vicyos_music/app/view/main.player.view.screen.dart';

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
              folderName(folderPath),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
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
                // width: media.width * 0.9,
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

                        // Image.asset(
                        //   "assets/img/audio_file.png",
                        //   width: 43,
                        //   height: 43,
                        //   color: TColor.focus,
                        // ),
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

                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const MainPlayerView(),
                            ),
                          );
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
