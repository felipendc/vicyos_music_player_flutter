import 'dart:async';

import 'package:vicyos_music/app/common/music_player/music.player.functions.and.more.dart';

// Stream controllers
StreamController<void> getCurrentSongFullPathStreamController =
    StreamController<void>.broadcast();

StreamController<void> getCurrentSongFolderStreamController =
    StreamController<void>.broadcast();

StreamController<void> currentSongAlbumStreamController =
    StreamController<void>.broadcast();

StreamController<void> currentSongNameStreamController =
    StreamController<void>.broadcast();

StreamController<void> listPlaylistFolderStreamController =
    StreamController<void>.broadcast();

StreamController<void> clearCurrentPlaylistStreamController =
    StreamController<void>.broadcast();

StreamController<void> repeatModeStreamController =
    StreamController<void>.broadcast();

StreamController<void> systemVolumeStreamController =
    StreamController<void>.broadcast();

StreamController<bool> hideBottonSheetStreamController =
    StreamController<bool>.broadcast();

StreamController<void> rebuildPlaylistCurrentLengthController =
    StreamController<void>.broadcast();

StreamController<void> rebuildSongsListScreenStreamController =
    StreamController<void>.broadcast();

StreamController<String> rebuildHomePageFolderListStreamController =
    StreamController<String>.broadcast();

StreamController<void> rebuildSpeedRateBottomSheetStreamController =
    StreamController<void>.broadcast();

StreamController<String> isSearchingSongsStreamController =
    StreamController<String>.broadcast();

StreamController<bool> isSearchTypingStreamController =
    StreamController<bool>.broadcast();

// Streams Notifiers Functions
Future<void> getCurrentSongFullPathStreamControllerNotifier() async {
  getCurrentSongFullPathStreamController.sink.add(null);
}

void getCurrentSongFolderStreamControllerNotifier() {
  getCurrentSongFolderStreamController.sink.add(null);
}

void isSearchTypingStreamNotifier(bool value) {
  isSearchTypingStreamController.sink.add(value);
}

void isSearchingSongsStreamNotifier(String value) {
  isSearchingSongsStreamController.sink.add(value);
}

void rebuildSpeedRateBottomSheetStreamNotifier() {
  rebuildSpeedRateBottomSheetStreamController.sink.add(null);
}

void rebuildHomePageFolderListStreamNotifier(String value) {
  rebuildHomePageFolderListStreamController.sink.add(value);
}

void rebuildSongsListScreenStreamNotifier() {
  rebuildSongsListScreenStreamController.sink.add(null);
}

void rebuildPlaylistCurrentLengthStreamNotifier() {
  // Get the current playlist index
  audioPlayer.sequenceStream.listen(
    (sequence) {
      playlistCurrentLength = sequence.length;
    },
  );
  rebuildPlaylistCurrentLengthController.sink.add(null);
}

void clearCurrentPlaylistStreamNotifier() {
  audioPlayer.stop();
  songIsPlaying = false;
  clearCurrentPlaylistStreamController.sink.add(null);
}

void listPlaylistFolderStreamNotifier() async {
  playlistCurrentLength = musicFolderPaths.length;
  listPlaylistFolderStreamController.sink.add(null);
}

void currentSongNameStreamNotifier() {
  currentSongNameStreamController.sink.add(null);
}

void currentSongAlbumStreamNotifier() {
  currentSongAlbumStreamController.sink.add(null);
}

void repeatModeStreamNotifier() {
  repeatModeStreamController.sink.add(null);
}

void systemVolumeStreamNotifier() {
  systemVolumeStreamController.sink.add(null);
}

Future<void> hideMiniPlayerStreamNotifier(bool value) async {
  hideBottonSheetStreamController.sink.add(value);
}
