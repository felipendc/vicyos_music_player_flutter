import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:vicyos_music/app/is_smartphone/functions/folders.and.files.related.dart';
import 'package:vicyos_music/app/common/models/audio.info.dart';
import 'package:vicyos_music/app/common/models/folder.sources.dart';
import 'package:vicyos_music/app/common/music_player/music.player.dart';

Future<void> searchFilesByName(
    List<FolderSources> folders, String searchTerm) async {
  isSearchingSongsStreamNotifier("searching");
  Set<String> foundFilesPaths =
      {}; // Using a Set to store file paths and avoid duplicates
  foundFilesPaths.clear();
  foundSongs.clear();

  String searchQuery =
      searchTerm.trim().toLowerCase(); // Normalize search query

  debugPrint("🔎 Searching for: '$searchQuery'");

  for (String folder in folders.map((folder) => folder.path).toList()) {
    Directory dir = Directory(folder);

    if (await dir.exists()) {
      List<FileSystemEntity> files = dir.listSync();

      for (var file in files) {
        if (file is File) {
          String fileName = file.uri.pathSegments.last.toLowerCase();
          debugPrint("📂 File found: $fileName");

          // Check if the file name contains the search term
          if (fileName.contains(searchQuery)) {
            // Check if the file path has already been added
            if (!foundFilesPaths.contains(file.path)) {
              foundFilesPaths
                  .add(file.path); // Avoid duplicates based on the full path
              debugPrint("✅ Match found: $fileName");

              try {
                foundSongs.add(
                  AudioInfo(
                    name: songName(file.path),
                    path: file.path,
                    size: file.existsSync() ? getFileSize(file.path) : '0 KB',
                    format: getFileExtension(file.path),
                  ),
                );
              } catch (e) {
                debugPrint("❌ Error processing file: ${file.path} | Error: $e");
              }
            }
          }
        }
      }
    } else {
      debugPrint("⚠ Directory not found: $folder");
    }
  }

  if (foundSongs.isEmpty) {
    isSearchingSongsStreamNotifier("nothing_found");
    debugPrint("🚫 No matching files found.");
  } else {
    isSearchingSongsStreamNotifier("finished");
  }

  debugPrint("🎵 Final found files: ${foundSongs.map((s) => s.name).toList()}");
}
