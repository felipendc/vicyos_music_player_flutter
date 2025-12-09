import 'package:flutter/material.dart';
import 'package:vicyos_music/app/common/color_palette/color_extension.dart';
import 'package:vicyos_music/app/common/files_and_folders_handler/folders.and.files.related.dart';
import 'package:vicyos_music/app/common/music_player/music.player.functions.and.more.dart';
import 'package:vicyos_music/app/common/music_player/music.player.stream.controllers.dart';
import 'package:vicyos_music/app/common/navigation_animation/song.files.screen.navigation.animation.dart';
import 'package:vicyos_music/app/common/radio_player/functions_and_streams/radio.functions.and.more.dart';
import 'package:vicyos_music/app/common/screen_orientation/screen.orientation.dart';
import 'package:vicyos_music/app/is_smartphone/view/bottomsheet/bottom.sheet.folders.to.playlist.dart';
import 'package:vicyos_music/app/is_smartphone/view/bottomsheet/bottom.sheet.song.info.more.dart';
import 'package:vicyos_music/app/is_smartphone/view/bottomsheet/bottomsheet.song.preview.dart';
import 'package:vicyos_music/app/is_smartphone/view/screens/song.search.screen.dart';
import 'package:vicyos_music/app/is_smartphone/widgets/music_visualizer.dart';
import 'package:vicyos_music/l10n/app_localizations.dart';

class SongsListScreen extends StatelessWidget {
  final String folderPath;
  const SongsListScreen({super.key, required this.folderPath});

