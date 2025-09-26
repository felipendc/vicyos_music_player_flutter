import 'dart:async';

import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:vicyos_music/app/common/color_palette/color_extension.dart';
import 'package:vicyos_music/app/common/music_player/music.player.dart';
import 'package:vicyos_music/app/common/screen_orientation/screen.orientation.dart';
import 'package:vicyos_music/app/is_tablet/view/bottomsheet/bottomsheet.song.preview.dart';

import '../../../common/search_bar_handler/search.songs.dart';
import '../../widgets/music_visualizer.dart';
import '../bottomsheet/bottom.sheet.song.info.more.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Set the preferred orientations to landscape mode when this screen is built
    getScreenOrientation();

    TextEditingController searchBoxController = TextEditingController();
    FocusNode searchBarKeyboardFocusNode = FocusNode();
    // Ensure the search runs only once

    Timer? debounce;

    void onTextChanged(String text) {
      // If there is a previous timer, cancel it to avoid multiple concurrent searches
      debounce?.cancel();

      String trimmedText = text.trim();

      if (trimmedText.isEmpty) {
        foundSongs.clear();
        isSearchingSongsStreamNotifier("");
        isSearchingSongsStreamNotifier("");
        //
        isSearchTypingStreamNotifier(false);
        return;
      }

      // Create a new timer that will execute the search after 800ms
      // This will fix the issue where the function returns wrong results
      //  This is because the function didn't even had time to clear the
      //  foundSongs and foundFilesPaths lists
      debounce = Timer(
        Duration(milliseconds: 800),
        () async {
          foundSongs.clear();
          debugPrint("🔎 Searching for: '$trimmedText'");

          isSearchTypingStreamNotifier(true);

          await searchFilesByName(musicFolderPaths, trimmedText);
        },
      );
    }

    void clearSearch() {
      searchBoxController.clear();
      foundSongs.clear();
      isSearchingSongsStreamNotifier("");

      //
      isSearchTypingStreamNotifier(false);
      //
      foundSongs.clear();
    }

    // void openKeyboard() {
    //   Future.delayed(Duration(milliseconds: 100), () {
    //     FocusScope.of(context).requestFocus(searchBarKeyboardFocusNode);
    //   });
    // }

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
              "assets/img/arrow_back_ios.png",
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
            hintText: 'Search...',
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
                Text("Just a sec..."),
              ],
            );
          } else if (isSearching == "finished") {
            return StreamBuilder<void>(
              stream: getCurrentSongFullPathStreamController.stream,
              builder: (context, snapshot) {
                return ListView.separated(
                  padding: const EdgeInsets.only(bottom: 112),
                  itemCount: foundSongs.length,
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

                          final result = await showModalBottomSheet<String>(
                            backgroundColor: Colors.transparent,
                            context: context,
                            builder: (BuildContext context) {
                              return SongPreviewBottomSheet(
                                  songPath: foundSongs[index].path);
                            },
                          ).whenComplete(
                            () {
                              isSongPreviewBottomSheetOpen = false;

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
                            foundSongs.clear();
                            isSearchingSongsStreamNotifier("nothing_found");
                          } else {
                            // Do not close the Player Preview bottom sheet
                          }
                        },
                        child: ListTile(
                          key: ValueKey(foundSongs[index].path),
                          leading: (foundSongs[index].path ==
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
                            foundSongs[index].name,
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
                            "${foundSongs[index].size!} MB  |  ${foundSongs[index].format!}",
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
                              "assets/img/more_vert.png",
                              color: TColor.lightGray,
                            ),
                            onPressed: () async {
                              if (context.mounted) {
                                final result =
                                    await showModalBottomSheet<String>(
                                  backgroundColor: Colors.transparent,
                                  context: context,
                                  builder: (BuildContext context) {
                                    return SongInfoMoreBottomSheet(
                                      fullFilePath: foundSongs[index].path,
                                    );
                                  },
                                ).whenComplete(
                                  () {
                                    if (context.mounted) {
                                      if (!Navigator.canPop(context)) {
                                        debugPrint("No other screen is open.");
                                      } else {
                                        debugPrint(
                                            " There are other open screens .");
                                      }
                                    }
                                  },
                                );
                                if (result ==
                                    "close_song_preview_bottom_sheet") {
                                  foundSongs.clear();
                                  isSearchingSongsStreamNotifier(
                                      "nothing_found");
                                } else {
                                  // Do not close the Player Preview bottom sheet
                                }
                              }
                            },
                          ),
                          onTap: () {
                            setFolderAsPlaylist(foundSongs, index);
                            debugPrint(
                                "SONG DIRECTORY: ${getCurrentSongParentFolder(currentSongFullPath)}");
                            debugPrint('Tapped on ${(foundSongs[index].path)}');
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
                const Center(
                  child: Text('No search results',
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
