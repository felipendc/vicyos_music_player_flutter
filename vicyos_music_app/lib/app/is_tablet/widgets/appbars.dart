import 'package:flutter/material.dart';
import 'package:vicyos_music/app/common/color_extension.dart';
import 'package:vicyos_music/app/is_tablet/functions/folders.and.files.related.dart';
import 'package:vicyos_music/app/is_tablet/view/bottomsheet/bottom.sheet.folders.to.playlist.dart';
import 'package:vicyos_music/app/is_tablet/view/bottomsheet/bottom.sheet.players.appbar.actions.dart';
import 'package:vicyos_music/app/common/music_player/music.player.dart';

AppBar homePageAppBar() {
  return AppBar(
    shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(5))),
    toolbarHeight: 60,
    elevation: 0,
    backgroundColor: TColor.bg,
    title: Center(
      child: GestureDetector(
        onTap: () async {
          musicFolderPaths.clear();
          await listMusicFolders();
          listPlaylistFolderStreamNotifier();
        },
        child: Text(
          textAlign: TextAlign.center,
          ' SCAN MUSIC FOLDERS ',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: TColor.org,
            fontSize: 20,
          ),
        ),
      ),
    ),
  );
}

AppBar songsListAppBar(
    {required String folderPath, required BuildContext context}) {
  return AppBar(
    shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(5))),
    toolbarHeight: 60,
    automaticallyImplyLeading: false,
    leading: Padding(
      padding: const EdgeInsets.only(left: 14),
      child: IconButton(
        splashRadius: 20,
        icon: Icon(
          Icons.arrow_back,
          color: TColor.org,
        ),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
    ),
    elevation: 0,
    centerTitle: true,
    backgroundColor: TColor.bg,
    title: Text(
      folderName(folderPath),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: TextStyle(
        fontWeight: FontWeight.w600,
        color: TColor.org,
        fontSize: 22,
      ),
    ),
    actions: [
      Padding(
        padding: const EdgeInsets.only(right: 20),
        child: IconButton(
          splashRadius: 22,
          icon: Icon(
            color: TColor.org,
            Icons.more_horiz_rounded,
          ),
          onPressed: () {
            showModalBottomSheet<void>(
              backgroundColor: Colors.transparent,
              context: context,
              builder: (BuildContext context) {
                return FolderToPlaylistBottomSheet(folderPath: folderPath);
              },
            );
          },
        ),
      )
    ],
  );
}

AppBar mainPlayerViewAppBar(BuildContext context) {
  return AppBar(
    shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(5))),
    toolbarHeight: 60,
    elevation: 0,
    automaticallyImplyLeading: false,
    // leading: SizedBox(
    //   width: 45,
    //   height: 45,
    //   child: Padding(
    //     padding: const EdgeInsets.only(left: 10),
    //     child: IconButton(
    //       splashRadius: 20,
    //       icon: Image.asset("assets/img/keyboard_arrow_down.png"),
    //       onPressed: () {
    //         Navigator.pop(context);
    //       },
    //     ),
    //   ),
    // ),
    centerTitle: true,
    backgroundColor: TColor.bg,
    title: Text(
      "Vicyos Music",
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: TextStyle(
        fontWeight: FontWeight.w900,
        color: TColor.primaryText80,
        fontSize: 23,
      ),
    ),
    actions: [
      Padding(
        padding: const EdgeInsets.only(right: 10),
        child: Padding(
          padding: const EdgeInsets.only(left: 10),
          child: SizedBox(
            width: 50,
            height: 50,
            child: IconButton(
              splashRadius: 20,
              icon: Image.asset("assets/img/more_horiz.png"),
              onPressed: () {
                if (audioPlayer.audioSources.isEmpty) {
                } else {
                  showModalBottomSheet<void>(
                    backgroundColor: Colors.transparent,
                    context: context,
                    builder: (BuildContext context) {
                      return PlayersAppBarActionsBottomSheet(
                        fullFilePath: currentSongFullPath,
                      );
                    },
                  );
                }
              },
            ),
          ),
        ),
      ),
    ],
  );
}

AppBar previewPlayerViewAppBar(BuildContext context, String filePath) {
  return AppBar(
    shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(5))),
    toolbarHeight: 60,
    elevation: 0,
    automaticallyImplyLeading: false,
    leading: SizedBox(
      width: 45,
      height: 45,
      child: Padding(
        padding: const EdgeInsets.only(left: 10),
        child: IconButton(
          splashRadius: 20,
          icon: Image.asset("assets/img/keyboard_arrow_down.png"),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
    ),
    centerTitle: true,
    backgroundColor: TColor.bg,
    title: Text(
      "SONG PREVIEW",
      style: TextStyle(
        fontWeight: FontWeight.w900,
        color: TColor.org,
        fontSize: 19,
      ),
    ),
    actions: [
      Padding(
        padding: const EdgeInsets.only(right: 10),
        child: Padding(
          padding: const EdgeInsets.only(left: 10),
          child: SizedBox(
            width: 50,
            height: 50,
            child: IconButton(
              splashRadius: 20,
              icon: Image.asset("assets/img/more_horiz.png"),
              onPressed: () async {
                final result = await showModalBottomSheet<String>(
                  backgroundColor: Colors.transparent,
                  context: context,
                  builder: (BuildContext context) {
                    return PlayersAppBarActionsBottomSheet(
                      fullFilePath: filePath,
                    );
                  },
                );
                if (result == "close_song_preview_bottom_sheet") {
                  if (context.mounted) {
                    Navigator.pop(context, "close_song_preview_bottom_sheet");
                  }
                } else {
                  // Do not close the Player Preview bottom sheet
                }
              },
            ),
          ),
        ),
      ),
    ],
  );
}
