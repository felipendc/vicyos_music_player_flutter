import 'package:vicyos_music/app/common/music_player/music.player.dart';

class RadioStationInfo {
  String radioSimpleName;
  String radioName;
  String radioLocation;
  String radioUrl;
  String radioStation;
  String? ratioStationLogo;
  RadioStationConnectionStatus? stationStatus;

  RadioStationInfo({
    required this.radioSimpleName,
    required this.radioName,
    required this.radioLocation,
    required this.radioUrl,
    required this.radioStation,
    this.ratioStationLogo,
    this.stationStatus,
  });
}
