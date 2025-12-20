import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:vicyos_music/app/files_and_folders_handler/folders.and.files.related.dart';
import 'package:vicyos_music/app/models/audio.info.dart';
import 'package:vicyos_music/app/models/folder.sources.dart';
import 'package:vicyos_music/app/music_player/music.player.functions.and.more.dart';
import 'package:vicyos_music/app/music_player/music.player.stream.controllers.dart';

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
    // debugPrint('📦 Initiating database...');
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

  // Saving and syncing folders one by one
  Future<void> syncFolder(FolderSources folder) async {
    final db = await database;

    final existing = await _getFolderByPath(db, folder.folderPath);

    final newSongs = folder.songPathsList.map((e) => e.path).toSet();

    // New folder
    if (existing == null) {
      await db.insert('music_folders', {
        'folder_path': folder.folderPath,
        'song_count': folder.songPathsList.length,
        'folder_content': jsonEncode(
          folder.songPathsList.map((e) => e.toMap()).toList(),
        ),
      });
      return;
    }

    // Old content
    final List oldDecoded = jsonDecode(existing['folder_content'] as String);

    final oldSongs = oldDecoded.map((e) => e['path'] as String).toSet();

    // Files removed from device
    final removedSongs = oldSongs.difference(newSongs);

    // Delete the song removed from all tables
    for (final removedPath in removedSongs) {
      await deleteAudioPath(removedPath);
    }

    // If nothing hasn't been changed
    if (oldSongs.length == newSongs.length && oldSongs.containsAll(newSongs)) {
      return;
    }

    // Update the folder
    await db.update(
      'music_folders',
      {
        'song_count': folder.songPathsList.length,
        'folder_content': jsonEncode(
          folder.songPathsList.map((e) => e.toMap()).toList(),
        ),
      },
      where: 'folder_path = ?',
      whereArgs: [folder.folderPath],
    );
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
  Future<void> removeDeletedFoldersFromDB(
    List<String> deviceFolders,
  ) async {
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
        debugPrint('Folder removed from database: $dbPath');
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
      // Remove from all playlist
      await txn.delete(
        'playlist_audios',
        where: 'audio_path = ?',
        whereArgs: [audioPath],
      );

      // Delete from favorites
      await txn.delete(
        'favorites',
        where: 'path = ?',
        whereArgs: [audioPath],
      );

      //  Fetch all folders
      final folders = await txn.query('music_folders');

      for (final folder in folders) {
        // final List decoded = jsonDecode(folder['folder_content'] as String);
        final decoded = jsonDecode(folder['folder_content'] as String);
        if (decoded is! List) continue;
        final originalLength = decoded.length;

        decoded.removeWhere((e) => e['path'] == audioPath);

        if (decoded.length == originalLength) continue;

        // If the folder is now empty, delete it
        if (decoded.isEmpty) {
          await txn.delete(
            'music_folders',
            where: 'id = ?',
            whereArgs: [folder['id']],
          );
        } else {
          // 🔄 Update the folder normally
          await txn.update(
            'music_folders',
            {
              'folder_content': jsonEncode(decoded),
              'song_count': decoded.length,
            },
            where: 'id = ?',
            whereArgs: [folder['id']],
          );
        }
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
      debugPrint("🚫 No matching files found.");
    } else {}

    debugPrint("🎵 Final found files: ${matches.map((s) => s.path).toList()}");
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
      debugPrint("🚫 No matching files found.");
    } else {
      isSearchingSongsNotifier("finished");
    }

    debugPrint("🎵 Final found files: ${matches.map((s) => s.path).toList()}");
    return matches;
  }

  // Add a song to favorite
  Future<bool> addToFavorites(AudioInfo audio) async {
    final db = await database;

    final id = await db.insert(
      'favorites',
      audio.toMap(),
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

  // Remove from favorites (toggle ❤️)
  Future<void> removeFromFavorites(
      String songPath, BuildContext context) async {
    final db = await database;

    await db.delete(
      'favorites',
      where: 'path = ?',
      whereArgs: [songPath],
    );

    // Check if the file is present on the playlist...
    final int index = audioPlayer.audioSources.indexWhere(
        (audio) => (audio as UriAudioSource).uri.toFilePath() == songPath);

    if (index != -1) {
      if (songPath == currentSongFullPath &&
          audioPlayer.audioSources.length == 1) {
        // Clean playlist and rebuild the entire screen to clean the listview
        if (context.mounted) {
          cleanPlaylist(context);
        }
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
  }

  // Complete Toggle (better UI)
  // Add if isn't in favorites or delete if it is in favorites table
  Future<bool> toggleFavorite(AudioInfo audio, BuildContext context) async {
    final exists = await isFavorite(audio.path);

    if (exists) {
      if (context.mounted) {
        await removeFromFavorites(audio.path, context);
      }

      return false;
    } else {
      await addToFavorites(audio);
      return true;
    }
  }

  // Get all favorites
  Future<List<AudioInfo>> getFavorites() async {
    final db = await database;

    final result = await db.query(
      'favorites',
      orderBy: 'name COLLATE NOCASE ASC',
    );

    return result.map((e) => AudioInfo.fromMap(e)).toList();
  }

  // Create database
  Future _createDB(Database db, int version) async {
    // -------------------------------
    // 1)  Playlists Table
    // -------------------------------
    await db.execute('''
    CREATE TABLE playlists (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      name TEXT NOT NULL
    );
  ''');

    // -------------------------------
    // 2) Folder tables with JSON
    // -------------------------------
    await db.execute('''
    CREATE TABLE music_folders (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      folder_path TEXT UNIQUE NOT NULL,
      song_count INTEGER NOT NULL,
      folder_content TEXT NOT NULL
    );
    ''');

    // ---------------------------------------------
    // 3) Playlists ↔ Audios (NOW SAVES THE PATH)
    // ---------------------------------------------
    await db.execute('''
    CREATE TABLE playlist_audios (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      playlist_id INTEGER NOT NULL,
      audio_path TEXT NOT NULL,
      FOREIGN KEY (playlist_id) REFERENCES playlists (id) ON DELETE CASCADE
    );
    ''');

    // ---------------------------------------------
    // 4) Save to Favorites
    // ---------------------------------------------
    await db.execute('''
    CREATE TABLE favorites (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      path TEXT NOT NULL UNIQUE,
      name TEXT NOT NULL,
      size TEXT NOT NULL,
      format TEXT NOT NULL
    );
    ''');

    // 5) Index for favorites.path (fast lookup)
    await db.execute('''
    CREATE INDEX idx_favorites_path
    ON favorites (path);
    ''');

    // 6) INDEX
    await db.execute('''
    CREATE INDEX idx_playlist_audio_path
    ON playlist_audios (audio_path);
    ''');
  }
}
