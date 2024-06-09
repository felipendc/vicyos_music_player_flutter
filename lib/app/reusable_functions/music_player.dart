// ignore_for_file: avoid_print

import 'dart:io';

import 'dart:async';
import 'package:flutter_media_metadata/flutter_media_metadata.dart';
import 'package:get/get.dart';

import 'package:path/path.dart' as path;
import 'package:just_audio/just_audio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:audio_service/audio_service.dart';
import 'package:vicyos_music_player/app/controller/home.controller.dart';

final HomeController controller = Get.find<HomeController>();
late AudioPlayer audioPlayer;

// This func should be used on a flutter.initState or GetX.onInit();
void playerEventStateStreamListener() {
  // I will need to use another state listener otherthan!
  // To display on a widget: Text('Current Time: ${formatDuration(currentPosition)} / ${formatDuration(songTotalDuration)}'),
  audioPlayer.positionStream.listen((position) {
    controller.currentSongDurationPostion.value = position;
    controller.sleekCircularSliderPosition.value =
        position.inSeconds.toDouble();
  });

  audioPlayer.durationStream.listen((duration) {
    controller.currentSongTotalDuration.value = duration ?? Duration.zero;
    controller.sleekCircularSliderDuration.value =
        duration?.inSeconds.toDouble() ?? 100.0;
  });

  // The player has completed playback
  audioPlayer.playerStateStream.listen((playerState) {
    if (playerState.processingState == ProcessingState.completed) {
      controller.songIsPlaying.value = false;
    }
  });

  // Update the pause button if the player is interrupted
  audioPlayer.playerStateStream.listen((state) {
    if (state.playing == false &&
        state.processingState == ProcessingState.ready) {
      controller.songIsPlaying.value = false;
    }
  });

  // Get the current playlist index
  audioPlayer.playbackEventStream.listen((event) {
    controller.currentIndex.value = event.currentIndex!;
    File audioFile =
        File(controller.audioSources[event.currentIndex!] as String);
    String fileName = audioFile.uri.pathSegments.last;
    String fileNameWithoutExtension = path.basenameWithoutExtension(fileName);
    controller.currentSongName.value = fileNameWithoutExtension;
  });

  // Get the current songe name
  audioPlayer.currentIndexStream.listen((index) {
    final audioFile = audioPlayer.sequence![index!] as File;
    String fileName = audioFile.uri.pathSegments.last;
    final String fileNameWithoutExtension =
        path.basenameWithoutExtension(fileName);
    controller.currentSongName.value = fileNameWithoutExtension;
    if (fileNameWithoutExtension.length < 21) {
      controller.currentSongNameTrimmed.value = fileNameWithoutExtension;
    } else {
      controller.currentSongNameTrimmed.value =
          "${fileNameWithoutExtension.substring(0, 30)}..."; // Return the first 30 characters of the input
    }
  });

  //  Get current Songname using MediaItem tag.
  // audioPlayer.currentIndexStream.listen((index) {
  //   final currentMediaItem = audioPlayer.sequence![index!].tag as MediaItem;
  //   controller.currentSongName.value = currentMediaItem.title;
  //   controller.currentSongArtistName.value = currentMediaItem.artist!;
  //   controller.currentSongAlbumName.value = currentMediaItem.album!;

  // if (currentMediaItem.title.length < 21) {
  //   controller.currentSongNameTrimmed.value = currentMediaItem.title;
  // } else {
  //   controller.currentSongNameTrimmed.value =
  //       "${currentMediaItem.title.substring(0, 30)}..."; // Return the first 30 characters of the input
  // }
  // print(controller.currentSongNameTrimmed.value);

  // print(
  //     'Current audio name USING MEDIA_ITEM: ${controller.currentSongName.value}');
//   });
}

String trimName(String song) {
  if (controller.audioSources.isEmpty) {
    return "The playlist is empty";
  } else {
    if (song.length < 5) {
      return controller.currentSongNameTrimmed.value = song;
    } else {
      return controller.currentSongNameTrimmed.value =
          "${song.substring(0, 30)}..."; // Return the first 30 characters of the input
    }
  }
}

