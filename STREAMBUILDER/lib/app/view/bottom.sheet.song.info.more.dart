import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:vicyos_music/app/common/color_extension.dart';
import 'package:vicyos_music/app/functions/folders.and.files.related.dart';
import 'package:vicyos_music/app/functions/music_player.dart';
import 'package:vicyos_music/app/view/song.preview.dialog.dart';

import 'delete.song.confirmation.dialog.dart';

class SongInfoMoreBottomSheet extends StatefulWidget {
  final dynamic fullFilePath;
  const SongInfoMoreBottomSheet({super.key, required this.fullFilePath});

  @override
  State<SongInfoMoreBottomSheet> createState() =>
      _SongInfoMoreBottomSheetState();
}

class _SongInfoMoreBottomSheetState extends State<SongInfoMoreBottomSheet> {
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.vertical(
        top: Radius.circular(25),
        bottom: Radius.circular(0),
      ),
      child: Container(
        color: TColor.bg,
        height: 290, // Adjust the height as needed
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
                songName(widget.fullFilePath).toUpperCase(),
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
                            AssetImage("assets/img/sound_sampler.png"),
                            color: TColor.focus,
                            size: 32,
                          ),
                        ),
                        title: Text(
                          "Song Preview",
                          style: TextStyle(
                            color: TColor.primaryText80,
                            fontSize: 18,
                          ),
                        ),
                        contentPadding: const EdgeInsets.fromLTRB(0, 4, 0, 4),
                        onTap: () async {
                          isSongPreviewBottomSheetOpen = true;
                          hideButtonSheetStreamListener(true);
                          Navigator.pop(context);

                          showModalBottomSheet<String>(
                              backgroundColor: Colors.transparent,
                              context: context,
                              builder: (BuildContext context) {
                                return SongPreviewDialog(
                                    songPath: widget.fullFilePath);
                              }).whenComplete(() {
                            if (isSongPreviewBottomSheetOpen) {
                              hideButtonSheetStreamListener(true);
                            } else {
                              hideButtonSheetStreamListener(false);
                            }

                            Navigator.pop(context);
                          });

                          // if (result == "close_song_preview_bottom_sheet") {
                          //   Navigator.pop(
                          //       context, "close_song_preview_bottom_sheet");
                          // } else {
                          //   Navigator.pop(context);
                          // }
                          // Navigator.pop(
                          //     context, "close_song_preview_bottom_sheet");
                          // setState(() {});
                          // "When the bottom sheet is closed, send a signal to show the mini player again."
                          // hideButtonSheetStreamListener(false);
                        },
                      ),
                    ),
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

                          if (widget.fullFilePath is String) {
                            await Share.shareXFiles(
                                [XFile(widget.fullFilePath)],
                                text:
                                    'This file was shared using the Vicyos Music app.');
                          } else if (widget.fullFilePath is List) {
                            //  TODO: FUTURE FEATURE, SHARE MULTIPLE FILES...
                            List<XFile> files = widget.fullFilePath
                                .map((path) => XFile(path))
                                .toList();
                            await Share.shareXFiles(files,
                                text:
                                    "These ${widget.fullFilePath.length} audio files 🎵, were shared using the Vicyos Music app.");
                          }

                          hideButtonSheetStreamListener(false);
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
                        onTap: () async {
                          final result = await showModalBottomSheet<String>(
                            backgroundColor: Colors.transparent,
                            context: context,
                            builder: (BuildContext context) {
                              return DeleteSongConfirmationDialog(
                                  songPath: widget.fullFilePath);
                            },
                          );

                          if (result == "close_song_preview_bottom_sheet") {
                            Navigator.pop(
                                context, "close_song_preview_bottom_sheet");
                          } else if (result == "canceled") {
                            hideButtonSheetStreamListener(false);
                            Navigator.pop(context);
                          }
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
