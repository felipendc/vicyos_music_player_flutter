// import 'dart:io';
// import 'package:audio_service/audio_service.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_media_metadata/flutter_media_metadata.dart';
// import 'package:get/get.dart';
// import 'package:just_audio/just_audio.dart';
// import 'package:vicyos_music_player/app/functions/music_player.dart';
// import 'package:vicyos_music_player/app/models/audio.info.dart';
// import 'package:vicyos_music_player/app/models/folder.sources.dart';
// import 'package:volume_controller/volume_controller.dart';
// import 'package:path/path.dart' as path;

// class HomeController extends GetxController {
  // RxList<FolderSources> musicFolderPaths = <FolderSources>[].obs;
  // RxList<AudioInfo> folderSongList = <AudioInfo>[].obs;
  // var volumeSliderValue = 50.0.obs;
  // RxString volumeSliderStatus = 'idle'.obs;
  // Rx<MaterialColor> volumeSliderStatusColor = Colors.amber.obs;
  //
  // final RxBool playlistIsEmpty = true.obs;
  // final RxString currentSongName = 'The playlist is empty'.obs;
  //
  // final RxString currentSongArtistName = 'Unknown Artist'.obs;
  // final RxString currentSongAlbumName = 'Unknown Album'.obs;
  // final RxBool isFirstArtDemoCover = true.obs;
  //
  // final Rx<Duration> currentSongDurationPostion = Duration.zero.obs;
  // final Rx<Duration> currentSongTotalDuration = Duration.zero.obs;
  //
  // final RxBool songIsPlaying = false.obs;
  // final RxBool isStopped = false.obs;
  // //
  // final RxInt playlistLength = 0.obs;
  // final Rx<int> currentIndex = 0.obs;
  // final RxBool firstSongIndex = true.obs;
  // final RxBool lastSongIndex = false.obs;
  // final RxBool penultimateSongIndex = false.obs;
  // final RxBool playlistTrailingIndex = false.obs;
  // //
  // final Rx<Duration> currentPosition = Duration.zero.obs;
  // final Rx<LoopMode> currentLoopMode = LoopMode.all.obs;
  // final RxString currentLoopModeLabel = 'Repeat: All'.obs;
  // final RxString currentLoopModeIcone = 'assets/img/repeat_all.png'.obs;
  // final Rx<Duration> songTotalDuration = Duration.zero.obs;
  //
  // final RxDouble sleekCircularSliderPosition = 0.0.obs;
  // RxDouble sleekCircularSliderDuration =
  //     100.0.obs; // Initialize with default max value
  //
  // final RxList<AudioSource> audioSources = <AudioSource>[].obs;
  // late ConcatenatingAudioSource playlist;

  // @override
  // void onInit() {
  //   super.onInit();

  // initVolumeControl();
  // audioPlayer = AudioPlayer();
  // audioPlayer.setLoopMode(LoopMode.all);
  // playlist = ConcatenatingAudioSource(
  //   useLazyPreparation: false,
  //   shuffleOrder: DefaultShuffleOrder(),
  //   children: audioSources,
  // );
  // playerEventStateStreamListener();
  // }

  // @override
  // void onClose() {
  //   super.onClose();
  //   VolumeController().removeListener();
  //   super.dispose();
  // }

  // Future<void> setFolderAsPlaylist(currentFolder, currenIndex) async {
  //   // controller.folderSongList.clear();
  //   stopSong();
  //   await playlist.clear();

  //   for (AudioInfo filePath in currentFolder) {
  //     File audioFile = File(filePath.path);
  //     String fileNameWithoutExtension =
  //         path.basenameWithoutExtension(filePath.path);
  //     String filePathAsId = audioFile.absolute.path;
  //     Metadata? metadata;

  //     try {
  //       metadata = await MetadataRetriever.fromFile(audioFile);
  //     } catch (e) {
  //       print('Failed to extract metadata: $e');
  //     }

  //     final mediaItem = MediaItem(
  //       id: filePathAsId,
  //       album: metadata?.albumName ?? 'Unknown Album',

  //       // Using the name of the file as the title by default
  //       title: fileNameWithoutExtension,
  //       artist: metadata?.albumArtistName ?? 'Unknown Artist',
  //     );

  //     playlist.add(
  //       AudioSource.uri(
  //         Uri.file(filePath.path),
  //         tag: mediaItem,
  //       ),
  //     );
  //     playlistLenghtStreamListener();
  //   }

  //   audioPlayer.setAudioSource(playlist,
  //       initialIndex: currenIndex, preload: false);
  //   playlistIsEmpty = false;
  //   firstSongIndex = true;
  //   preLoadSongName();
  //   playOrPause();
  //   // print("Testing");
  // }

  // Future<void> addFolderToPlaylist(currentFolder) async {
  //   if (audioSources.isEmpty) {
  //     for (AudioInfo filePath in currentFolder) {
  //       File audioFile = File(filePath.path);
  //       String fileNameWithoutExtension =
  //           path.basenameWithoutExtension(filePath.path);
  //       String filePathAsId = audioFile.absolute.path;
  //       Metadata? metadata;

  //       try {
  //         metadata = await MetadataRetriever.fromFile(audioFile);
  //       } catch (e) {
  //         print('Failed to extract metadata: $e');
  //       }

  //       final mediaItem = MediaItem(
  //         id: filePathAsId,
  //         album: metadata?.albumName ?? 'Unknown Album',

  //         // Using the name of the file as the title by default
  //         title: fileNameWithoutExtension,
  //         artist: metadata?.albumArtistName ?? 'Unknown Artist',
  //       );

  //       playlist.add(
  //         AudioSource.uri(
  //           Uri.file(filePath.path),
  //           tag: mediaItem,
  //         ),
  //       );
  //       playlistLenghtStreamListener();
  //     }

  //     audioPlayer.setAudioSource(playlist, initialIndex: 0, preload: false);
  //     playlistIsEmpty = false;
  //     firstSongIndex = true;
  //     preLoadSongName();
  //     playOrPause();

  //     // print("Testing");
  //   } else {
  //     for (AudioInfo filePath in currentFolder) {
  //       File audioFile = File(filePath.path);
  //       String fileNameWithoutExtension =
  //           path.basenameWithoutExtension(filePath.path);
  //       String filePathAsId = audioFile.absolute.path;
  //       Metadata? metadata;

  //       try {
  //         metadata = await MetadataRetriever.fromFile(audioFile);
  //       } catch (e) {
  //         print('Failed to extract metadata: $e');
  //       }

  //       final mediaItem = MediaItem(
  //         id: filePathAsId,
  //         album: metadata?.albumName ?? 'Unknown Album',

  //         // Using the name of the file as the title by default
  //         title: fileNameWithoutExtension,
  //         artist: metadata?.albumArtistName ?? 'Unknown Artist',
  //       );

  //       playlist.add(
  //         AudioSource.uri(
  //           Uri.file(filePath.path),
  //           tag: mediaItem,
  //         ),
  //       );
  //       playlistLenghtStreamListener();
  //     }

  //     playlistIsEmpty = false;
  //   }
  // }

  // Future<void> addSongToPlaylist(songPath) async {
  //   if (audioSources.isEmpty) {
  //     File audioFile = File(songPath);
  //     String fileNameWithoutExtension = path.basenameWithoutExtension(songPath);
  //     String filePathAsId = audioFile.absolute.path;
  //     Metadata? metadata;

  //     try {
  //       metadata = await MetadataRetriever.fromFile(audioFile);
  //     } catch (e) {
  //       print('Failed to extract metadata: $e');
  //     }

  //     final mediaItem = MediaItem(
  //       id: filePathAsId,
  //       album: metadata?.albumName ?? 'Unknown Album',

  //       // Using the name of the file as the title by default
  //       title: fileNameWithoutExtension,
  //       artist: metadata?.albumArtistName ?? 'Unknown Artist',
  //     );

  //     playlist.add(
  //       AudioSource.uri(
  //         Uri.file(songPath),
  //         tag: mediaItem,
  //       ),
  //     );

  //     playlistLenghtStreamListener();

  //     audioPlayer.setAudioSource(playlist, initialIndex: 0, preload: false);
  //     playlistIsEmpty = false;
  //     firstSongIndex = true;
  //     preLoadSongName();
  //     playOrPause();

  //     // print("Testing");
  //   } else {
  //     File audioFile = File(songPath);
  //     String fileNameWithoutExtension = path.basenameWithoutExtension(songPath);
  //     String filePathAsId = audioFile.absolute.path;
  //     Metadata? metadata;

  //     try {
  //       metadata = await MetadataRetriever.fromFile(audioFile);
  //     } catch (e) {
  //       print('Failed to extract metadata: $e');
  //     }

  //     final mediaItem = MediaItem(
  //       id: filePathAsId,
  //       album: metadata?.albumName ?? 'Unknown Album',

  //       // Using the name of the file as the title by default
  //       title: fileNameWithoutExtension,
  //       artist: metadata?.albumArtistName ?? 'Unknown Artist',
  //     );

  //     playlist.add(
  //       AudioSource.uri(
  //         Uri.file(songPath),
  //         tag: mediaItem,
  //       ),
  //     );
  //     playlistLenghtStreamListener();

  //     playlistIsEmpty = false;
  //   }
  // }
// }
