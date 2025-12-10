import 'package:vicyos_music/app/common/radio_player/functions_and_streams/radio.functions.and.more.dart';

class RadioStationInfo {
  String id;
  String radioSimpleName;
  String radioName;
  String radioLocation;
  String radioUrl;
  String radioStation;
  String? ratioStationLogo;
  RadioStationConnectionStatus? stationStatus;

  RadioStationInfo({
    required this.id,
    required this.radioSimpleName,
    required this.radioName,
    required this.radioLocation,
    required this.radioUrl,
    required this.radioStation,
    this.ratioStationLogo,
    this.stationStatus,
  });

  static RadioStationInfo fromMap(Map<String, dynamic> map) {
    return RadioStationInfo(
      id: map["id"],
      radioSimpleName: map['radioSimpleName'],
      radioName: map['radioName'],
      radioLocation: map['radioLocation'],
      radioUrl: map['radioUrl'],
      radioStation: map['radioStation'],
      ratioStationLogo: map['ratioStationLogo'],
      stationStatus: map['stationStatus'] != null
          ? RadioStationConnectionStatus.values.byName(map['stationStatus'])
          : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "radioSimpleName": radioSimpleName,
      "radioName": radioName,
      "radioLocation": radioLocation,
      "radioUrl": radioUrl,
      "radioStation": radioStation,
      "ratioStationLogo": ratioStationLogo,
      "stationStatus": stationStatus?.name,
    };
  }
}
