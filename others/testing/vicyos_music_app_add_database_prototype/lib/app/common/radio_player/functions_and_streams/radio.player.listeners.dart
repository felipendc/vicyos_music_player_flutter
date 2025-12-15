import 'package:audio_service/audio_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:just_audio/just_audio.dart';
import 'package:vicyos_music/app/common/models/radio.stations.model.dart';
import 'package:vicyos_music/app/common/music_player/music.player.functions.and.more.dart';
import 'package:vicyos_music/app/common/radio_player/functions_and_streams/radio.functions.and.more.dart';
import 'package:vicyos_music/app/common/radio_player/functions_and_streams/radio.stream.controllers.dart';
import 'package:vicyos_music/app/common/radio_player/radio_stations/radio.stations.list.dart';
import 'package:vicyos_music/app/common/radio_player/screens/radio.station.list.screen.dart';
import 'package:vicyos_music/app/common/radio_player/widgets/show.radio.top.message.dart';
import 'package:vicyos_music/app/common/search_bar_handler/search.songs.stations.handler.dart';
import 'package:vicyos_music/app/common/services/audio.output.service.dart';
import 'package:vicyos_music/app/is_smartphone/view/screens/main.radio.player.screen.dart';
import 'package:vicyos_music/app/is_tablet/view/screens/main.player.view.screen.dart';

void radioPlayerStreamListeners() {
  // Update radio_player stations list screen only when the current index changes
  int? lastRadioIndex;
  radioPlayer.playbackEventStream.listen((event) async {
    if (lastRadioIndex != event.currentIndex) {
      currentRadioIndex = event.currentIndex ?? 0;
      lastRadioIndex = currentRadioIndex;

      debugPrint("Radio current Index: $lastRadioIndex");
    }

    // Getting the Radio current MediaItem id, title and album
    final mediaItem = radioPlayer.sequenceState.currentSource?.tag;
    if (mediaItem is MediaItem) {
      if (mediaItem.title != currentRadioStationName) {
        // Getting the current station info
        currentRadioStationName = mediaItem.title;
        currentRadioStationLocation = mediaItem.album!;
        currentRadioStationID = mediaItem.id;

        //debugPrint("CURRENT INDEX ID $currentIndex: ${mediaItem.id}");
        //debugPrint("Title: ${mediaItem.title}");
        //debugPrint("Artist: ${mediaItem.artist}");
        debugPrint("radio_player nome $currentRadioStationName");
        updateRadioScreensNotifier();
      }
    }

    // Player states (playing, pausing and stopped)
    if (event.processingState == ProcessingState.idle) {
      // Stopped
      isRadioPlaying = false;
      isRadioPaused = false;
      isRadioStopped = true;
      if (isRadioOn) {
        turnOffRadioStation();
        updateRadioScreensNotifier();
        switchingToRadioNotifier();
      }
      debugPrint("The radio_player is: Stopped");
    } else if (radioPlayer.playing) {
      // Playing
      isRadioPlaying = true;
      isRadioPaused = false;
      isRadioStopped = false;
      debugPrint("The radio_player is: Playing");
    } else if (radioPlayer.playing == false &&
        event.processingState == ProcessingState.ready) {
      // Paused
      isRadioPlaying = false;
      isRadioPaused = true;
      isRadioStopped = false;
      debugPrint("The radio_player is: Paused");
    }
  });

  // Get the current radio_player station uri to be able to re-load the current station
  radioPlayer.sequenceStateStream.listen(
    (sequenceState) {
      final currentSource = sequenceState.currentSource;
      if (currentSource is UriAudioSource) {
        currentRadioIndexUrl = currentSource.uri.toString();
      }
    },
  );

  // Check for playback errors, display the error and add the broken signal icon:
  final mainRadioScreenContextKey = mainRadioScreenKey.currentContext;
  final mainRadioPlayerViewContextKey = mainRadioPlayerViewKey.currentContext;
  final mainPlayerViewTabletContextKey = mainPlayerViewTabletKey.currentContext;

  radioPlayer.playerStateStream.listen((radioState) async {
    if (radioState.processingState == ProcessingState.idle &&
        radioState.playing) {
      // Combine two lists into one and iterate over and search for the current
      // radio_player url in two lists [radioStationList and foundStations]
      // to toggle the radio_player offline signal icon
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

  // Checking audio output route changes
  // and update the volume slider
  final AudioOutputService audioService = AudioOutputService();
  audioService.listen((event) async {
    await getCurrentVolume();

    // debugPrint('Received from Android: $event');
    // if (event is List) {
    //   for (var d in event) {
    //     debugPrint(
    //         'Device ${d['name']} ${d['type']} kind:${d['kind']} id:${d['id']}');
    //     debugPrint("The device ${d['name']} has been ${d['type']}");
    //   }
    // } else if (event is Map) {
    //   debugPrint('Output: ${event['output']}, action: ${event['action']}');
    // } else {
    //   debugPrint('Event: $event');
    // }
  }, onError: (err) {
    debugPrint('audio chanel error: $err');
  });
}
