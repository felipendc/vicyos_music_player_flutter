import 'dart:async';
import 'dart:io';

import 'package:audio_service/audio_service.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:just_audio/just_audio.dart';
// import 'package:flutter_media_metadata/flutter_media_metadata.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';
import 'package:vicyos_music/app/models/audio.info.dart';
import 'package:vicyos_music/app/models/folder.sources.dart';
import 'package:volume_controller/volume_controller.dart';

String currentFolderPath = 'The song folder will be displayed here...';
String currentSongFullPath = '';
int playlistLengths = 0;
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
late final File defaultalbumArt;

bool songIsPlaying = false;
bool isStopped = false;
int playlistLength = 0;
int currentIndex = 0;
bool firstSongIndex = true;
bool lastSongIndex = false;
bool penultimateSongIndex = false;
bool playlistTrailingIndex = false;
Duration currentPosition = Duration.zero;
LoopMode currentLoopMode = LoopMode.all;
String currentLoopModeLabel = 'Repeat: All';
Duration songTotalDuration = Duration.zero;
List<AudioSource> audioSources = <AudioSource>[];

late ConcatenatingAudioSource playlist;
late AudioPlayer audioPlayer;

late final MediaItem mediaItem;

// Player for Preview
late AudioPlayer audioPlayerPreview;
late ConcatenatingAudioSource playlistPreview;
List<AudioSource> audioSourcesPreview = <AudioSource>[];

Duration currentSongDurationPositionPreview = Duration.zero;
Duration currentSongTotalDurationPreview = Duration.zero;
double sleekCircularSliderPositionPreview = 0.0;
double sleekCircularSliderDurationPreview = 100.0;
//

StreamController<String> getCurrentSongFolderStreamController =
    StreamController<String>.broadcast();

StreamController<String> getCurrentSongFullPathStreamController =
    StreamController<String>.broadcast();

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

void getCurrentSongFolderStreamControllerListener(value) {
  getCurrentSongFolderStreamController.sink.add(value);
}

void getCurrentSongFullPathStreamControllerListener(value) {
  getCurrentSongFullPathStreamController.sink.add(value);
}

Future<void> onInitPlayer() async {
  initVolumeControl();
  // Inform the operating system of our app's audio attributes etc.
  // We pick a reasonable default for an app that plays speech.
  // final session = await AudioSession.instance;
  // await session.configure(const AudioSessionConfiguration.music());

  // Player for previewing the songs.
  audioPlayerPreview = AudioPlayer();
  audioPlayerPreview.setLoopMode(LoopMode.off);
  playlistPreview = ConcatenatingAudioSource(
    useLazyPreparation: true,
    children: audioSourcesPreview,
  );

  audioPlayer = AudioPlayer();
  audioPlayer.setLoopMode(LoopMode.all);
  playlist = ConcatenatingAudioSource(
    useLazyPreparation: true,
    shuffleOrder: DefaultShuffleOrder(),
    children: audioSources,
  );
  playerEventStateStreamListener();
  playerPreviewEventStateStreamListener();
  await defaultAlbumArt();

  audioPlayer.sequenceStateStream.listen((sequenceState) {
    final currentSource = sequenceState?.currentSource;
    if (currentSource is UriAudioSource) {
      getCurrentSongFolderStreamControllerListener(currentFolderPath =
          getCurrentSongFolder(currentSource.uri.toString()));

      getCurrentSongFullPathStreamControllerListener(currentSongFullPath =
          getCurrentSongFullPath(currentSource.uri.toString()));

      print(
          "FUUUULL PATH dir: ${getCurrentSongFullPath(currentSource.uri.toString())}");

      //   print(
      //       'Música atual CORTADA: ${getCurrentSongFolder(currentSource.uri.toString())}');
      //   print('Música atual: ${currentSource.uri}');
    }
  });
}

void initVolumeControl() async {
  VolumeController.instance.addListener((volume) {
    systemVolumeStreamListener(volumeSliderValue = volume * 100);
  });
  double currentVolume = await VolumeController.instance.getVolume();
  volumeSliderValue = (currentVolume * 100);
}

