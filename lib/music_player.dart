// ignore_for_file: avoid_print

import 'package:file_picker/file_picker.dart';
import 'package:just_audio/just_audio.dart';
import 'dart:io';

late AudioPlayer audioPlayer;
bool isPlaying = false;
LoopMode currentLoopMode = LoopMode.off;
bool songIsPlaying = false;
bool isStopped = false;

ConcatenatingAudioSource playlist = ConcatenatingAudioSource(
  useLazyPreparation: false,
  shuffleOrder: DefaultShuffleOrder(),
  // Specify the playlist items
  children: [],
);

Future<void> playOrPause() async {
  if (playlist.length == 0) {
    print("Playlist is EMPTY!");
    // await pickAndPlayAudio();
  } else {
    if (songIsPlaying == false) {
      songIsPlaying = !songIsPlaying;
      await audioPlayer.play();
    } else if (songIsPlaying == true) {
      songIsPlaying = !songIsPlaying;
      await audioPlayer.pause();
    }
  }

  audioPlayer.playerStateStream.listen((playerState) {
    final playing = playerState.playing;
    final processingState = playerState.processingState;

    if (playing) {
      // The player is playing
      print('Playing');
      // audioPlayer.pause();
    }

    if (processingState == ProcessingState.ready) {
      // The player is paused
      print('Paused');
      // audioPlayer.play();
    }

    if (processingState == ProcessingState.completed) {
      // The player has completed playback
      print('Completed');
      // audioPlayer.play();
    } else {
      // Other states (idle, buffering, etc.)
      print('Other state: $processingState');
    }
  });
}

void playSong() async {
  songIsPlaying = true;
  await audioPlayer.play();
}

void pauseSong() async {
  songIsPlaying = false;
  await audioPlayer.pause();
}

void stopSong() {
  songIsPlaying = false;
  isStopped = true;
  audioPlayer.stop();
}

void nextSong() {
  songIsPlaying = false;
  audioPlayer.seekToNext();
  playOrPause();
}

void previousSong() {
  songIsPlaying = false;
  audioPlayer.seekToPrevious();
  playOrPause();
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

void repeatMode() async {
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
      for (var file in folderFileNames) {
        playlist.add(AudioSource.uri(Uri.file(file)));
      }
      audioPlayer.setAudioSource(playlist);
      await playOrPause();
    } else {
      for (var file in folderFileNames) {
        playlist.add(AudioSource.uri(Uri.file(file)));
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
      for (var filePath in selectedSongs) {
        print('Processing file: $filePath');
        playlist.add(AudioSource.uri(Uri.file(filePath)));
      }

      audioPlayer.setAudioSource(playlist);
      await playOrPause();
    } else {
      for (var filePath in selectedSongs) {
        playlist.add(AudioSource.uri(Uri.file(filePath)));
        print('Processing file: $filePath');
      }
    }
  }
}
