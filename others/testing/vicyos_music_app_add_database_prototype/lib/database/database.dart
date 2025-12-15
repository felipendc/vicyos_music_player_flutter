import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:vicyos_music/app/common/models/audio.info.dart';
import 'package:vicyos_music/app/common/models/folder.sources.dart';
import 'package:vicyos_music/app/common/music_player/music.player.stream.controllers.dart';

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
    print('📦 Iniciando banco de dados...');
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
    final db = await AppDatabase.instance.database;

    final existing = await _getFolderByPath(db, folder.folderPath);

    final newSongs = folder.songPathsList.map((e) => e.path).toSet();

    // 🆕 Pasta nova
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

    // 📂 Pasta já existe → comparar
    final oldSongs = (jsonDecode(existing['folder_content']) as List)
        .map((e) => e['path'] as String)
        .toSet();

    // ✅ Nada mudou → NÃO TOCA NO BANCO
    if (oldSongs.length == newSongs.length && oldSongs.containsAll(newSongs)) {
      return;
    }

    // 🔄 Atualiza só se mudou
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

  // Retorna o model de _music_folders pra acessar folders[index].value
  Future<List<FolderSources>> getFolders() async {
    final db = await AppDatabase.instance.database;

    final result = await db.query('music_folders');

    return result.map((row) {
      return FolderSources(
        folderPath: row['folder_path'] as String,
        folderSongCount: row['song_count'] as int,
        songPathsList: const [], // carregar depois
      );
    }).toList();
  }

  // Retorna uma lista de folder_path para o list.view
  Future<List<String>> getFolderPaths() async {
    final db = await AppDatabase.instance.database;

    final result = await db.query(
      'music_folders',
      columns: ['folder_path'],
      orderBy: 'folder_path ASC', // opcional
    );

    return result.map((row) => row['folder_path'] as String).toList();
  }

  // // Saving various folder at once
  // Future<void> insertFolders(List<FolderSources> folders) async {
  //   final db = await AppDatabase.instance.database;
  //   final batch = db.batch();
  //
  //   for (final folder in folders) {
  //     batch.insert(
  //       'music_folders',
  //       {
  //         'folder_path': folder.folderPath,
  //         'song_count': folder.folderSongCount,
  //         'folder_content': jsonEncode(
  //           folder.songPathsList.map((e) => e.toMap()).toList(),
  //         ),
  //       },
  //       conflictAlgorithm: ConflictAlgorithm.replace,
  //     );
  //   }
  //
  //   await batch.commit(noResult: true);
  // }

  // Buscar todas as pastas do banco
  Future<List<String>> getAllFolderPathsFromDB() async {
    final db = await AppDatabase.instance.database;

    final result = await db.query('music_folders', columns: ['folder_path']);

    return result.map((e) => e['folder_path'] as String).toList();
  }

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
        print('🗑 Pasta removida do banco: $dbPath');
      }
    }
  }

  // Verificar se a tabela music_folder está vazia
  Future<bool> musicFoldersIsEmpty() async {
    final db = await AppDatabase.instance.database;

    final result = Sqflite.firstIntValue(
      await db.rawQuery('SELECT COUNT(*) FROM music_folders'),
    );

    return (result ?? 0) == 0;
  }

  // Reading the database and converting it to FolderSources
  // Future<List<FolderSources>> getFolders() async {
  //   final db = await AppDatabase.instance.database;
  //
  //   final result = await db.query('music_folders');
  //
  //   return result.map((row) {
  //     final songs = (jsonDecode(row['folder_content'] as String) as List)
  //         .map((e) => AudioInfo.fromMap(e as Map<String, dynamic>))
  //         .toList();
  //
  //     return FolderSources(
  //       folderPath: row['folder_path'] as String,
  //       folderSongCount: row['song_count'] as int,
  //       songPathsList: songs,
  //     );
  //   }).toList();
  // }

  // Delete audio path from all playlists
  Future<void> deleteAudioPath(String audioPath) async {
    final db = await database;

    await db.transaction((txn) async {
      // 1️⃣ Remove de TODAS as playlists
      await txn.delete(
        'playlist_audios',
        where: 'audio_path = ?',
        whereArgs: [audioPath],
      );

      // 2️⃣ Busca todas as pastas
      final folders = await txn.query('music_folders');

      for (final folder in folders) {
        // final List decoded = jsonDecode(folder['folder_content'] as String);
        final decoded = jsonDecode(folder['folder_content'] as String);
        if (decoded is! List) continue;
        decoded.removeWhere((e) => e['path'] == audioPath);

        final originalLength = decoded.length;

        decoded.removeWhere(
          (e) => e['path'] == audioPath,
        );

        // Não tinha essa música nessa pasta
        if (decoded.length == originalLength) continue;

        // 🧹 Se a pasta ficou vazia → apaga ela
        if (decoded.isEmpty) {
          await txn.delete(
            'music_folders',
            where: 'id = ?',
            whereArgs: [folder['id']],
          );
        } else {
          // 🔄 Atualiza pasta normalmente
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
    print('📦 Deletando banco de dados...');
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'vicyos_music.db');

    // Fecha se estiver aberto
    if (_database != null) {
      await _database!.close();
      _database = null;
    }

    await deleteDatabase(path);
  }

  // Acessar a lista de musicas da pasta através do folder_path
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

  // Procurar por músicas
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

  Future _createDB(Database db, int version) async {
    // -------------------------------
    // 1) Tabela de Playlists
    // -------------------------------
    await db.execute('''
    CREATE TABLE playlists (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      name TEXT NOT NULL
    );
  ''');

    // -------------------------------
    // 2) Tabela de Pastas com JSON
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
    // 3) Playlists ↔ Áudios (AGORA SALVA PATH)
    // ---------------------------------------------
    await db.execute('''
    CREATE TABLE playlist_audios (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      playlist_id INTEGER NOT NULL,
      audio_path TEXT NOT NULL,
      FOREIGN KEY (playlist_id) REFERENCES playlists (id) ON DELETE CASCADE
    );
    ''');

    // ✅ 4) ÍNDICE
    await db.execute('''
    CREATE INDEX idx_playlist_audio_path
    ON playlist_audios (audio_path);
    ''');
  }
}
