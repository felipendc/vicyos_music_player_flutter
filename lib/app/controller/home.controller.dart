import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:vicyos_music_player/app/reusable_functions/music_player.dart';

class HomeController extends GetxController {
  final RxBool playlistIsEmpty = true.obs;
  final RxBool songIsPlaying = false.obs;
  //
  final RxBool firstSongIndex = true.obs;
  final RxBool lastSongIndex = false.obs;
  final RxBool penultimateSongIndex = false.obs;
  //
  final RxInt currentIndex = 0.obs;
  final Rx<Duration> currentPosition = Duration.zero.obs;
  final Rx<LoopMode> currentLoopMode = LoopMode.off.obs;
  final RxString currentLoopModeLabel = 'Repeat: Off'.obs;
  final RxBool isStopped = false.obs;
  final RxString currentSongName = ''.obs;
  final Rx<Duration> totalDuration = Duration.zero.obs;
  final RxList<dynamic> listas = [].obs;

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