// This function will update the display the song title one the audio or folder is imported
void preLoadSongName() {
  audioPlayer.currentIndexStream.listen((index) {
    final currentMediaItem = audioPlayer.sequence![index!].tag as MediaItem;
    controller.currentSongName.value = currentMediaItem.title;
    controller.currentSongArtistName.value = currentMediaItem.artist!;
    controller.currentSongAlbumName.value = currentMediaItem.album!;

    if (currentMediaItem.title.length < 21) {
      controller.currentSongNameTrimmed.value = currentMediaItem.title;
    } else {
      controller.currentSongNameTrimmed.value =
          "${currentMediaItem.title.substring(0, 30)}..."; // Return the first 30 characters of the input
    }
  });
}

// Format song duration.
String formatDuration(Duration duration) {
  final hours = (duration.inHours % 24).toString().padLeft(2, '0');
  final minutes = duration.inMinutes.remainder(60).toString().padLeft(2, '0');
  final seconds = duration.inSeconds.remainder(60).toString().padLeft(2, '0');
  if (duration.inHours >= 1) {
    return '$hours:$minutes:$seconds';
  } else {
    return '$minutes:$seconds';
  }
}

void cleanPlaylist() {
  if (controller.audioSources.isEmpty) {
    if (controller.songIsPlaying.value) {
      controller.songIsPlaying.value = false;
    }

    controller.playlistIsEmpty.value = true;
    audioPlayer.setAudioSource(controller.playlist,
        initialIndex: 0, preload: true);
    controller.audioSources.clear();
    controller.currentSongName.value = "The playlist is empty";
    controller.currentSongNameTrimmed.value = "The playlist is empty";

    controller.currentSongArtistName.value = "Unknown Artist";
    controller.currentSongAlbumName.value = "Unknown Album";
    pauseSong();
    print('CLEAN LIST!!! IS SONG PLAYING? ${controller.songIsPlaying.value}');
  }
}

void playOrPause() {
  if (controller.audioSources.isEmpty) {
    print("The playlist is EMPTY");
  } else {
    if (controller.songIsPlaying.value == false) {
      controller.songIsPlaying.value = true;
      controller.isStopped.value = false;
      audioPlayer.play();
    } else if (controller.songIsPlaying.value == true) {
      controller.songIsPlaying.value = !controller.songIsPlaying.value;
      audioPlayer.pause();
    }
    print('IS THE SONG PLAYING? ${controller.songIsPlaying.value}');
    print('Song: : ${controller.currentSongName.value}');
  }

  // audioPlayer.playerStateStream.listen((playerState) {
  //   final playing = playerState.playing;
  //   final processingState = playerState.processingState;

  //   if (playing) {
  //     // The player is playing
  //     print('Playing');
  //     // audioPlayer.pause();
  //   }

  //   if (processingState == ProcessingState.ready) {
  //     // The player is paused
  //     print('Paused');
  //     // audioPlayer.play();
  //   }

  //   if (processingState == ProcessingState.completed) {
  //     // The player has completed playback
  //     print('Completed');
  //     // audioPlayer.play();
  //   } else {
  //     // Other states (idle, buffering, etc.)
  //     print('Other state: $processingState');
  //   }
  // });
}

// void playSong() async {
//   controller.songIsPlaying.value = true;
//   await audioPlayer.play();
// }

void pauseSong() {
  controller.songIsPlaying.value = false;
  audioPlayer.pause();
}

void stopSong() {
  controller.songIsPlaying.value = false;
  controller.isStopped.value = true;
  audioPlayer.stop();
}

Future<void> nextSong() async {
  print('LIST TOTAL ITEM.${controller.audioSources.length}');

  await audioPlayer.seekToNext();
  if (controller.currentIndex.value > 0) {
    controller.firstSongIndex.value = false;
    print('INDEX IS GRATER THAN 0!');
  }

  if (controller.currentIndex.value == controller.audioSources.length - 1) {
    controller.lastSongIndex.value = true;
    print('INDEX IS THE LAST');
  } else {
    controller.lastSongIndex.value = false;
  }
}

