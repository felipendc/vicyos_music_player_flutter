import 'package:vicyos_music/app/models/audio.info.dart';

class Playlists {
  String playlistName;
  List<AudioInfo> playlistSongs;

  Playlists({
    required this.playlistName,
    required this.playlistSongs,
  });

  static Playlists fromMap(Map<String, dynamic> map) {
    return Playlists(
      playlistName: map["playlistName"],
      playlistSongs: (map["playlistSongs"] as List)
          .map((e) => AudioInfo.fromMap(e))
          .toList(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "playlistName": playlistName,
      "playlistSongs": playlistSongs.map((e) => e.toMap()).toList(),
    };
  }
}
