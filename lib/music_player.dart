// ignore_for_file: avoid_print

import 'dart:async';

import 'package:file_picker/file_picker.dart';
import 'package:just_audio/just_audio.dart';
import 'package:audio_service/audio_service.dart';
import 'package:flutter_media_metadata/flutter_media_metadata.dart';
import 'dart:io';

late AudioPlayer audioPlayer;
bool isPlaying = false;
LoopMode currentLoopMode = LoopMode.off;
bool songIsPlaying = false;
bool isStopped = false;
Duration currentPosition = Duration.zero;
Duration totalDuration = Duration.zero;

ConcatenatingAudioSource playlist = ConcatenatingAudioSource(
  useLazyPreparation: false,
  shuffleOrder: DefaultShuffleOrder(),
  // Specify the playlist items
  children: [],
);

void cleanPlaylist() {
  // audioPlayer.pause();
  if (playlist.length > 0) {
    if (songIsPlaying) {
      songIsPlaying = false;
    }

    audioPlayer.setAudioSource(playlist, initialIndex: 0, preload: true);
    playlist.clear();
    pauseSong();
    print('IS IT PLAYING? $isPlaying');
  }
}

void currenSongName() {
  audioPlayer.currentIndexStream.listen((index) {
    if (index != null) {
      final currentMediaItem = audioPlayer.sequence![index].tag as MediaItem;
      print('Current audio name USING MEDIA_ITEM: ${currentMediaItem.title}');
    }
  });
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

Future<void> playOrPause() async {
  if (playlist.length == 0) {
    print("Playlist is EMPTY!");
    // await pickAndPlayAudio();
  } else {
    if (songIsPlaying == false) {
      songIsPlaying = true;
      isStopped = false;
      await audioPlayer.play();
    } else if (songIsPlaying == true) {
      songIsPlaying = !songIsPlaying;
      await audioPlayer.pause();
    }

    currenSongName();
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
//   songIsPlaying = true;
//   await audioPlayer.play();
// }

Future<void> pauseSong() async {
  songIsPlaying = false;
  await audioPlayer.pause();
}

void stopSong() {
  songIsPlaying = false;
  isStopped = true;
  audioPlayer.stop();
}

Future<void> nextSong() async {
  // songIsPlaying = true;
  await audioPlayer.seekToNext();
  // await playOrPause();
}

Future<void> previousSong() async {
  // songIsPlaying = false;
  await audioPlayer.seekToPrevious();
  // await playOrPause();
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

Future<void> repeatMode() async {
  if (currentLoopMode == LoopMode.off) {
    currentLoopMode = LoopMode.one;
    print("Repeat One");
    await audioPlayer.setLoopMode(LoopMode.one);
  } else if (currentLoopMode == LoopMode.one) {
    currentLoopMode = LoopMode.all;
    print("Repeat All");
    await audioPlayer.setLoopMode(LoopMode.all);
  } else if (currentLoopMode == LoopMode.all) {
    currentLoopMode = LoopMode.off;
    print("Repeat Off");
    await audioPlayer.setLoopMode(LoopMode.off);
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
    if (playlist.length == 0) {
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

        playlist.add(AudioSource.uri(
          Uri.file(filePath),
          tag: mediaItem,
        ));
      }
      await audioPlayer.setAudioSource(playlist);
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

        playlist.add(AudioSource.uri(
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

    if (playlist.length == 0) {
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

        playlist.add(AudioSource.uri(
          Uri.file(filePath),
          tag: mediaItem,
        ));
      }

      audioPlayer.setAudioSource(playlist);
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

        playlist.add(AudioSource.uri(
          Uri.file(filePath),
          tag: mediaItem,
        ));
        print('Processing file: $filePath');
      }
    }
  }
}
