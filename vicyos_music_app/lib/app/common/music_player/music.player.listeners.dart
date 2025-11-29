// This function should be used on a flutter.initState or GetX.on_init_app();
import 'package:audio_service/audio_service.dart';
import 'package:flutter/foundation.dart';
import 'package:just_audio/just_audio.dart';
import 'package:vicyos_music/app/common/music_player/music.player.functions.and.more.dart';
import 'package:vicyos_music/app/common/music_player/music.player.stream.controllers.dart';

void audioPlayerStreamListeners() {
  // I will need to use another state listener other than!
  audioPlayer.positionStream.listen(
    (position) {
      currentSongDurationPosition = position;
      sleekCircularSliderPosition = position.inSeconds.toDouble();
    },
  );

  // Get the duration and the full duration of the song for the sleekCircularSlider
  audioPlayer.durationStream.listen(
    (duration) {
      currentSongTotalDuration = duration ?? Duration.zero;
      sleekCircularSliderDuration = duration?.inSeconds.toDouble() ?? 100.0;
    },
  );

  // Pause PlayerPreview if the main player is playing
  // to avoid simultaneous audio playback
  audioPlayer.playerStateStream.listen(
    (playerState) {
      if (audioPlayerPreview.state.toString() == "PlayerState.playing" &&
          playerState.playing == true) {
        audioPlayerPreview.pause();
      }

      if (playerState.processingState == ProcessingState.completed) {
        songIsPlaying = false;
      }

      if (playerState.processingState == ProcessingState.completed &&
          audioPlayer.loopMode == LoopMode.off) {
        audioPlayer.setAudioSources(
            preload: true,
            audioPlayer.audioSources,
            initialIndex: audioPlayer.currentIndex);
        audioPlayer.pause();
      }

      // Update the pause button if the player is interrupted
      if (playerState.playing == false &&
          playerState.processingState == ProcessingState.ready) {
        songIsPlaying = false;
      }

      // Update the play button when the player is playing or paused
      if (playerState.playing == false) {
        songIsPlaying = false;
      } else if (playerState.playing) {
        songIsPlaying = true;
      }
    },
  );

  // Get the current playlist index
  audioPlayer.playbackEventStream
      .map((sequenceState) => sequenceState.currentIndex)
      .distinct((prev, next) {
    return prev == next;
  }).listen((sourceIndex) {
    currentIndex = sourceIndex ?? 0;

    if (sourceIndex != null) {
      currentSongIndexNotifier();
      debugPrint("Playlist current index: $currentIndex");
    }
  });
}

// This function will update the display the song title one the audio or folder is imported
void preLoadSongName() {
  int? lastSongCurrentIndex;

  audioPlayer.currentIndexStream.listen((index) {
    if (lastSongCurrentIndex != index) {
      lastSongCurrentIndex = index;

      if (lastSongCurrentIndex != null) {
        if (index == null) return; // The song hasn't been loaded yet
        if (index < 0 || index >= audioPlayer.sequence.length) return;

        final currentMediaItem = audioPlayer.sequence[index].tag as MediaItem;

        currentSongName = currentMediaItem.title;
        currentSongArtistName = currentMediaItem.artist ?? "Unknown Artist";
        currentSongAlbumName = currentMediaItem.album ?? "Unknown Album";

        currentSongNameNotifier();
        currentSongAlbumNotifier();

        currentIndex = index;
      }
    }
  });
}

// This func should be used on a flutter.initState or GetX.on_init_app();
void audioPlayerPreviewEventStateStreamNotifier() {
  audioPlayerPreview.onPositionChanged.listen(
    (position) {
      currentSongDurationPositionPreview = position;
      sleekCircularSliderPositionPreview = position.inSeconds.toDouble();
    },
  );

  // Get the duration and the full duration of the song for the sleekCircularSlider
  audioPlayerPreview.onDurationChanged.listen(
    (duration) {
      currentSongTotalDurationPreview = duration;
      sleekCircularSliderDurationPreview = duration.inSeconds.toDouble();
    },
  );
}
