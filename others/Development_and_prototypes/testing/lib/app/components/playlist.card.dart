import 'package:flutter/material.dart';
import 'package:vicyos_music/app/color_palette/color_extension.dart';
import 'package:vicyos_music/app/models/playlists.dart';
import 'package:vicyos_music/l10n/app_localizations.dart';

class PlaylistCard extends StatelessWidget {
  final List<Playlists> playlistModel;
  final int index;

  const PlaylistCard(
      {super.key, required this.playlistModel, required this.index});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xff272A3E),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.06),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.18),
            blurRadius: 10,
            offset: const Offset(0, 6),
          ),

          // subtle top highlight
          BoxShadow(
            color: Colors.white.withValues(alpha: 0.03),
            blurRadius: 4,
            offset: const Offset(0, -1),
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            child:
                // Play
                Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: Colors.white10,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.play_arrow,
                size: 20,
                color: Colors.white70,
              ),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 10),

              // Image
              Expanded(
                child: Center(
                  child: Image.asset(
                    "assets/img/playlist/playlist_flaticon.png",
                    height: 90,
                    fit: BoxFit.contain,
                    // color: TColor.focus,
                  ),
                ),
              ),

              const SizedBox(height: 10),

              // Playlist Name
              Text(
                playlistModel[index].playlistName,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: TColor.lightGray,
                ),
              ),

              const SizedBox(height: 0),

              // Playlist total of songs
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Text(
                        playlistModel[index].playlistSongs.length.toString(),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: Colors.white60,
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(width: 4),
                      Text(
                        AppLocalizations.of(context)!.playlist_total_of_songs(
                            playlistModel[index].playlistSongs.length),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: Colors.white60,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
