import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';

class HomeController extends GetxController {
  final RxBool playlistIsEmpty = true.obs;
  final RxBool hasNextSong = false.obs;
  final RxBool hasPreviousSong = false.obs;
  final Rx<LoopMode> currentLoopMode = LoopMode.off.obs;
  final RxString currentLoopModeLabel = 'Repeat: Off'.obs;
  final RxBool songIsPlaying = false.obs;
  final RxBool isStopped = false.obs;
  final Rx<Duration> currentPosition = Duration.zero.obs;
  final Rx<Duration> totalDuration = Duration.zero.obs;
  final RxList<dynamic> listas = [].obs;
  late AudioPlayer audioPlayer;

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
  }

  @override
  void onClose() {
    super.onClose();
    super.dispose();
  }
}
