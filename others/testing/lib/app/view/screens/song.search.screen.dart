import 'dart:async';

import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:vicyos_music/app/color_palette/color_extension.dart';
import 'package:vicyos_music/app/models/audio.info.dart';
import 'package:vicyos_music/app/music_player/music.player.functions.and.more.dart';
import 'package:vicyos_music/app/music_player/music.player.stream.controllers.dart';
import 'package:vicyos_music/app/screen_orientation/screen.orientation.dart';
import 'package:vicyos_music/app/view/bottomsheet/bottom.sheet.song.info.more.dart';
import 'package:vicyos_music/app/view/bottomsheet/bottomsheet.song.preview.dart';
import 'package:vicyos_music/app/components/music_visualizer.dart';
import 'package:vicyos_music/database/database.dart';
import 'package:vicyos_music/l10n/app_localizations.dart';

List<AudioInfo> searchSongFromDataBase = [];

class SearchScreen extends StatelessWidget {
  const SearchScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    // Set the preferred orientations to portrait mode when this screen is built
    setScreenOrientation();

    TextEditingController searchBoxController = TextEditingController();
    FocusNode searchBarKeyboardFocusNode = FocusNode();
    // Ensure the search runs only once

    Timer? debounce;

    void onTextChanged(String text) {
      // If there is a previous timer, cancel it to avoid multiple concurrent searches
      debounce?.cancel();

      String trimmedText = text.trim();

      if (trimmedText.isEmpty) {
        searchSongFromDataBase.clear();
        isSearchingSongsNotifier("");
        isSearchingSongsNotifier("");
        //
        isSearchTypingNotifier(false);
        return;
      }

      // Create a new timer that will execute the search after 800ms
      // This will fix the issue where the function returns wrong results
      //  This is because the function didn't even had time to clear the
      //  searchSongFromDataBase
      debounce = Timer(
        Duration(milliseconds: 800),
        () async {
          searchSongFromDataBase.clear();
          debugPrint("🔎 Searching for: '$trimmedText'");

          isSearchTypingNotifier(true);

          searchSongFromDataBase =
              await AppDatabase.instance.searchSongs(trimmedText);
        },
      );
    }

    void clearSearch() {
      searchBoxController.clear();
      searchSongFromDataBase.clear();
      isSearchingSongsNotifier("");
      isSearchTypingNotifier(false);
      searchSongFromDataBase.clear();
    }

