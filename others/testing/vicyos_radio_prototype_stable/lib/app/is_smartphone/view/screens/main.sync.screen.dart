import 'package:flutter/material.dart';
import 'package:vicyos_music/app/common/color_palette/color_extension.dart';
import 'package:vicyos_music/app/common/files_and_folders_handler/folders.and.files.related.dart';
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
              debugPrint(musicFolderPaths.toString());
              listMusicFolders();
            },
            backgroundColor: TColor.darkGray,
          ),
        ),
      ],
    );
  }
}
