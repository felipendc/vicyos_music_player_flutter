import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:vicyos_music/app/files_and_folders_handler/folders.and.files.related.dart';
import 'package:vicyos_music/app/models/audio.info.dart';
import 'package:vicyos_music/app/models/folder.sources.dart';
import 'package:vicyos_music/app/models/radio.stations.model.dart';
import 'package:vicyos_music/app/music_player/music.player.stream.controllers.dart';

List<RadioStationInfo> foundStations = <RadioStationInfo>[];
List<AudioInfo> foundSongs = <AudioInfo>[];

Future<void> searchSongFilesByName(
    List<FolderSources> folders, String searchTerm) async {
  isSearchingSongsNotifier("searching");
  Set<String> foundFilesPaths =
      {}; // Using a Set to store file paths and avoid duplicates
  foundFilesPaths.clear();
  foundSongs.clear();

  String searchQuery =
      searchTerm.trim().toLowerCase(); // Normalize search query

  debugPrint("🔎 Searching for: '$searchQuery'");

  for (String folder in folders.map((folder) => folder.folderPath).toList()) {
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
    isSearchingSongsNotifier("nothing_found");
    debugPrint("🚫 No matching files found.");
  } else {
    isSearchingSongsNotifier("finished");
  }

  debugPrint("🎵 Final found files: ${foundSongs.map((s) => s.name).toList()}");
}

//
Future<void> searchRadioStationsByName(
    List<RadioStationInfo> radioStationsList, String searchTerm) async {
  isSearchingSongsNotifier("searching");
  Set<String> foundStationNames =
      {}; // Using a Set to store station paths and avoid duplicates
  foundStationNames.clear();
  foundStations.clear();

  String searchQuery =
      searchTerm.trim().toLowerCase(); // Normalize search query

  debugPrint("🔎 Searching for: '$searchQuery'");

  for (RadioStationInfo station in radioStationsList) {
    String stationName = station.radioName.toLowerCase();
    debugPrint("📂 Station found: $stationName");

    // Check if the station name contains the search term
    if (stationName.contains(searchQuery)) {
      // Check if the station name has already been added
      if (!foundStationNames.contains(stationName)) {
        foundStationNames
            .add(stationName); // Avoid duplicates based on the full path
        debugPrint("✅ Match found: $stationName");

        try {
          foundStations.add(station);
          debugPrint("❌ RÁDIO ADDED: ${station.radioName} ");
        } catch (e) {
          debugPrint(
              "❌ Error processing file: ${station.radioName} | Error: $e");
        }
      }
    }
  }

  if (foundStations.isEmpty) {
    isSearchingSongsNotifier("nothing_found");
    debugPrint("🚫 No matching files found.");
  } else {
    isSearchingSongsNotifier("finished");
  }

  debugPrint(
      "🎵 Final found files: ${foundStations.map((s) => s.radioName).toList()}");
}
