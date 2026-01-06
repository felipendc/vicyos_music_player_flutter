import 'package:audioplayers/audioplayers.dart' as audio_players;
import 'package:flutter/cupertino.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:vicyos_music/app/music_player/music.player.functions.and.more.dart';
import 'package:vicyos_music/app/music_player/music.player.listeners.dart';
import 'package:vicyos_music/app/radio_player/functions_and_streams/radio.functions.and.more.dart';
import 'package:vicyos_music/app/radio_player/functions_and_streams/radio.player.listeners.dart';

Future<void> onInitPlayer() async {
  // Init WidgetsBinding
  WidgetsFlutterBinding.ensureInitialized();

  // Init JustAudioBackground
  await JustAudioBackground.init(
    androidNotificationChannelId: 'com.ryanheise.bg_demo.channel.audio',
    androidNotificationChannelName: 'Vicyos Music',
    androidNotificationOngoing: true,
  );

  // Volume Control Listener
  initVolumeControl();

  // flutterSoundPlayer init
  await flutterSoundPlayer.openPlayer();

  // Song Preview Player.
  audioPlayerPreview = audio_players.AudioPlayer();
  audioPlayerPreview.setReleaseMode(audio_players.ReleaseMode.stop);
  audioPlayerPreviewEventStateStreamNotifier();
  audioPlayerPreviewListener();

  // Radio Player
  radioPlayer = AudioPlayer();
  radioPlayer.setLoopMode(LoopMode.all);
  audioPlayer = AudioPlayer();
  radioPlayerStreamListeners();

  // Music Player
  audioPlayer.setLoopMode(LoopMode.all);
  audioPlayerStreamListeners();

  // Set the default Media Notification Background
  await defaultAlbumArt();

  // Init current song name listener
  preLoadSongName();
}
