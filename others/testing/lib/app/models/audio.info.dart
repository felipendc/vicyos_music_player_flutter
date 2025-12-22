class AudioInfo {
  String path;
  String name;
  String size;
  String format;

  AudioInfo({
    required this.path,
    required this.name,
    required this.size,
    required this.format,
  });

  static AudioInfo fromMap(Map<String, dynamic> map) {
    return AudioInfo(
      path: map['path'],
      name: map['name'],
      size: map['size'],
      format: map['format'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "path": path,
      "name": name,
      "size": size,
      "format": format,
    };
  }
}
