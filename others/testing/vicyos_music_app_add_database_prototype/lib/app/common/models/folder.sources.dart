class FolderSources {
  String path;
  int songs;

  FolderSources({
    required this.path,
    required this.songs,
  });

  static FolderSources fromMap(Map<String, dynamic> map) {
    return FolderSources(
      path: map["path"],
      songs: map["songs"],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "path": path,
      "songs": songs,
    };
  }
}
