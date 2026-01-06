import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:just_audio/just_audio.dart';
import 'package:path/path.dart' as path;
import 'package:share_plus/share_plus.dart';
import 'package:vicyos_music/app/components/show.top.message.dart';
import 'package:vicyos_music/app/models/audio.info.dart';
import 'package:vicyos_music/app/models/folder.sources.dart';
import 'package:vicyos_music/app/music_player/music.player.functions.and.more.dart';
import 'package:vicyos_music/app/music_player/music.player.stream.controllers.dart';
import 'package:vicyos_music/app/permission_handler/permission.handler.dart'
    show requestAudioPermission;
import 'package:vicyos_music/database/database.dart';
import 'package:vicyos_music/l10n/app_localizations.dart';

Future<List<String>> getFoldersWithoutAudioFiles() async {
  await requestAudioPermission();

  final audioExtensions = {'.mp3', '.m4a', '.ogg', '.wav', '.aac', '.midi'};
  final allFolders = <String>{};
  final foldersWithAudio = <String>{};

  final deviceRoot = Directory("/storage/emulated/0/Music/");

  if (await deviceRoot.exists()) {
    noDeviceMusicFolderFound = false;

    // Iterate all of the files and folders
    await for (var entity
        in deviceRoot.list(recursive: true, followLinks: false)) {
      if (entity is File) {
        final extension = '.${entity.path.split('.').last.toLowerCase()}';
        if (audioExtensions.contains(extension)) {
          // Add the folders containing audio files
          foldersWithAudio.add(entity.parent.path);
        }
      } else if (entity is Directory) {
        // Add all the folders
        allFolders.add(entity.path);
      }
    }
  } else {
    noDeviceMusicFolderFound = true;
  }

  // Return only the folders that doesn't have audio files
  final foldersWithoutAudio = allFolders.difference(foldersWithAudio);

  return foldersWithoutAudio.toList();
}

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

Future<String> getMusicFolderPathWindowsOrLinux() async {
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

Future<List<AudioInfo>> filterSongsOnlyToList(
    {required String folderPath}) async {
  final List<AudioInfo> musicFolderContents = <AudioInfo>[];
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
    musicFolderContents.add(
      AudioInfo(
        name: songName(songPath),
        path: songPath,
        size: getFileSize(songPath),
        format: getFileExtension(songPath),
        extension: getFileExtension(songPath),
      ),
    );
  }
  return musicFolderContents;
}

Future<List<String>> deviceMusicFolderPath() async {
  List<String> audioFolders = [];

  if (Platform.isAndroid) {
    audioFolders = await getFoldersWithAudioFiles('/storage/emulated/0/Music/');
  } else if (Platform.isWindows) {
    audioFolders = await getFoldersWithAudioFiles(
        await getMusicFolderPathWindowsOrLinux());
    debugPrint(audioFolders.toString());
  }
  return audioFolders;
}

Future<void> getMusicFoldersContent(
    {required bool isMusicFolderListener}) async {
  // rebuildHomePageFolderListNotifier(FetchingSongs.fetching);

  for (var musicFolder in await deviceMusicFolderPath()) {
    final folderPath = musicFolder;
    final totalSongs = folderLength(musicFolder);
    final folderSongPathsList =
        await filterSongsOnlyToList(folderPath: musicFolder);

    // Populating the database with folder paths and its song list
    await AppDatabase.instance.syncFolder(
      folder: FolderSources(
        folderPath: folderPath,
        folderSongCount: totalSongs,
        songPathsList: folderSongPathsList,
      ),
      isMusicFolderListener: isMusicFolderListener,
    );
  }

  if (isPermissionGranted) {
    if (noDeviceMusicFolderFound == true) {
      // Delete database
      await AppDatabase.instance.deleteDatabaseFile();
      rebuildHomePageFolderListNotifier(
          FetchingSongs.noMusicFolderHasBeenFound);
      //
    } else if (!await AppDatabase.instance.musicFoldersIsEmpty()) {
      // Database isn't empty!
      rebuildHomePageFolderListNotifier(FetchingSongs.done);
      //
    } else if (await AppDatabase.instance.musicFoldersIsEmpty()) {
      // Database is empty
      rebuildHomePageFolderListNotifier(FetchingSongs.musicFolderIsEmpty);
      //
    } else {
      rebuildHomePageFolderListNotifier(FetchingSongs.nullValue);
    }
  } else {
    rebuildHomePageFolderListNotifier(FetchingSongs.permissionDenied);
  }

  // rebuild the song list screen
  rebuildSongsListScreenNotifier();
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

Future<void> sharingFiles(dynamic shareFile, BuildContext context) async {
  if (shareFile is String) {
    await SharePlus.instance.share(
      ShareParams(
        text: AppLocalizations.of(context)!.single_shared_file,
        files: [XFile(shareFile)],
      ),
    );
  } else if (shareFile is Set<AudioInfo>) {
    //  TODO: FUTURE FEATURE, SHARE MULTIPLE FILES...
    List<XFile> files = shareFile.map((path) => XFile(path.path)).toList();
    await SharePlus.instance.share(
      ShareParams(
        text: AppLocalizations.of(context)!
            .multiple_shared_files(shareFile.length),
        files: files,
      ),
    );
  }
}

Future<void> deleteSongFromStorage(
    {required BuildContext context,
    required String wasDeleted,
    required String songPath,
    bool? multipleFiles}) async {
  if (wasDeleted == "Files deleted successfully") {
    // ----------------------------------------------------------

    // Re-sync the folder list
    await getMusicFoldersContent(isMusicFolderListener: false);

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
        rebuildPlaylistCurrentLengthNotifier();
        currentSongNameNotifier();

        // Update the current song name
        if (index < audioPlayer.audioSources.length) {
          String newCurrentSongFullPath = Uri.decodeFull(
              (audioPlayer.audioSources[index] as UriAudioSource)
                  .uri
                  .toString());
          currentSongName = songName(newCurrentSongFullPath);
        }
      }
      currentSongNameNotifier();
    }
    // ----------------------------------------------------------
    rebuildSongsListScreenNotifier();
    rebuildHomePageFolderListNotifier(FetchingSongs.done);
    currentSongNavigationRouteNotifier();
    if (multipleFiles != true || multipleFiles == null) {
      if (context.mounted) {
        Navigator.pop(context, "close_song_preview_bottom_sheet");
      }
    }
  } else if (wasDeleted != "Files deleted successfully") {
    if (multipleFiles != true || multipleFiles == null) {
      if (context.mounted) {
        Navigator.pop(context);
      }
    }
  }

  // if (multipleFiles != true || multipleFiles == null) {
  if (context.mounted) {
    showFileDeletedMessage(
      context,
      songName(songPath),
      AppLocalizations.of(context)!.deleted_successfully,
    );
  }
  // }
}
