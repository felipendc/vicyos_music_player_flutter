import 'package:flutter/material.dart';
import 'package:vicyos_music/app/color_palette/color_extension.dart';
import 'package:vicyos_music/app/files_and_folders_handler/folders.and.files.related.dart';
import 'package:vicyos_music/app/music_player/music.player.functions.and.more.dart';
import 'package:vicyos_music/app/music_player/music.player.stream.controllers.dart';
import 'package:vicyos_music/app/navigation_animation/song.files.screen.navigation.animation.dart';
import 'package:vicyos_music/app/radio_player/functions_and_streams/radio.functions.and.more.dart';
import 'package:vicyos_music/app/screen_orientation/screen.orientation.dart';
import 'package:vicyos_music/app/view/bottomsheet/bottom.sheet.song.info.more.dart';
import 'package:vicyos_music/app/view/bottomsheet/bottomsheet.song.preview.dart';
import 'package:vicyos_music/app/view/screens/song.search.screen.dart';
import 'package:vicyos_music/app/widgets/music_visualizer.dart';
import 'package:vicyos_music/database/database.dart';
import 'package:vicyos_music/l10n/app_localizations.dart';

class ShowAllSongsScreen extends StatelessWidget {
  const ShowAllSongsScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    // Set the preferred orientations to portrait mode when this screen is built
    setScreenOrientation();

    var media = MediaQuery.sizeOf(context);

    return StreamBuilder<void>(
      stream: rebuildSongsListScreenStreamController.stream,
      builder: (context, snapshot) {
        return SafeArea(
          child: Scaffold(
            body: Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                    // color: Colors.grey,
                    color: Color(0xff181B2C),
                  ),
                  // height: deviceTypeIsTablet() ? 140 : 135,
                  // Loading enabled
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(20, 0, 8, 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      height: 30,
                                      // color: Colors.grey,
                                      child: Text(
                                        folderName(
                                          AppLocalizations.of(context)!
                                              .all_songs,
                                        ),
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
                                    FutureBuilder(
                                        future: AppDatabase.instance
                                            .getAllMusicPathsFromDB(),
                                        builder: (context, snapshot) {
                                          final totalOfSongs =
                                              snapshot.data ?? [];

                                          return Text(
                                            AppLocalizations.of(context)!
                                                .total_of_songs(
                                                    totalOfSongs.length),
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
                                          );
                                        }),
                                  ],
                                ),
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
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        icon: Image.asset(
                                          "assets/img/menu/arrow_back_ios.png",
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
                                              width: deviceTypeIsTablet()
                                                  ? 130 * 0.44
                                                  : media.width * 0.13,
                                              height: deviceTypeIsTablet()
                                                  ? 130 * 0.44
                                                  : media.width * 0.13,
                                              fit: BoxFit.cover,
                                            );
                                          },
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        // Search Box
                        Padding(
                          padding: const EdgeInsets.fromLTRB(10, 5, 10, 8),
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
                      return FutureBuilder(
                          future: AppDatabase.instance.getAllMusicPathsFromDB(),
                          builder: (context, snapshot) {
                            final songs = snapshot.data ?? [];

                            return Expanded(
                              child: ListView.separated(
                                padding: const EdgeInsets.only(bottom: 112),
                                itemCount: songs.length,
                                itemBuilder: (context, index) {
                                  final song = songs[index];
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

                                        if (deviceTypeIsSmartphone()) {
                                          hideMiniPlayerNotifier(true);
                                        }

                                        showModalBottomSheet<void>(
                                          isScrollControlled: true,
                                          backgroundColor: Colors.transparent,
                                          context: context,
                                          builder: (BuildContext context) {
                                            return SongPreviewBottomSheet(
                                              songModel: song,
                                              audioRoute:
                                                  NavigationButtons.music,
                                            );
                                          },
                                        ).whenComplete(
                                          () {
                                            isSongPreviewBottomSheetOpen =
                                                false;

                                            if (deviceTypeIsSmartphone()) {
                                              // "When the bottom sheet is closed, send a signal to show the mini player again."
                                              hideMiniPlayerNotifier(false);
                                            }
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
                                        key: ValueKey(song.path),
                                        leading: (song.path ==
                                                currentSongFullPath)
                                            ? Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 10.0,
                                                    left: 5.0,
                                                    bottom: 10.0),
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
                                          song.name,
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
                                          "${song.size} MB  •  ${song.format}",
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
                                            if (deviceTypeIsSmartphone()) {
                                              await hideMiniPlayerNotifier(
                                                  true);
                                            }
                                            if (context.mounted) {
                                              showModalBottomSheet<String>(
                                                backgroundColor:
                                                    Colors.transparent,
                                                context: context,
                                                builder:
                                                    (BuildContext context) {
                                                  return SongInfoMoreBottomSheet(
                                                    songModel: song,
                                                    isFromFavoriteScreen: false,
                                                    audioRoute:
                                                        NavigationButtons.music,
                                                  );
                                                },
                                              ).whenComplete(
                                                () {
                                                  if (context.mounted) {
                                                    if (!Navigator.canPop(
                                                        context)) {
                                                      debugPrint(
                                                          "No other screen is open.");
                                                    } else {
                                                      if (deviceTypeIsSmartphone()) {
                                                        hideMiniPlayerNotifier(
                                                            false);
                                                      }
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
                                          if (song.path ==
                                                  currentSongFullPath &&
                                              songCurrentRouteType ==
                                                  NavigationButtons.music) {
                                            if (songIsPlaying) {
                                              audioPlayer.pause();
                                              songIsPlaying = false;
                                            } else {
                                              audioPlayer.play();
                                              songIsPlaying = true;
                                            }
                                          } else {
                                            setFolderAsPlaylist(
                                              currentFolder: songs,
                                              currentIndex: index,
                                              context: context,
                                              audioRoute:
                                                  NavigationButtons.music,
                                              audioRouteEmptyPlaylist:
                                                  NavigationButtons.music,
                                            );
                                          }
                                        },
                                      ),
                                    ),
                                  );
                                },
                                separatorBuilder:
                                    (BuildContext context, int index) {
                                  return Container();
                                },
                              ),
                            );
                          });
                    }),
              ],
            ),
          ),
        );
      },
    );
  }
}
