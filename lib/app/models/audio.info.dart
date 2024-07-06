class AudioInfo {
  String path;
  String name;
  String? album;
  String? size;
  String? format;

  AudioInfo({
    required this.path,
    required this.name,
    this.album,
    this.size,
    this.format,
  });
}
