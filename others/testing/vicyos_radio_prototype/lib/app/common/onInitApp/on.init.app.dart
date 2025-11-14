import 'package:audioplayers/audioplayers.dart' as audio_players;
import 'package:flutter/cupertino.dart';
import 'package:just_audio/just_audio.dart';
import 'package:vicyos_music/app/common/music_player/music.player.dart'
    show
        initVolumeControl,
        radioPlayer,
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
        currentIndex,
        currentRadioIndex,
        radioPlaylist,
        currentRadioStationName;

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

  // FAZER DEPOIS!
  // Update radio stations list screen
  radioPlayer.playbackEventStream.listen(
    (event) {
      currentIndex = event.currentIndex ?? 0;
      debugPrint("INDEX RADIO ATUAL: $currentIndex");

      currentRadioIndex =
          (radioPlayer.audioSources.isEmpty || radioPlaylist.isEmpty)
              ? currentIndex = 0
              : currentIndex += 1;
      getCurrentSongFullPathStreamControllerNotifier();
    },
  );
}
