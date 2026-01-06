import 'dart:async';
import 'dart:io';

import 'package:audio_service/audio_service.dart';
import 'package:audioplayers/audioplayers.dart' as audio_players;
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_sound/public/flutter_sound_player.dart';
import 'package:just_audio/just_audio.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';
import 'package:vicyos_music/app/build_flags/build.flags.dart';
import 'package:vicyos_music/app/components/show.top.message.dart';
import 'package:vicyos_music/app/files_and_folders_handler/folders.and.files.related.dart';
import 'package:vicyos_music/app/models/audio.info.dart';
import 'package:vicyos_music/app/models/playlists.dart';
import 'package:vicyos_music/app/music_player/music.player.stream.controllers.dart';
import 'package:vicyos_music/app/radio_player/functions_and_streams/radio.functions.and.more.dart';
import 'package:vicyos_music/app/screen_orientation/screen.orientation.dart';
import 'package:vicyos_music/database/database.dart';
import 'package:vicyos_music/l10n/app_localizations.dart';
import 'package:volume_controller/volume_controller.dart';

import 'music.player.listeners.dart';

enum NavigationButtons { music, favorites, playlists, none }

enum CurrentLoopMode { all, one, shuffle, off }

enum FetchingSongs {
  fetching,
  noMusicFolderHasBeenFound,
  musicFolderIsEmpty,
  done,
  nullValue,
  permissionDenied,
}

// From audioPlayer.listener
NavigationButtons songCurrentRouteType = NavigationButtons.none;

// Manual listener only when playlist is empty
NavigationButtons activeNavigationButton = NavigationButtons.none;

// From the Multi Selection Screen
Set<AudioInfo> selectedItemsFromMultiselectionScreen = <AudioInfo>{};
List<AudioInfo> songModelListGlobal = [];

// It will be initiated by the listener in the main()
late bool isPlayerPreviewPlaying;

// If the user added songs to to an empty playlist when they were using the players preview
// play the song after closing the players preview bottomsheet or screen
bool playAfterClosingPlayersPreview = false;

bool isMultiSelectionScreenOpen = false;
String playingFromPlaylist = "";
bool appSettingsWasOpened = false;
late bool isPermissionGranted;
CurrentLoopMode currentLoopMode = CurrentLoopMode.all;
late final TextEditingController searchBoxController;
bool mainPlayerIsOpen = false;
late bool audioPlayerWasPlaying;
bool noDeviceMusicFolderFound = false;
bool isSongPreviewBottomSheetOpen = false;
String currentFolderPath = ""; //""The song folder will be displayed here...";
String currentSongFullPath = '';
int playlistCurrentLength = 0;
String currentLoopModeIcon = 'assets/img/repeat_mode/repeat_all.png';
late double volumeSliderValue;
String currentSongAlbumName = ""; //""Unknown Album";
String currentSongName = ""; //""The playlist is empty";
Duration currentSongDurationPosition = Duration.zero;
Duration currentSongTotalDuration = Duration.zero;
double sleekCircularSliderPosition = 0.0;
double sleekCircularSliderDuration = 100.0;
String currentSongArtistName = ""; //""Unknown Artist";
late final File notificationPlayerAlbumArt;
bool songIsPlaying = false;
bool isStopped = false;
int currentIndex = 0;
bool firstSongIndex = true;
bool lastSongIndex = false;
bool penultimateSongIndex = false;
Duration currentPosition = Duration.zero;
String currentLoopModeLabel = ""; //"Repeat: All";
late AudioPlayer audioPlayer;
late final MediaItem mediaItem;
final playlist = <AudioSource>[];

// Player for Preview
late audio_players.AudioPlayer audioPlayerPreview;
Duration currentSongDurationPositionPreview = Duration.zero;
Duration currentSongTotalDurationPreview = Duration.zero;
double sleekCircularSliderPositionPreview = 0.0;
double sleekCircularSliderDurationPreview = 100.0;

// FlutterSoundPlayer
final FlutterSoundPlayer flutterSoundPlayer = FlutterSoundPlayer();

// Functions

// Check the device type
bool deviceTypeIsTablet() => (deviceType == DeviceType.tablet);
bool deviceTypeIsSmartphone() => (deviceType == DeviceType.smartphone);

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

  // Set the volume system volume UI to be hidden
  VolumeController.instance.showSystemUI = false;
}

void setVolume(double value) {
  // Set the volume
  double volume = value / 100;
  VolumeController.instance.setVolume(volume);
}

