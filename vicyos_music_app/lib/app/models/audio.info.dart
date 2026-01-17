class AudioInfo {
  String path;
  String name;
  String size;
  String format;
  String extension;
  String? duration;

  AudioInfo({
    required this.path,
    required this.name,
    required this.size,
    required this.format,
    required this.extension,
    this.duration,
  });

  static AudioInfo fromMap(Map<String, dynamic> map) {
    return AudioInfo(
      path: map['path'],
      name: map['name'],
      size: map['size'],
      format: map['format'],
      extension: map['extension'],
      duration: map['duration'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "path": path,
      "name": name,
      "size": size,
      "format": format,
      "extension": extension,
      "duration": duration,
    };
  }

  /// COPIES THE OBJECT, CHANGING ONLY THE NECESSARY FIELDS
  AudioInfo copyWith({
    String? path,
    String? name,
    String? size,
    String? format,
    String? extension,
    String? duration,
  }) {
    return AudioInfo(
      path: path ?? this.path,
      name: name ?? this.name,
      size: size ?? this.size,
      format: format ?? this.format,
      extension: extension ?? this.extension,
      duration: duration ?? this.duration,
    );
  }
}
