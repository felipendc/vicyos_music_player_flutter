import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vicyos_music/app/common/color_extension.dart';
import 'package:vicyos_music/app/controller/home.controller.dart';
import 'package:vicyos_music/app/functions/folders.and.files.related.dart';

final HomeController controller = Get.find<HomeController>();

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
              listMusicFolders();
              print(controller.musicFolderPaths);
            },
            backgroundColor: TColor.darkGray,
          ),
        ),
      ],
    );
  }
}
