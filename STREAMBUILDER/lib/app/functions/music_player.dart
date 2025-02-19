import 'dart:async';
import 'dart:io';

import 'package:audio_service/audio_service.dart';
import 'package:audioplayers/audioplayers.dart' as audio_players;
import 'package:ffmpeg_kit_flutter_audio/ffprobe_kit.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:just_audio/just_audio.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';
import 'package:vicyos_music/app/functions/folders.and.files.related.dart';
import 'package:vicyos_music/app/models/audio.info.dart';
import 'package:vicyos_music/app/models/folder.sources.dart';
import 'package:volume_controller/volume_controller.dart';

late bool audioPlayerWasPlaying;
late bool isInternalStoragePermissionDenied;
bool noDeviceMusicFolderFound = false;
late final TextEditingController searchBoxController;
List<AudioInfo> foundSongs = <AudioInfo>[];
bool isSongPreviewBottomSheetOpen = false;
bool mainPlayerIsOpen = false;
String currentFolderPath = 'The song folder will be displayed here...';
String currentSongFullPath = '';
int playlistCurrentLength = 0;
String currentLoopModeIcon = 'assets/img/repeat_all.png';
late double volumeSliderValue;
String currentSongAlbumName = 'Unknown Album';
String currentSongName = 'The playlist is empty';
Duration currentSongDurationPosition = Duration.zero;
Duration currentSongTotalDuration = Duration.zero;
double sleekCircularSliderPosition = 0.0;
double sleekCircularSliderDuration = 100.0;
List<FolderSources> musicFolderPaths = <FolderSources>[];
List<AudioInfo> folderSongList = <AudioInfo>[];
String currentSongArtistName = 'Unknown Artist';
late final File notificationPlayerAlbumArt;
bool songIsPlaying = false;
bool isStopped = false;
int playlistLength = 0;
int currentIndex = 0;
bool firstSongIndex = true;
bool lastSongIndex = false;
bool penultimateSongIndex = false;
Duration currentPosition = Duration.zero;
LoopMode currentLoopMode = LoopMode.all;
String currentLoopModeLabel = 'Repeat: All';
List<AudioSource> audioSources = <AudioSource>[];
late ConcatenatingAudioSource playlist;
late AudioPlayer audioPlayer;
late final MediaItem mediaItem;

// Player for Preview
late audio_players.AudioPlayer audioPlayerPreview;
Duration currentSongDurationPositionPreview = Duration.zero;
Duration currentSongTotalDurationPreview = Duration.zero;
double sleekCircularSliderPositionPreview = 0.0;
double sleekCircularSliderDurationPreview = 100.0;

// Stream controllers
StreamController<void> getCurrentSongFolderStreamController =
    StreamController<void>.broadcast();

StreamController<void> getCurrentSongFullPathStreamController =
    StreamController<void>.broadcast();

StreamController<void> playlistLengthStreamController =
    StreamController<void>.broadcast();

StreamController<void> currentSongAlbumStreamController =
    StreamController<void>.broadcast();

StreamController<void> currentSongNameStreamController =
    StreamController<void>.broadcast();

StreamController<void> listPlaylistFolderStreamController =
    StreamController<void>.broadcast();

StreamController<void> clearCurrentPlaylistStreamController =
    StreamController<void>.broadcast();

StreamController<void> repeatModeStreamController =
    StreamController<void>.broadcast();

StreamController<void> systemVolumeStreamController =
    StreamController<void>.broadcast();

StreamController<bool> hideButtonSheetStreamController =
    StreamController<bool>.broadcast();

StreamController<void> rebuildPlaylistBottomSheet =
    StreamController<void>.broadcast();

StreamController<void> rebuildSongsListScreenStreamController =
    StreamController<void>.broadcast();

StreamController<String> rebuildHomePageFolderListStreamController =
    StreamController<String>.broadcast();

StreamController<void> rebuildSpeedRateBottomSheetStreamController =
    StreamController<void>.broadcast();

StreamController<String> isSearchingSongsStreamController =
    StreamController<String>.broadcast();

StreamController<bool> isSearchTypingStreamController =
    StreamController<bool>.broadcast();

