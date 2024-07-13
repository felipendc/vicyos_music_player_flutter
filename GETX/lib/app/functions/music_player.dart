import 'dart:io';
import 'dart:async';
import 'package:flutter_media_metadata/flutter_media_metadata.dart';
import 'package:get/get.dart';
import 'package:path/path.dart' as path;
import 'package:just_audio/just_audio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:audio_service/audio_service.dart';
import 'package:vicyos_music_player/app/controller/home.controller.dart';
import 'package:vicyos_music_player/app/widgets/snackbar.dart';
import 'package:volume_controller/volume_controller.dart';

final HomeController controller = Get.find<HomeController>();
late AudioPlayer audioPlayer;
late final MediaItem mediaItem;

void initVolumeControl() async {
  VolumeController().listener((volume) {
    controller.volumeSliderValue.value = volume * 100;
  });
  double currentVolume = await VolumeController().getVolume();
  controller.volumeSliderValue.value = (currentVolume * 100);
}

void setVolume(double value) {
  double volume = value / 100;
  // Set the volume and keep the system volume UI hidden
  VolumeController().setVolume(volume, showSystemUI: false);
}

// This func should be used on a flutter.initState or GetX.onInit();
void playerEventStateStreamListener() {
  // I will need to use another state listener otherthan!
  // To display on a widget: Text('Current Time: ${formatDuration(currentPosition)} / ${formatDuration(songTotalDuration)}'),
  audioPlayer.positionStream.listen((position) {
    controller.currentSongDurationPostion.value = position;
    controller.sleekCircularSliderPosition.value =
        position.inSeconds.toDouble();
  });

  // Get the duration and the full duration of the song for the sleekCircularSlider
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

    // Update the pause button if the player is interrupted
    if (playerState.playing == false &&
        playerState.processingState == ProcessingState.ready) {
      controller.songIsPlaying.value = false;
    }

    // Update the play button when the player is playing or paused
    if (playerState.playing == false) {
      controller.songIsPlaying.value = false;
    } else if (playerState.playing) {
      controller.songIsPlaying.value = true;
    }
  });

  // Get the current playlist index
  audioPlayer.playbackEventStream.listen((event) {
    controller.currentIndex.value = event.currentIndex!;
  });
}

// This function will update the display the song title one the audio or folder is imported
void preLoadSongName() {
  audioPlayer.currentIndexStream.listen((index) {
    final currentMediaItem = audioPlayer.sequence![index!].tag as MediaItem;
    controller.currentSongName.value = currentMediaItem.title;
    controller.currentSongArtistName.value = currentMediaItem.artist!;
    controller.currentSongAlbumName.value = currentMediaItem.album!;
    controller.currentIndex.value = index;
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

Future<void> cleanPlaylist() async {
  // if (controller.audioSources.isNotEmpty) {
  audioPlayer.stop();
  controller.songIsPlaying.value = false;
  await controller.playlist.clear();
  controller.currentIndex.value = 0;
  controller.playlistLength.value = controller.audioSources.length;
  controller.currentSongDurationPostion.value = Duration.zero;
  controller.currentSongTotalDuration.value = Duration.zero;
  controller.sleekCircularSliderPosition.value = 0.0;
  controller.currentSongName.value = "The playlist is empty";
  controller.currentSongArtistName.value = "Unknown Artist";
  controller.currentSongAlbumName.value = "Unknown Album";
  // print('CLEAN LIST!!! IS SONG PLAYING? ${controller.songIsPlaying.value}');
  // }
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
}

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

void repeatMode() {
  if (controller.currentLoopMode.value == LoopMode.all) {
    controller.currentLoopMode.value = LoopMode.one;
    audioPlayer.setLoopMode(LoopMode.one);
    controller.currentLoopModeIcone.value = "assets/img/repeat_one.png";
    repeatModeSnackbar(
      message: "Repeat: One",
      iconePath: controller.currentLoopModeIcone.value,
    );

    print("Repeat: One");
  } else if (controller.currentLoopMode.value == LoopMode.one) {
    controller.currentLoopMode.value = LoopMode.off;
    audioPlayer.setLoopMode(LoopMode.off);
    controller.currentLoopModeIcone.value = "assets/img/repeat_none.png";
    repeatModeSnackbar(
      message: "Repeat: Off",
      iconePath: controller.currentLoopModeIcone.value,
    );

    print("Repeat: Off");
  } else if (controller.currentLoopMode.value == LoopMode.off) {
    controller.currentLoopMode.value = LoopMode.all;
    audioPlayer.setLoopMode(LoopMode.all);
    controller.currentLoopModeIcone.value = "assets/img/repeat_all.png";

    repeatModeSnackbar(
      message: "Repeat All",
      iconePath: controller.currentLoopModeIcone.value,
    );
    // controller.currentLoopModeLabel.value = "Repeat: All";
    print("Repeat All");
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
