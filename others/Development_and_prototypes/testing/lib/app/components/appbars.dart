import 'package:flutter/material.dart';
import 'package:vicyos_music/app/color_palette/color_extension.dart';
import 'package:vicyos_music/app/music_player/music.player.functions.and.more.dart';
import 'package:vicyos_music/app/radio_player/functions_and_streams/radio.functions.and.more.dart';
import 'package:vicyos_music/app/radio_player/functions_and_streams/radio.stream.controllers.dart';
import 'package:vicyos_music/app/view/bottomsheet/bottom.sheet.players.appbar.actions.dart';
import 'package:vicyos_music/database/database.dart';
import 'package:vicyos_music/l10n/app_localizations.dart';

AppBar mainPlayerViewAppBarTablet({
  required BuildContext context,
  required NavigationButtons audioRoute,
}) {
  return AppBar(
    shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(5))),
    toolbarHeight: 60,
    elevation: 0,
    automaticallyImplyLeading: false,
    centerTitle: true,
    backgroundColor: TColor.bg,
    title: StreamBuilder(
        stream: switchingToRadioStreamController.stream,
        builder: (context, asyncSnapshot) {
          return Text(
            isRadioOn
                ? AppLocalizations.of(context)!.vicyos_radio
                : AppLocalizations.of(context)!.vicyos_music,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontWeight: FontWeight.w900,
              color: TColor.primaryText80,
              fontSize: 23,
            ),
          );
        }),
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
              icon: Image.asset("assets/img/menu/more_horiz.png"),
              onPressed: isRadioOn
                  ? null
                  : () async {
                      if (audioPlayer.audioSources.isEmpty) {
                      } else {
                        final songIsFavorite = await AppDatabase.instance
                            .isFavorite(currentSongFullPath);

                        if (!context.mounted) return;
                        showModalBottomSheet<void>(
                          backgroundColor: Colors.transparent,
                          context: context,
                          builder: (BuildContext context) {
                            return PlayerPreviewAppBarActionsBottomSheet(
                              songIsFavorite: songIsFavorite,
                              fullFilePath: currentSongFullPath,
                              audioRoute: audioRoute,
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

AppBar mainPlayerViewAppBar({
  required BuildContext context,
  required NavigationButtons audioRoute,
}) {
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
          icon: Image.asset("assets/img/menu/keyboard_arrow_down.png"),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
    ),
    centerTitle: true,
    backgroundColor: TColor.bg,
    title: Text(
      AppLocalizations.of(context)!.vicyos_music,
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
              icon: Image.asset("assets/img/menu/more_horiz.png"),
              onPressed: () async {
                if (audioPlayer.audioSources.isEmpty) {
                } else {
                  final songIsFavorite = await AppDatabase.instance
                      .isFavorite(currentSongFullPath);

                  if (!context.mounted) return;
                  showModalBottomSheet<void>(
                    backgroundColor: Colors.transparent,
                    context: context,
                    builder: (BuildContext context) {
                      return PlayerPreviewAppBarActionsBottomSheet(
                        songIsFavorite: songIsFavorite,
                        fullFilePath: currentSongFullPath,
                        audioRoute: audioRoute,
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

AppBar previewPlayerViewAppBar({
  required BuildContext context,
  required String filePath,
  required NavigationButtons audioRoute,
}) {
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
          icon: Image.asset("assets/img/menu/keyboard_arrow_down.png"),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
    ),
    centerTitle: true,
    backgroundColor: TColor.bg,
    title: Text(
      AppLocalizations.of(context)!.song_preview,
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
              icon: Image.asset("assets/img/menu/more_horiz.png"),
              onPressed: () async {
                final songIsFavorite =
                    await AppDatabase.instance.isFavorite(filePath);
                if (!context.mounted) return;
                final result = await showModalBottomSheet<String>(
                  backgroundColor: Colors.transparent,
                  context: context,
                  builder: (BuildContext context) {
                    return PlayerPreviewAppBarActionsBottomSheet(
                      songIsFavorite: songIsFavorite,
                      fullFilePath: filePath,
                      audioRoute: audioRoute,
                    );
                  },
                );
                if (result == "close_song_preview_bottom_sheet") {
                  if (!context.mounted) return;
                  Navigator.pop(context, "close_song_preview_bottom_sheet");
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
