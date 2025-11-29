import 'dart:async';
import 'dart:io';

import 'package:audio_service/audio_service.dart';
import 'package:audioplayers/audioplayers.dart' as audio_players;
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:just_audio/just_audio.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';
import 'package:vicyos_music/app/common/files_and_folders_handler/folders.and.files.related.dart';
import 'package:vicyos_music/app/common/models/audio.info.dart';
import 'package:vicyos_music/app/common/models/folder.sources.dart';
import 'package:vicyos_music/app/common/music_player/music.player.stream.controllers.dart';
import 'package:vicyos_music/app/common/radio_player/functions_and_streams/radio.functions.and.more.dart';
import 'package:vicyos_music/app/common/widgets/show.top.message.dart';
import 'package:volume_controller/volume_controller.dart';

enum CurrentLoopMode { all, one, shuffle, off }

CurrentLoopMode currentLoopMode = CurrentLoopMode.all;
late final TextEditingController searchBoxController;
bool mainPlayerIsOpen = false;
late bool audioPlayerWasPlaying;
bool noDeviceMusicFolderFound = false;
bool isSongPreviewBottomSheetOpen = false;
String currentFolderPath = 'The song folder will be displayed here...';
String currentSongFullPath = '';
int playlistCurrentLength = 0;
String currentLoopModeIcon = 'assets/img/repeat_mode/repeat_all.png';
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
int currentIndex = 0;
bool firstSongIndex = true;
bool lastSongIndex = false;
bool penultimateSongIndex = false;
Duration currentPosition = Duration.zero;
String currentLoopModeLabel = 'Repeat: All';
late AudioPlayer audioPlayer;
late final MediaItem mediaItem;
final playlist = <AudioSource>[];

// Player for Preview
late audio_players.AudioPlayer audioPlayerPreview;
Duration currentSongDurationPositionPreview = Duration.zero;
Duration currentSongTotalDurationPreview = Duration.zero;
double sleekCircularSliderPositionPreview = 0.0;
double sleekCircularSliderDurationPreview = 100.0;

// Functions
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

Future<void> getCurrentVolume() async {
  double currentVolume = await VolumeController.instance.getVolume();
  volumeSliderValue = (currentVolume * 100);
  systemVolumeNotifier();
}

