import 'dart:async';

import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:vicyos_music/app/common/color_extension.dart';
import 'package:vicyos_music/app/functions/music_player.dart';
import 'package:vicyos_music/app/view/song.preview.dialog.dart';

import '../functions/search.songs.dart';
import '../widgets/music_visualizer.dart';
import 'bottom.sheet.song.info.more.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    TextEditingController searchBoxController = TextEditingController();
    FocusNode searchBarKeyboardFocusNode = FocusNode();
    // Ensure the search runs only once

    Timer? _debounce;

    void _onTextChanged(String text) {
      // If there is a previous timer, cancel it to avoid multiple concurrent searches
      _debounce?.cancel();

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
      _debounce = Timer(Duration(milliseconds: 800), () async {
        foundSongs.clear();
        print("🔎 Searching for: '$trimmedText'");

        isSearchTypingStreamNotifier(true);

        await searchFilesByName(musicFolderPaths, trimmedText);
      });
    }

    void _clearSearch() {
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
          onChanged: _onTextChanged, // Detects text changes
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
                  bool _isNowTyping = snapshot.data ?? false;
                  if (_isNowTyping == true) {
                    return Padding(
                      padding: const EdgeInsets.only(
                          right: 8), // Small space for the icon
                      child: IconButton(
                        icon: const Icon(Icons.close, color: Colors.white70),
                        onPressed:
                            _clearSearch, // Clears the text when "X" is pressed
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
                }),
          ),
        ),
      ),
      body: StreamBuilder<String>(
        stream: isSearchingSongsStreamController.stream,
        builder: (context, snapshot) {
          String? _isSearching = snapshot.data;
          if (_isSearching == "searching") {
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
          } else if (_isSearching == "finished") {
            return ListView.separated(
              padding: const EdgeInsets.only(bottom: 112),
              itemCount: foundSongs.length,
              itemBuilder: (context, index) {
                return SizedBox(
                  height: 67,
                  child: GestureDetector(
                    onLongPress: () {
                      hideButtonSheetStreamNotifier(true);
                      showModalBottomSheet<void>(
                        backgroundColor: Colors.transparent,
                        context: context,
                        builder: (BuildContext context) {
                          return SongPreviewDialog(
                              songPath: foundSongs[index].path);
                        },
                      ).whenComplete(() {
                        rebuildSongsListScreenStreamNotifier(true);
                        // "When the bottom sheet is closed, send a signal to show the mini player again."
                        if (isSongPreviewBottomSheetOpen) {
                          hideButtonSheetStreamNotifier(true);
                        } else {
                          hideButtonSheetStreamNotifier(false);
                        }
                      });
                    },
                    child: ListTile(
                      key: ValueKey(foundSongs[index].path),
                      leading: (foundSongs[index].path == currentSongFullPath)
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
                          await hideButtonSheetStreamNotifier(true);

                          showModalBottomSheet<String>(
                            backgroundColor: Colors.transparent,
                            context: context,
                            builder: (BuildContext context) {
                              return SongInfoMoreBottomSheet(
                                fullFilePath: foundSongs[index].path,
                              );
                            },
                          ).whenComplete(
                            () {
                              if (!Navigator.canPop(context)) {
                                print("No other screen is open.");
                              } else {
                                hideButtonSheetStreamNotifier(false);
                                print(" There are other open screens .");
                              }
                            },
                          );
                        },
                      ),
                      onTap: () {
                        setFolderAsPlaylist(foundSongs, index);
                        print(
                            "SONG DIRECTORY: ${getCurrentSongParentFolder(currentSongFullPath)}");
                        print('Tapped on ${(foundSongs[index].path)}');
                      },
                    ),
                  ),
                );
              },
              separatorBuilder: (BuildContext context, int index) {
                return Container();
              },
            );
          } else if (_isSearching == "nothing_found") {
            return Column(
              children: [
                SizedBox(
                  height: 20,
                ),
                Container(
                  child: const Center(
                    child: Text('No search results',
                        style: TextStyle(color: Colors.white)),
                  ),
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