void setVolume(double value) {
  // Set the volume and keep the system volume UI hidden
  // VolumeController.instance.showSystemUI = false;
  double volume = value / 100;
  VolumeController.instance.setVolume(volume);
}

void setVolumeJustAudio(value) {
  // Set the volume and keep the system volume UI hidden
  // VolumeController.instance.showSystemUI = false;

  double volume = value / 100;
  audioPlayer.setVolume(volume);
  VolumeController.instance.setVolume(audioPlayer.volume);
}

Future<void> defaultAlbumArt() async {
  // Load the image asset as a Uri
  final ByteData imageData =
      await rootBundle.load('assets/img/lofi-woman-album-cover-art_11.png');
  final Uint8List bytes = imageData.buffer.asUint8List();

  // Save the image to a temporary directory
  final tempDir = await getTemporaryDirectory();
  defaultalbumArt =
      await File('${tempDir.path}/default_album_art.png').writeAsBytes(bytes);
}

// This func should be used on a flutter.initState or GetX.onInit();
void playerPreviewEventStateStreamListener() {
  audioPlayerPreview.positionStream.listen((position) {
    currentSongDurationPositionPreview = position;
    sleekCircularSliderPositionPreview = position.inSeconds.toDouble();
  });

  // Get the duration and the full duration of the song for the sleekCircularSlider
  audioPlayerPreview.durationStream.listen((duration) {
    currentSongTotalDurationPreview = duration ?? Duration.zero;
    sleekCircularSliderDurationPreview =
        duration?.inSeconds.toDouble() ?? 100.0;
  });
  audioPlayerPreview.playerStateStream.listen((playerState) {
    if (playerState.processingState == ProcessingState.completed &&
        audioPlayerPreview.loopMode == LoopMode.off) {
      audioPlayerPreview.setAudioSource(
          preload: true,
          playlistPreview,
          initialIndex: audioPlayerPreview.currentIndex);
      audioPlayerPreview.pause();
    }
  });
}

