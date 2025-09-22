import 'package:flutter/material.dart';
import 'package:vicyos_music/app/common/color_extension.dart';
import 'package:vicyos_music/app/is_smartphone/functions/folders.and.files.related.dart';
import 'package:vicyos_music/app/common/music_player/music.player.dart';

class MainSyncScreen extends StatelessWidget {
  const MainSyncScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Center(
          child: FloatingActionButton.extended(
            label: const Text('Sync Music Folder'),
            icon: const Icon(Icons.add),
            onPressed: () {
              print(musicFolderPaths);
              listMusicFolders();
            },
            backgroundColor: TColor.darkGray,
          ),
        ),
      ],
    );
  }
}
