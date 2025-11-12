import 'package:audio_service/audio_service.dart';
import 'package:flutter/cupertino.dart' show BuildContext, Color;
import 'package:flutter/foundation.dart' show debugPrint;
import 'package:flutter/material.dart' show Colors;
import 'package:just_audio/just_audio.dart';
import 'package:uuid/uuid.dart';
import 'package:vicyos_music/app/common/music_player/music.player.dart';
import 'package:vicyos_music/app/common/radio/radio.stream.notifiers.dart';
import 'package:vicyos_music/app/common/radio_stations/radio.stations.list.dart';

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
}

Future<void> turnOffRadioStation() async {
  isRadioOn = false;
  radioStationBtn = Color(0xFFFF0F7B);
  radioPlayer.clearAudioSources();
  radioPlaylist.clear();
  radioPlayer.stop();
  currentRadioIndex = 0;
  getCurrentSongFullPathStreamControllerNotifier();
  radioScreenStreamNotifier();
}

Future<void> playRadioStation(BuildContext context, int index) async {
  turnOnRadioStation();
  cleanPlaylist();

  // Clear and re-add all the radio stations to the "radioPlaylist"
  radioPlaylist.clear();
  for (var radioStation in radioStationList) {
    String radioStationUrl = radioStation.radioUrl;
    debugPrint("Radio URLS: $radioStationUrl");

    final mediaItem = MediaItem(
      id: const Uuid().v4(),
      // album: metadata?.albumName ?? 'Unknown Album',

      // Using the name of the file as the title by default
      title: radioStation.radioName,
      album: radioStation.radioInfo,
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
  } catch (e) {
    // if (context.mounted) {
    //   errorToFetchRadioStationCard(context, radioStationList[index].radioName);
    // }
    radioPlayer.seekToNext();
    debugPrint('Erro ao carregar a rádio: $e');
  }
  getCurrentSongFullPathStreamControllerNotifier();
}

// ------------ RADIO FUNCTIONS END --------------------//
