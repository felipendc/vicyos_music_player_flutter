// ignore_for_file: avoid_print

import 'dart:io';
import 'dart:async';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:audio_service/audio_service.dart';
import 'package:flutter_media_metadata/flutter_media_metadata.dart';
import 'package:vicyos_music_player/app/controller/home.controller.dart';

final HomeController controller = Get.find<HomeController>();
late AudioPlayer audioPlayer;

void getSongName() {
  // TODO:
  final index = controller.playlist.value.children[audioPlayer.currentIndex!];
}

// This func should be used on a flutter.iniSstate or GetX.onInit();
void playerEventStateStreamListener() {
  // The player has completed playback
  audioPlayer.playerStateStream.listen((playerState) {
    if (playerState.processingState == ProcessingState.completed) {
      controller.songIsPlaying.value = false;
    }
  });
  // Get the current playlist index
  audioPlayer.playbackEventStream.listen((event) {
    controller.currentIndex?.value = event.currentIndex!;
  });

  //  Get current Songname using MediaItem tag.
  audioPlayer.currentIndexStream.listen((index) {
    if (index != null) {
      final currentMediaItem = audioPlayer.sequence![index].tag as MediaItem;
      controller.currentSongName.value = currentMediaItem.title;
      print(
          'Current audio name USING MEDIA_ITEM: ${controller.currentSongName.value}');
    }
  });
}

void cleanPlaylist() {
  // audioPlayer.pause();
  if (controller.playlist.value.length > 0) {
    if (controller.songIsPlaying.value) {
      controller.songIsPlaying.value = false;
    }
    controller.playlistIsEmpty.value = true;
    audioPlayer.setAudioSource(controller.playlist.value,
        initialIndex: 0, preload: true);
    controller.playlist.value.clear();
    pauseSong();
    print('IS SONG PLAYING? ${controller.songIsPlaying.value}');
  } else {
    controller.currentSongName.value = "";
  }
}

// void listenAudioPosition() {
//   // I will need to use another state listener otherthan!
//   // To display on a widget: Text('Current Time: ${formatDuration(currentPosition)} / ${formatDuration(totalDuration)}'),
//   audioPlayer.positionStream.listen((position) {
//     currentPosition = position;
//   });

//   audioPlayer.durationStream.listen((duration) {
//     totalDuration = duration ?? Duration.zero;
//   });
// }

// String formatDuration(Duration duration) {
//   final minutes = duration.inMinutes.remainder(60).toString().padLeft(2, '0');
//   final seconds = duration.inSeconds.remainder(60).toString().padLeft(2, '0');
//   return '$minutes:$seconds';
// }

void playOrPause() {
  if (controller.playlist.value.length == 0) {
    print("Playlist is EMPTY!");
    // await pickAndPlayAudio();
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

void nextSong() {
  audioPlayer.seekToNext();
}

void previousSong() {
  audioPlayer.seekToPrevious();
}

void forward() {
  audioPlayer.seek(audioPlayer.position + const Duration(seconds: 5));
}

void rewind() {
  audioPlayer.seek(audioPlayer.position - const Duration(seconds: 5));
}

void songSpeedRate1() {
  audioPlayer.setSpeed(1.0);
}

// This is a temp function, just for learning purpose...
void songSpeedRate2() {
  audioPlayer.setSpeed(2.0);
}

void repeatMode() {
  if (controller.currentLoopMode.value == LoopMode.off) {
    controller.currentLoopMode.value = LoopMode.one;
    controller.currentLoopModeLabel.value = "Repeat: One";
    print("Repeat One");
    audioPlayer.setLoopMode(LoopMode.one);
  } else if (controller.currentLoopMode.value == LoopMode.one) {
    controller.currentLoopMode.value = LoopMode.all;
    controller.currentLoopModeLabel.value = "Repeat: All";
    print("Repeat All");
    audioPlayer.setLoopMode(LoopMode.all);
  } else if (controller.currentLoopMode.value == LoopMode.all) {
    controller.currentLoopMode.value = LoopMode.off;
    controller.currentLoopModeLabel.value = "Repeat: Off";
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
    if (controller.playlist.value.length == 0) {
      for (String filePath in folderFileNames) {
        // Try to extract metadata from the local file
        File audioFile = File(filePath);
        String fileName = audioFile.uri.pathSegments.last;
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
          title: fileName,
          artist: metadata?.albumArtistName ?? 'Unknown Artist',
        );

        controller.playlist.value.add(AudioSource.uri(
          Uri.file(filePath),
          tag: mediaItem,
        ));
      }
      await audioPlayer.setAudioSource(controller.playlist.value,
          initialIndex: 0, preload: true);
      controller.playlistIsEmpty.value = false;
      // await playOrPause();
    } else {
      for (String filePath in folderFileNames) {
        // Try to extract metadata from the local file
        File audioFile = File(filePath);
        String fileName = audioFile.uri.pathSegments.last;
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
          title: fileName,
          artist: metadata?.albumArtistName ?? 'Unknown Artist',
        );

        controller.playlist.value.add(AudioSource.uri(
          Uri.file(filePath),
          tag: mediaItem,
        ));
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

    if (controller.playlist.value.length == 0) {
      for (String filePath in selectedSongs) {
        print('Processing file: $filePath');

        // Try to extract metadata from the local file
        File audioFile = File(filePath);
        String fileName = audioFile.uri.pathSegments.last;
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
          title: fileName,
          artist: metadata?.albumArtistName ?? 'Unknown Artist',
        );

        controller.playlist.value.add(AudioSource.uri(
          Uri.file(filePath),
          tag: mediaItem,
        ));
      }

      audioPlayer.setAudioSource(controller.playlist.value,
          initialIndex: 0, preload: true);
      controller.playlistIsEmpty.value = false;
      // await playOrPause();
    } else {
      for (String filePath in selectedSongs) {
        // Try to extract metadata from the local file
        File audioFile = File(filePath);
        String fileName = audioFile.uri.pathSegments.last;
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
          title: fileName,
          artist: metadata?.albumArtistName ?? 'Unknown Artist',
        );

        controller.playlist.value.add(AudioSource.uri(
          Uri.file(filePath),
          tag: mediaItem,
        ));

        print('Processing file: $filePath');
      }
    }
  }
}