Future<void> previousSong() async {
  print('LIST TOTAL ITEM.${controller.audioSources.length}');
  if (controller.currentIndex.value == 0) {
    controller.firstSongIndex.value = true;
    print('INDEX IS EQUAL TO 0!');
  }

  if (controller.currentIndex.value > 0) {
    controller.firstSongIndex.value = false;
    print('INDEX IS GRATER THAN 0!');
  }

  await audioPlayer.seekToPrevious();

  if (controller.currentIndex.value == controller.audioSources.length - 2) {
    controller.penultimateSongIndex.value = true;
    print('INDEX IS THE PENULTIMATE ####');
  } else {
    controller.penultimateSongIndex.value = false;
    print('INDEX IS NO LONGER THE PENULTIMATE ####');
  }
}

void forward() {
  audioPlayer.seek(audioPlayer.position + const Duration(seconds: 5));
}

void rewind() {
  audioPlayer.position > const Duration(seconds: 5)
      ? audioPlayer.seek(audioPlayer.position - const Duration(seconds: 5))
      : audioPlayer.seek(Duration.zero);
}

// This is a temp function, just for learning purpose...
// void songSpeedRate2() {
//   audioPlayer.setSpeed(2.0);
// }

void repeatMode() {
  if (controller.currentLoopMode.value == LoopMode.off) {
    controller.currentLoopMode.value = LoopMode.one;
    controller.currentLoopModeIcone.value = "assets/img/repeat_one.png";
    // controller.currentLoopModeLabel.value = "Repeat: One";

    print("Repeat One");
    audioPlayer.setLoopMode(LoopMode.one);
  } else if (controller.currentLoopMode.value == LoopMode.one) {
    controller.currentLoopMode.value = LoopMode.all;
    controller.currentLoopModeIcone.value = "assets/img/repeat_all.png";
    // controller.currentLoopModeLabel.value = "Repeat: All";
    print("Repeat All");
    audioPlayer.setLoopMode(LoopMode.all);
  } else if (controller.currentLoopMode.value == LoopMode.all) {
    controller.currentLoopMode.value = LoopMode.off;
    controller.currentLoopModeIcone.value = "assets/img/repeat_none.png";
    // controller.currentLoopModeLabel.value = "Repeat: Off";
    print("Repeat Off");
    audioPlayer.setLoopMode(LoopMode.off);
  }
}

Future<void> pickFolder() async {
  String? selectedDirectory = await FilePicker.platform.getDirectoryPath();
  List<String> folderFileNames = [];
  final allowedExtensions = ["mp3", "m4a", "ogg", "wav", "aac", "midi"];

  if (selectedDirectory != null) {
    selectedDirectory = selectedDirectory;
    final dir = Directory(selectedDirectory);
    final files = dir.listSync();
    folderFileNames = files
        .where((file) =>
            file is File &&
            allowedExtensions.any((ext) => file.path.endsWith('.$ext')))
        .map((file) => file.path)
        .toList();

    print(folderFileNames);
    if (controller.audioSources.isEmpty) {
      for (String filePath in folderFileNames) {
        // Try to extract metadata from the local file
        File audioFile = File(filePath);
        String fileName = audioFile.uri.pathSegments.last;
        String fileNameWithoutExtension =
            path.basenameWithoutExtension(fileName);
        String filePathAsId = audioFile.absolute.path;

        Metadata? metadata;

        try {
          metadata = await MetadataRetriever.fromFile(audioFile);
        } catch (e) {
          print('Failed to extract metadata: $e');
        }

        final mediaItem = MediaItem(
          id: filePathAsId,
          album: metadata?.albumName ?? 'Unknown Album',

          // Using the name of the file as the title by default
          title: fileNameWithoutExtension,
          artist: metadata?.albumArtistName ?? 'Unknown Artist',
        );

        controller.playlist.add(
          AudioSource.uri(
            Uri.file(filePath),
            tag: mediaItem,
          ),
        );
        controller.playlistLength.value = controller.audioSources.length;
      }
      await audioPlayer.setAudioSource(controller.playlist,
          initialIndex: 0, preload: true);
      controller.playlistIsEmpty.value = false;
      controller.firstSongIndex.value = true;
      preLoadSongName();

      // await playOrPause();
    } else {
      for (String filePath in folderFileNames) {
        // Try to extract metadata from the local file
        File audioFile = File(filePath);
        String fileName = audioFile.uri.pathSegments.last;
        String fileNameWithoutExtension =
            path.basenameWithoutExtension(fileName);
        String filePathAsId = audioFile.absolute.path;

        Metadata? metadata;

        try {
          metadata = await MetadataRetriever.fromFile(audioFile);
        } catch (e) {
          print('Failed to extract metadata: $e');
        }

        final mediaItem = MediaItem(
          id: filePathAsId,
          album: metadata?.albumName ?? 'Unknown Album',

          // Using the name of the file as the title by default
          title: fileNameWithoutExtension,
          artist: metadata?.albumArtistName ?? 'Unknown Artist',
        );

        controller.playlist.add(
          AudioSource.uri(
            Uri.file(filePath),
            tag: mediaItem,
          ),
        );
        controller.playlistLength.value = controller.audioSources.length;
      }
    }
  } else {
    print("No folder has been selected");
  }
}

