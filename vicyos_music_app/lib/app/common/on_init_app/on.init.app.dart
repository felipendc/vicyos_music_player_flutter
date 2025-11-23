import 'package:audio_service/audio_service.dart';
import 'package:audioplayers/audioplayers.dart' as audio_players;
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:vicyos_music/app/common/models/radio.stations.model.dart';
import 'package:vicyos_music/app/common/music_player/music.player.functions.and.more.dart'
    show
        initVolumeControl,
        audioPlayer,
        audioPlayerPreview,
        playerEventStateStreamNotifier,
        playerPreviewEventStateStreamNotifier,
        defaultAlbumArt,
        currentFolderPath,
        getCurrentSongFolder,
        getCurrentSongFolderStreamControllerNotifier,
        currentSongFullPath,
        getCurrentSongFullPath,
        getCurrentSongFullPathStreamControllerNotifier,
        currentIndex;
import 'package:vicyos_music/app/common/radio/radio.functions.and.more.dart';
import 'package:vicyos_music/app/common/radio/radio.stream.notifiers.dart';
import 'package:vicyos_music/app/common/radio/radio_stations/radio.stations.list.dart';
import 'package:vicyos_music/app/common/radio/screens/main.radio.player.screen.dart';
import 'package:vicyos_music/app/common/radio/screens/radio.station.list.screen.dart';
import 'package:vicyos_music/app/common/radio/widgets/show.radio.top.message.dart';
import 'package:vicyos_music/app/common/search_bar_handler/search.songs.stations.dart';
import 'package:vicyos_music/app/is_tablet/view/screens/main.player.view.screen.dart';

Future<void> onInitPlayer() async {
  initVolumeControl();

  // Player for previewing the songs.
  audioPlayerPreview = audio_players.AudioPlayer();
  audioPlayerPreview.setReleaseMode(audio_players.ReleaseMode.stop);

  radioPlayer = AudioPlayer();
  radioPlayer.setLoopMode(LoopMode.all);
  audioPlayer = AudioPlayer();
  audioPlayer.setLoopMode(LoopMode.all);

  // playlist = ConcatenatingAudioSource(
  //   useLazyPreparation: true,
  //   shuffleOrder: DefaultShuffleOrder(),
  //   children: audioSources,
  // );
  playerEventStateStreamNotifier();
  playerPreviewEventStateStreamNotifier();
  await defaultAlbumArt();

  audioPlayer.sequenceStateStream.listen(
    (sequenceState) {
      final currentSource = sequenceState.currentSource;
      if (currentSource is UriAudioSource) {
        currentFolderPath = getCurrentSongFolder(currentSource.uri.toString());
        getCurrentSongFolderStreamControllerNotifier();

        currentSongFullPath =
            getCurrentSongFullPath(currentSource.uri.toString());
        getCurrentSongFullPathStreamControllerNotifier();
      }
    },
  );

  // Update radio stations list screen
  radioPlayer.playbackEventStream.listen((event) async {
    currentIndex = event.currentIndex ?? 0;
    debugPrint("INDEX RADIO ATUAL: $currentIndex");

    currentRadioIndex =
        (radioPlayer.audioSources.isEmpty || radioPlaylist.isEmpty)
            ? currentIndex = 0
            : currentIndex += 1;
    getCurrentSongFullPathStreamControllerNotifier();

    // Getting the Radio current MediaItem id, title and album
    final mediaItem = radioPlayer.sequenceState.currentSource?.tag;
    if (mediaItem is MediaItem) {
      // Getting the current station info
      currentRadioStationName = mediaItem.title;
      currentRadioStationLocation = mediaItem.album ?? "...";
      currentRadioStationID = mediaItem.id;

      // print("CURRENT INDEX ID $currentIndex: ${mediaItem.id}");
      // print("Title: ${mediaItem.title}");
      // print("Artist: ${mediaItem.artist}");
      debugPrint("radio nome $currentRadioStationName");
    }

    // Player states (playing, pausing and stopped)
    if (event.processingState == ProcessingState.idle) {
      // Stopped
      isRadioPlaying = false;
      isRadioPaused = false;
      isRadioStopped = true;
      if (isRadioOn) {
        turnOffRadioStation();
        await getCurrentSongFullPathStreamControllerNotifier();
        radioScreenStreamNotifier();
        switchingToRadioStreamNotifier();
      }
      debugPrint("The radio is: Stopped");
    } else if (radioPlayer.playing) {
      // Playing
      isRadioPlaying = true;
      isRadioPaused = false;
      isRadioStopped = false;
      debugPrint("The radio is: Playing");
    } else if (radioPlayer.playing == false &&
        event.processingState == ProcessingState.ready) {
      // Paused
      isRadioPlaying = false;
      isRadioPaused = true;
      isRadioStopped = false;
      debugPrint("The radio is: Paused");
    }
  });

  // Get the current radio station uri to be able to re-load the current station
  radioPlayer.sequenceStateStream.listen(
    (sequenceState) {
      final currentSource = sequenceState.currentSource;
      if (currentSource is UriAudioSource) {
        currentRadioIndexUrl = currentSource.uri.toString();
      }
    },
  );

  // Check for playback errors, display the error and add the broken signal icon:
  radioPlayer.playerStateStream.listen((radioState) async {
    if (radioState.processingState == ProcessingState.idle &&
        radioState.playing) {
      final mainRadioScreenContextKey = mainRadioScreenKey.currentContext;
      final mainRadioPlayerViewContextKey =
          mainRadioPlayerViewKey.currentContext;
      final mainPlayerViewTabletContextKey =
          mainPlayerViewTabletKey.currentContext;

      // Combine two lists into one and iterate over and search for the current
      // radio url in two lists [radioStationList and foundStations]
      // to toggle the radio offline signal icon
      for (RadioStationInfo station in [
        ...radioStationList,
        ...foundStations
      ]) {
        String stationId = station.radioUrl;
        if (stationId.contains(currentRadioIndexUrl)) {
          station.stationStatus = RadioStationConnectionStatus.error;
        }
      }

      if (mainRadioScreenContextKey != null &&
          mainRadioScreenContextKey.mounted) {
        errorToFetchRadioStationCard(
            mainRadioScreenContextKey, currentRadioStationName);
      }
      if (mainRadioPlayerViewContextKey != null &&
          mainRadioPlayerViewContextKey.mounted) {
        errorToFetchRadioStationCard(
            mainRadioPlayerViewContextKey, currentRadioStationName);
      }
      if (mainPlayerViewTabletContextKey != null &&
          mainPlayerViewTabletContextKey.mounted) {
        errorToFetchRadioStationCard(
            mainPlayerViewTabletContextKey, currentRadioStationName);
      }
      await turnOffRadioStation();
    }
  });
}
