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

void cleanPlaylist() {
  // controller.audioPlayer.pause();
  if (controller.playlist.value.length > 0) {
    if (controller.songIsPlaying.value) {
      controller.songIsPlaying.value = false;
    }
    controller.playlistIsEmpty.value = true;
    controller.audioPlayer.setAudioSource(controller.playlist.value,
        initialIndex: 0, preload: true);
    controller.playlist.value.clear();
    pauseSong();
    print('IS SONG PLAYING? ${controller.songIsPlaying.value}');
  }
}

void currenSongName() {
  controller.audioPlayer.currentIndexStream.listen((index) {
    if (index != null) {
      final currentMediaItem =
          controller.audioPlayer.sequence![index].tag as MediaItem;
      print('Current audio name USING MEDIA_ITEM: ${currentMediaItem.title}');
    }
  });
}

// void listenAudioPosition() {
//   // I will need to use another state listener otherthan!
//   // To display on a widget: Text('Current Time: ${formatDuration(currentPosition)} / ${formatDuration(totalDuration)}'),
//   controller.audioPlayer.positionStream.listen((position) {
//     currentPosition = position;
//   });

//   controller.audioPlayer.durationStream.listen((duration) {
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
      controller.audioPlayer.play();
    } else if (controller.songIsPlaying.value == true) {
      controller.songIsPlaying.value = !controller.songIsPlaying.value;
      controller.audioPlayer.pause();
    }
    print('IS THE SONG PLAYING? ${controller.songIsPlaying.value}');
    currenSongName();
  }

  // controller.audioPlayer.playerStateStream.listen((playerState) {
  //   final playing = playerState.playing;
  //   final processingState = playerState.processingState;

  //   if (playing) {
  //     // The player is playing
  //     print('Playing');
  //     // controller.audioPlayer.pause();
  //   }

  //   if (processingState == ProcessingState.ready) {
  //     // The player is paused
  //     print('Paused');
  //     // controller.audioPlayer.play();
  //   }

  //   if (processingState == ProcessingState.completed) {
  //     // The player has completed playback
  //     print('Completed');
  //     // controller.audioPlayer.play();
  //   } else {
  //     // Other states (idle, buffering, etc.)
  //     print('Other state: $processingState');
  //   }
  // });
}

// void playSong() async {
//   controller.songIsPlaying.value = true;
//   await controller.audioPlayer.play();
// }

void pauseSong() {
  controller.songIsPlaying.value = false;
  controller.audioPlayer.pause();
}

void stopSong() {
  controller.songIsPlaying.value = false;
  controller.isStopped.value = true;
  controller.audioPlayer.stop();
}

void nextSong() {
  // controller.songIsPlaying.value = true;
  controller.audioPlayer.seekToNext();
  controller.audioPlayer.hasNext
      ? controller.hasNextSong.value = true
      : controller.hasNextSong.value = false;
  controller.audioPlayer.hasPrevious
      ? controller.hasPreviousSong.value = true
      : controller.hasPreviousSong.value = false;
  // await playOrPause();
}

void previousSong() {
  // controller.songIsPlaying.value = false;
  controller.audioPlayer.seekToPrevious();
  controller.audioPlayer.hasNext
      ? controller.hasNextSong.value = true
      : controller.hasNextSong.value = false;
  controller.audioPlayer.hasPrevious
      ? controller.hasPreviousSong.value = true
      : controller.hasPreviousSong.value = false;
  // await playOrPause();
}

void forward() {
  controller.audioPlayer
      .seek(controller.audioPlayer.position + const Duration(seconds: 5));
}

void rewind() {
  controller.audioPlayer
      .seek(controller.audioPlayer.position - const Duration(seconds: 5));
}

void songSpeedRate1() {
  controller.audioPlayer.setSpeed(1.0);
}

// This is a temp function, just for learning purpose...
void songSpeedRate2() {
  controller.audioPlayer.setSpeed(2.0);
}

void repeatMode() {
  if (controller.currentLoopMode.value == LoopMode.off) {
    controller.currentLoopMode.value = LoopMode.one;
    controller.currentLoopModeLabel.value = "Repeat: One";
    print("Repeat One");
    controller.audioPlayer.setLoopMode(LoopMode.one);
  } else if (controller.currentLoopMode.value == LoopMode.one) {
    controller.currentLoopMode.value = LoopMode.all;
    controller.currentLoopModeLabel.value = "Repeat: All";
    print("Repeat All");
    controller.audioPlayer.setLoopMode(LoopMode.all);
  } else if (controller.currentLoopMode.value == LoopMode.all) {
    controller.currentLoopMode.value = LoopMode.off;
    controller.currentLoopModeLabel.value = "Repeat: Off";
    print("Repeat Off");
    controller.audioPlayer.setLoopMode(LoopMode.off);
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
      await controller.audioPlayer.setAudioSource(controller.playlist.value);
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

      controller.audioPlayer.setAudioSource(controller.playlist.value);
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
