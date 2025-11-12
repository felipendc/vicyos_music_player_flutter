class RadioStationInfo {
  String radioSimpleName;
  String radioName;
  String radioInfo;
  String radioUrl;
  String radioStation;
  String? ratioStationLogo;

  RadioStationInfo({
    required this.radioSimpleName,
    required this.radioName,
    required this.radioInfo,
    required this.radioUrl,
    required this.radioStation,
    this.ratioStationLogo,
  });
}
