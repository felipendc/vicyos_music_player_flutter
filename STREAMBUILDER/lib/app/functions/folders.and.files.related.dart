import 'dart:io';

import 'package:just_audio/just_audio.dart';
import 'package:path/path.dart' as path;
import 'package:permission_handler/permission_handler.dart';
import 'package:vicyos_music/app/functions/music_player.dart';
import 'package:vicyos_music/app/models/audio.info.dart';
import 'package:vicyos_music/app/models/folder.sources.dart';
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

Future<String> getMusicFolderPath() async {
  // Get the user directory
  Directory userDirectory;

  if (Platform.isWindows) {
    userDirectory = Directory(Platform.environment['USERPROFILE']!);
  } else {
    userDirectory = Directory(Platform.environment['HOME']!);
  }

  if (!await userDirectory.exists()) {
    throw Exception('Could not find user home directory');
  }

  // Append the Music folder to the user home directory
  String musicFolderPath = path.join(userDirectory.path, 'Music');

  return musicFolderPath;
}

Future<void> listMusicFolders() async {
  musicFolderPaths.clear();
  folderSongList.clear();

  String folderPath;
  int totalSongs;

  Future<List<String>> audioFolder() async {
    late List<String> audioFolders;

    if (Platform.isAndroid) {
      audioFolders =
          await getFoldersWithAudioFiles('/storage/emulated/0/Music/');
    } else if (Platform.isWindows) {
      audioFolders = await getFoldersWithAudioFiles(await getMusicFolderPath());
      print(audioFolders);
    }

    return audioFolders;
  }

  for (var folder in await audioFolder()) {
    folderPath = folder;
    totalSongs = folderLength(folder);
    musicFolderPaths.add(FolderSources(path: folderPath, songs: totalSongs));
    print(musicFolderPaths
        .map((index) => index)
        .map((index) => index.path)
        .toString()
        .toString());
  }
  listPlaylistFolderStreamNotifier();
}

int folderLength(String folderPath) {
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

  return folderLenght.length;
}

void filterSongsOnlyToList({required String folderPath}) {
  folderSongList.clear();
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
    folderSongList.add(
      AudioInfo(
        name: songName(songPath),
        path: songPath,
        size: getFileSize(songPath),
        format: getFileExtension(songPath),
      ),
    );
  }
}

String songFullPath({required int index}) {
  var fullPath = playlist.children[index].sequence
      .map((audioSource) => Uri.decodeFull(
            (audioSource as UriAudioSource).uri.toString(),
          ))
      .first;

  //  "Windows has /// Android //""
  if (fullPath.startsWith("file:///")) {
    return fullPath.replaceFirst('file:///', '');
  } else if (fullPath.startsWith("file://")) {
    return fullPath.replaceFirst('file://', '');
  }
  return fullPath;
}

String getFileSize(filePath) {
  final file = File(filePath);
  int sizeInBytes = file.lengthSync();
  double sizeInMb = sizeInBytes / (1024 * 1024);
  // double kb = sizeInMb * 1024;
  return sizeInMb.toStringAsFixed(2);
}

String getFileExtension(filePath) {
  final file = File(filePath);
  String fileExtension =
      file.path.substring(file.path.lastIndexOf('.')).toUpperCase();

  return fileExtension;
}
