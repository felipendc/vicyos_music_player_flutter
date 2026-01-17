import 'dart:convert';

import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:vicyos_music/app/build_flags/build.flags.dart';
import 'package:vicyos_music/app/files_and_folders_handler/folders.and.files.related.dart';
import 'package:vicyos_music/app/models/audio.info.dart';
import 'package:vicyos_music/app/models/folder.sources.dart';
import 'package:vicyos_music/app/models/playlists.dart';
import 'package:vicyos_music/app/music_player/music.player.functions.and.more.dart';
import 'package:vicyos_music/app/music_player/music.player.stream.controllers.dart';
import 'package:vicyos_music/app/services/audio.metadata.dart';

class AppDatabase {
  static final AppDatabase instance = AppDatabase._init();
  static Database? _database;

  AppDatabase._init();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDB('vicyos_music.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    // debugPrint('Initiating database...');
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
      onOpen: (db) async {
        await db.execute('PRAGMA foreign_keys = ON');
      },
    );
  }

  Future<Map<String, dynamic>?> _getFolderByPath(
    Database db,
    String folderPath,
  ) async {
    final result = await db.query(
      'music_folders',
      where: 'folder_path = ?',
      whereArgs: [folderPath],
      limit: 1,
    );

    return result.isNotEmpty ? result.first : null;
  }

  Future<void> removeEmptyFoldersAndDeletedFolders() async {
    final listDeviceFoldersWithAudioFile =
        await getFoldersWithAudioFiles("/storage/emulated/0/Music/");

    final foldersWithoutAudios = await getFoldersWithoutAudioFiles();
    final dbFolders = await getAllFolderPathsFromDB();

    // Remove folder from database if it doesn't exist in the device music folder
    for (String folder in dbFolders) {
      if (!listDeviceFoldersWithAudioFile.contains(folder)) {
        // -----------------------------------------------------------------
        // If the device music folder(s) has(have) been removed or renamed:
        // Remove all the songs from the playing queue to avoid crashes
        // Then, remove the folder(s) from the Data base
        // -----------------------------------------------------------------
        if (audioPlayer.audioSources.isNotEmpty) {
          final List<int> indexesToRemove = [];

          // Make sure the folder ends with "/" to avoid removing the path
          final String normalizedFolder =
              folder.endsWith('/') ? folder : '$folder/';

          for (int i = 0; i < audioPlayer.audioSources.length; i++) {
            final source = audioPlayer.audioSources[i];

            if (source is UriAudioSource) {
              final uri = source.uri;

              if (uri.isScheme('file')) {
                final String path = uri.toFilePath();
                if (path.contains(normalizedFolder)) {
                  indexesToRemove.add(i);
                }
              }
            }
          }

          // Remove in reversed order
          for (final index in indexesToRemove.reversed) {
            await audioPlayer.removeAudioSourceAt(index);
            rebuildPlaylistCurrentLengthNotifier();
            currentSongNameNotifier();
          }
          if (audioPlayer.audioSources.isEmpty) {
            cleanPlaylist();
          }
        }
        await removeFolderFromDB(folder);
      }
    }

    // Remove the empty folders from the DB
    for (String emptyFolder in foldersWithoutAudios) {
      if (dbFolders.contains(emptyFolder)) {
        await removeFolderFromDB(emptyFolder);
        // print("Folder deleted: $emptyFolder");
      }
    }
    // rebuildHomePageFolderListNotifier(FetchingSongs.done);
  }

  // Saving and syncing folders one by one
  Future<void> syncFolder({
    required FolderSources folder,
    required bool isMusicFolderListener,
  }) async {
    if (!isMusicFolderListener) {
      rebuildHomePageFolderListNotifier(FetchingSongs.fetching);
    }

    final db = await database;

    // Look up the folder in the database
    final existing = await _getFolderByPath(db, folder.folderPath);

    // ===============================
    // Case 1: New folder
    // ===============================
    if (existing == null) {
      // Calculate duration for all files (first sync)
      final List<AudioInfo> enriched = [];

      for (final audio in folder.songPathsList) {
        final duration = await AudioMetadata.getFormattedDuration(audio.path);

        enriched.add(
          audio.copyWith(duration: duration ?? "00:00"),
        );
      }

      await db.insert('music_folders', {
        'folder_path': folder.folderPath,
        'song_count': enriched.length,
        'folder_content': jsonEncode(enriched.map((e) => e.toMap()).toList()),
      });

      return;
    }

    // ===============================
    // Case 2: Existing folder
    // ===============================

    // Old songs stored in the database
    final List decoded = jsonDecode(existing['folder_content'] as String);

    final List<AudioInfo> oldAudios =
        decoded.map((e) => AudioInfo.fromMap(e)).toList();

    final Map<String, AudioInfo> oldByPath = {
      for (final audio in oldAudios) audio.path: audio,
    };

    final Set<String> newPaths =
        folder.songPathsList.map((e) => e.path).toSet();

    final Set<String> oldPaths = oldAudios.map((e) => e.path).toSet();

    // ===============================
    // Removed files
    // ===============================
    final removedPaths = oldPaths.difference(newPaths);

    if (removedPaths.isNotEmpty) {
      await Future.wait(
        removedPaths.map(deleteAudioPath),
      );
    }

    // ===============================
    // Smart merge
    // ===============================
    final List<AudioInfo> finalList = [];

    for (final audio in folder.songPathsList) {
      final old = oldByPath[audio.path];

      // New song
      if (old == null) {
        final duration = await AudioMetadata.getFormattedDuration(audio.path);

        finalList.add(
          audio.copyWith(duration: duration ?? "00:00"),
        );
        continue;
      }

      // Existing song without duration
      if (old.duration == null || old.duration!.isEmpty) {
        final duration = await AudioMetadata.getFormattedDuration(old.path);

        finalList.add(
          old.copyWith(duration: duration ?? "00:00"),
        );
        continue;
      }

      // Existing song already complete
      finalList.add(old);
    }

    // ===============================
    // Update database
    // ===============================
    await db.update(
      'music_folders',
      {
        'song_count': finalList.length,
        'folder_content': jsonEncode(finalList.map((e) => e.toMap()).toList()),
      },
      where: 'folder_path = ?',
      whereArgs: [folder.folderPath],
    );

    rebuildPlaylistCurrentLengthNotifier();
    currentSongNameNotifier();
  }

  // Remove a folder from the database
  Future<void> removeFolderFromDB(String folderPath) async {
    final db = await AppDatabase.instance.database;

    await db.delete(
      'music_folders', // Table
      where: 'folder_path = ?', // Statement
      whereArgs: [folderPath], //  folder_path path
    );

    debugPrint("Folder removed from DB: $folderPath");
  }

  // Check if folder exists in the database
  Future<bool> folderExistsInDB(String folderPath) async {
    final db = await AppDatabase.instance.database;

    final result = await db.query(
      'music_folders', // Table
      columns: ['folder_path'], // Only get the column folder_path
      where: 'folder_path = ?', // Statement
      whereArgs: [folderPath], // folder_path value
      limit: 1, // We only need one result
    );

    // If result isn't empty, the folder exists
    return result.isNotEmpty;
  }

  // Return the music_folders model to access the music_folders[index].value
  Future<List<FolderSources>> getFolders() async {
    final db = await AppDatabase.instance.database;

    final result = await db.query('music_folders');

    return result.map((row) {
      return FolderSources(
        folderPath: row['folder_path'] as String,
        folderSongCount: row['song_count'] as int,
        songPathsList: const [], // Load it later
      );
    }).toList();
  }

  // Return a list of folder_path to the list.view
  Future<List<String>> getFolderPaths() async {
    final db = await AppDatabase.instance.database;

    final result = await db.query(
      'music_folders',
      columns: ['folder_path'],
      orderBy: 'folder_path ASC', // Optional
    );

    return result.map((row) => row['folder_path'] as String).toList();
  }

  // Look for all the Music in the database
  Future<List<AudioInfo>> getAllMusicPathsFromDB() async {
    final db = await AppDatabase.instance.database;
    final result = await db.query('music_folders');
    final List<AudioInfo> allSongs = [];

    for (final row in result) {
      final List songs = jsonDecode(row['folder_content'] as String);
      for (final song in songs) {
        allSongs.add(AudioInfo.fromMap(song));
      }
    }

    allSongs.sort(
      (a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()),
    );

    return allSongs;
  }

  // Look for all the folders in the database
  Future<List<String>> getAllFolderPathsFromDB() async {
    final db = await AppDatabase.instance.database;

    final result = await db.query('music_folders', columns: ['folder_path']);

    return result.map((e) => e['folder_path'] as String).toList();
  }

  // Remove deleted folders from the database
  Future<void> removeDeletedFoldersFromDB(List<String> deviceFolders) async {
    final db = await AppDatabase.instance.database;

    final dbFolders = await getAllFolderPathsFromDB();

    final deviceSet = deviceFolders.toSet();

    for (final dbPath in dbFolders) {
      if (!deviceSet.contains(dbPath)) {
        await db.delete(
          'music_folders',
          where: 'folder_path = ?',
          whereArgs: [dbPath],
        );
      }
    }
  }

  // Check if the music_folder table is empty
  Future<bool> musicFoldersIsEmpty() async {
    final db = await AppDatabase.instance.database;

    final result = Sqflite.firstIntValue(
      await db.rawQuery('SELECT COUNT(*) FROM music_folders'),
    );

    return (result ?? 0) == 0;
  }

  // Delete an audio path from all playlists
  Future<void> deleteAudioPath(String audioPath) async {
    final db = await database;

    await db.transaction((txn) async {
      // ----------------- Delete from favorites -----------------
      await txn.delete(
        'favorites',
        where: 'path = ?',
        whereArgs: [audioPath],
      );

      // ----------------- Delete from folders -----------------
      final folders = await txn.query('music_folders');
      for (final folder in folders) {
        final folderId = folder['id'] as int;
        final decoded = jsonDecode(folder['folder_content'] as String);
        if (decoded is! List) continue;

        final originalLength = decoded.length;
        decoded.removeWhere((e) => e['path'] == audioPath);

        if (decoded.length == originalLength) continue; // Nothing has changed

        if (decoded.isEmpty) {
          // If the is empty, delete it
          await txn.delete(
            'music_folders',
            where: 'id = ?',
            whereArgs: [folderId],
          );
        } else {
          // Update the folder content
          await txn.update(
            'music_folders',
            {
              'folder_content': jsonEncode(decoded),
              'song_count': decoded.length,
            },
            where: 'id = ?',
            whereArgs: [folderId],
          );
        }
      }

      // ----------------- Delete from playlists -----------------
      final playlists = await txn.query('playlists');
      for (final playlist in playlists) {
        final playlistId = playlist['id'] as int;
        final decoded = jsonDecode(playlist['playlist_songs'] as String);
        if (decoded is! List) continue;

        final originalLength = decoded.length;
        decoded.removeWhere((e) => e['path'] == audioPath);

        if (decoded.length == originalLength) continue; // Nada mudou

        await txn.update(
          'playlists',
          {'playlist_songs': jsonEncode(decoded)},
          where: 'id = ?',
          whereArgs: [playlistId],
        );
      }
    });
  }

  Future<void> deleteDatabaseFile() async {
    debugPrint('Deleting the database...');
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'vicyos_music.db');

    // Close the database if it is open
    if (_database != null) {
      await _database!.close();
      _database = null;
    }

    await deleteDatabase(path);
  }

  // Access the folder music list through the folder_path
  Future<List<AudioInfo>> getFolderContentByPath(String folderPath) async {
    final db = await database;

    final result = await db.query(
      'music_folders',
      columns: ['folder_content'],
      where: 'folder_path = ?',
      whereArgs: [folderPath],
      limit: 1,
    );

    if (result.isEmpty) return [];

    final List decoded = jsonDecode(result.first['folder_content'] as String);

    return decoded.map((e) => AudioInfo.fromMap(e)).toList();
  }

  // Search for a song path and return its model
  Future<List<AudioInfo>> returnSongPathAsModel(String songPath) async {
    final db = await AppDatabase.instance.database;

    final result = await db.query('music_folders');

    final List<AudioInfo> matches = [];

    for (final row in result) {
      final List songs = jsonDecode(row['folder_content'] as String);

      for (final song in songs) {
        final name = (song['path'] as String).toLowerCase();

        if (name.contains(songPath.toLowerCase())) {
          matches.add(AudioInfo.fromMap(song));
        }
      }
    }
    if (matches.isEmpty) {
      debugPrint("No matching files found.");
    } else {}

    debugPrint("Final found files: ${matches.map((s) => s.path).toList()}");
    return matches;
  }

  // Search for songs
  Future<List<AudioInfo>> searchSongs(String query) async {
    isSearchingSongsNotifier("searching");
    final db = await AppDatabase.instance.database;

    final result = await db.query('music_folders');

    final List<AudioInfo> matches = [];

    for (final row in result) {
      final List songs = jsonDecode(row['folder_content'] as String);

      for (final song in songs) {
        final name = (song['name'] as String).toLowerCase();

        if (name.contains(query.toLowerCase())) {
          matches.add(AudioInfo.fromMap(song));
        }
      }
    }
    if (matches.isEmpty) {
      isSearchingSongsNotifier("nothing_found");
      debugPrint("No matching files found.");
    } else {
      isSearchingSongsNotifier("finished");
    }

    debugPrint("Final found files: ${matches.map((s) => s.path).toList()}");
    return matches;
  }

  // Add a song to favorite
  Future<bool> addToFavorites(AudioInfo audio) async {
    final db = await database;

    final count = Sqflite.firstIntValue(
          await db.rawQuery('SELECT COUNT(*) FROM favorites'),
        ) ??
        0;

    final id = await db.insert(
      'favorites',
      {
        ...audio.toMap(),
        'order_index': count,
      },
      conflictAlgorithm: ConflictAlgorithm.ignore,
    );

    return id > 0;
  }

  // Verify if the song has already been added to favorites
  Future<bool> isFavorite(String path) async {
    final db = await database;

    final result = await db.query(
      'favorites',
      where: 'path = ?',
      whereArgs: [path],
      limit: 1,
    );

    return result.isNotEmpty;
  }

  // Remove from favorites (toggle)
  Future<void> removeFromFavorites({
    required String songPath,
    required BuildContext context,
  }) async {
    final db = await database;

    await db.delete('favorites', where: 'path = ?', whereArgs: [songPath]);

    await rebuildFavoriteScreenNotifier();

    //=========== DO NOT DELETE, THIS IS FOR LEARNING PURPOSES ===============
    // final int index = audioPlayer.audioSources.indexWhere((audio) {
    //   if (audio is! UriAudioSource) return false;
    //
    //   final tag = audio.tag;
    //   if (tag is! MediaItem) return false;
    //
    //   return (tag.extras?['playedFromRoute'] == NavigationButtons.favorites.toString() &&
    //       audio.uri.toFilePath() == songPath);
    // });
    //
    // // Exit the function if the song does not exist in the queue
    // if (index == -1) {
    //   return; // Song is not part of the favorites queue
    // }
    //
    // if (songPath == currentSongFullPath &&
    //     audioPlayer.audioSources.length == 1) {
    //   // Clean playlist and rebuild the entire screen to clean the listview
    //     cleanPlaylist();

    // } else {
    //   await audioPlayer.removeAudioSourceAt(index);
    //   rebuildPlaylistCurrentLengthNotifier();
    // }
    //=======================================================================
    //

    //
    //----------- USE THIS IF YOU ALSO WANT TO REMOVE SONG FROM THE PLAYING QUEUE TOO ------------//

    // Check if the song is present on the playing queue...
    // and if the song present on the playing queue is in favorites...

    // Collect all of the indices I want to remove
    if (removeSongFromFavoritesAndPlayingQueueToo) {
      final List<int> indexesToRemove = [];
      for (int i = 0; i < audioPlayer.audioSources.length; i++) {
        final audio = audioPlayer.audioSources[i];

        if (audio is! UriAudioSource) continue;

        final tag = audio.tag;
        if (tag is! MediaItem) continue;

        if (audio.uri.toFilePath() == songPath &&
            tag.extras?['playedFromRoute'] ==
                NavigationButtons.favorites.toString()) {
          indexesToRemove.add(i);
        }
      }

      for (final index in indexesToRemove.reversed) {
        if (audioPlayer.audioSources.length == 1) {
          if (context.mounted) {
            cleanPlaylist();
          }
        } else {
          await audioPlayer.removeAudioSourceAt(index);
          rebuildPlaylistCurrentLengthNotifier();
        }
      }
    }
    //--------------------------------------------------------------------//
  }

  // Complete Toggle (better UI)
  // Add if isn't in favorites or delete if it is in favorites table
  Future<bool> toggleFavorite(
      {required AudioInfo audio,
      required BuildContext context,
      required bool isFromFavoriteScreen}) async {
    final exists = await isFavorite(audio.path);

    if (exists) {
      if (context.mounted) {
        await removeFromFavorites(
          context: context,
          songPath: audio.path,
        );
      }

      return false;
    } else {
      await addToFavorites(audio);
      return true;
    }
  }

  // Re-order the favorites when I drag the ordered list
  Future<void> updateFavoriteOrder(
    String path,
    int newIndex,
  ) async {
    final db = await database;

    await db.update(
      'favorites',
      {'order_index': newIndex},
      where: 'path = ?',
      whereArgs: [path],
    );
  }

  Future<void> updateFavoritesOrder(List<AudioInfo> list) async {
    final db = await database;

    for (int i = 0; i < list.length; i++) {
      await db.update(
        'favorites',
        {'order_index': i},
        where: 'path = ?',
        whereArgs: [list[i].path],
      );
    }
  }

  // Get all favorites
  Future<List<AudioInfo>> getFavorites() async {
    final db = await database;

    final result = await db.query(
      'favorites',
      orderBy: 'order_index ASC',
    );

    return result.map((e) => AudioInfo.fromMap(e)).toList();
  }

  Future<void> createEmptyPlaylist(String name) async {
    final db = await database;

    await db.insert(
      'playlists',
      {
        'playlist_name': name,
        'playlist_songs': jsonEncode([]),
      },
      conflictAlgorithm: ConflictAlgorithm.ignore,
    );
  }

  Future<void> createPlaylistWithAudio(
    String name,
    AudioInfo audio,
  ) async {
    final db = await database;

    await db.insert(
      'playlists',
      {
        'playlist_name': name,
        'playlist_songs': jsonEncode([audio.toMap()]),
      },
      conflictAlgorithm: ConflictAlgorithm.ignore,
    );
  }

  Future<void> addAudioToPlaylist({
    required String playlistName,
    required AudioInfo audio,
  }) async {
    final db = await database;

    final result = await db.query(
      'playlists',
      columns: ['playlist_songs'],
      where: 'playlist_name = ?',
      whereArgs: [playlistName],
    );

    if (result.isEmpty) return;

    final List list = jsonDecode(result.first['playlist_songs'] as String);

    // prevent duplicate audio (by path)
    final exists = list.any((e) => e['path'] == audio.path);
    if (exists) return;

    list.add(audio.toMap());

    await db.update(
      'playlists',
      {
        'playlist_songs': jsonEncode(list),
      },
      where: 'playlist_name = ?',
      whereArgs: [playlistName],
    );
  }

  Future<void> renamePlaylist({
    required String currentName,
    required String newName,
  }) async {
    final db = await database;

    await db.update(
      'playlists',
      {'playlist_name': newName},
      where: 'playlist_name = ?',
      whereArgs: [currentName],
    );
  }

  Future<void> deletePlaylist(String playlistName) async {
    final db = await database;

    await db.delete(
      'playlists',
      where: 'playlist_name = ?',
      whereArgs: [playlistName],
    );
  }

  Future<List<Playlists>> getAllPlaylists() async {
    final db = await database;

    final result = await db.query(
      'playlists',
      orderBy: 'id DESC', // The last created is listed first
    );

    return result.map((row) {
      final List<dynamic> decodedSongs =
          jsonDecode(row['playlist_songs'] as String);

      return Playlists(
        playlistName: row['playlist_name'] as String,
        playlistSongs: decodedSongs
            .map((e) => AudioInfo.fromMap(e as Map<String, dynamic>))
            .toList(),
      );
    }).toList();
  }

  Future<void> removeAudioFromPlaylist({
    required String playlistName,
    required String audioPath,
    required BuildContext context,
  }) async {
    final db = await database;

    // 1. Get the playlist by name
    final result = await db.query(
      'playlists',
      where: 'playlist_name = ?',
      whereArgs: [playlistName],
    );

    if (result.isEmpty) return;

    // 2. Decode playlist songs (JSON → List)
    final List decoded = jsonDecode(result.first['playlist_songs'] as String);

    // 3. Remove the audio by its path
    decoded.removeWhere((e) => e['path'] == audioPath);

    // 4. Update the playlist with the new list
    await db.update(
      'playlists',
      {
        'playlist_songs': jsonEncode(decoded),
      },
      where: 'playlist_name = ?',
      whereArgs: [playlistName],
    );

    await rebuildPlaylistScreenSNotifier();
    await rebuildSongsListScreenNotifier();

    //=========== DO NOT DELETE, THIS IS FOR LEARNING PURPOSES ===============
    // final int index = audioPlayer.audioSources.indexWhere((audio) {
    //   if (audio is! UriAudioSource) return false;
    //
    //   final tag = audio.tag;
    //   if (tag is! MediaItem) return false;
    //
    //   final playedFromRoute = tag.extras?['playedFromRoute'];
    //
    //   return (playedFromRoute == NavigationButtons.playlists.toString() &&
    //       audio.uri.toFilePath() == audioPath);
    // });
    //
    // // Exit the function if the song does not exist in the queue
    // if (index == -1) {
    //   return; // Song is not part of the playlists queue
    // }
    //
    // if (audioPath == currentSongFullPath &&
    //     audioPlayer.audioSources.length == 1) {
    //   // Clean playlist and rebuild the entire screen to clean the listview
    //
    //
    //     cleanPlaylist();
    //
    // } else {
    //   await audioPlayer.removeAudioSourceAt(index);
    //   rebuildPlaylistCurrentLengthNotifier();
    // }
    //=======================================================================
    //

    //
    //----------- USE THIS IF YOU ALSO WANT TO REMOVE SONG FROM THE PLAYING QUEUE TOO ------------//
    // Check if the song is present on the playing queue...
    // and if the song present on the playing queue is in the playlist...

    // Collect all of the indices I want to remove
    if (removeSongFromPlaylistAndPlayingQueueToo) {
      final List<int> indexesToRemove = [];
      for (int i = 0; i < audioPlayer.audioSources.length; i++) {
        final audio = audioPlayer.audioSources[i];

        if (audio is! UriAudioSource) continue;

        final tag = audio.tag;
        if (tag is! MediaItem) continue;

        if (audio.uri.toFilePath() == audioPath &&
            tag.extras?['playedFromRoute'] ==
                NavigationButtons.playlists.toString()) {
          indexesToRemove.add(i);
        }
      }

      for (final index in indexesToRemove.reversed) {
        if (audioPlayer.audioSources.length == 1) {
          cleanPlaylist();
        } else {
          await audioPlayer.removeAudioSourceAt(index);
          rebuildPlaylistCurrentLengthNotifier();
        }
      }
    }
    //----------------------------------------------------------------------------------------//
  }

  //  Update the database with the new order
  Future<void> updatePlaylistOrder({
    required String playlistName,
    required List<AudioInfo> songs,
  }) async {
    final db = await database;

    // Convert the list to JSON
    final List<Map<String, dynamic>> encoded =
        songs.map((e) => e.toMap()).toList();

    await db.update(
      'playlists',
      {
        'playlist_songs': jsonEncode(encoded),
      },
      where: 'playlist_name = ?',
      whereArgs: [playlistName],
    );
  }

  // Create database
  Future _createDB(Database db, int version) async {
    // ---------------------------------------------
    // 1) Music folders (JSON based)
    // ---------------------------------------------
    await db.execute('''
    CREATE TABLE music_folders (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      folder_path TEXT UNIQUE NOT NULL,
      song_count INTEGER NOT NULL,
      folder_content TEXT NOT NULL
    );
  ''');

    // ---------------------------------------------
    // 2) Playlists (JSON based, can be empty)
    // ---------------------------------------------
    await db.execute('''
   CREATE TABLE playlists (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    playlist_name TEXT UNIQUE NOT NULL,
    playlist_songs TEXT NOT NULL
    );
    ''');

    // ---------------------------------------------
    // 3) Favorites
    // ---------------------------------------------
    await db.execute('''
    CREATE TABLE favorites (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      path TEXT NOT NULL UNIQUE,
      name TEXT NOT NULL,
      size TEXT NOT NULL,
      format TEXT NOT NULL,
      extension TEXT NOT NULL,
      duration TEXT NOT NULL,
      order_index INTEGER
    );
  ''');

    await db.execute('''
    CREATE INDEX idx_favorites_path
    ON favorites (path);
  ''');
  }
}
