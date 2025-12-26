import 'package:audio_service/audio_service.dart';
import 'package:flutter/cupertino.dart' show BuildContext, Color;
import 'package:flutter/foundation.dart' show debugPrint;
import 'package:flutter/material.dart' show Colors, Navigator;
import 'package:http/http.dart' as http;
import 'package:just_audio/just_audio.dart';
import 'package:vicyos_music/app/models/radio.stations.model.dart';
import 'package:vicyos_music/app/music_player/music.player.functions.and.more.dart';
import 'package:vicyos_music/app/music_player/music.player.stream.controllers.dart'
    show currentSongNavigationRouteNotifier;
import 'package:vicyos_music/app/radio_player/functions_and_streams/radio.stream.controllers.dart';
import 'package:vicyos_music/app/radio_player/radio_stations/radio.stations.list.dart';
import 'package:vicyos_music/app/radio_player/widgets/show.radio.top.message.dart';
import 'package:vicyos_music/app/search_bar_handler/search.songs.stations.handler.dart';
import 'package:vicyos_music/app/view/screens/tablet.main.player.view.screen.dart';
import 'package:vicyos_music/l10n/app_localizations.dart';

// ------------ RADIO FUNCTIONS, VARIABLES AND MORE ------------//
enum RadioStationConnectionStatus { online, error }

int currentRadioIndex = 0;
bool isRadioPlaying = false;
bool isRadioPaused = false;
bool isRadioStopped = isRadioOn ? false : true;
bool stationHasBeenSearched = false;
String currentRadioIndexUrl = "";
String currentRadioStationName = "";
String currentRadioStationLocation = "";
String currentRadioStationID = "";
bool isRadioOn = false;
Color radioStationBtn = Color(0xFFFF0F7B);
bool radioStationFetchError = false;
late int radioStationErrorIndex;

// Radio Player
late AudioPlayer radioPlayer;
final radioPlaylist = <AudioSource>[];

// ------------ RADIO FUNCTIONS --------------------//
bool radioHasLogo(int index) {
  return (radioStationList[index].ratioStationLogo != null);
}

String radioLogo() {
  return "assets/img/radio/radio_icon.png";
}

void errorToFetchRadioStation(int index) {
  radioStationFetchError = true;
  radioStationErrorIndex = index;
}

Future<void> turnOnRadioStation() async {
  isRadioOn = true;
  isRadioPaused = false;
  radioStationBtn = Colors.green;

  activeNavigationButton = NavigationButtons.none; // Manual attribution
  songCurrentRouteType = NavigationButtons.none; // Via listener

  currentSongNavigationRouteNotifier();

  switchingToRadioNotifier();

  updateRadioScreensNotifier();
}

Future<void> turnOffRadioStation() async {
  stationHasBeenSearched = false;
  isRadioOn = false;
  isRadioPaused = false;
  radioStationBtn = const Color(0xFFFF0F7B);

  currentRadioStationID = "";
  currentRadioIndex = 0;

  await radioPlayer.stop();
  await radioPlayer.clearAudioSources();

  radioPlaylist.clear();

  switchingToRadioNotifier();

  updateRadioScreensNotifier();

  if (radioPlayerPlaybackSpeedBottomSheetTabletContext != null) {
    Navigator.pop(radioPlayerPlaybackSpeedBottomSheetTabletContext!);
  }
}

