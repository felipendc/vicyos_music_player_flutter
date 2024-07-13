import 'dart:io';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_media_metadata/flutter_media_metadata.dart';
import 'package:path/path.dart' as path;
import 'package:just_audio/just_audio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:audio_service/audio_service.dart';
import 'package:vicyos_music_player/app/models/audio.info.dart';
import 'package:vicyos_music_player/app/models/folder.sources.dart';
import 'package:volume_controller/volume_controller.dart';

//
int playlistLengths = 0;
//
bool isFirstArtDemoCover = true;
String currentLoopModeIcone = 'assets/img/repeat_all.png';
var volumeSliderValue = 50.0;
String currentSongAlbumName = 'Unknown Album';
String currentSongName = 'The playlist is empty';
Duration currentSongDurationPostion = Duration.zero; //temp
Duration currentSongTotalDuration = Duration.zero; //temp
double sleekCircularSliderPosition = 0.0; //temp
double sleekCircularSliderDuration = 100.0; //temp
bool playlistIsEmpty = true; //temp
List<FolderSources> musicFolderPaths = <FolderSources>[];
List<AudioInfo> folderSongList = <AudioInfo>[];
String volumeSliderStatus = 'idle';
MaterialColor volumeSliderStatusColor = Colors.amber;
String currentSongArtistName = 'Unknown Artist';

bool songIsPlaying = false;
bool isStopped = false;
//
int playlistLength = 0;
int currentIndex = 0;
bool firstSongIndex = true;
bool lastSongIndex = false;
bool penultimateSongIndex = false;
bool playlistTrailingIndex = false;
//
Duration currentPosition = Duration.zero;
LoopMode currentLoopMode = LoopMode.all;
String currentLoopModeLabel = 'Repeat: All';
// String currentLoopModeIcone = 'assets/img/repeat_all.png';
Duration songTotalDuration = Duration.zero;
//
List<AudioSource> audioSources = <AudioSource>[];
late ConcatenatingAudioSource playlist;
// final HomeController controller = Get.find<HomeController>();
late AudioPlayer audioPlayer;
late final MediaItem mediaItem;

StreamController<int> playlistLenghtStreamController =
    StreamController<int>.broadcast();

StreamController<String> currentSongAlbumStreamController =
    StreamController<String>.broadcast();

StreamController<String> currentSongNameStreamController =
    StreamController<String>.broadcast();

StreamController<int> listPlaylistFolderStreamController =
    StreamController<int>.broadcast();

StreamController<void> clearCurrentPlaylistStreamController =
    StreamController<void>.broadcast();

StreamController<LoopMode> repeatModeStreamController =
    StreamController<LoopMode>.broadcast();

StreamController<double> systemVolumeStreamController =
    StreamController<double>.broadcast();

StreamController<bool> albumArtStreamController =
    StreamController<bool>.broadcast();

void listPlaylistFolderStreamListener() {
  listPlaylistFolderStreamController.sink
      .add(playlistLength = musicFolderPaths.length);
}

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

void clearCurrentPlaylistStreamListener() {
  clearCurrentPlaylistStreamController.sink.add(playlist.clear());
}

void repeatModeStreamListener(value) {
  repeatModeStreamController.sink.add(value);
}

void systemVolumeStreamListener(value) {
  systemVolumeStreamController.sink.add(value);
}

void albumArtStreamControllerStreamListener(value) {
  albumArtStreamController.sink.add(value);
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
    systemVolumeStreamListener(volumeSliderValue = volume * 100);
  });
  double currentVolume = await VolumeController().getVolume();
  volumeSliderValue = (currentVolume * 100);
}

void setVolume(double value) {
  double volume = value / 100;
  // Set the volume and keep the system volume UI hidden
  VolumeController().setVolume(volume, showSystemUI: false);
}

