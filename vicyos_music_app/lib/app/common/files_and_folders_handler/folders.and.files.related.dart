import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:just_audio/just_audio.dart';
import 'package:path/path.dart' as path;
import 'package:share_plus/share_plus.dart';
import 'package:vicyos_music/app/common/models/audio.info.dart';
import 'package:vicyos_music/app/common/models/folder.sources.dart';
import 'package:vicyos_music/app/common/music_player/music.player.functions.and.more.dart';
import 'package:vicyos_music/app/common/permission_handler/permission.handler.dart'
    show requestAudioPermission;
import 'package:vicyos_music/app/common/widgets/show.top.message.dart';

Future<List<String>> getFoldersWithAudioFiles(String rootDir) async {
  await requestAudioPermission();

  final audioExtensions = {'.mp3', '.m4a', '.ogg', '.wav', '.aac', '.midi'};
  final foldersWithAudio = <String>{};
  final deviceMusicFolder = Directory(rootDir);

  if (await deviceMusicFolder.exists()) {
    noDeviceMusicFolderFound = false;
    if (await deviceMusicFolder.list().isEmpty) {
      // The device music folder is empty!
    } else {
      await for (var entity
          in Directory(rootDir).list(recursive: true, followLinks: false)) {
        if (entity is File) {
          final extension = entity.path.split('.').last.toLowerCase();
          if (audioExtensions.contains('.$extension')) {
            foldersWithAudio.add(entity.parent.path);
          }
        }
      }
    }
  } else {
    noDeviceMusicFolderFound = true;
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
  rebuildHomePageFolderListStreamNotifier("fetching_files");
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
      debugPrint(audioFolders.toString());
    }

    return audioFolders;
  }

  for (var folder in await audioFolder()) {
    folderPath = folder;
    totalSongs = folderLength(folder);
    musicFolderPaths.add(FolderSources(path: folderPath, songs: totalSongs));
    debugPrint(musicFolderPaths
        .map((index) => index)
        .map((index) => index.path)
        .toString()
        .toString());
  }

  // if (IsInternalStoragePermissionDenied == true && musicFolderPaths.isEmpty) {
  //   rebuildHomePageFolderListStreamNotifier("Null");
  // } else

  if (noDeviceMusicFolderFound == true && musicFolderPaths.isEmpty) {
    rebuildHomePageFolderListStreamNotifier("there_is_no_music_folder");
  } else if (musicFolderPaths.isNotEmpty) {
    rebuildHomePageFolderListStreamNotifier("fetching_files_done");
  } else {
    rebuildHomePageFolderListStreamNotifier("Null");
  }

  // rebuild the song list screen
  rebuildSongsListScreenStreamNotifier();
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
  final folderLength = directorySongList
      .where(
        (entity) {
          if (entity is File) {
            String extension = entity.path
                .substring(entity.path.lastIndexOf('.'))
                .toLowerCase();
            return audioExtensions.contains(extension);
          }
          return false;
        },
      )
      .map((entity) => entity.path)
      .toList();

  return folderLength.length;
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
      .where(
        (entity) {
          if (entity is File) {
            String extension = entity.path
                .substring(entity.path.lastIndexOf('.'))
                .toLowerCase();

            return audioExtensions.contains(extension);
          }
          return false;
        },
      )
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
  var fullPath = audioPlayer.audioSources[index].sequence
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

String getFileSize(String filePath) {
  final file = File(filePath);
  int sizeInBytes = file.lengthSync();
  double sizeInMb = sizeInBytes / (1024 * 1024);
  // double kb = sizeInMb * 1024;
  return sizeInMb.toStringAsFixed(2);
}

String getFileExtension(String filePath) {
  final file = File(filePath);
  String fileExtension =
      file.path.substring(file.path.lastIndexOf('.') + 1).toUpperCase();

  return fileExtension;
}

Future<void> sharingFiles(dynamic shareFile) async {
  if (shareFile is String) {
    await SharePlus.instance.share(
      ShareParams(
        text: 'This file was shared using the Vicyos Music app.',
        files: [XFile(shareFile)],
      ),
    );
  } else if (shareFile is List) {
    //  TODO: FUTURE FEATURE, SHARE MULTIPLE FILES...
    List<XFile> files = shareFile.map((path) => XFile(path)).toList();
    await SharePlus.instance.share(
      ShareParams(
        text:
            "These ${shareFile.length} audio files 🎵, were shared using the Vicyos Music app.",
        files: files,
      ),
    );
  }
}

Future<void> deleteSongFromStorage(
    BuildContext context, String wasDeleted, String songPath) async {
  if (wasDeleted == "Files deleted successfully") {
    // ----------------------------------------------------------
    musicFolderPaths.clear();
    folderSongList.clear();

    // Re sync the folder list
    await listMusicFolders();

    // Check if the file is present on the playlist...
    final int index = audioPlayer.audioSources.indexWhere(
        (audio) => (audio as UriAudioSource).uri.toFilePath() == songPath);

    if (index != -1) {
      if (songPath == currentSongFullPath &&
          audioPlayer.audioSources.length == 1) {
        // Clean playlist and rebuild the entire screen to clean the listview
        cleanPlaylist();
      } else {
        await audioPlayer.removeAudioSourceAt(index);
        rebuildPlaylistCurrentLengthStreamNotifier();
        await getCurrentSongFullPathStreamControllerNotifier();

        // Update the current song name
        if (index < audioPlayer.audioSources.length) {
          String newCurrentSongFullPath = Uri.decodeFull(
              (audioPlayer.audioSources[index] as UriAudioSource)
                  .uri
                  .toString());
          currentSongName = songName(newCurrentSongFullPath);
        }
      }
      currentSongNameStreamNotifier();
    }
    // ----------------------------------------------------------
    rebuildSongsListScreenStreamNotifier();
    rebuildHomePageFolderListStreamNotifier("fetching_files_done");
    if (context.mounted) {
      Navigator.pop(context, "close_song_preview_bottom_sheet");
    }
  } else if (wasDeleted != "Files deleted successfully") {
    if (context.mounted) {
      Navigator.pop(context);
    }
  }
  if (context.mounted) {
    showFileDeletedMessage(
        context, songName(songPath), "Has been deleted successfully");
  }
}
