import 'package:audio_service/audio_service.dart';
import 'package:flutter/cupertino.dart' show BuildContext, Color;
import 'package:flutter/foundation.dart' show debugPrint;
import 'package:flutter/material.dart' show Colors;
import 'package:http/http.dart' as http;
import 'package:just_audio/just_audio.dart';
import 'package:vicyos_music/app/common/models/radio.stations.model.dart';
import 'package:vicyos_music/app/common/music_player/music.player.dart';
import 'package:vicyos_music/app/common/radio/radio.stream.notifiers.dart';
import 'package:vicyos_music/app/common/radio/radio_stations/radio.stations.list.dart';
import 'package:vicyos_music/app/common/radio/widgets/show.radio.top.message.dart'
    show errorToFetchRadioStationCard;
import 'package:vicyos_music/app/common/search_bar_handler/search.songs.stations.dart';

// ------------ RADIO FUNCTIONS --------------------//

bool radioHasLogo(int index) {
  return (radioStationList[index].ratioStationLogo != null);
}

String radioLogo() {
  return "assets/img/radio_icon.png";
}

void errorToFetchRadioStation(int index) {
  radioStationFetchError = true;
  radioStationErrorIndex = index;
}

Future<void> turnOnRadioStation() async {
  isRadioOn = true;

  radioStationBtn = Colors.green;

  // hideBottonSheetStreamNotifier(false);
  // hideMiniPlayerStreamNotifier(false);

  radioScreenStreamNotifier();
  switchingToRadioStreamNotifier();
}

Future<void> turnOffRadioStation() async {
  // Ordered instructions:
  isRadioOn = false;
  isRadioPaused = false;
  radioStationBtn = Color(0xFFFF0F7B);
  await radioPlayer.stop();
  await radioPlayer.clearAudioSources();
  radioPlaylist.clear();
  currentRadioIndex = 0;
  getCurrentSongFullPathStreamControllerNotifier();
  radioScreenStreamNotifier();
  currentRadioStationID = "";
  switchingToRadioStreamNotifier();
}

Future<bool> checkStreamUrl(String url) async {
  try {
    final response = await http.head(Uri.parse(url)).timeout(
          const Duration(seconds: 5),
        );

    // If the server responds with 200, 206, or 302 — the URL is valid
    return response.statusCode == 200 ||
        response.statusCode == 206 ||
        response.statusCode == 302;
  } catch (e) {
    // Any error (timeout, invalid host, etc.) -> the URL is broken
    return false;
  }
}

Future<void> radioSeekToNext() async {
  if (radioPlayer.audioSources.length == 1) {
  } else {
    radioPlayer.setSpeed(1.0);
    await radioPlayer.seekToNext();
  }
}

Future<void> radioSeekToPrevious() async {
  if (radioPlayer.audioSources.length == 1) {
  } else {
    radioPlayer.setSpeed(1.0);
    await radioPlayer.seekToPrevious();
  }
}

Future<void> playRadioStation(BuildContext context, int index) async {
  radioPlayer.setSpeed(1.0);
  isRadioPaused = false;
  turnOnRadioStation();
  cleanPlaylist();

  // Clear and re-add all the radio stations to the "radioPlaylist"
  radioPlaylist.clear();
  for (var radioStation in radioStationList) {
    String radioStationUrl = radioStation.radioUrl;
    debugPrint("Radio URLS: $radioStationUrl");

    final mediaItem = MediaItem(
      id: radioStation.id,
      // album: metadata?.albumName ?? 'Unknown Album',

      // Using the name of the file as the title by default
      title: radioStation.radioName,
      album: radioStation.radioLocation,
      // artist: metadata?.albumArtistName ?? 'Unknown Artist',
      artUri: Uri.file(notificationPlayerAlbumArt.path),
    );

    radioPlaylist.add(
      AudioSource.uri(
        Uri.parse(radioStationUrl),
        tag: mediaItem,
      ),
    );
  }

  try {
    // Load the playlist
    await radioPlayer.setAudioSources(
      radioPlaylist,
      initialIndex: index,
      initialPosition: Duration.zero, // Load each item just in time
      // Customise the shuffle algorithm
      preload: true,
    );

    radioPlayer.play();
    radioStationList[index].stationStatus = RadioStationConnectionStatus.online;
  } catch (e) {
    if (!await checkStreamUrl(radioStationList[index].radioUrl)) {
      radioStationList[index].stationStatus =
          RadioStationConnectionStatus.error;
      errorToFetchRadioStation(index);
      if (context.mounted) {
        errorToFetchRadioStationCard(
            context, radioStationList[index].radioName);
      }
      await turnOffRadioStation();
      getCurrentSongFullPathStreamControllerNotifier();
    }

    debugPrint('Erro ao carregar a rádio: $e');
  }
}