// Streams Notifiers Functions
void isSearchTypingStreamNotifier(bool value) {
  isSearchTypingStreamController.sink.add(value);
}

void isSearchingSongsStreamNotifier(String value) {
  isSearchingSongsStreamController.sink.add(value);
}

void rebuildSpeedRateBottomSheetStreamNotifier() {
  rebuildSpeedRateBottomSheetStreamController.sink.add(null);
}

void rebuildHomePageFolderListStreamNotifier(String value) {
  rebuildHomePageFolderListStreamController.sink.add(value);
}

void rebuildSongsListScreenStreamNotifier() {
  rebuildSongsListScreenStreamController.sink.add(null);
}

void rebuildPlaylistBottomSheetStreamNotifier() {
  rebuildPlaylistBottomSheet.sink.add(null);
}

Future<void> hideButtonSheetStreamNotifier(bool value) async {
  hideButtonSheetStreamController.sink.add(value);
}

void clearCurrentPlaylistStreamNotifier() {
  playlist.clear();
  clearCurrentPlaylistStreamController.sink.add(null);
}

void listPlaylistFolderStreamNotifier() async {
  playlistLength = musicFolderPaths.length;
  listPlaylistFolderStreamController.sink.add(null);
}

Future<void> playlistLengthStreamNotifier() async {
  playlistCurrentLength = playlist.children.length;
  playlistLengthStreamController.sink.add(null);
}

void currentSongNameStreamNotifier() {
  currentSongNameStreamController.sink.add(null);
}

void currentSongAlbumStreamNotifier() {
  currentSongAlbumStreamController.sink.add(null);
}

void repeatModeStreamNotifier() {
  repeatModeStreamController.sink.add(null);
}

void systemVolumeStreamNotifier() {
  systemVolumeStreamController.sink.add(null);
}

void getCurrentSongFolderStreamControllerNotifier() {
  getCurrentSongFolderStreamController.sink.add(null);
}

Future<void> getCurrentSongFullPathStreamControllerNotifier() async {
  getCurrentSongFullPathStreamController.sink.add(null);
}

Future<void> onInitPlayer() async {
  initVolumeControl();

  // Player for previewing the songs.
  audioPlayerPreview = audio_players.AudioPlayer();
  audioPlayerPreview.setReleaseMode(audio_players.ReleaseMode.stop);

  audioPlayer = AudioPlayer();
  audioPlayer.setLoopMode(LoopMode.all);
  playlist = ConcatenatingAudioSource(
    useLazyPreparation: true,
    shuffleOrder: DefaultShuffleOrder(),
    children: audioSources,
  );
  playerEventStateStreamNotifier();
  playerPreviewEventStateStreamNotifier();
  await defaultAlbumArt();

  audioPlayer.sequenceStateStream.listen((sequenceState) {
    final currentSource = sequenceState?.currentSource;
    if (currentSource is UriAudioSource) {
      currentFolderPath = getCurrentSongFolder(currentSource.uri.toString());
      getCurrentSongFolderStreamControllerNotifier();

      currentSongFullPath =
          getCurrentSongFullPath(currentSource.uri.toString());
      getCurrentSongFullPathStreamControllerNotifier();
    }
  });
}

void initVolumeControl() async {
  VolumeController.instance.addListener((volume) {
    volumeSliderValue = volume * 100;
    systemVolumeStreamNotifier();
  });
  double currentVolume = await VolumeController.instance.getVolume();
  volumeSliderValue = (currentVolume * 100);

  // Set the volume system volume UI to be hidden
  VolumeController.instance.showSystemUI = false;
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
  notificationPlayerAlbumArt =
      await File('${tempDir.path}/default_album_art.png').writeAsBytes(bytes);
}

// This func should be used on a flutter.initState or GetX.onInit();
void playerPreviewEventStateStreamNotifier() {
  audioPlayerPreview.onPositionChanged.listen((position) {
    currentSongDurationPositionPreview = position;
    sleekCircularSliderPositionPreview = position.inSeconds.toDouble();
  });

  // Get the duration and the full duration of the song for the sleekCircularSlider
  audioPlayerPreview.onDurationChanged.listen((duration) {
    currentSongTotalDurationPreview = duration;
    sleekCircularSliderDurationPreview = duration.inSeconds.toDouble();
  });
}

