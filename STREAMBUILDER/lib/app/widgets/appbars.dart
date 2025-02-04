import 'package:flutter/material.dart';
import 'package:vicyos_music/app/common/color_extension.dart';
import 'package:vicyos_music/app/functions/folders.and.files.related.dart';
import 'package:vicyos_music/app/functions/music_player.dart';
import 'package:vicyos_music/app/view/bottom.sheet.folders.to.playlist.dart';
import 'package:vicyos_music/app/view/bottom.sheet.players.appbar.actions.dart';

AppBar homePageAppBar() {
  return AppBar(
    shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(5))),
    toolbarHeight: 60,

    elevation: 0,
    backgroundColor: TColor.bg, // TColor.darkGray,
    title: Center(
      child: GestureDetector(
        onTap: () {
          musicFolderPaths.clear();
          listMusicFolders();
          listPlaylistFolderStreamListener();
        },
        child: Text(
          textAlign: TextAlign.center,
          ' SCAN MUSIC FOLDERS ',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: TColor.org,
            // color: TColor.lightGray,
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
    backgroundColor: TColor.bg, // TColor.darkGray,
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
            hideButtonSheetStreamListener(true);
            showModalBottomSheet<void>(
              backgroundColor: Colors.transparent,
              context: context,
              builder: (BuildContext context) {
                return FolderToPlaylistBottomSheet(folderPath: folderPath);
              },
            ).whenComplete(() {
              if (mainPlayerIsOpen) {
                hideButtonSheetStreamListener(true);
              } else {
                // "When the bottom sheet is closed, send a signal to show the mini player again."
                hideButtonSheetStreamListener(false);
              }
            });
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
    leading: SizedBox(
      width: 45,
      height: 45,
      child: Padding(
        padding: const EdgeInsets.only(left: 10),
        child: IconButton(
          splashRadius: 20,
          icon: Image.asset("assets/img/keyboard_arrow_down.png"),

          // Icon(
          //   Icons.arrow_back,
          //   color: TColor.primaryText80,
          // ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
    ),
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

              // Icon(
              //   Icons.arrow_back,
              //   color: TColor.primaryText80,
              // ),
              onPressed: () {
                if (playlist.children.isEmpty) {
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

          // Icon(
          //   Icons.arrow_back,
          //   color: TColor.primaryText80,
          // ),
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

              // Icon(
              //   Icons.arrow_back,
              //   color: TColor.primaryText80,
              // ),
              onPressed: () {
                showModalBottomSheet<void>(
                  backgroundColor: Colors.transparent,
                  context: context,
                  builder: (BuildContext context) {
                    return PlayersAppBarActionsBottomSheet(
                      fullFilePath: filePath,
                    );
                  },
                ).whenComplete(() {
                  //TODO

                  // "When the bottom sheet is closed, send a signal to show the mini player again."
                });
              },
            ),
          ),
        ),
      ),
    ],
  );
}
