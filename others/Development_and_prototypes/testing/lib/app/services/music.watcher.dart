import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:vicyos_music/app/files_and_folders_handler/folders.and.files.related.dart';
import 'package:vicyos_music/app/music_player/music.player.functions.and.more.dart';
import 'package:vicyos_music/app/music_player/music.player.stream.controllers.dart';
import 'package:vicyos_music/database/database.dart';

class MusicWatcher {
  static const _channel = EventChannel('mediastore_music_changes');

  StreamSubscription? _sub;
  Timer? _debounceTimer;

  bool _hasReceivedFirstEvent = false;

  void start(BuildContext context) {
    if (_sub != null) return;

    _sub = _channel.receiveBroadcastStream().listen((event) {
      print('🎵 Detected change: ${event['uri']}');

      // 🔹 Marca que o stream começou a emitir eventos
      if (!_hasReceivedFirstEvent) {
        _hasReceivedFirstEvent = true;
      }

      // Cancel the previous timer
      _debounceTimer?.cancel();

      // Create a new 2-second timer
      _debounceTimer = Timer(const Duration(seconds: 2), () async {
        if (!context.mounted) return;

        // I will only run if the stream has emitted a real value
        if (_hasReceivedFirstEvent) {
          await getMusicFoldersContent(
              context: context, isMusicFolderListener: true);
          await AppDatabase.instance.removeEmptyFoldersAndDeletedFolders();
          rebuildHomePageFolderListNotifier(FetchingSongs.done);
        }
      });
    });
  }

  void stop() {
    _debounceTimer?.cancel();
    _debounceTimer = null;

    _sub?.cancel();
    _sub = null;

    _hasReceivedFirstEvent = false;
  }
}
