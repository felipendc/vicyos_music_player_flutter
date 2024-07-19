import 'package:flutter/material.dart';
import 'package:vicyos_music_player/app/common/color_extension.dart';
import 'package:vicyos_music_player/app/functions/folders.and.files.related.dart';
import 'package:vicyos_music_player/app/view/bottom.sheet.folders.to.playlist.dart';

AppBar homePageAppBar() {
  return AppBar(
    shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(5))),
    toolbarHeight: 60,

    elevation: 0,
    backgroundColor: TColor.bg, // TColor.darkGray,
    title: Center(
      child: Text(
        ' MUSIC FOLDERS ',
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
    leading: Padding(
      padding: const EdgeInsets.only(left: 14),
      child: IconButton(
        splashRadius: 20,
        icon: Icon(
          Icons.arrow_back,
          color: TColor.primaryText80,
        ),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
    ),
    centerTitle: true,
    backgroundColor: TColor.bg,
    title: Text(
      "Vicyos Music Player",
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: TextStyle(
        fontWeight: FontWeight.w900,
        color: TColor.primaryText80,
        fontSize: 23,
      ),
    ),
  );
}
