class AudioInfo {
  String path;
  String name;
  String? size;
  String? format;

  AudioInfo({
    required this.path,
    required this.name,
    this.size,
    this.format,
  });
}