  @override
  Widget build(BuildContext context) {
    // Set the preferred orientations to portrait mode when this screen is built
    setScreenOrientation();

    var media = MediaQuery.sizeOf(context);

    return StreamBuilder<void>(
      stream: rebuildSongsListScreenStreamController.stream,
      builder: (context, snapshot) {
        // Filter all songs from folderPath and add them to folderSongList
        filterSongsOnlyToList(folderPath: folderPath);

        // Filter all songs from folderPath and add them to folderSongList
        filterSongsOnlyToList(folderPath: folderPath);

        debugPrint("REBUILD LIST SONG: $folderPath");
        return SafeArea(
          child: Scaffold(
            // appBar: songsListAppBar(folderPath: folderPath, context: context),
            body: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 10.0),
                  child: Container(
                    decoration: BoxDecoration(
                      // color: Colors.grey,
                      color: Color(0xff181B2C),
                    ),
                    height: 130, // Loading enabled
                    child: Column(
                      // mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(20, 0, 8, 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    AppLocalizations.of(context)!.folder_name,
                                    style: TextStyle(
                                      color: TColor.primaryText28
                                          .withValues(alpha: 0.84),
                                      fontSize: 15,
                                      fontWeight: FontWeight.w400,
                                      shadows: [
                                        Shadow(
                                          color: Colors.black
                                              .withValues(alpha: 0.2),
                                          offset: Offset(1, 1),
                                          blurRadius: 3,
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    height: 30,
                                    width: 180,
                                    // color: Colors.grey,
                                    child: Text(
                                      folderName(folderPath),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        color: TColor.primaryText
                                            .withValues(alpha: 0.84),
                                        fontSize: 20,
                                        fontWeight: FontWeight.w600,
                                        shadows: [
                                          BoxShadow(
                                            color: Colors.black
                                                .withValues(alpha: 0.2),
                                            spreadRadius: 5,
                                            blurRadius: 8,
                                            offset: Offset(2, 4),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Material(
                                    color: Colors.transparent,
                                    child: SizedBox(
                                      width: 35,
                                      height: 35,
                                      child: IconButton(
                                        splashRadius: 20,
                                        iconSize: 10,
                                        onPressed: () async {
                                          Navigator.pop(context);
                                        },
                                        icon: Image.asset(
                                          "assets/img/menu/arrow_back_ios.png",
                                          color: TColor.lightGray,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Material(
                                    color: Colors.transparent,
                                    child: SizedBox(
                                      width: 45,
                                      height: 45,
                                      child: IconButton(
                                        splashRadius: 20,
                                        iconSize: 10,
                                        onPressed: () async {
                                          hideMiniPlayerNotifier(true);
                                          showModalBottomSheet<void>(
                                            backgroundColor: Colors.transparent,
                                            context: context,
                                            builder: (BuildContext context) {
                                              return FolderToPlaylistBottomSheet(
                                                  folderPath: folderPath);
                                            },
                                          ).whenComplete(
                                            () {
                                              if (mainPlayerIsOpen) {
                                                hideMiniPlayerNotifier(true);
                                              } else {
                                                // "When the bottom sheet is closed, send a signal to show the mini player again."
                                                hideMiniPlayerNotifier(false);
                                              }
                                            },
                                          );
                                        },
                                        icon: Image.asset(
                                          "assets/img/menu/menu_open.png",
                                          color: TColor.lightGray,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                      padding:
                                          const EdgeInsets.fromLTRB(9, 0, 8, 0),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(
                                              media.width * 0.2),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.black
                                                  .withValues(alpha: 0.2),
                                              spreadRadius: 5,
                                              blurRadius: 8,
                                              offset: Offset(2, 4),
                                            ),
                                          ],
                                        ),
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(
                                              media.width * 0.2),
                                          child: StreamBuilder<void>(
                                            stream: null,
                                            builder: (context, snapshot) {
                                              return Image.asset(
                                                "assets/img/pics/default.png",
                                                width: media.width * 0.13,
                                                height: media.width * 0.13,
                                                fit: BoxFit.cover,
                                              );
                                            },
                                          ),
                                        ),
                                      )),
                                ],
                              ),
                            ],
                          ),
                        ),
                        // Search Box
                        Padding(
                          padding: const EdgeInsets.fromLTRB(10, 8, 10, 8),
                          child: GestureDetector(
                            onTap: () async {
                              Navigator.push(
                                  context,
                                  slideRightLeftTransition(
                                    const SearchScreen(),
                                  )).whenComplete(
                                () {
                                  searchBoxController.dispose();
                                  searchBoxController.dispose();
                                },
                              );
                            },
                            child: Container(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16),
                              decoration: BoxDecoration(
                                color: const Color(
                                    0xff24273A), // Background color of the container
                                borderRadius: BorderRadius.circular(30),
                              ),
                              child: TextField(
                                // Attach FocusNode to the TextField
                                autofocus:
                                    false, // Ensure the TextField doesn't autofocus
                                enabled:
                                    false, // Disable the TextField to avoid interaction
                                style: const TextStyle(color: Colors.white),
                                decoration: InputDecoration(
                                  hintText: AppLocalizations.of(context)!
                                      .search_with_ellipsis,
                                  hintStyle:
                                      const TextStyle(color: Colors.white60),
                                  filled: false,
                                  fillColor: Colors
                                      .transparent, // Transparent background for TextField
                                  contentPadding: const EdgeInsets.symmetric(
                                      vertical: 12, horizontal: 0),
                                  border: InputBorder
                                      .none, // Removing border from TextField
                                  suffixIcon: Padding(
                                    padding: const EdgeInsets.only(left: 50),
                                    child: const Icon(Icons.search,
                                        color: Colors.white70),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                StreamBuilder<void>(
                  stream: currentSongNameStreamController.stream,
                  builder: (context, snapshot) {
                    return Expanded(
                      child: ListView.separated(
                        padding: const EdgeInsets.only(bottom: 112),
                        itemCount: folderSongList.length,
                        itemBuilder: (context, index) {
                          return SizedBox(
                            height: 67,
                            child: GestureDetector(
                              onLongPress: () {
                                if (audioPlayer.playerState.playing) {
                                  audioPlayerWasPlaying = true;
                                } else {
                                  audioPlayerWasPlaying = false;
                                }
                                isSongPreviewBottomSheetOpen = true;
                                hideMiniPlayerNotifier(true);

                                showModalBottomSheet<void>(
                                  isScrollControlled: true,
                                  backgroundColor: Colors.transparent,
                                  context: context,
                                  builder: (BuildContext context) {
                                    return SongPreviewBottomSheet(
                                        songPath: folderSongList[index].path);
                                  },
                                ).whenComplete(
                                  () {
                                    isSongPreviewBottomSheetOpen = false;

                                    // "When the bottom sheet is closed, send a signal to show the mini player again."
                                    hideMiniPlayerNotifier(false);
                                    audioPlayerPreview.stop();
                                    audioPlayerPreview.release();

                                    if (audioPlayerWasPlaying) {
                                      Future.microtask(
                                        () async {
                                          await audioPlayer.play();
                                        },
                                      );
                                    }

                                    if (isRadioOn && isRadioPaused) {
                                      radioPlayer.play();
                                    }
                                  },
                                );
                              },
                              child: ListTile(
                                key: ValueKey(folderSongList[index].path),
                                leading: (folderSongList[index].path ==
                                        currentSongFullPath)
                                    ? Padding(
                                        padding: const EdgeInsets.only(
                                            top: 10.0, left: 5.0, bottom: 10.0),
                                        child: SizedBox(
                                          height: 27,
                                          width: 30,
                                          child: MusicVisualizer(
                                            barCount: 6,
                                            colors: [
                                              TColor.focus,
                                              TColor.secondaryEnd,
                                              TColor.focusStart,
                                              Colors.blue[900]!,
                                            ],
                                            duration: const [
                                              900,
                                              700,
                                              600,
                                              800,
                                              500
                                            ],
                                          ),
                                        ),
                                      )
                                    : Icon(
                                        Icons.music_note_rounded,
                                        color: TColor.focus,
                                        size: 36,
                                      ),
                                title: Text(
                                  folderSongList[index].name,
                                  textAlign: TextAlign.start,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    color: TColor.lightGray,
                                    fontSize: 18,
                                  ),
                                ),
                                subtitle: Text(
                                  "${folderSongList[index].size!} MB  •  ${folderSongList[index].format!}",
                                  textAlign: TextAlign.start,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    color: TColor.secondaryText,
                                    fontSize: 15,
                                  ),
                                ),
                                trailing: IconButton(
                                  splashRadius: 24,
                                  iconSize: 20,
                                  icon: Image.asset(
                                    "assets/img/menu/more_vert.png",
                                    color: TColor.lightGray,
                                  ),
                                  onPressed: () async {
                                    await hideMiniPlayerNotifier(true);
                                    if (context.mounted) {
                                      showModalBottomSheet<String>(
                                        backgroundColor: Colors.transparent,
                                        context: context,
                                        builder: (BuildContext context) {
                                          return SongInfoMoreBottomSheet(
                                            fullFilePath:
                                                folderSongList[index].path,
                                          );
                                        },
                                      ).whenComplete(
                                        () {
                                          if (context.mounted) {
                                            if (!Navigator.canPop(context)) {
                                              debugPrint(
                                                  "No other screen is open.");
                                            } else {
                                              hideMiniPlayerNotifier(false);
                                              debugPrint(
                                                  "There are other open screens.");
                                            }
                                          }
                                        },
                                      );
                                    }
                                  },
                                ),
                                onTap: () {
                                  if (folderSongList[index].path ==
                                      currentSongFullPath) {
                                    if (songIsPlaying) {
                                      audioPlayer.pause();
                                      songIsPlaying = false;
                                    } else {
                                      audioPlayer.play();
                                      songIsPlaying = true;
                                    }
                                  } else {
                                    setFolderAsPlaylist(
                                        folderSongList, index, context);
                                    debugPrint(
                                        "SONG DIRECTORY: ${getCurrentSongParentFolder(currentSongFullPath)}");
                                    debugPrint(
                                        'Tapped on ${(folderSongList[index].path)}');
                                  }
                                },
                              ),
                            ),
                          );
                        },
                        separatorBuilder: (BuildContext context, int index) {
                          return Container();
                        },
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