void setVolumeJustAudio(double value) {
  // Set the just_audio player volume
  double volume = value / 100;
  audioPlayer.setVolume(volume);
  VolumeController.instance.setVolume(audioPlayer.volume);
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

Future<void> cleanPlaylist() async {
  audioPlayer.stop();
  await audioPlayer.clearAudioSources();
  audioPlayer.audioSources.clear();
  playlist.clear();
  songIsPlaying = false;
  currentSongDurationPosition = Duration.zero;
  currentSongTotalDuration = Duration.zero;
  sleekCircularSliderPosition = 0.0;

  sleekCircularSliderPosition = Duration.zero.inSeconds.toDouble();
  currentSongFullPath = "";
  playingFromPlaylist = "";
  currentSongNameNotifier();
  getCurrentSongFolderNotifier();
  clearCurrentPlaylistNotifier();
  rebuildSongsListScreenNotifier();
  clearCurrentPlaylistStreamController.sink.add(null);
  rebuildPlaylistCurrentLengthNotifier();
  activeNavigationButton = NavigationButtons.none; // Manual attribution
  songCurrentRouteType = NavigationButtons.none; // Via listener
  currentSongNavigationRouteNotifier();
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
    showLoopMode(context, AppLocalizations.of(context)!.repeating_one);
  } else if (currentLoopMode == CurrentLoopMode.one) {
    currentLoopMode = CurrentLoopMode.shuffle;
    repeatModeNotifier();
    audioPlayer.setLoopMode(LoopMode.all);
    audioPlayer.setShuffleModeEnabled(true);
    currentLoopModeIcon = "assets/img/repeat_mode/shuffle_1.png";
    debugPrint("Repeat: Shuffle");
    showLoopMode(context, AppLocalizations.of(context)!.playback_is_shuffled);
  } else if (currentLoopMode == CurrentLoopMode.shuffle) {
    currentLoopMode = CurrentLoopMode.off;
    repeatModeNotifier();
    audioPlayer.setShuffleModeEnabled(false);
    audioPlayer.setLoopMode(LoopMode.off);
    currentLoopModeIcon = "assets/img/repeat_mode/repeat_none.png";
    debugPrint("Repeat: Off");
    showLoopMode(context, AppLocalizations.of(context)!.repeating_off);
  } else if (currentLoopMode == CurrentLoopMode.off) {
    currentLoopMode = CurrentLoopMode.all;
    repeatModeNotifier();
    audioPlayer.setLoopMode(LoopMode.all);
    currentLoopModeIcon = "assets/img/repeat_mode/repeat_all.png";
    debugPrint("Repeat: All");
    showLoopMode(context, AppLocalizations.of(context)!.repeating_all);
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

Future<void> pickFolder(BuildContext context) async {
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
          // album: metadata?.albumName ?? AppLocalizations.of(context)!.unknown_album,

          // Using the name of the file as the title by default
          title: fileNameWithoutExtension,
          // artist: metadata?.albumArtistName ?? AppLocalizations.of(context)!.unknown_artist,
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
      if (context.mounted) {
        // preLoadSongName(context);
        updateCurrentSongNameOnlyOnce(context);
      }

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
          // album: metadata?.albumName ?? AppLocalizations.of(context)!.unknown_album,

          // Using the name of the file as the title by default
          title: fileNameWithoutExtension,
          // artist: metadata?.albumArtistName ?? AppLocalizations.of(context)!.unknown_artist,
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

Future<void> pickAndPlayAudio(BuildContext context) async {
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
          // album: metadata?.albumName ?? AppLocalizations.of(context)!.unknown_album,

          // Using the name of the file as the title by default
          title: fileNameWithoutExtension,
          // artist: metadata?.albumArtistName ?? AppLocalizations.of(context)!.unknown_artist,
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
      if (context.mounted) {
        // preLoadSongName(context);
        updateCurrentSongNameOnlyOnce(context);
      }
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
          // album: metadata?.albumName ?? AppLocalizations.of(context)!.unknown_album,

          // Using the name of the file as the title by default
          title: fileNameWithoutExtension,
          // artist: metadata?.albumArtistName ?? AppLocalizations.of(context)!.unknown_artist,
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

Future<void> setFolderAsPlaylist({
  String? playlistName,
  required List<AudioInfo> currentFolder,
  required int currentIndex,
  required BuildContext context,
  required NavigationButtons audioRoute,
  required NavigationButtons audioRouteEmptyPlaylist,
}) async {
  if (isRadioOn) {
    turnOffRadioStation();
  }
  stopSong();
  playlist.clear();

  playingFromPlaylist = playlistName ?? "";

  activeNavigationButton = audioRouteEmptyPlaylist; // Manual attribution
  currentSongNavigationRouteNotifier();

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
      // album: metadata?.albumName ?? AppLocalizations.of(context)!.unknown_album,

      // Using the name of the file as the title by default
      title: fileNameWithoutExtension,
      // artist: metadata?.albumArtistName ?? AppLocalizations.of(context)!.unknown_artist,
      artUri: Uri.file(notificationPlayerAlbumArt.path),
      extras: {
        "playedFromRoute": audioRoute,
        "size": filePath.size,
        "extension": filePath.extension,
      },
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
  // preLoadSongName(context);
  updateCurrentSongNameOnlyOnce(context);
  playOrPause();
  rebuildPlaylistCurrentLengthNotifier();
  rebuildFavoriteScreenNotifier();
}

Future<void> addFolderToPlaylist({
  required List<AudioInfo> currentFolder,
  required BuildContext context,
  required NavigationButtons audioRoute,
  required NavigationButtons audioRouteEmptyPlaylist,
}) async {
  if (isRadioOn) {
    turnOffRadioStation();
  }

  currentSongNavigationRouteNotifier();

  if (audioPlayer.audioSources.isEmpty) {
    activeNavigationButton = audioRouteEmptyPlaylist; // Manual attribution
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
        // album: metadata?.albumName ?? AppLocalizations.of(context)!.unknown_album,

        // Using the name of the file as the title by default
        title: fileNameWithoutExtension,
        // artist: metadata?.albumArtistName ?? AppLocalizations.of(context)!.unknown_artist,
        artUri: Uri.file(notificationPlayerAlbumArt.path),
        extras: {
          "playedFromRoute": audioRoute,
          "size": filePath.size,
          "extension": filePath.extension,
        },
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
    // preLoadSongName(context);
    updateCurrentSongNameOnlyOnce(context);
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
        // album: metadata?.albumName ?? AppLocalizations.of(context)!.unknown_album,

        // Using the name of the file as the title by default
        title: fileNameWithoutExtension,
        // artist: metadata?.albumArtistName ?? AppLocalizations.of(context)!.unknown_artist,
        artUri: Uri.file(notificationPlayerAlbumArt.path),
        extras: {
          "playedFromRoute": audioRoute,
          "size": filePath.size,
          "extension": filePath.extension,
        },
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
  rebuildFavoriteScreenNotifier();
}

Future<void> addSongToPlaylist({
  required BuildContext context,
  dynamic songPath,
  required NavigationButtons audioRoute,
  required NavigationButtons audioRouteEmptyPlaylist,
}) async {
  if (isRadioOn) {
    turnOffRadioStation();
  }

  if (audioPlayer.audioSources.isEmpty) {
    if (isSongPreviewBottomSheetOpen || isMultiSelectionScreenOpen) {
      playAfterClosingPlayersPreview = true;
    }
  }

  if (songPath is String) {
    currentSongNavigationRouteNotifier();

    if (audioPlayer.audioSources.isEmpty) {
      activeNavigationButton = audioRouteEmptyPlaylist; // Manual attribution
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
        // album: metadata?.albumName ?? AppLocalizations.of(context)!.unknown_album,

        // Using the name of the file as the title by default
        title: fileNameWithoutExtension,
        // artist: metadata?.albumArtistName ?? AppLocalizations.of(context)!.unknown_artist,
        artUri: Uri.file(notificationPlayerAlbumArt.path),
        extras: {
          "playedFromRoute": audioRoute,
          "size": getFileSize(songPath),
          "extension": getFileExtension(songPath),
        },
      );

      playlist.add(
        AudioSource.uri(
          Uri.file(songPath),
          tag: mediaItem,
        ),
      );

      audioPlayer.setAudioSources(playlist, initialIndex: 0, preload: true);
      firstSongIndex = true;
      // preLoadSongName(context);
      updateCurrentSongNameOnlyOnce(context);
      if (isSongPreviewBottomSheetOpen || isMultiSelectionScreenOpen) {
      } else {
        playOrPause();
      }
      showAddedToPlaylist(context, "", songName(songPath),
          AppLocalizations.of(context)!.added_to_the_playlist);
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
        // album: metadata?.albumName ?? AppLocalizations.of(context)!.unknown_album,

        // Using the name of the file as the title by default
        title: fileNameWithoutExtension,
        // artist: metadata?.albumArtistName ?? AppLocalizations.of(context)!.unknown_artist,
        artUri: Uri.file(notificationPlayerAlbumArt.path),
        extras: {
          "playedFromRoute": audioRoute,
          "size": getFileSize(songPath),
          "extension": getFileExtension(songPath),
        },
      );

      await audioPlayer.addAudioSource(
        AudioSource.uri(
          Uri.file(songPath),
          tag: mediaItem,
        ),
      );
      rebuildPlaylistCurrentLengthNotifier();

      if (context.mounted) {
        showAddedToPlaylist(context, "", songName(songPath),
            AppLocalizations.of(context)!.added_to_the_current_playlist);
      }
    }
    rebuildFavoriteScreenNotifier();
  } else if (songPath is Set<AudioInfo>) {
    currentSongNavigationRouteNotifier();

    activeNavigationButton = audioRouteEmptyPlaylist; // Manual attribution
    audioPlayerWasPlaying = true;
    playlist.clear();

    if (audioPlayer.audioSources.isEmpty) {
      playlist.clear();
      for (AudioInfo song in songPath) {
        // File audioFile = File(songPath);
        String fileNameWithoutExtension =
            path.basenameWithoutExtension(song.path);
        // String filePathAsId = audioFile.absolute.path;
        // Metadata? metadata;

        // try {
        //   metadata = await MetadataRetriever.fromFile(audioFile);
        // } catch (e) {
        //   debugPrint('Failed to extract metadata: $e');
        // }

        final mediaItem = MediaItem(
          id: const Uuid().v4(),
          // album: metadata?.albumName ?? AppLocalizations.of(context)!.unknown_album,

          // Using the name of the file as the title by default
          title: fileNameWithoutExtension,
          // artist: metadata?.albumArtistName ?? AppLocalizations.of(context)!.unknown_artist,
          artUri: Uri.file(notificationPlayerAlbumArt.path),
          extras: {
            "playedFromRoute": audioRoute,
            "size": song.size,
            "extension": song.extension,
          },
        );

        playlist.add(
          AudioSource.uri(
            Uri.file(song.path),
            tag: mediaItem,
          ),
        );
        rebuildPlaylistCurrentLengthNotifier();
      }

      audioPlayer.setAudioSources(playlist, initialIndex: 0, preload: true);
      firstSongIndex = true;
      if (context.mounted) {
        // preLoadSongName(context);
        updateCurrentSongNameOnlyOnce(context);
      }
      if (isSongPreviewBottomSheetOpen || isMultiSelectionScreenOpen) {
      } else {
        playOrPause();
      }
      if (context.mounted) {
        showAddedToPlaylist(
            context,
            "",
            AppLocalizations.of(context)!.song_plural(songPath.length),
            AppLocalizations.of(context)!
                .added_to_the_playlist_plural(songPath.length));
      }
      rebuildPlaylistCurrentLengthNotifier();
    } else {
      playlist.clear();

      for (AudioInfo song in songPath) {
        // File audioFile = File(songPath);
        String fileNameWithoutExtension =
            path.basenameWithoutExtension(song.path);
        // String filePathAsId = audioFile.absolute.path;
        // Metadata? metadata;

        // try {
        //   metadata = await MetadataRetriever.fromFile(audioFile);
        // } catch (e) {
        //   debugPrint('Failed to extract metadata: $e');
        // }

        final mediaItem = MediaItem(
          id: const Uuid().v4(),
          // album: metadata?.albumName ?? AppLocalizations.of(context)!.unknown_album,

          // Using the name of the file as the title by default
          title: fileNameWithoutExtension,
          // artist: metadata?.albumArtistName ?? AppLocalizations.of(context)!.unknown_artist,
          artUri: Uri.file(notificationPlayerAlbumArt.path),
          extras: {
            "playedFromRoute": audioRoute,
            "size": song.size,
            "extension": song.extension,
          },
        );

        await audioPlayer.addAudioSource(
          AudioSource.uri(
            Uri.file(song.path),
            tag: mediaItem,
          ),
        );
        rebuildPlaylistCurrentLengthNotifier();
      }

      if (context.mounted) {
        showAddedToPlaylist(
            context,
            "",
            AppLocalizations.of(context)!.song_plural(songPath.length),
            AppLocalizations.of(context)!
                .added_to_the_playlist_plural(songPath.length));
      }
    }
    rebuildFavoriteScreenNotifier();
  }
}

void addToPlayNext({
  required dynamic playNextFilePath,
  required BuildContext context,
  required NavigationButtons audioRoute,
  required NavigationButtons audioRouteEmptyPlaylist,
}) {
  if (audioPlayer.audioSources.isEmpty) {
    if (isSongPreviewBottomSheetOpen || isMultiSelectionScreenOpen) {
      playAfterClosingPlayersPreview = true;
    }
  }

  if (playNextFilePath is String) {
    if (audioPlayer.audioSources.isEmpty) {
      activeNavigationButton = audioRouteEmptyPlaylist; // Manual attribution
    }

    currentSongNavigationRouteNotifier();

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
      // album: metadata?.albumName ?? AppLocalizations.of(context)!.unknown_album,

      // Using the name of the file as the title by default
      title: fileNameWithoutExtension,
      // artist: metadata?.albumArtistName ?? AppLocalizations.of(context)!.unknown_artist,
      artUri: Uri.file(notificationPlayerAlbumArt.path),
      extras: {
        "playedFromRoute": audioRoute,
        "size": getFileSize(playNextFilePath),
        "extension": getFileExtension(playNextFilePath),
      },
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
      // preLoadSongName(context);
      updateCurrentSongNameOnlyOnce(context);
      rebuildPlaylistCurrentLengthNotifier();

      if (isSongPreviewBottomSheetOpen || isMultiSelectionScreenOpen) {
      } else {
        playOrPause();
      }
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
    rebuildFavoriteScreenNotifier();
  } else if (playNextFilePath is Set<AudioInfo>) {
    if (audioPlayer.audioSources.isEmpty) {
      activeNavigationButton = audioRouteEmptyPlaylist; // Manual attribution
    }
    currentSongNavigationRouteNotifier();

    List<AudioSource> selectedSongs = [];

    for (AudioInfo song in playNextFilePath) {
      File audioFile = File(song.path);
      String fileNameWithoutExtension =
          path.basenameWithoutExtension(song.path);
      String filePathAsId = audioFile.absolute.path;
      // Metadata? metadata;

      final mediaItem = MediaItem(
        id: filePathAsId,
        // album: metadata?.albumName ?? AppLocalizations.of(context)!.unknown_album,

        // Using the name of the file as the title by default
        title: fileNameWithoutExtension,
        // artist: metadata?.albumArtistName ?? AppLocalizations.of(context)!.unknown_artist,
        artUri: Uri.file(notificationPlayerAlbumArt.path),
        extras: {
          "playedFromRoute": audioRoute,
          "size": song.size,
          "extension": song.extension,
        },
      );

      selectedSongs.add(
        AudioSource.uri(
          Uri.file(song.path),
          tag: mediaItem,
        ),
      );
    }

    if (audioPlayer.audioSources.isEmpty) {
      audioPlayerWasPlaying = true;
      playlist.clear();
      playlist.addAll(
        selectedSongs,
      );

      audioPlayer.setAudioSources(playlist, initialIndex: 0, preload: true);
      firstSongIndex = true;
      // preLoadSongName(context);
      updateCurrentSongNameOnlyOnce(context);
      rebuildPlaylistCurrentLengthNotifier();
      if (isSongPreviewBottomSheetOpen || isMultiSelectionScreenOpen) {
      } else {
        playOrPause();
      }
    } else {
      playlist.clear();
      // audioSources.insert(
      audioPlayer.insertAudioSources(
        currentIndex.toInt() + 1,
        selectedSongs,
      );

      rebuildPlaylistCurrentLengthNotifier();
    }
    rebuildFavoriteScreenNotifier();
  }
}

NavigationButtons miuiNavigationButtonsBehavior() {
  if (navigationButtonsHasMiuiBehavior) {
    return activeNavigationButton;
  } else {
    return songCurrentRouteType;
  }
}

Future<bool> playlistNameAlreadyExist(String text) async {
  String trimmedText = text.trim().toLowerCase();
  if (trimmedText.isEmpty) return false;

  final List<Playlists> playlist = await AppDatabase.instance.getAllPlaylists();

  for (var playlistName in playlist) {
    if (playlistName.playlistName.toLowerCase() == trimmedText) {
      return true;
    }
  }
  return false;
}
