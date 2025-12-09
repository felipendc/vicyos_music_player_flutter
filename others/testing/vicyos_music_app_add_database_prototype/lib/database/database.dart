import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

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
    // 2) Tabela de Áudios (AudioInfo)
    // -------------------------------
    await db.execute('''
      CREATE TABLE audios (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        path TEXT NOT NULL,
        name TEXT NOT NULL,
        size TEXT,
        format TEXT
      );
    ''');

    // -------------------------------
    // 3) Tabela de Pastas (FolderSources)
    // -------------------------------
    await db.execute('''
      CREATE TABLE music_folders (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        folder_path TEXT NOT NULL,
        songs INTEGER NOT NULL
      );
    ''');

    // ---------------------------------------------
    // 4) Tabela N-PARA-N ligando playlists ↔ audios
    // ---------------------------------------------
    await db.execute('''
    CREATE TABLE playlist_audios (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      playlist_id INTEGER NOT NULL,
      audio_id INTEGER NOT NULL,
      FOREIGN KEY (playlist_id) REFERENCES playlists (id),
      FOREIGN KEY (audio_id) REFERENCES audios (id)
      );
    ''');
  }
}
