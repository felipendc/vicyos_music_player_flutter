import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:vicyos_music_player/app/reusable_functions/music_player.dart';

class HomeController extends GetxController {
  final RxBool playlistIsEmpty = true.obs;
  final RxString currentSongName = 'The playlist is empty!'.obs;
  final RxString currentSongArtistName = 'Unknown Artist'.obs;
  final RxString currentSongAlbumName = 'Unknown Album'.obs;

  final Rx<Duration> currentSongDurationPostion = Duration.zero.obs;
  final Rx<Duration> currentSongTotalDuration = Duration.zero.obs;

  final RxBool songIsPlaying = false.obs;
  final RxBool isStopped = false.obs;
  //
  final RxInt currentIndex = 0.obs;
  final RxBool firstSongIndex = true.obs;
  final RxBool lastSongIndex = false.obs;
  final RxBool penultimateSongIndex = false.obs;
  //
  final Rx<Duration> currentPosition = Duration.zero.obs;
  final Rx<LoopMode> currentLoopMode = LoopMode.all.obs;
  final RxString currentLoopModeLabel = 'Repeat: Off'.obs;
  final RxString currentLoopModeIcone = 'assets/img/repeat_all.png'.obs;
  final Rx<Duration> songTotalDuration = Duration.zero.obs;

  Rx<ConcatenatingAudioSource> playlist = ConcatenatingAudioSource(
    useLazyPreparation: false,
    shuffleOrder: DefaultShuffleOrder(),
    // Specify the playlist items
    children: [],
  ).obs;

  @override
  void onInit() {
    super.onInit();
    audioPlayer = AudioPlayer();
    playerEventStateStreamListener();
  }

  @override
  void onClose() {
    super.onClose();
    super.dispose();
  }
}
