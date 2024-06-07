import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:vicyos_music_player/app/reusable_functions/music_player.dart';

class HomeController extends GetxController {
  final RxBool playlistIsEmpty = true.obs;
  final RxString currentSongName = 'The playlist is empty'.obs;
  final RxString currentSongNameTrimmed = 'The playlist is empty'.obs;

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
  //
  final RxDouble sleekCircularSliderPosition = 0.0.obs;
  RxDouble sleekCircularSliderDuration =
      100.0.obs; // Initialize with default max value

  final RxList<AudioSource> audioSources = <AudioSource>[].obs;
  late ConcatenatingAudioSource playlist;

  @override
  void onInit() {
    super.onInit();
    audioPlayer = AudioPlayer();
    audioPlayer.setLoopMode(LoopMode.all);

    playlist = ConcatenatingAudioSource(
      useLazyPreparation: false,
      shuffleOrder: DefaultShuffleOrder(),
      children: audioSources,
    );
  }

  @override
  void onClose() {
    super.onClose();
    super.dispose();
  }

  String getFirst30Characters() {
    if (controller.currentSongName.value.length <= 21) {
      return controller.currentSongName
          .value; // If the input is already 30 characters or less, return the input as is
    } else {
      return "${controller.currentSongName.value.substring(0, 30)}..."; // Return the first 30 characters of the input
    }
  }
}