// This func should be used on a flutter.initState or GetX.onInit();
void playerEventStateStreamNotifier() {
  // I will need to use another state listener other than!
  audioPlayer.positionStream.listen((position) {
    currentSongDurationPosition = position;
    sleekCircularSliderPosition = position.inSeconds.toDouble();
  });

  // Get the duration and the full duration of the song for the sleekCircularSlider
  audioPlayer.durationStream.listen((duration) {
    currentSongTotalDuration = duration ?? Duration.zero;
    sleekCircularSliderDuration = duration?.inSeconds.toDouble() ?? 100.0;
  });

  // Pause PlayerPreview if the main player is playing
  // to avoid simultaneous audio playback
  audioPlayer.playerStateStream.listen(
    (playerState) {
      print("evento ${playerState}");
      if (audioPlayerPreview.state.toString() == "PlayerState.playing" &&
          playerState.playing == true) {
        audioPlayerPreview.pause();
      }

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
    currentIndex = event.currentIndex ?? 0;
  });
}

// This function will update the display the song title one the audio or folder is imported
void preLoadSongName() {
  audioPlayer.currentIndexStream.listen((index) {
    final currentMediaItem = audioPlayer.sequence![index!].tag as MediaItem;
    currentSongName = currentMediaItem.title;
    currentSongNameStreamNotifier();

    currentSongArtistName = currentMediaItem.artist!;
    currentSongAlbumName = currentMediaItem.album!;
    currentSongAlbumStreamNotifier();
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
  // if (audioPlayer.playerState.playing == false) {
  //   clearCurrentPlaylistStreamListener();
  // }

  audioPlayer.stop();
  songIsPlaying = false;
  await playlist.clear();
  playlistLengthStreamNotifier();

  currentIndex = 0;
  playlistLength = playlist.children.length;
  currentSongDurationPosition = Duration.zero;
  currentSongTotalDuration = Duration.zero;
  sleekCircularSliderPosition = 0.0;

  currentSongName = "The playlist is empty";
  currentSongNameStreamNotifier();
  currentSongAlbumName = "Unknown Album";
  currentSongAlbumStreamNotifier();

  currentFolderPath = 'The song folder will be displayed here...';
  getCurrentSongFolderStreamControllerNotifier();
  clearCurrentPlaylistStreamNotifier();

  currentSongFullPath = "";
  getCurrentSongFullPathStreamControllerNotifier();
}

void playOrPause() {
  if (playlist.children.isEmpty) {
  } else {
    if (songIsPlaying == false) {
      songIsPlaying = true;
      isStopped = false;
      audioPlayer.play();
    } else if (songIsPlaying == true) {
      songIsPlaying = !songIsPlaying;
      audioPlayer.pause();
    }
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
    currentLoopMode = LoopMode.one;
    repeatModeStreamNotifier();
    audioPlayer.setLoopMode(LoopMode.one);
    currentLoopModeIcon = "assets/img/repeat_one.png";

    print("Repeat: One");
  } else if (currentLoopMode == LoopMode.one) {
    currentLoopMode = LoopMode.off;
    repeatModeStreamNotifier();
    audioPlayer.setLoopMode(LoopMode.off);
    currentLoopModeIcon = "assets/img/repeat_none.png";

    print("Repeat: Off");
  } else if (currentLoopMode == LoopMode.off) {
    currentLoopMode = LoopMode.all;
    repeatModeStreamNotifier();
    audioPlayer.setLoopMode(LoopMode.all);
    currentLoopModeIcon = "assets/img/repeat_all.png";
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
          artUri: Uri.file(notificationPlayerAlbumArt.path),
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
          artUri: Uri.file(notificationPlayerAlbumArt.path),
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
          artUri: Uri.file(notificationPlayerAlbumArt.path),
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
          artUri: Uri.file(notificationPlayerAlbumArt.path),
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

Future<void> setFolderAsPlaylist(currentFolder, currentIndex) async {
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
      artUri: Uri.file(notificationPlayerAlbumArt.path),
    );

    playlist.add(
      AudioSource.uri(
        Uri.file(filePath.path),
        tag: mediaItem,
      ),
    );
    playlistLengthStreamNotifier();
  }

  audioPlayer.setAudioSource(playlist,
      initialIndex: currentIndex, preload: false);
  firstSongIndex = true;
  preLoadSongName();
  playOrPause();
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
        artUri: Uri.file(notificationPlayerAlbumArt.path),
      );

      playlist.add(
        AudioSource.uri(
          Uri.file(filePath.path),
          tag: mediaItem,
        ),
      );
      playlistLengthStreamNotifier();
    }

    audioPlayer.setAudioSource(playlist, initialIndex: 0, preload: false);
    firstSongIndex = true;
    preLoadSongName();
    playOrPause();
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
        artUri: Uri.file(notificationPlayerAlbumArt.path),
      );

      await playlist.add(
        AudioSource.uri(
          Uri.file(filePath.path),
          tag: mediaItem,
        ),
      );
      playlistLengthStreamNotifier();
    }
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
      artUri: Uri.file(notificationPlayerAlbumArt.path),
    );

    playlist.add(
      AudioSource.uri(
        Uri.file(songPath),
        tag: mediaItem,
      ),
    );

    audioPlayer.setAudioSource(playlist, initialIndex: 0, preload: false);
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
      artUri: Uri.file(notificationPlayerAlbumArt.path),
    );

    playlist.add(
      AudioSource.uri(
        Uri.file(songPath),
        tag: mediaItem,
      ),
    );
    playlistLengthStreamNotifier();
  }
}