Future<bool> checkStreamUrl(String url) async {
  try {
    final response =
        await http.head(Uri.parse(url)).timeout(const Duration(seconds: 5));

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
  stationHasBeenSearched = false;
  radioPlayer.setSpeed(1.0);
  isRadioPaused = false;
  currentRadioIndex = index;

  // Set the currentRadioStationID to avoid StreamBuilder won't updating the listview
  currentRadioStationID = radioStationList[index].id;

  turnOnRadioStation();
  if (!context.mounted) return;
  cleanPlaylist(context);

  // Clear and re-add all the radio_player stations to the "radioPlaylist"
  radioPlaylist.clear();
  for (var radioStation in radioStationList) {
    String radioStationUrl = radioStation.radioUrl;
    debugPrint("Radio URLS: $radioStationUrl");

    final mediaItem = MediaItem(
      id: radioStation.id,
      // album: metadata?.albumName ?? AppLocalizations.of(context)!.unknown_album,

      // Using the name of the file as the title by default
      title: radioStation.radioName,
      album: radioStation.radioLocation,
      // artist: metadata?.albumArtistName ?? AppLocalizations.of(context)!.unknown_artist,
      artUri: Uri.file(notificationPlayerAlbumArt.path),
    );

    radioPlaylist.add(
      AudioSource.uri(Uri.parse(radioStationUrl), tag: mediaItem),
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
      if (!context.mounted) return;
      errorToFetchRadioStationCard(
        context,
        radioStationList[index].radioName,
      );

      await turnOffRadioStation();
      await updateRadioScreensNotifier();
    }

    debugPrint('Error to load radio station: $e');
  }
  updateRadioScreensNotifier();
}

Future<void> playSearchedRadioStation(BuildContext context, int index) async {
  stationHasBeenSearched = true;
  radioPlayer.setSpeed(1.0);
  // isRadioPaused = false;
  turnOnRadioStation();
  cleanPlaylist(context);

  // Clear and re-add all the radio_player stations to the "radioPlaylist"
  radioPlaylist.clear();

  final mediaItem = MediaItem(
    id: foundStations[index].id,
    // album: metadata?.albumName ?? AppLocalizations.of(context)!.unknown_album,

    // Using the name of the file as the title by default
    title: foundStations[index].radioName,
    album: foundStations[index].radioLocation,
    // artist: metadata?.albumArtistName ?? AppLocalizations.of(context)!.unknown_artist,
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
      if (!context.mounted) return;
      errorToFetchRadioStationCard(
        context,
        radioStationList[index].radioName,
      );

      await turnOffRadioStation();
      await updateRadioScreensNotifier();
    }

    debugPrint('Error to load radio station: $e');
  }
}

Future<void> radioPlayOrPause() async {
  if (radioPlayer.audioSources.isNotEmpty) {
    if (isRadioPaused == false) {
      // isRadioPaused = true;
      await radioPlayer.pause();
    } else if (isRadioPaused == true) {
      // isRadioPaused = false;
      await radioPlayer.play();
    }
  }
}

Future<void> reLoadRatioStationCurrentIndex(BuildContext context) async {
  radioPlayer.setSpeed(1.0);
  // isRadioPaused = false;
  turnOnRadioStation();
  cleanPlaylist(context);

  // Clear and re-add all the radio_player stations to the "radioPlaylist"
  radioPlaylist.clear();

  final mediaItem = MediaItem(
    id: currentRadioStationID,
    // album: metadata?.albumName ?? AppLocalizations.of(context)!.unknown_album,

    // Using the name of the file as the title by default
    title: currentRadioStationName,
    album: currentRadioStationLocation.isEmpty
        ? AppLocalizations.of(context)!.ellipsis
        : currentRadioStationLocation,
    // artist: metadata?.albumArtistName ?? AppLocalizations.of(context)!.unknown_artist,
    artUri: Uri.file(notificationPlayerAlbumArt.path),
  );

  radioPlaylist.add(
    AudioSource.uri(Uri.parse(currentRadioIndexUrl), tag: mediaItem),
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

    // Combine two lists into one and iterate over and search for the current
    // radio_player url in two lists [radioStationList and foundStations]
    // to toggle the radio_player online signal icon
    for (RadioStationInfo station in [...radioStationList, ...foundStations]) {
      String stationUrl = station.radioUrl;
      if (stationUrl.contains(currentRadioIndexUrl)) {
        station.stationStatus = RadioStationConnectionStatus.online;
      }
    }
  } catch (e) {
    if (!await checkStreamUrl(currentRadioIndexUrl)) {
      // Combine two lists into one and iterate over and search for the current
      // radio_player url in two lists [radioStationList and foundStations]
      // to toggle the radio_player offline signal icon
      for (RadioStationInfo station in [
        ...radioStationList,
        ...foundStations,
      ]) {
        String stationId = station.radioUrl;
        if (stationId.contains(currentRadioIndexUrl)) {
          station.stationStatus = RadioStationConnectionStatus.error;
        }
      }

      if (!context.mounted) return;
      errorToFetchRadioStationCard(context, currentRadioStationName);

      await turnOffRadioStation();
      await updateRadioScreensNotifier();
    }

    debugPrint('Error to load radio_player: $e');
  }

  debugPrint("Checking current radio_player url: $currentRadioIndexUrl");
}
