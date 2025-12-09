import 'package:audioplayers/audioplayers.dart' as audio_players;
import 'package:just_audio/just_audio.dart';
import 'package:vicyos_music/app/common/music_player/music.player.functions.and.more.dart';
import 'package:vicyos_music/app/common/music_player/music.player.listeners.dart';
import 'package:vicyos_music/app/common/radio_player/functions_and_streams/radio.functions.and.more.dart';
import 'package:vicyos_music/app/common/radio_player/functions_and_streams/radio.player.listeners.dart';

Future<void> onInitPlayer() async {
  initVolumeControl();

  // Song Preview Player.
  audioPlayerPreview = audio_players.AudioPlayer();
  audioPlayerPreview.setReleaseMode(audio_players.ReleaseMode.stop);
  audioPlayerPreviewEventStateStreamNotifier();

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
}
