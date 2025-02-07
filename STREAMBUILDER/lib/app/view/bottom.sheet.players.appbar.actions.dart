import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:vicyos_music/app/common/color_extension.dart';
import 'package:vicyos_music/app/functions/folders.and.files.related.dart';

import 'delete.song.confirmation.dialog.dart';

class PlayersAppBarActionsBottomSheet extends StatelessWidget {
  final dynamic fullFilePath;
  const PlayersAppBarActionsBottomSheet(
      {super.key, required this.fullFilePath});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.vertical(
        top: Radius.circular(25),
        bottom: Radius.circular(0),
      ),
      child: Container(
        color: TColor.bg,
        height: 230, // Adjust the height
        padding: const EdgeInsets.fromLTRB(0, 5, 0, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.only(left: 21, right: 21),
              child: Text(
                songName(fullFilePath).toUpperCase(),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontWeight: FontWeight.w900,
                  color: TColor.org,
                  fontSize: 23,
                ),
              ),
            ),
            const SizedBox(height: 20),
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
                          child: ImageIcon(
                            AssetImage("assets/img/share.png"),
                            color: TColor.focus,
                            size: 32,
                          ),
                        ),
                        title: Text(
                          "Share",
                          style: TextStyle(
                            color: TColor.primaryText80,
                            fontSize: 18,
                          ),
                        ),
                        contentPadding: const EdgeInsets.fromLTRB(0, 4, 0, 4),
                        onTap: () async {
                          Navigator.pop(context);

                          if (fullFilePath is String) {
                            await Share.shareXFiles([XFile(fullFilePath)],
                                text:
                                    'This file was shared using the Vicyos Music app.');
                          } else if (fullFilePath is List) {
                            //  TODO: FUTURE FEATURE, SHARE MULTIPLE FILES...
                            List<XFile> files = fullFilePath
                                .map((path) => XFile(path))
                                .toList();
                            await Share.shareXFiles(files,
                                text:
                                    "These ${fullFilePath.length} audio files 🎵, were shared using the Vicyos Music app.");
                          }
                        },
                      ),
                    ),
                    Material(
                      color: Colors.transparent,
                      child: ListTile(
                        leading: Padding(
                          padding: const EdgeInsets.only(left: 17),
                          child: ImageIcon(
                            AssetImage("assets/img/delete_outlined.png"),
                            color: TColor.focus,
                            size: 32,
                          ),
                        ),
                        title: Text(
                          "Delete from device",
                          style: TextStyle(
                            color: TColor.primaryText80,
                            fontSize: 18,
                          ),
                        ),
                        contentPadding: const EdgeInsets.fromLTRB(0, 4, 0, 4),
                        onTap: () async {
                          final result = await showModalBottomSheet<String>(
                            backgroundColor: Colors.transparent,
                            context: context,
                            builder: (BuildContext context) {
                              return DeleteSongConfirmationDialog(
                                  songPath: fullFilePath);
                            },
                          );

                          if (result == "close_song_preview_bottom_sheet") {
                            Navigator.pop(
                                context, "close_song_preview_bottom_sheet");
                          } else {
                            Navigator.pop(context);
                          }
                        },
                      ),
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