Future<void> pickAndPlayAudio() async {
  FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowMultiple: true,
      allowedExtensions: ["mp3", "m4a", "ogg", "wav", "aac", "midi"]);

  if (result != null) {
    List<String>? selectedSongs;
    selectedSongs =
        result.paths.where((path) => path != null).cast<String>().toList();

    if (controller.audioSources.isEmpty) {
      for (String filePath in selectedSongs) {
        print('Processing file: $filePath');

        // Try to extract metadata from the local file
        File audioFile = File(filePath);
        String fileName = audioFile.uri.pathSegments.last;
        String fileNameWithoutExtension =
            path.basenameWithoutExtension(fileName);
        String filePathAsId = audioFile.absolute.path;

        Metadata? metadata;

        try {
          metadata = await MetadataRetriever.fromFile(audioFile);
        } catch (e) {
          print('Failed to extract metadata: $e');
        }

        final mediaItem = MediaItem(
          id: filePathAsId,
          album: metadata?.albumName ?? 'Unknown Album',

          // Using the name of the file as the title by default
          title: fileNameWithoutExtension,
          artist: metadata?.albumArtistName ?? 'Unknown Artist',
        );

        controller.playlist.add(
          AudioSource.uri(
            Uri.file(filePath),
            tag: mediaItem,
          ),
        );
        controller.playlistLength.value = controller.audioSources.length;
      }

      audioPlayer.setAudioSource(controller.playlist,
          initialIndex: 0, preload: true);
      controller.playlistIsEmpty.value = false;
      controller.firstSongIndex.value = true;
      preLoadSongName();

      // await playOrPause();
    } else {
      for (String filePath in selectedSongs) {
        // Try to extract metadata from the local file
        File audioFile = File(filePath);
        String fileName = audioFile.uri.pathSegments.last;
        String fileNameWithoutExtension =
            path.basenameWithoutExtension(fileName);
        String filePathAsId = audioFile.absolute.path;

        Metadata? metadata;

        try {
          metadata = await MetadataRetriever.fromFile(audioFile);
        } catch (e) {
          print('Failed to extract metadata: $e');
        }

        final mediaItem = MediaItem(
          id: filePathAsId,
          album: metadata?.albumName ?? 'Unknown Album',

          // Using the name of the file as the title by default
          title: fileNameWithoutExtension,
          artist: metadata?.albumArtistName ?? 'Unknown Artist',
        );

        controller.playlist.add(AudioSource.uri(
          Uri.file(filePath),
          tag: mediaItem,
        ));
        controller.playlistLength.value = controller.audioSources.length;
        print('Processing file: $filePath');
      }
    }
  }
}
