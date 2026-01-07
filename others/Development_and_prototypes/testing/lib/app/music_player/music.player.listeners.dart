// This function should be used on a flutter.initState or GetX.on_init_app();

import 'package:audio_service/audio_service.dart';
import 'package:audioplayers/audioplayers.dart' as audio_players;
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:vicyos_music/app/build_flags/build.flags.dart';
import 'package:vicyos_music/app/music_player/music.player.functions.and.more.dart';
import 'package:vicyos_music/app/music_player/music.player.stream.controllers.dart';
import 'package:vicyos_music/l10n/app_localizations.dart';

void audioPlayerStreamListeners() {
  // Getting the current song path and its folder
  // Using Dart distinct()
  audioPlayer.sequenceStateStream
      .map((sequenceState) => sequenceState.currentSource)
      .where((src) {
        return src is UriAudioSource;
      })
      .map((src) {
        return src as UriAudioSource;
      })
      .distinct()
      .listen((gettingCurrentSource) {
        final currentSource = gettingCurrentSource;

        currentFolderPath = getCurrentSongFolder(currentSource.uri.toString());
        currentSongFullPath =
            getCurrentSongFullPath(currentSource.uri.toString());
      });

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

  // Pause PlayerPreview if the main audioPlayer is playing
  // to avoid simultaneous audio playback
  audioPlayer.playerStateStream.listen(
    (playerState) {
      if (audioPlayerPreview.state.toString() == "PlayerState.playing" &&
          playerState.playing == true) {
        audioPlayerPreview.pause();
      }

      // Pause flutterSoundPlayer when main player starts playing
      if (flutterSoundPlayer.isPlaying && playerState.playing == true) {
        flutterSoundPlayer.pausePlayer();
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
  });
}

void audioPlayerPreviewListener() {
  // Check if the audioPlayerPreview is playing, paused, or stopped
  audioPlayerPreview.onPlayerStateChanged.listen(
    (audio_players.PlayerState state) {
      if (state == audio_players.PlayerState.playing) {
        debugPrint("Playing");
        isPlayerPreviewPlaying = true;
      } else if (state == audio_players.PlayerState.paused) {
        debugPrint("Paused");
        isPlayerPreviewPlaying = false;
      } else if (state == audio_players.PlayerState.stopped) {
        debugPrint("Stopped");
        isPlayerPreviewPlaying = false;
      }
    },
  );
}

// Update and display the title, artist, album, and index of the song
void preLoadSongName() {
  int? lastSongCurrentIndex;

  audioPlayer.currentIndexStream.listen((index) {
    if (lastSongCurrentIndex != index) {
      lastSongCurrentIndex = index;

      if (lastSongCurrentIndex != null) {
        if (index == null) return; // The song hasn't been loaded yet
        if (index < 0 || index >= audioPlayer.sequence.length) return;
        final currentMediaItem = audioPlayer.sequence[index].tag as MediaItem;

        // Accessing the enum playedFromRoute from MediaItem extras
        songCurrentRouteType = currentMediaItem.extras?['playedFromRoute'];
        debugPrint("current song route type: $songCurrentRouteType");
        // If the navigationButtonsHasMiuiBehavior if disabled,
        // update the navigation buttons whenever the player changes the song index
        if (!navigationButtonsHasMiuiBehavior) {
          currentSongNavigationRouteNotifier();
        }

        currentSongName = currentMediaItem.title;
        // if (context.mounted) {
        //   currentSongArtistName = currentMediaItem.artist ??
        //       AppLocalizations.of(context)!.unknown_artist;
        // }
        // if (context.mounted) {
        //   currentSongAlbumName = currentMediaItem.album ??
        //       AppLocalizations.of(context)!.unknown_album;
        // }

        currentIndex = index;
        currentSongNameNotifier();
      }
    }
  });
}

// Learning purposes
// Update only once and display the title, artist, album, and index of the song
Future<void> updateCurrentSongNameOnlyOnce(BuildContext context) async {
  final index = audioPlayer.currentIndex;

  if (index == null) return; // The song hasn't been loaded yet
  if (index < 0 || index >= audioPlayer.sequence.length) return;
  final currentMediaItem = audioPlayer.sequence[index].tag as MediaItem;

  // Accessing the enum playedFromRoute from MediaItem extras
  songCurrentRouteType = currentMediaItem.extras?['playedFromRoute'];

  debugPrint("current song route type: $songCurrentRouteType");
  // If the navigationButtonsHasMiuiBehavior if disabled,
  // update the navigation buttons whenever the player changes the song index
  if (!navigationButtonsHasMiuiBehavior) {
    currentSongNavigationRouteNotifier();
  }

  currentSongName = currentMediaItem.title;
  if (context.mounted) {
    currentSongArtistName =
        currentMediaItem.artist ?? AppLocalizations.of(context)!.unknown_artist;
  }
  if (context.mounted) {
    currentSongAlbumName =
        currentMediaItem.album ?? AppLocalizations.of(context)!.unknown_album;
  }

  currentIndex = index;
  currentSongNameNotifier();
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