Future<void> playSearchedRadioStation(BuildContext context, int index) async {
  radioPlayer.setSpeed(1.0);
  isRadioPaused = false;
  turnOnRadioStation();
  cleanPlaylist();

  // Clear and re-add all the radio stations to the "radioPlaylist"
  radioPlaylist.clear();

  final mediaItem = MediaItem(
    id: foundStations[index].id,
    // album: metadata?.albumName ?? 'Unknown Album',

    // Using the name of the file as the title by default
    title: foundStations[index].radioName,
    album: foundStations[index].radioLocation,
    // artist: metadata?.albumArtistName ?? 'Unknown Artist',
    artUri: Uri.file(notificationPlayerAlbumArt.path),
  );

  radioPlaylist.add(
    AudioSource.uri(
      Uri.parse(foundStations[index].radioUrl),
      tag: mediaItem,
    ),
  );

  try {
    // Load the playlist
    await radioPlayer.setAudioSources(
      radioPlaylist,
      initialIndex: 0,
      initialPosition: Duration.zero, // Load each item just in time
      // Customise the shuffle algorithm
      preload: true,
    );

    radioPlayer.play();
    radioStationList[index].stationStatus = RadioStationConnectionStatus.online;
  } catch (e) {
    if (!await checkStreamUrl(radioStationList[index].radioUrl)) {
      radioStationList[index].stationStatus =
          RadioStationConnectionStatus.error;
      errorToFetchRadioStation(index);
      if (context.mounted) {
        errorToFetchRadioStationCard(
            context, radioStationList[index].radioName);
      }
      await turnOffRadioStation();
      getCurrentSongFullPathStreamControllerNotifier();
    }

    debugPrint('Erro ao carregar a rádio: $e');
  }
}

Future<void> radioPlayOrPause() async {
  if (radioPlayer.audioSources.isNotEmpty) {
    if (isRadioPaused == false) {
      isRadioPaused = true;
      await radioPlayer.pause();
    } else if (isRadioPaused == true) {
      isRadioPaused = false;
      await radioPlayer.play();
    }
  }
}

Future<void> reLoadRatioStationCurrentIndex(BuildContext context) async {
  radioPlayer.setSpeed(1.0);
  isRadioPaused = false;
  turnOnRadioStation();
  cleanPlaylist();

  // Clear and re-add all the radio stations to the "radioPlaylist"
  radioPlaylist.clear();

  final mediaItem = MediaItem(
    id: currentRadioStationID,
    // album: metadata?.albumName ?? 'Unknown Album',

    // Using the name of the file as the title by default
    title: currentRadioStationName,
    album: currentRadioStationLocation,
    // artist: metadata?.albumArtistName ?? 'Unknown Artist',
    artUri: Uri.file(notificationPlayerAlbumArt.path),
  );

  radioPlaylist.add(
    AudioSource.uri(
      Uri.parse(currentRadioIndexUrl),
      tag: mediaItem,
    ),
  );

  try {
    // Load the playlist
    await radioPlayer.setAudioSources(
      radioPlaylist,
      initialIndex: 0,
      initialPosition: Duration.zero, // Load each item just in time
      // Customise the shuffle algorithm
      preload: true,
    );

    radioPlayer.play();

    // Toggle radio online signal icon
    for (RadioStationInfo station in [...radioStationList, ...foundStations]) {
      String stationId = station.radioUrl;
      if (stationId.contains(currentRadioIndexUrl)) {
        station.stationStatus = RadioStationConnectionStatus.online;
      }
    }
  } catch (e) {
    if (!await checkStreamUrl(currentRadioIndexUrl)) {
      // Toggle radio offline signal icon
      for (RadioStationInfo station in [
        ...radioStationList,
        ...foundStations
      ]) {
        String stationId = station.radioUrl;
        if (stationId.contains(currentRadioIndexUrl)) {
          station.stationStatus = RadioStationConnectionStatus.error;
        }
      }

      if (context.mounted) {
        errorToFetchRadioStationCard(context, currentRadioStationName);
      }
      await turnOffRadioStation();
      getCurrentSongFullPathStreamControllerNotifier();
    }

    debugPrint('Error to load radio: $e');
  }

  debugPrint("Checking current radio url: $currentRadioIndexUrl");
}
// ------------ RADIO FUNCTIONS END --------------------//
