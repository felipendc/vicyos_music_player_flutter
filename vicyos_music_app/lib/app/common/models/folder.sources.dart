import 'package:vicyos_music/app/common/models/audio.info.dart';

class FolderSources {
  String folderPath;
  int folderSongCount;
  List<AudioInfo> songPathsList;

  FolderSources({
    required this.folderPath,
    required this.folderSongCount,
    required this.songPathsList,
  });

  static FolderSources fromMap(Map<String, dynamic> map) {
    return FolderSources(
      folderPath: map["path"],
      folderSongCount: map["songs"],
      songPathsList: (map["songPathList"] as List)
          .map((e) => AudioInfo.fromMap(e))
          .toList(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "path": folderPath,
      "songs": folderSongCount,
      "songPathList": songPathsList.map((e) => e.toMap()).toList(),
    };
  }
}

//
// class FolderSources {
//   String path;
//   int songs;
//
//   FolderSources({
//     required this.path,
//     required this.songs,
//   });
//
//   static FolderSources fromMap(Map<String, dynamic> map) {
//     return FolderSources(
//       path: map["path"],
//       songs: map["songs"],
//     );
//   }
//
//   Map<String, dynamic> toMap() {
//     return {
//       "path": path,
//       "songs": songs,
//     };
//   }
// }
