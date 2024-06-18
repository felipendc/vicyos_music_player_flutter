// ignore_for_file: avoid_print

import 'dart:io';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:path/path.dart' as path;
import 'package:vicyos_music_player/app/controller/home.controller.dart';

final HomeController controller = Get.find<HomeController>();

// String internalStorage = '/storage/emulated/0/Music/';

Future<void> requestStoragePermission() async {
  var status = await Permission.storage.status;
  if (!status.isGranted) {
    await Permission.storage.request();
  }
}

Future<List<String>> getFoldersWithAudioFiles(String rootDir) async {
  await requestStoragePermission();
  final audioExtensions = {'.mp3', '.m4a', '.ogg', '.wav', '.aac', '.midi'};
  final foldersWithAudio = <String>{};

  await for (var entity
      in Directory(rootDir).list(recursive: true, followLinks: false)) {
    if (entity is File) {
      final extension = entity.path.split('.').last.toLowerCase();
      if (audioExtensions.contains('.$extension')) {
        foldersWithAudio.add(entity.parent.path);
      }
    }
  }
  return foldersWithAudio.toList();
}

String folderName(String folderDir) {
  File folderPath = File(folderDir);
  String getFolderName = folderPath.uri.pathSegments.last;
  return getFolderName[0].toUpperCase() + getFolderName.substring(1);
}

String songName(String songPath) {
  File folderPath = File(songPath);
  String songName = folderPath.uri.pathSegments.last;
  String songNameWithoutExtension = path.basenameWithoutExtension(songName);
  return songNameWithoutExtension;
}

Future<void> listMusicFolders() async {
  final audioFolders =
      await getFoldersWithAudioFiles('/storage/emulated/0/Music/');
  for (var folder in audioFolders) {
    controller.musicFolderPaths.add(folder);
  }
  print(audioFolders);
}