void initVolumeControl() async {
  VolumeController.instance.addListener(
    (volume) {
      volumeSliderValue = volume * 100;
      systemVolumeNotifier();
    },
  );
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

void setVolumeJustAudio(double value) {
  // Set the volume and keep the system volume UI hidden
  // VolumeController.instance.showSystemUI = false;
  double volume = value / 100;
  audioPlayer.setVolume(volume);
  VolumeController.instance.setVolume(audioPlayer.volume);
}

// This function should be used on a flutter.initState or GetX.on_init_app();
void playerEventStateStreamNotifier() {
  // I will need to use another state listener other than!
  audioPlayer.positionStream.listen(
    (position) {
      currentSongDurationPosition = position;
      sleekCircularSliderPosition = position.inSeconds.toDouble();
    },
  );

  // Get the duration and the full duration of the song for the sleekCircularSlider
  audioPlayer.durationStream.listen(
    (duration) {
      currentSongTotalDuration = duration ?? Duration.zero;
      sleekCircularSliderDuration = duration?.inSeconds.toDouble() ?? 100.0;
    },
  );

  // Pause PlayerPreview if the main player is playing
  // to avoid simultaneous audio playback
  audioPlayer.playerStateStream.listen(
    (playerState) {
      if (audioPlayerPreview.state.toString() == "PlayerState.playing" &&
          playerState.playing == true) {
        audioPlayerPreview.pause();
      }

      if (playerState.processingState == ProcessingState.completed) {
        songIsPlaying = false;
      }

      if (playerState.processingState == ProcessingState.completed &&
          audioPlayer.loopMode == LoopMode.off) {
        audioPlayer.setAudioSources(
            preload: true,
            audioPlayer.audioSources,
            initialIndex: audioPlayer.currentIndex);
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
  audioPlayer.playbackEventStream.listen(
    (event) {
      currentIndex = event.currentIndex ?? 0;
      debugPrint("Playlist current index: $currentIndex");
    },
  );
}

Future<void> defaultAlbumArt() async {
  // Load the image asset as a Uri
  final ByteData imageData = await rootBundle
      .load('assets/img/default_album_art/lofi-woman-album-cover-art_11.png');
  final Uint8List bytes = imageData.buffer.asUint8List();

  // Save the image to a temporary directory
  final tempDir = await getTemporaryDirectory();
  notificationPlayerAlbumArt =
      await File('${tempDir.path}/default_album_art.png').writeAsBytes(bytes);
}

// This func should be used on a flutter.initState or GetX.on_init_app();
void playerPreviewEventStateStreamNotifier() {
  audioPlayerPreview.onPositionChanged.listen(
    (position) {
      currentSongDurationPositionPreview = position;
      sleekCircularSliderPositionPreview = position.inSeconds.toDouble();
    },
  );

  // Get the duration and the full duration of the song for the sleekCircularSlider
  audioPlayerPreview.onDurationChanged.listen(
    (duration) {
      currentSongTotalDurationPreview = duration;
      sleekCircularSliderDurationPreview = duration.inSeconds.toDouble();
    },
  );
}

// This function will update the display the song title one the audio or folder is imported
void preLoadSongName() {
  audioPlayer.currentIndexStream.listen((index) {
    if (index == null) return; // The song hasn't been loaded yet
    if (index < 0 || index >= audioPlayer.sequence.length) return;

    final currentMediaItem = audioPlayer.sequence[index].tag as MediaItem;

    currentSongName = currentMediaItem.title;
    currentSongArtistName = currentMediaItem.artist ?? "Unknown Artist";
    currentSongAlbumName = currentMediaItem.album ?? "Unknown Album";

    currentSongNameNotifier();
    currentSongAlbumNotifier();

    currentIndex = index;
  });
}

Future<void> cleanPlaylist() async {
  audioPlayer.stop();
  await audioPlayer.clearAudioSources();
  audioPlayer.audioSources.clear();
  playlist.clear();
  songIsPlaying = false;
  rebuildPlaylistCurrentLengthNotifier();
  currentSongDurationPosition = Duration.zero;
  currentSongTotalDuration = Duration.zero;
  sleekCircularSliderPosition = 0.0;
  currentSongName = "The playlist is empty";
  currentSongNameNotifier();
  currentSongAlbumName = "Unknown Album";
  currentFolderPath = 'The song folder will be displayed here...';
  sleekCircularSliderPosition = Duration.zero.inSeconds.toDouble();
  currentSongFullPath = "";
  currentSongAlbumNotifier();
  getCurrentSongFolderNotifier();
  clearCurrentPlaylistNotifier();
  getCurrentSongFullPathNotifier();
  rebuildSongsListScreenNotifier();
  clearCurrentPlaylistStreamController.sink.add(null);
  rebuildPlaylistCurrentLengthNotifier();
}

Future<void> playOrPause() async {
  if (audioPlayer.audioSources.isEmpty) {
  } else {
    await turnOffRadioStation();
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
  await audioPlayer.seekToNext();
  if (currentIndex > 0) {
    firstSongIndex = false;
    debugPrint('INDEX IS GRATER THAN 0!');
  }

  if (currentIndex == audioPlayer.audioSources.length - 1) {
    lastSongIndex = true;
    debugPrint('INDEX IS THE LAST');
  } else {
    lastSongIndex = false;
  }
}

Future<void> previousSong() async {
  debugPrint('LIST TOTAL ITEM.${audioPlayer.audioSources.length}');
  if (currentIndex == 0) {
    firstSongIndex = true;
    debugPrint('INDEX IS EQUAL TO 0!');
  }

  if (currentIndex > 0) {
    firstSongIndex = false;
    debugPrint('INDEX IS GRATER THAN 0!');
  }

  await audioPlayer.seekToPrevious();

  if (currentIndex == audioPlayer.audioSources.length - 2) {
    penultimateSongIndex = true;
    debugPrint('INDEX IS THE PENULTIMATE ####');
  } else {
    penultimateSongIndex = false;
    debugPrint('INDEX IS NO LONGER THE PENULTIMATE ####');
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

void repeatMode(BuildContext context) {
  if (currentLoopMode == CurrentLoopMode.all) {
    currentLoopMode = CurrentLoopMode.one;
    repeatModeNotifier();
    audioPlayer.setLoopMode(LoopMode.one);
    currentLoopModeIcon = "assets/img/repeat_mode/repeat_one.png";
    debugPrint("Repeat: One");
    showLoopMode(context, "Repeating one");
  } else if (currentLoopMode == CurrentLoopMode.one) {
    currentLoopMode = CurrentLoopMode.shuffle;
    repeatModeNotifier();
    audioPlayer.setLoopMode(LoopMode.all);
    audioPlayer.setShuffleModeEnabled(true);
    currentLoopModeIcon = "assets/img/repeat_mode/shuffle_1.png";
    debugPrint("Repeat: Shuffle");
    showLoopMode(context, "Playback is shuffled");
  } else if (currentLoopMode == CurrentLoopMode.shuffle) {
    currentLoopMode = CurrentLoopMode.off;
    repeatModeNotifier();
    audioPlayer.setShuffleModeEnabled(false);
    audioPlayer.setLoopMode(LoopMode.off);
    currentLoopModeIcon = "assets/img/repeat_mode/repeat_none.png";
    debugPrint("Repeat: Off");
    showLoopMode(context, "Repeating off");
  } else if (currentLoopMode == CurrentLoopMode.off) {
    currentLoopMode = CurrentLoopMode.all;
    repeatModeNotifier();
    audioPlayer.setLoopMode(LoopMode.all);
    currentLoopModeIcon = "assets/img/repeat_mode/repeat_all.png";
    debugPrint("Repeat: All");
    showLoopMode(context, "Repeating all");
  }
}

Future<void> previewSong(String songPath) async {
  await audioPlayerPreview.setSourceDeviceFile(songPath);
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

Future<void> pickFolder() async {
  if (isRadioOn) {
    turnOffRadioStation();
  }
  stopSong();
  playlist.clear();

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

    debugPrint(folderFileNames.toString());
    if (audioPlayer.audioSources.isEmpty) {
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
        //   debugPrint('Failed to extract metadata: $e');
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
        rebuildPlaylistCurrentLengthNotifier();
      }
      await audioPlayer.setAudioSources(
        playlist,
        initialIndex: 0,
        preload: true,
      );
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
        //   debugPrint('Failed to extract metadata: $e');
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
        rebuildPlaylistCurrentLengthNotifier();
      }
    }
  } else {
    debugPrint("No folder has been selected");
  }
}

Future<void> pickAndPlayAudio() async {
  if (isRadioOn) {
    turnOffRadioStation();
  }
  stopSong();
  playlist.clear();

  FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowMultiple: true,
      allowedExtensions: ["mp3", "m4a", "ogg", "wav", "aac", "midi"]);

  if (result != null) {
    List<String>? selectedSongs;
    selectedSongs =
        result.paths.where((path) => path != null).cast<String>().toList();

    if (audioPlayer.audioSources.isEmpty) {
      for (String filePath in selectedSongs) {
        debugPrint('Processing file: $filePath');

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
        //   debugPrint('Failed to extract metadata: $e');
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
        rebuildPlaylistCurrentLengthNotifier();
      }

      audioPlayer.setAudioSources(playlist, initialIndex: 0, preload: true);
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
        //   debugPrint('Failed to extract metadata: $e');
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
        rebuildPlaylistCurrentLengthNotifier();
        debugPrint('Processing file: $filePath');
      }
    }
  }
}

//

Future<void> setFolderAsPlaylist(
    dynamic currentFolder, int currentIndex) async {
  if (isRadioOn) {
    turnOffRadioStation();
  }
  stopSong();
  playlist.clear();

  for (AudioInfo filePath in currentFolder) {
    // File audioFile = File(filePath.path);
    String fileNameWithoutExtension =
        path.basenameWithoutExtension(filePath.path);
    // String filePathAsId = audioFile.absolute.path;
    // Metadata? metadata;

    // try {
    //   metadata = await MetadataRetriever.fromFile(audioFile);
    // } catch (e) {
    //   debugPrint('Failed to extract metadata: $e');
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
    rebuildPlaylistCurrentLengthNotifier();
  }

  audioPlayer.setAudioSources(
    playlist,
    initialIndex: currentIndex,
    initialPosition: Duration.zero,
    preload: true,
  );

  firstSongIndex = true;
  preLoadSongName();
  playOrPause();
  rebuildPlaylistCurrentLengthNotifier();
}

Future<void> addFolderToPlaylist(dynamic currentFolder) async {
  if (isRadioOn) {
    turnOffRadioStation();
  }
  if (audioPlayer.audioSources.isEmpty) {
    playlist.clear();
    for (AudioInfo filePath in currentFolder) {
      // File audioFile = File(filePath.path);
      String fileNameWithoutExtension =
          path.basenameWithoutExtension(filePath.path);
      // String filePathAsId = audioFile.absolute.path;
      // Metadata? metadata;

      // try {
      //   metadata = await MetadataRetriever.fromFile(audioFile);
      // } catch (e) {
      //   debugPrint('Failed to extract metadata: $e');
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
      rebuildPlaylistCurrentLengthNotifier();
    }

    audioPlayer.setAudioSources(
      playlist,
      initialIndex: 0,
      initialPosition: Duration.zero,
      preload: true,
    );

    firstSongIndex = true;
    preLoadSongName();
    playOrPause();
    rebuildPlaylistCurrentLengthNotifier();
  } else {
    for (AudioInfo filePath in currentFolder) {
      playlist.clear();
      File audioFile = File(filePath.path);
      String fileNameWithoutExtension =
          path.basenameWithoutExtension(filePath.path);
      String filePathAsId = audioFile.absolute.path;
      // Metadata? metadata;

      // try {
      //   metadata = await MetadataRetriever.fromFile(audioFile);
      // } catch (e) {
      //   debugPrint('Failed to extract metadata: $e');
      // }

      final mediaItem = MediaItem(
        id: filePathAsId,
        // album: metadata?.albumName ?? 'Unknown Album',

        // Using the name of the file as the title by default
        title: fileNameWithoutExtension,
        // artist: metadata?.albumArtistName ?? 'Unknown Artist',
        artUri: Uri.file(notificationPlayerAlbumArt.path),
      );

      await audioPlayer.addAudioSource(
        AudioSource.uri(
          Uri.file(filePath.path),
          tag: mediaItem,
        ),
      );
      rebuildPlaylistCurrentLengthNotifier();
    }
  }
}

Future<void> addSongToPlaylist(BuildContext context, songPath) async {
  if (isRadioOn) {
    turnOffRadioStation();
  }
  if (audioPlayer.audioSources.isEmpty) {
    audioPlayerWasPlaying = true;
    playlist.clear();
    // File audioFile = File(songPath);
    String fileNameWithoutExtension = path.basenameWithoutExtension(songPath);
    // String filePathAsId = audioFile.absolute.path;
    // Metadata? metadata;

    // try {
    //   metadata = await MetadataRetriever.fromFile(audioFile);
    // } catch (e) {
    //   debugPrint('Failed to extract metadata: $e');
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

    audioPlayer.setAudioSources(playlist, initialIndex: 0, preload: false);
    firstSongIndex = true;
    preLoadSongName();
    playOrPause();
    showAddedToPlaylist(
        context, "Folder", songName(songPath), "Added to the playlist");
    rebuildPlaylistCurrentLengthNotifier();
  } else {
    playlist.clear();
    // File audioFile = File(songPath);
    String fileNameWithoutExtension = path.basenameWithoutExtension(songPath);
    // String filePathAsId = audioFile.absolute.path;
    // Metadata? metadata;

    // try {
    //   metadata = await MetadataRetriever.fromFile(audioFile);
    // } catch (e) {
    //   debugPrint('Failed to extract metadata: $e');
    // }

    final mediaItem = MediaItem(
      id: const Uuid().v4(),
      // album: metadata?.albumName ?? 'Unknown Album',

      // Using the name of the file as the title by default
      title: fileNameWithoutExtension,
      // artist: metadata?.albumArtistName ?? 'Unknown Artist',
      artUri: Uri.file(notificationPlayerAlbumArt.path),
    );

    await audioPlayer.addAudioSource(
      AudioSource.uri(
        Uri.file(songPath),
        tag: mediaItem,
      ),
    );
    rebuildPlaylistCurrentLengthNotifier();

    if (context.mounted) {
      showAddedToPlaylist(context, "Folder", songName(songPath),
          "Added to the current playlist");
    }
  }
}

void addToPlayNext(String playNextFilePath) {
  File audioFile = File(playNextFilePath);
  String fileNameWithoutExtension =
      path.basenameWithoutExtension(playNextFilePath);
  String filePathAsId = audioFile.absolute.path;
  // Metadata? metadata;

  // try {
  //   metadata = await MetadataRetriever.fromFile(audioFile);
  // } catch (e) {
  //   debugPrint('Failed to extract metadata: $e');
  // }

  final mediaItem = MediaItem(
    id: filePathAsId,
    // album: metadata?.albumName ?? 'Unknown Album',

    // Using the name of the file as the title by default
    title: fileNameWithoutExtension,
    // artist: metadata?.albumArtistName ?? 'Unknown Artist',
    artUri: Uri.file(notificationPlayerAlbumArt.path),
  );

  if (audioPlayer.audioSources.isEmpty) {
    audioPlayerWasPlaying = true;
    playlist.clear();
    playlist.add(
      AudioSource.uri(
        Uri.file(playNextFilePath),
        tag: mediaItem,
      ),
    );

    audioPlayer.setAudioSources(playlist, initialIndex: 0, preload: true);
    firstSongIndex = true;
    preLoadSongName();
    rebuildPlaylistCurrentLengthNotifier();
    playOrPause();
  } else {
    playlist.clear();
    // audioSources.insert(
    audioPlayer.insertAudioSource(
      currentIndex.toInt() + 1,
      AudioSource.uri(
        Uri.file(playNextFilePath),
        tag: mediaItem,
      ),
    );

    rebuildPlaylistCurrentLengthNotifier();
  }
}
