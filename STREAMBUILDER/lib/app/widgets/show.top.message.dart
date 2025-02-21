import 'package:flutter/material.dart';
import 'package:vicyos_music/app/common/color_extension.dart';
import 'package:vicyos_music/app/functions/music_player.dart';

void showLoopMode(BuildContext context, String message) {
  OverlayEntry overlayEntry = OverlayEntry(
    builder: (context) => Positioned(
      top: 40,
      left: 20,
      right: 20,
      child: Material(
        color: Colors.transparent,
        child: Container(
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: TColor.focus,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            children: [
              SizedBox(
                width: audioPlayer.shuffleModeEnabled ? 45 : 45,
                height: 40,
                child: IconButton(
                  onPressed: () {
                  },
                  icon: Image.asset(
                    currentLoopModeIcon,
                    width: 30,
                    height: 30,
                    color: TColor.primaryText80,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 5),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "REPEAT MODE:",
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      message,
                      style: TextStyle(color: Colors.white, fontSize: 16),
                      textAlign: TextAlign.left,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );

  Overlay.of(context).insert(overlayEntry);

  Future.delayed(Duration(seconds: 3), () {
    overlayEntry.remove();
  });
}


void showAddedToPlaylist(BuildContext context, String type, String folderName, String message) {
  OverlayEntry overlayEntry = OverlayEntry(
    builder: (context) => Positioned(
      top: 40,
      left: 20,
      right: 20,
      child: Material(
        color: Colors.transparent,
        child: Container(
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: TColor.focus,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            children: [
              (type == "Folder") ?
              Padding(
                padding: const EdgeInsets.only(bottom: 7.0),
                child: SizedBox(
                  width:  45,
                  height: 40,
                  child: IconButton(
                    onPressed: () {
                    },
                    icon: Icon(
                      Icons.create_new_folder_outlined,
                      size: 30,
                    ),
                            ),
                ),
              ) :
              SizedBox(
                width:  45,
                height: 45,
                child: IconButton(
                  onPressed: () {
                  },
                  icon: Image.asset(
                      "assets/img/sound_sampler.png",
                    width: 30,
                    height: 30,
                    color: TColor.primaryText80,
                  ),
                ),
              ),
              SizedBox(width: 5),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      folderName.toUpperCase(),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w700,

                      ),
                    ),
                    Text(
                      textAlign: TextAlign.left,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      message,
                      style: TextStyle(color: Colors.white, fontSize: 16),

                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );


  Overlay.of(context).insert(overlayEntry);

  Future.delayed(Duration(seconds: 3), () {
    overlayEntry.remove();
  });
}

void showFileDeletedMessage(BuildContext context, String fileName, String message) {
  OverlayEntry overlayEntry = OverlayEntry(
    builder: (context) => Positioned(
      top: 40,
      left: 20,
      right: 20,
      child: Material(
        color: Colors.transparent,
        child: Container(
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: TColor.focus,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            children: [

              Padding(
                padding: const EdgeInsets.only(bottom: 7.0),
                child: SizedBox(
                  width:  40,
                  height: 40,
                  child: IconButton(
                    onPressed: () {
                    },
                    icon: Icon(
                      Icons.delete_forever_outlined,
                      size: 30,
                    ),
                  ),
                ),
              ),
              SizedBox(width: 5),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      fileName.toUpperCase(),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w700,

                      ),
                    ),
                    Text(
                      textAlign: TextAlign.left,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      message ,
                      style: TextStyle(color: Colors.white, fontSize: 16),

                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );

  Overlay.of(context).insert(overlayEntry);

  Future.delayed(Duration(seconds: 4), () {
    overlayEntry.remove();
  });
}