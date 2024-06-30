import 'dart:io';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:path/path.dart' as path;
import 'package:vicyos_music_player/app/controller/home.controller.dart';
import 'package:vicyos_music_player/app/models/folder.sources.dart';

final HomeController controller = Get.find<HomeController>();

// String internalStorage = '/storage/emulated/0/Music/';

Future<void> requestStoragePermission() async {
  var status = await Permission.storage.status;
  if (!status.isGranted) {
    await Permission.storage.request();
  } else {
    // openAppSettings();
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
  String folderPath;
  String totalSongs;
  final audioFolders =
      await getFoldersWithAudioFiles('/storage/emulated/0/Music/');

  for (var folder in audioFolders) {
    folderPath = folder;
    totalSongs = folderLenght(folder);
    controller.musicFolderPaths
        .add(FolderSources(path: folderPath, songs: totalSongs));
    print(controller.musicFolderPaths
        .map((index) => index as FolderSources)
        .map((index) => index.path)
        .toString()
        .toString());
  }

  // print(audioFolders);
}

String folderLenght(String folderPath) {
  final Set<String> audioExtensions = {
    '.mp3',
    '.m4a',
    '.ogg',
    '.wav',
    '.aac',
    '.midi'
  };

  Directory? folderDirectory = Directory(folderPath);
  final directorySongList = folderDirectory.listSync();
  final folderLenght = directorySongList
      .where((entity) {
        if (entity is File) {
          String extension =
              entity.path.substring(entity.path.lastIndexOf('.')).toLowerCase();
          return audioExtensions.contains(extension);
        }
        return false;
      })
      .map((entity) => entity.path)
      .toList();

  return folderLenght.length.toString();
}

void filterSongsOnlyToList({required String folderPath}) {
  controller.folderSongList.clear();
  final Set<String> audioExtensions = {
    '.mp3',
    '.m4a',
    '.ogg',
    '.wav',
    '.aac',
    '.midi'
  };
  Directory? folderDirectory = Directory(folderPath);

  final directorySongList = folderDirectory.listSync();

  final List<String> audioFiles = directorySongList
      .where((entity) {
        if (entity is File) {
          String extension =
              entity.path.substring(entity.path.lastIndexOf('.')).toLowerCase();
          return audioExtensions.contains(extension);
        }
        return false;
      })
      .map((entity) => entity.path)
      .toList();

  for (var songPath in audioFiles) {
    controller.folderSongList.add(songPath);
  }
}

String songFullPath({required int index}) {
  return controller.playlist.children[index].sequence
      .map((audioSource) => [audioSource].map(
            (audioSource) => Uri.decodeFull(
              (audioSource as UriAudioSource).uri.toString(),
            ),
          ))
      .toString();
}