    return Scaffold(
      backgroundColor: const Color(0xff181B2C), // Dark background
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color(0xff181B2C),
        leading: Padding(
          padding: const EdgeInsets.only(left: 20),
          child: IconButton(
            splashRadius: 20,
            onPressed: () async {
              Navigator.pop(context);
            },
            icon: Image.asset(
              "assets/img/menu/arrow_back_ios.png",
              color: TColor.lightGray,
              height: 20,
              width: 20,
            ),
          ),
        ),
        title: TextField(
          controller: searchBoxController,
          focusNode:
              searchBarKeyboardFocusNode, // Linking the FocusNode to the TextField
          onChanged: onTextChanged, // Detects text changes
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            hintText: AppLocalizations.of(context)!.search_with_ellipsis,
            hintStyle: const TextStyle(color: Colors.white60),
            filled: true,
            fillColor: const Color(0xff24273A), // TextField background color
            contentPadding: const EdgeInsets.only(
                left: 16, right: 48, top: 12, bottom: 12), // Padding adjustment
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              borderSide: BorderSide.none,
            ),
            suffixIcon: StreamBuilder<bool>(
              stream: isSearchTypingStreamController.stream,
              builder: (context, snapshot) {
                bool isNowTyping = snapshot.data ?? false;
                if (isNowTyping == true) {
                  return Padding(
                    padding: const EdgeInsets.only(
                        right: 8), // Small space for the icon
                    child: IconButton(
                      icon: const Icon(Icons.close, color: Colors.white70),
                      onPressed:
                          clearSearch, // Clears the text when "X" is pressed
                    ),
                  );
                } else {
                  return Padding(
                    padding: const EdgeInsets.only(
                        right: 8), // Small space for the icon
                    child: const Icon(Icons.search,
                        color: Colors.white70), // Search icon when empty
                  );
                }
              },
            ),
          ),
        ),
      ),
      body: StreamBuilder<String>(
        stream: isSearchingSongsStreamController.stream,
        builder: (context, snapshot) {
          String? isSearching = snapshot.data;
          if (isSearching == "searching") {
            return Column(
              // mainAxisAlignment: MainAxisAlignment.start,
              // crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(
                  height: 20,
                ),
                Center(
                  child: LoadingAnimationWidget.staggeredDotsWave(
                    size: 40,
                  ),
                ),
                Text(AppLocalizations.of(context)!.just_a_sec),
              ],
            );
          } else if (isSearching == "finished") {
            return StreamBuilder<void>(
              stream: currentSongNameStreamController.stream,
              builder: (context, snapshot) {
                return ListView.separated(
                  padding: const EdgeInsets.only(bottom: 112),
                  itemCount: searchSongFromDataBase.length,
                  itemBuilder: (context, index) {
                    return SizedBox(
                      height: 67,
                      child: GestureDetector(
                        onLongPress: () async {
                          if (audioPlayer.playerState.playing) {
                            audioPlayerWasPlaying = true;
                          } else {
                            audioPlayerWasPlaying = false;
                          }
                          isSongPreviewBottomSheetOpen = true;
                          hideMiniPlayerNotifier(true);

                          final result = await showModalBottomSheet<String>(
                            isScrollControlled: true,
                            backgroundColor: Colors.transparent,
                            context: context,
                            builder: (BuildContext context) {
                              return SongPreviewBottomSheet(
                                songModel: searchSongFromDataBase[index],
                                audioRoute: NavigationButtons.music,
                              );
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
                            },
                          );

                          if (result == "close_song_preview_bottom_sheet") {
                            searchSongFromDataBase.clear();
                            isSearchingSongsNotifier("nothing_found");
                          } else {
                            // Do not close the Player Preview bottom sheet
                          }
                        },
                        child: ListTile(
                          key: ValueKey(searchSongFromDataBase[index].path),
                          leading: (searchSongFromDataBase[index].path ==
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
                                      duration: const [900, 700, 600, 800, 500],
                                    ),
                                  ),
                                )
                              : Icon(
                                  Icons.music_note_rounded,
                                  color: TColor.focus,
                                  size: 36,
                                ),
                          title: Text(
                            searchSongFromDataBase[index].name,
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
                            "${searchSongFromDataBase[index].size} MB  |  ${searchSongFromDataBase[index].format}",
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
                                final result =
                                    await showModalBottomSheet<String>(
                                  backgroundColor: Colors.transparent,
                                  context: context,
                                  builder: (BuildContext context) {
                                    return SongInfoMoreBottomSheet(
                                      songModel: searchSongFromDataBase[index],
                                      isFromFavoriteScreen: false,
                                      audioRoute: NavigationButtons.music,
                                    );
                                  },
                                ).whenComplete(
                                  () {
                                    if (context.mounted) {
                                      if (!Navigator.canPop(context)) {
                                        debugPrint("No other screen is open.");
                                      } else {
                                        hideMiniPlayerNotifier(false);
                                        debugPrint(
                                            " There are other open screens .");
                                      }
                                    }
                                  },
                                );
                                if (result ==
                                    "close_song_preview_bottom_sheet") {
                                  searchSongFromDataBase.clear();
                                  isSearchingSongsNotifier("nothing_found");
                                } else {
                                  // Do not close the Player Preview bottom sheet
                                }
                              }
                            },
                          ),
                          onTap: () {
                            setFolderAsPlaylist(
                              currentFolder: searchSongFromDataBase,
                              currentIndex: index,
                              context: context,
                              audioRoute: NavigationButtons.music,
                              audioRouteEmptyPlaylist: NavigationButtons.music,
                            );
                            debugPrint(
                                "SONG DIRECTORY: ${getCurrentSongParentFolder(currentSongFullPath)}");
                            debugPrint(
                                'Tapped on ${(searchSongFromDataBase[index].path)}');
                          },
                        ),
                      ),
                    );
                  },
                  separatorBuilder: (BuildContext context, int index) {
                    return Container();
                  },
                );
              },
            );
          } else if (isSearching == "nothing_found") {
            return Column(
              children: [
                SizedBox(
                  height: 20,
                ),
                Center(
                  child: Text(AppLocalizations.of(context)!.no_search_results,
                      style: TextStyle(color: Colors.white)),
                ),
              ],
            );
          } else {
            return Container();
          }
        },
      ),
    );
  }
}
