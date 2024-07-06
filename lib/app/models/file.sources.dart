class AudioInfo {
  String path;
  String name;
  String? size;
  String? extension;

  AudioInfo({
    required this.path,
    required this.name,
    this.size,
    this.extension,
  });
}
