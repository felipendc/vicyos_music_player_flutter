import 'package:flutter/material.dart';
import 'package:vicyos_music/app/common/color_extension.dart';
import 'package:vicyos_music/app/functions/folders.and.files.related.dart';

import 'delete.song.confirmation.dialog.dart';

class PlayersAppBarActionsBottomSheet extends StatelessWidget {
  final String fullFilePath;
  const PlayersAppBarActionsBottomSheet(
      {super.key, required this.fullFilePath});

  @override
  Widget build(BuildContext context) {
    print("GTGTGTGT ${fullFilePath}");
    return ClipRRect(
      borderRadius: const BorderRadius.vertical(
        top: Radius.circular(25),
        bottom: Radius.circular(0),
      ),
      child: Container(
        color: TColor.bg,
        height: 230, // Adjust the height as needed
        padding: const EdgeInsets.fromLTRB(0, 5, 0, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Top button indicator
            // Container(
            //   width: 100,
            //   margin: const EdgeInsets.only(top: 10, bottom: 10),
            //   height: 5,
            //   decoration: BoxDecoration(
            //     color: TColor.secondaryText,
            //     borderRadius: BorderRadius.circular(20),
            //   ),
            // ),
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
                        onTap: () {
                          print("SHAREEE ${fullFilePath}");
                        },
                      ),
                    ),
                    // const Divider(
                    //   color: Colors.white12,
                    //   indent: 70,
                    //   endIndent: 25,
                    //   height: 1,
                    // ),
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
                        onTap: () {
                          showModalBottomSheet<void>(
                            backgroundColor: Colors.transparent,
                            context: context,
                            builder: (BuildContext context) {
                              return DeleteSongConfirmationDialog(
                                  songPath: fullFilePath);
                            },
                          ).whenComplete(() {
                            // "When the bottom sheet is closed"
                            //TODO
                            Navigator.pop(context);
                          });
                        },
                      ),
                    ),
                    // const Divider(
                    //   color: Colors.white12,
                    //   indent: 70,
                    //   endIndent: 25,
                    //   height: 1,
                    // ),
                    // TODO copy and paste tiles
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
