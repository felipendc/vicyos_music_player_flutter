import 'dart:io';
import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_media_metadata/flutter_media_metadata.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:vicyos_music_player/app/reusable_functions/music_player.dart';
import 'package:volume_controller/volume_controller.dart';
import 'package:path/path.dart' as path;

class HomeController extends GetxController {
  RxList musicFolderPaths = [].obs;
  RxList folderSongList = [].obs;
  var volumeSliderValue = 50.0.obs;
  RxString volumeSliderStatus = 'idle'.obs;
  Rx<MaterialColor> volumeSliderStatusColor = Colors.amber.obs;
  //
  final RxBool playlistIsEmpty = true.obs;
  final RxString currentSongName = 'The playlist is empty'.obs;
  //
  final RxString currentSongArtistName = 'Unknown Artist'.obs;
  final RxString currentSongAlbumName = 'Unknown Album'.obs;
  final RxBool isFirstArtDemoCover = true.obs;
  //
  final Rx<Duration> currentSongDurationPostion = Duration.zero.obs;
  final Rx<Duration> currentSongTotalDuration = Duration.zero.obs;
  //
  final RxBool songIsPlaying = false.obs;
  final RxBool isStopped = false.obs;
  //
  final RxInt playlistLength = 0.obs;
  final Rx<int> currentIndex = 0.obs;
  final RxBool firstSongIndex = true.obs;
  final RxBool lastSongIndex = false.obs;
  final RxBool penultimateSongIndex = false.obs;
  final RxBool playlistTrailingIndex = false.obs;

  //
  final Rx<Duration> currentPosition = Duration.zero.obs;
  final Rx<LoopMode> currentLoopMode = LoopMode.all.obs;
  final RxString currentLoopModeLabel = 'Repeat: Off'.obs;
  final RxString currentLoopModeIcone = 'assets/img/repeat_all.png'.obs;
  final Rx<Duration> songTotalDuration = Duration.zero.obs;
  //
  final RxDouble sleekCircularSliderPosition = 0.0.obs;
  RxDouble sleekCircularSliderDuration =
      100.0.obs; // Initialize with default max value
  //
  final RxList<AudioSource> audioSources = <AudioSource>[].obs;
  late ConcatenatingAudioSource playlist;

  @override
  void onInit() {
    super.onInit();

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

  @override
  void onClose() {
    super.onClose();
    VolumeController().removeListener();
    super.dispose();
  }

  Future<void> setFolderAsPlaylist(currentFolder, currenIndex) async {
    // controller.folderSongList.clear();
    stopSong();
    playlist.clear();

    for (String filePath in currentFolder) {
      File audioFile = File(filePath);
      String fileNameWithoutExtension = path.basenameWithoutExtension(filePath);
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
      playlistLength.value = audioSources.length;
    }

    audioPlayer.setAudioSource(playlist,
        initialIndex: currenIndex, preload: false);
    playlistIsEmpty.value = false;
    firstSongIndex.value = true;
    preLoadSongName();
    playOrPause();
    // print("Testing");
  }
}
