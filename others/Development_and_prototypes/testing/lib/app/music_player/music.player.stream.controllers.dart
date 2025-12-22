import 'dart:async';

import 'package:vicyos_music/app/music_player/music.player.functions.and.more.dart';

// Stream controllers
StreamController<void> getCurrentSongFolderStreamController =
    StreamController<void>.broadcast();

StreamController<void> currentSongNameStreamController =
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

StreamController<FetchingSongs> rebuildHomePageFolderListStreamController =
    StreamController<FetchingSongs>.broadcast();

StreamController<void> rebuildSpeedRateBottomSheetStreamController =
    StreamController<void>.broadcast();

StreamController<String> isSearchingSongsStreamController =
    StreamController<String>.broadcast();

StreamController<bool> isSearchTypingStreamController =
    StreamController<bool>.broadcast();

StreamController<void> currentSongNavigationRouteStreamController =
    StreamController<void>.broadcast();

StreamController<void> rebuildFavoriteScreenStreamController =
    StreamController<void>.broadcast();

// Streams Notifiers Functions
void getCurrentSongFolderNotifier() {
  getCurrentSongFolderStreamController.sink.add(null);
}

void isSearchTypingNotifier(bool value) {
  isSearchTypingStreamController.sink.add(value);
}

void isSearchingSongsNotifier(String value) {
  isSearchingSongsStreamController.sink.add(value);
}

void rebuildSpeedRateBottomSheetNotifier() {
  rebuildSpeedRateBottomSheetStreamController.sink.add(null);
}

void rebuildHomePageFolderListNotifier(FetchingSongs value) {
  rebuildHomePageFolderListStreamController.sink.add(value);
}

void rebuildSongsListScreenNotifier() {
  rebuildSongsListScreenStreamController.sink.add(null);
}

void rebuildPlaylistCurrentLengthNotifier() {
  // Get the current playlist index
  audioPlayer.sequenceStream.listen(
    (sequence) {
      playlistCurrentLength = sequence.length;
    },
  );
  rebuildPlaylistCurrentLengthController.sink.add(null);
}

void clearCurrentPlaylistNotifier() {
  audioPlayer.stop();
  songIsPlaying = false;
  clearCurrentPlaylistStreamController.sink.add(null);
}

void currentSongNameNotifier() {
  currentSongNameStreamController.sink.add(null);
}

void repeatModeNotifier() {
  repeatModeStreamController.sink.add(null);
}

void systemVolumeNotifier() {
  systemVolumeStreamController.sink.add(null);
}

Future<void> hideMiniPlayerNotifier(bool value) async {
  hideBottonSheetStreamController.sink.add(value);
}

Future<void> currentSongNavigationRouteNotifier() async {
  currentSongNavigationRouteStreamController.sink.add(null);
}

Future<void> rebuildFavoriteScreenNotifier() async {
  rebuildFavoriteScreenStreamController.sink.add(null);
}