void setVolumeJustAudio(value) {
  double volume = value / 100;
  audioPlayer.setVolume(volume);
  // Set the volume and keep the system volume UI hidden
  VolumeController().setVolume(audioPlayer.volume, showSystemUI: false);
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
  audioPlayer.playerStateStream.listen(
    (playerState) {
      // print(
      //     "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA   $playerState");
      if (playerState.processingState == ProcessingState.completed) {
        songIsPlaying = false;
      }
      if (playerState.processingState == ProcessingState.completed &&
          audioPlayer.loopMode == LoopMode.off) {
        audioPlayer.setAudioSource(
            preload: true, playlist, initialIndex: audioPlayer.currentIndex);
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
  audioPlayer.playbackEventStream.listen((event) {
    currentIndex = event.currentIndex!;
  });
}

// This function will update the display the song title one the audio or folder is imported
void preLoadSongName() {
  audioPlayer.currentIndexStream.listen((index) {
    final currentMediaItem = audioPlayer.sequence![index!].tag as MediaItem;
    currentSongNameStreamListener(currentSongName = currentMediaItem.title);

    currentSongArtistName = currentMediaItem.artist!;
    currentSongAlbumStreamListener(
        currentSongAlbumName = currentMediaItem.album!);

    currentIndex = index;
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
  if (audioPlayer.playerState.playing == false) {
    clearCurrentPlaylistStreamListener();
  }
  audioPlayer.stop();
  songIsPlaying = false;
  await playlist.clear();
  playlistLenghtStreamListener();

  currentIndex = 0;
  playlistLength = playlist.children.length;
  currentSongDurationPostion = Duration.zero;
  currentSongTotalDuration = Duration.zero;
  sleekCircularSliderPosition = 0.0;
  currentSongNameStreamListener(currentSongName = "The playlist is empty");
  // controller.currentSongArtistName.value = "Unknown Artist";
  currentSongAlbumStreamListener(currentSongAlbumName = "Unknown Album");
  // print('CLEAN LIST!!! IS SONG PLAYING? ${songIsPlaying}');
  // }
}

void playOrPause() {
  if (playlist.children.isEmpty) {
    print("The playlist is EMPTY");
  } else {
    if (songIsPlaying == false) {
      songIsPlaying = true;
      isStopped = false;
      audioPlayer.play();
    } else if (songIsPlaying == true) {
      songIsPlaying = !songIsPlaying;
      audioPlayer.pause();
    }
    print('IS THE SONG PLAYING? $songIsPlaying');
    print('Song: : $currentSongName');
  }
}

void pauseSong() {
  songIsPlaying = false;
  audioPlayer.pause();
}

void stopSong() {
  songIsPlaying = false;
  isStopped = true;
  audioPlayer.stop();
}

Future<void> nextSong() async {
  print('LIST TOTAL ITEM.${playlist.children.length}');

  await audioPlayer.seekToNext();
  if (currentIndex > 0) {
    firstSongIndex = false;
    print('INDEX IS GRATER THAN 0!');
  }

  if (currentIndex == playlist.children.length - 1) {
    lastSongIndex = true;
    print('INDEX IS THE LAST');
  } else {
    lastSongIndex = false;
  }
}

Future<void> previousSong() async {
  print('LIST TOTAL ITEM.${playlist.children.length}');
  if (currentIndex == 0) {
    firstSongIndex = true;
    print('INDEX IS EQUAL TO 0!');
  }

  if (currentIndex > 0) {
    firstSongIndex = false;
    print('INDEX IS GRATER THAN 0!');
  }

  await audioPlayer.seekToPrevious();

  if (currentIndex == playlist.children.length - 2) {
    penultimateSongIndex = true;
    print('INDEX IS THE PENULTIMATE ####');
  } else {
    penultimateSongIndex = false;
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
  if (currentLoopMode == LoopMode.all) {
    repeatModeStreamListener(currentLoopMode = LoopMode.one);
    audioPlayer.setLoopMode(LoopMode.one);
    currentLoopModeIcone = "assets/img/repeat_one.png";
    // repeatModeSnackbar(
    //   message: "Repeat: One",
    //   iconePath: currentLoopModeIcone,
    // );

    print("Repeat: One");
  } else if (currentLoopMode == LoopMode.one) {
    repeatModeStreamListener(currentLoopMode = LoopMode.off);
    audioPlayer.setLoopMode(LoopMode.off);
    currentLoopModeIcone = "assets/img/repeat_none.png";
    // repeatModeSnackbar(
    //   message: "Repeat: Off",
    //   iconePath: currentLoopModeIcone,
    // );

    print("Repeat: Off");
  } else if (currentLoopMode == LoopMode.off) {
    repeatModeStreamListener(currentLoopMode = LoopMode.all);
    audioPlayer.setLoopMode(LoopMode.all);
    currentLoopModeIcone = "assets/img/repeat_all.png";

    // repeatModeSnackbar(
    //   message: "Repeat All",
    //   iconePath: currentLoopModeIcone,
    // );
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
        playlistLength = playlist.children.length;
      }
      await audioPlayer.setAudioSource(playlist,
          initialIndex: 0, preload: true);
      playlistIsEmpty = false;
      firstSongIndex = true;
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
        playlistLength = playlist.children.length;
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
        playlistLength = playlist.children.length;
      }

      audioPlayer.setAudioSource(playlist, initialIndex: 0, preload: true);
      playlistIsEmpty = false;
      firstSongIndex = true;
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
        playlistLength = playlist.children.length;
        print('Processing file: $filePath');
      }
    }
  }
}

//

Future<void> setFolderAsPlaylist(currentFolder, currenIndex) async {
  // controller.folderSongList.clear();
  stopSong();
  await playlist.clear();

  for (AudioInfo filePath in currentFolder) {
    File audioFile = File(filePath.path);
    String fileNameWithoutExtension =
        path.basenameWithoutExtension(filePath.path);
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
        Uri.file(filePath.path),
        tag: mediaItem,
      ),
    );
    playlistLenghtStreamListener();
  }

  audioPlayer.setAudioSource(playlist,
      initialIndex: currenIndex, preload: false);
  playlistIsEmpty = false;
  firstSongIndex = true;
  preLoadSongName();
  playOrPause();
  // print("Testing");
}

