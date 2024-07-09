import 'dart:io';
import 'dart:async';
import 'package:flutter_media_metadata/flutter_media_metadata.dart';
import 'package:get/get.dart';
import 'package:path/path.dart' as path;
import 'package:just_audio/just_audio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:audio_service/audio_service.dart';
import 'package:vicyos_music_player/app/controller/home.controller.dart';
import 'package:vicyos_music_player/app/models/folder.sources.dart';
import 'package:vicyos_music_player/app/widgets/snackbar.dart';
import 'package:volume_controller/volume_controller.dart';

//
int playlistLengths = 0;
//
bool isFirstArtDemoCover = true;
String currentLoopModeIcone = 'assets/img/repeat_all.png';
var volumeSliderValue = 50.0;
String currentSongAlbumName = 'Unknown Album'; //temp
String currentSongName = 'The playlist is empty'; //temp
Duration currentSongDurationPostion = Duration.zero; //temp
Duration currentSongTotalDuration = Duration.zero; //temp
double sleekCircularSliderPosition = 0.0; //temp
double sleekCircularSliderDuration = 100.0; //temp
bool playlistIsEmpty = true; //temp
List<FolderSources> musicFolderPaths = <FolderSources>[];
//
List<AudioSource> audioSources = <AudioSource>[];
late ConcatenatingAudioSource playlist;
final HomeController controller = Get.find<HomeController>();
late AudioPlayer audioPlayer;
late final MediaItem mediaItem;

StreamController<int> playlistLenghtStreamController =
    StreamController<int>.broadcast();

StreamController<String> currentSongAlbumStreamController =
    StreamController<String>.broadcast();
StreamController<String> currentSongNameStreamController =
    StreamController<String>.broadcast();

void playlistLenghtStreamListener() {
  playlistLenghtStreamController.sink
      .add(playlistLengths = playlist.children.length);
}

void currentSongNameStreamListener(value) {
  currentSongNameStreamController.sink.add(value);
}

void currentSongAlbumStreamListener(value) {
  currentSongAlbumStreamController.sink.add(value);
}

void onInitPlayer() {
  initVolumeControl();
  audioPlayer = AudioPlayer();
  audioPlayer.setLoopMode(LoopMode.all);
  playlist = ConcatenatingAudioSource(
    useLazyPreparation: false,
    shuffleOrder: DefaultShuffleOrder(),
    children: audioSources,
  );
  playerEventStateStreamListener();
}

void initVolumeControl() async {
  VolumeController().listener((volume) {
    volumeSliderValue = volume * 100;
  });
  double currentVolume = await VolumeController().getVolume();
  volumeSliderValue = (currentVolume * 100);
}

void setVolume(double value) {
  double volume = value / 100;
  VolumeController().setVolume(volume);
}

// This func should be used on a flutter.initState or GetX.onInit();
void playerEventStateStreamListener() {
  // I will need to use another state listener otherthan!
  // To display on a widget: Text('Current Time: ${formatDuration(currentPosition)} / ${formatDuration(songTotalDuration)}'),
  audioPlayer.positionStream.listen((position) {
    currentSongDurationPostion = position;
    sleekCircularSliderPosition = position.inSeconds.toDouble();
  });

  // Get the duration and the full duration of the song for the sleekCircularSlider
  audioPlayer.durationStream.listen((duration) {
    currentSongTotalDuration = duration ?? Duration.zero;
    sleekCircularSliderDuration = duration?.inSeconds.toDouble() ?? 100.0;
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
    currentSongNameStreamListener(currentSongName = currentMediaItem.title);

    controller.currentSongArtistName.value = currentMediaItem.artist!;
    currentSongAlbumStreamListener(
        currentSongAlbumName = currentMediaItem.album!);

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
  await playlist.clear();
  playlistLenghtStreamListener();

  controller.currentIndex.value = 0;
  controller.playlistLength.value = playlist.children.length;
  currentSongDurationPostion = Duration.zero;
  currentSongTotalDuration = Duration.zero;
  sleekCircularSliderPosition = 0.0;
  currentSongNameStreamListener(currentSongName = "The playlist is empty");
  // controller.currentSongArtistName.value = "Unknown Artist";
  currentSongAlbumStreamListener(currentSongAlbumName = "Unknown Album");
  // print('CLEAN LIST!!! IS SONG PLAYING? ${controller.songIsPlaying.value}');
  // }
}

void playOrPause() {
  if (playlist.children.isEmpty) {
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
    print('Song: : $currentSongName');
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
  print('LIST TOTAL ITEM.${playlist.children.length}');

  await audioPlayer.seekToNext();
  if (controller.currentIndex.value > 0) {
    controller.firstSongIndex.value = false;
    print('INDEX IS GRATER THAN 0!');
  }

  if (controller.currentIndex.value == playlist.children.length - 1) {
    controller.lastSongIndex.value = true;
    print('INDEX IS THE LAST');
  } else {
    controller.lastSongIndex.value = false;
  }
}

Future<void> previousSong() async {
  print('LIST TOTAL ITEM.${playlist.children.length}');
  if (controller.currentIndex.value == 0) {
    controller.firstSongIndex.value = true;
    print('INDEX IS EQUAL TO 0!');
  }

  if (controller.currentIndex.value > 0) {
    controller.firstSongIndex.value = false;
    print('INDEX IS GRATER THAN 0!');
  }

  await audioPlayer.seekToPrevious();

  if (controller.currentIndex.value == playlist.children.length - 2) {
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
    currentLoopModeIcone = "assets/img/repeat_one.png";
    repeatModeSnackbar(
      message: "Repeat: One",
      iconePath: currentLoopModeIcone,
    );

    print("Repeat: One");
  } else if (controller.currentLoopMode.value == LoopMode.one) {
    controller.currentLoopMode.value = LoopMode.off;
    audioPlayer.setLoopMode(LoopMode.off);
    currentLoopModeIcone = "assets/img/repeat_none.png";
    repeatModeSnackbar(
      message: "Repeat: Off",
      iconePath: currentLoopModeIcone,
    );

    print("Repeat: Off");
  } else if (controller.currentLoopMode.value == LoopMode.off) {
    controller.currentLoopMode.value = LoopMode.all;
    audioPlayer.setLoopMode(LoopMode.all);
    currentLoopModeIcone = "assets/img/repeat_all.png";

    repeatModeSnackbar(
      message: "Repeat All",
      iconePath: currentLoopModeIcone,
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
    if (playlist.children.isEmpty) {
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

        playlist.add(
          AudioSource.uri(
            Uri.file(filePath),
            tag: mediaItem,
          ),
        );
        controller.playlistLength.value = playlist.children.length;
      }
      await audioPlayer.setAudioSource(playlist,
          initialIndex: 0, preload: true);
      playlistIsEmpty = false;
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

        playlist.add(
          AudioSource.uri(
            Uri.file(filePath),
            tag: mediaItem,
          ),
        );
        controller.playlistLength.value = playlist.children.length;
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

    if (playlist.children.isEmpty) {
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

        playlist.add(
          AudioSource.uri(
            Uri.file(filePath),
            tag: mediaItem,
          ),
        );
        controller.playlistLength.value = playlist.children.length;
      }

      audioPlayer.setAudioSource(playlist, initialIndex: 0, preload: true);
      playlistIsEmpty = false;
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

        playlist.add(AudioSource.uri(
          Uri.file(filePath),
          tag: mediaItem,
        ));
        controller.playlistLength.value = playlist.children.length;
        print('Processing file: $filePath');
      }
    }
  }
}
