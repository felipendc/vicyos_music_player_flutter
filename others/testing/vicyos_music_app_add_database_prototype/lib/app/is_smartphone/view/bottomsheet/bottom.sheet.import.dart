import 'package:flutter/material.dart';
import 'package:vicyos_music/app/common/color_palette/color_extension.dart';
import 'package:vicyos_music/app/common/music_player/music.player.functions.and.more.dart';
import 'package:vicyos_music/l10n/app_localizations.dart';

class ImportFilesBottomSheet extends StatelessWidget {
  const ImportFilesBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
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
              AppLocalizations.of(context)!.add_to_playlist_all_capitalized,
              style: TextStyle(
                fontWeight: FontWeight.w900,
                color: TColor.org,
                fontSize: 19,
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
                          child: Icon(
                            Icons.create_new_folder_outlined,
                            color: TColor.focus,
                            size: 38,
                          ),
                        ),
                        title: Text(
                          AppLocalizations.of(context)!.import_folder,
                          style: TextStyle(
                            color: TColor.primaryText80,
                            fontSize: 19,
                          ),
                        ),
                        contentPadding: const EdgeInsets.fromLTRB(0, 4, 0, 4),
                        onTap: () async {
                          await pickFolder(context);
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
                          AppLocalizations.of(context)!.add_songs,
                          style: TextStyle(
                            color: TColor.primaryText80,
                            fontSize: 19,
                          ),
                        ),
                        contentPadding: const EdgeInsets.fromLTRB(0, 4, 0, 4),
                        onTap: () async {
                          await pickAndPlayAudio(context);
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