Future<void> addFolderToPlaylist(currentFolder) async {
  if (audioSources.isEmpty) {
    for (AudioInfo filePath in currentFolder) {
      File audioFile = File(filePath.path);
      String fileNameWithoutExtension =
          path.basenameWithoutExtension(filePath.path);
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
          Uri.file(filePath.path),
          tag: mediaItem,
        ),
      );
      playlistLenghtStreamListener();
    }

    audioPlayer.setAudioSource(playlist, initialIndex: 0, preload: false);
    playlistIsEmpty = false;
    firstSongIndex = true;
    preLoadSongName();
    playOrPause();

    // print("Testing");
  } else {
    for (AudioInfo filePath in currentFolder) {
      File audioFile = File(filePath.path);
      String fileNameWithoutExtension =
          path.basenameWithoutExtension(filePath.path);
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
          Uri.file(filePath.path),
          tag: mediaItem,
        ),
      );
      playlistLenghtStreamListener();
    }

    playlistIsEmpty = false;
  }
}

Future<void> addSongToPlaylist(songPath) async {
  if (audioSources.isEmpty) {
    File audioFile = File(songPath);
    String fileNameWithoutExtension = path.basenameWithoutExtension(songPath);
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
        Uri.file(songPath),
        tag: mediaItem,
      ),
    );

    playlistLenghtStreamListener();

    audioPlayer.setAudioSource(playlist, initialIndex: 0, preload: false);
    playlistIsEmpty = false;
    firstSongIndex = true;
    preLoadSongName();
    playOrPause();

    // print("Testing");
  } else {
    File audioFile = File(songPath);
    String fileNameWithoutExtension = path.basenameWithoutExtension(songPath);
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
        Uri.file(songPath),
        tag: mediaItem,
      ),
    );
    playlistLenghtStreamListener();

    playlistIsEmpty = false;
  }
}