Future<void> previewSong(songPath) async {
  await audioPlayerPreview.setSourceDeviceFile(songPath);
}

void addToPlayNext(playNextFilePath) {
  File audioFile = File(playNextFilePath);
  String fileNameWithoutExtension =
      path.basenameWithoutExtension(playNextFilePath);
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
    artUri: Uri.file(notificationPlayerAlbumArt.path),
  );

  if (playlist.children.isEmpty) {
    playlist.add(
      AudioSource.uri(
        Uri.file(playNextFilePath),
        tag: mediaItem,
      ),
    );

    audioPlayer.setAudioSource(playlist, initialIndex: 0, preload: false);
    firstSongIndex = true;
    preLoadSongName();
    playOrPause();
  } else {
    playlist.insert(
      currentIndex.toInt() + 1,
      AudioSource.uri(
        Uri.file(playNextFilePath),
        tag: mediaItem,
      ),
    );
  }
  playlistLengthStreamNotifier();
}

Future<Map<String, String>> getAudioMetadata(String filePath) async {
  // This FFmpegKit.execute will increase the apk
  // because it uses all of the library of the pkg
  // final session = await FFmpegKit.execute('-i "$filePath"');

  // This FFprobeKit.execute will decrease the apk because its more light and faster
  final session = await FFprobeKit.execute('-i "$filePath"');
  final logs = await session.getOutput();

  final Map<String, String> metadata = {
    'sampleRate': '',
    'bitrate': '',
    'fileFormat': '',
  };

  metadata['fileFormat'] = getFileExtension(filePath);

  final sampleRateMatch = RegExp(r'(\d+) Hz').firstMatch(logs ?? '');
  if (sampleRateMatch != null) {
    final int rate = int.parse(sampleRateMatch.group(1)!);
    metadata['sampleRate'] = '${(rate / 1000).toStringAsFixed(1)} kHz';
  }

  final bitrateMatch = RegExp(r'bitrate: (\d+) kb/s').firstMatch(logs ?? '');
  if (bitrateMatch != null) {
    metadata['bitrate'] = '${bitrateMatch.group(1)} kb/s';
  }

  return metadata;
}

Future<String> getAudioMetadataDuration(String filePath) async {
  final session = await FFprobeKit.execute('-i "$filePath"');
  final logs = await session.getOutput();

  final durationMatch = RegExp(r'Duration: (\d{2}):(\d{2}):(\d{2})\.(\d{2}),')
      .firstMatch(logs ?? '');

  if (durationMatch != null) {
    final hours = int.parse(durationMatch.group(1)!);
    final minutes = durationMatch.group(2);
    final seconds = durationMatch.group(3);

    if (hours > 0) {
      return '$hours:$minutes:$seconds';
    } else {
      return '$minutes:$seconds';
    }
  }

  return '';
}