// This func should be used on a flutter.initState or GetX.onInit();
void playerEventStateStreamListener() {
  // I will need to use another state listener other than!
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

String getCurrentSongFullPath(String songPath) {
  // Try to correctly interpret the path
  Uri uri = Uri.parse(songPath);
  songPath = uri.toString();

  // Decode special characters like %20
  String decodedPath = Uri.decodeFull(songPath);

  // Check if the string starts with "file:///" and remove it
  if (decodedPath.startsWith("file:///")) {
    return decodedPath.substring(7);
  }

  return decodedPath;
}

String getCurrentSongParentFolder(String songPath) {
  // Try to correctly interpret the path
  Uri uri = Uri.parse(songPath);
  songPath = uri.toString();

  // Decode special characters like %20
  String decodedPath = Uri.decodeFull(songPath);

  // Remove "file:///" if present
  if (decodedPath.startsWith("file:///")) {
    decodedPath = decodedPath.substring(7);
  }

  // Find the last slash and get only the folder path
  int lastSlashIndex = decodedPath.lastIndexOf("/");
  if (lastSlashIndex != -1) {
    return decodedPath.substring(
        0, lastSlashIndex); // Keep everything before the last slash
  }

  return decodedPath; // Return original if no slash is found
}

String getCurrentSongFolder(String songPath) {
// ------ Get  current folder -----
  // Try to correctly interpret the path
  Uri uri = Uri.parse(songPath);
  songPath = uri.toString();

  // Decode special characters like %20
  String decodedPath = Uri.decodeFull(songPath);

  // Get the part before the last "/" (directory path)
  String folderPath = decodedPath.substring(0, decodedPath.lastIndexOf('/'));

  // Extract the last folder name
  return folderPath.substring(folderPath.lastIndexOf('/') + 1).toUpperCase();
// ----------------------------------

// ------ Get full folder path -----
//   Try to correctly interpret the path
//   Uri uri = Uri.parse(songPath);
//   songPath = uri.toString();
//
//   // Decode special characters like %20
//   String decodedPath = Uri.decodeFull(songPath);
//
//   // Remove the "/storage/emulated/X/" part from the path
//   String relativePath = decodedPath.replaceFirst(RegExp(r'^file:///storage/emulated/[^/]+/'), '');
//
//   // Get the part before the last "/"
//   String folderPath = relativePath.substring(0, relativePath.lastIndexOf('/'));
//
//   // Replace "/" with " > "
//   return folderPath.replaceAll("/", " > ");
// ---------------------------------
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

  getCurrentSongFolderStreamControllerListener(
      currentFolderPath = 'The song folder will be displayed here...');
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
  audioPlayer.position + Duration(seconds: 5) > audioPlayer.duration!
      ? audioPlayer.seek(audioPlayer.duration)
      : audioPlayer.seek(audioPlayer.position + const Duration(seconds: 5));
}

void rewind() {
  audioPlayer.position - Duration(seconds: 5) < Duration.zero
      ? audioPlayer.seek(Duration.zero)
      : audioPlayer.seek(audioPlayer.position - const Duration(seconds: 5));
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
        // String filePathAsId = audioFile.absolute.path;

        // Metadata? metadata;

        // try {
        //   metadata = await MetadataRetriever.fromFile(audioFile);
        // } catch (e) {
        //   print('Failed to extract metadata: $e');
        // }

        final mediaItem = MediaItem(
          id: const Uuid().v4(),
          // album: metadata?.albumName ?? 'Unknown Album',

          // Using the name of the file as the title by default
          title: fileNameWithoutExtension,
          // artist: metadata?.albumArtistName ?? 'Unknown Artist',
          artUri: Uri.file(defaultalbumArt.path),
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
        // String filePathAsId = audioFile.absolute.path;

        // Metadata? metadata;

        // try {
        //   metadata = await MetadataRetriever.fromFile(audioFile);
        // } catch (e) {
        //   print('Failed to extract metadata: $e');
        // }

        final mediaItem = MediaItem(
          id: const Uuid().v4(),
          // album: metadata?.albumName ?? 'Unknown Album',

          // Using the name of the file as the title by default
          title: fileNameWithoutExtension,
          // artist: metadata?.albumArtistName ?? 'Unknown Artist',
          artUri: Uri.file(defaultalbumArt.path),
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
        // String filePathAsId = audioFile.absolute.path;

        // Metadata? metadata;

        // try {
        //   metadata = await MetadataRetriever.fromFile(audioFile);
        // } catch (e) {
        //   print('Failed to extract metadata: $e');
        // }

        final mediaItem = MediaItem(
          id: const Uuid().v4(),
          // album: metadata?.albumName ?? 'Unknown Album',

          // Using the name of the file as the title by default
          title: fileNameWithoutExtension,
          // artist: metadata?.albumArtistName ?? 'Unknown Artist',
          artUri: Uri.file(defaultalbumArt.path),
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
        // String filePathAsId = audioFile.absolute.path;

        // Metadata? metadata;

        // try {
        //   metadata = await MetadataRetriever.fromFile(audioFile);
        // } catch (e) {
        //   print('Failed to extract metadata: $e');
        // }

        final mediaItem = MediaItem(
          id: const Uuid().v4(),
          // album: metadata?.albumName ?? 'Unknown Album',

          // Using the name of the file as the title by default
          title: fileNameWithoutExtension,
          // artist: metadata?.albumArtistName ?? 'Unknown Artist',
          artUri: Uri.file(defaultalbumArt.path),
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
    // File audioFile = File(filePath.path);
    String fileNameWithoutExtension =
        path.basenameWithoutExtension(filePath.path);
    // String filePathAsId = audioFile.absolute.path;
    // Metadata? metadata;

    // try {
    //   metadata = await MetadataRetriever.fromFile(audioFile);
    // } catch (e) {
    //   print('Failed to extract metadata: $e');
    // }

    final mediaItem = MediaItem(
      id: const Uuid().v4(),
      // album: metadata?.albumName ?? 'Unknown Album',

      // Using the name of the file as the title by default
      title: fileNameWithoutExtension,
      // artist: metadata?.albumArtistName ?? 'Unknown Artist',
      artUri: Uri.file(defaultalbumArt.path),
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
      // File audioFile = File(filePath.path);
      String fileNameWithoutExtension =
          path.basenameWithoutExtension(filePath.path);
      // String filePathAsId = audioFile.absolute.path;
      // Metadata? metadata;

      // try {
      //   metadata = await MetadataRetriever.fromFile(audioFile);
      // } catch (e) {
      //   print('Failed to extract metadata: $e');
      // }

      final mediaItem = MediaItem(
        id: const Uuid().v4(),
        // album: metadata?.albumName ?? 'Unknown Album',

        // Using the name of the file as the title by default
        title: fileNameWithoutExtension,
        // artist: metadata?.albumArtistName ?? 'Unknown Artist',
        artUri: Uri.file(defaultalbumArt.path),
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
      // Metadata? metadata;

      // try {
      //   metadata = await MetadataRetriever.fromFile(audioFile);
      // } catch (e) {
      //   print('Failed to extract metadata: $e');
      // }

      final mediaItem = MediaItem(
        id: filePathAsId,
        // album: metadata?.albumName ?? 'Unknown Album',

        // Using the name of the file as the title by default
        title: fileNameWithoutExtension,
        // artist: metadata?.albumArtistName ?? 'Unknown Artist',
        artUri: Uri.file(defaultalbumArt.path),
      );

      await playlist.add(
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
    // File audioFile = File(songPath);
    String fileNameWithoutExtension = path.basenameWithoutExtension(songPath);
    // String filePathAsId = audioFile.absolute.path;
    // Metadata? metadata;

    // try {
    //   metadata = await MetadataRetriever.fromFile(audioFile);
    // } catch (e) {
    //   print('Failed to extract metadata: $e');
    // }

    final mediaItem = MediaItem(
      id: const Uuid().v4(),
      // album: metadata?.albumName ?? 'Unknown Album',

      // Using the name of the file as the title by default
      title: fileNameWithoutExtension,
      // artist: metadata?.albumArtistName ?? 'Unknown Artist',
      artUri: Uri.file(defaultalbumArt.path),
    );

    playlist.add(
      AudioSource.uri(
        Uri.file(songPath),
        tag: mediaItem,
      ),
    );

    audioPlayer.setAudioSource(playlist, initialIndex: 0, preload: false);
    playlistIsEmpty = false;
    firstSongIndex = true;
    preLoadSongName();
    playOrPause();
  } else {
    // File audioFile = File(songPath);
    String fileNameWithoutExtension = path.basenameWithoutExtension(songPath);
    // String filePathAsId = audioFile.absolute.path;
    // Metadata? metadata;

    // try {
    //   metadata = await MetadataRetriever.fromFile(audioFile);
    // } catch (e) {
    //   print('Failed to extract metadata: $e');
    // }

    final mediaItem = MediaItem(
      id: const Uuid().v4(),
      // album: metadata?.albumName ?? 'Unknown Album',

      // Using the name of the file as the title by default
      title: fileNameWithoutExtension,
      // artist: metadata?.albumArtistName ?? 'Unknown Artist',
      artUri: Uri.file(defaultalbumArt.path),
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

Future<void> previewSong(songPath) async {
  playlistPreview.clear();

  // File audioFile = File(songPath);
  String fileNameWithoutExtension = path.basenameWithoutExtension(songPath);
  // String filePathAsId = audioFile.absolute.path;
  // Metadata? metadata;

  // try {
  //   metadata = await MetadataRetriever.fromFile(audioFile);
  // } catch (e) {
  //   print('Failed to extract metadata: $e');
  // }

  final mediaItem = MediaItem(
    id: const Uuid().v4(),
    // album: metadata?.albumName ?? 'Unknown Album',

    // Using the name of the file as the title by default
    title: fileNameWithoutExtension,
    // artist: metadata?.albumArtistName ?? 'Unknown Artist',
    artUri: Uri.file(defaultalbumArt.path),
  );

  playlistPreview.add(
    AudioSource.uri(
      Uri.file(songPath),
      tag: mediaItem,
    ),
  );

  audioPlayerPreview.setAudioSource(playlistPreview,
      initialIndex: 0, preload: true);
}
