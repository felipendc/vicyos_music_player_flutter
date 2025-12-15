import 'dart:async';

import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:vicyos_music/app/common/color_palette/color_extension.dart';
import 'package:vicyos_music/app/common/music_player/music.player.stream.controllers.dart';
import 'package:vicyos_music/app/common/radio_player/functions_and_streams/radio.functions.and.more.dart';
import 'package:vicyos_music/app/common/radio_player/radio_stations/radio.stations.list.dart';
import 'package:vicyos_music/app/common/radio_player/widgets/radio.music.visualizer.dart';
import 'package:vicyos_music/app/common/screen_orientation/screen.orientation.dart';
import 'package:vicyos_music/app/common/search_bar_handler/search.songs.stations.handler.dart';
import 'package:vicyos_music/l10n/app_localizations.dart' show AppLocalizations;

class RadioSearchScreen extends StatelessWidget {
  const RadioSearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Set the preferred orientations to landscape mode when this screen is built
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
        foundStations.clear();
        isSearchingSongsNotifier("");
        isSearchingSongsNotifier("");
        //
        isSearchTypingNotifier(false);
        return;
      }

      // Create a new timer that will execute the search after 800ms
      // This will fix the issue where the function returns wrong results
      //  This is because the function didn't even had time to clear the
      //  foundStations and foundStationNames lists
      debounce = Timer(
        Duration(milliseconds: 800),
        () async {
          foundStations.clear();
          debugPrint("🔎 Searching for: '$trimmedText'");

          isSearchTypingNotifier(true);

          await searchRadioStationsByName(radioStationList, trimmedText);
        },
      );
    }

    void clearSearch() {
      searchBoxController.clear();
      foundStations.clear();
      isSearchingSongsNotifier("");

      //
      isSearchTypingNotifier(false);
      //
      foundStations.clear();
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
                  itemCount: foundStations.length,
                  itemBuilder: (context, index) {
                    return SizedBox(
                      height: 67,
                      child: GestureDetector(
                        onLongPress: () {},
                        child: ListTile(
                          key: ValueKey(foundStations[index].radioUrl),
                          leading: Container(
                            padding: EdgeInsets.symmetric(horizontal: 5),
                            child: (foundStations[index].id ==
                                    currentRadioStationID)
                                ? StreamBuilder<PlayerState>(
                                    stream: radioPlayer.playerStateStream,
                                    builder: (context, snapshot) {
                                      if (isRadioPaused || isRadioPlaying) {
                                        return Padding(
                                          padding: const EdgeInsets.only(
                                              top: 10.0,
                                              left: 2.0,
                                              bottom: 10.0),
                                          child: SizedBox(
                                            height: 27,
                                            width: 30,
                                            child: RadioMusicVisualizer(
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
                                        );
                                      } else {
                                        return Image.asset(
                                          width: radioHasLogo(index) ? 45 : 32,
                                          height: radioHasLogo(index) ? 45 : 32,
                                          radioHasLogo(index)
                                              ? radioStationList[index]
                                                  .ratioStationLogo!
                                              : radioLogo(),
                                          color: radioHasLogo(index)
                                              ? null
                                              : TColor.focus,
                                        );
                                      }
                                    },
                                  )
                                : Image.asset(
                                    width: radioHasLogo(index) ? 45 : 32,
                                    height: radioHasLogo(index) ? 45 : 32,
                                    radioHasLogo(index)
                                        ? foundStations[index].ratioStationLogo!
                                        : radioLogo(),
                                    color: radioHasLogo(index)
                                        ? null
                                        : TColor.focus,
                                  ),
                          ),
                          title: Text(
                            foundStations[index].radioName,
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
                            foundStations[index].radioLocation,
                            textAlign: TextAlign.start,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: TColor.secondaryText,
                              fontSize: 15,
                            ),
                          ),
                          trailing: Container(
                            padding: EdgeInsets.symmetric(horizontal: 5),
                            child: (foundStations[index].id ==
                                    currentRadioStationID)
                                ? StreamBuilder<PlayerState>(
                                    stream: radioPlayer.playerStateStream,
                                    builder: (context, snapshot) {
                                      final playerState = snapshot.data;
                                      final processingState =
                                          playerState?.processingState;
                                      final playing = playerState?.playing;

                                      if (processingState ==
                                              ProcessingState.loading ||
                                          processingState ==
                                              ProcessingState.buffering) {
                                        return Container(
                                          margin: const EdgeInsets.all(8.0),
                                          width: 18.0,
                                          height: 18.0,
                                          child:
                                              // const CircularProgressIndicator(),
                                              Center(
                                            child:
                                                LoadingAnimationWidget.inkDrop(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .primary,
                                              size: 20,
                                            ),
                                          ),
                                        );
                                      } else if (playing != true &&
                                          isRadioPaused == false) {
                                        return Image.asset(
                                          height: 30,
                                          width: 30,
                                          "assets/img/radio/antenna-bars-5-streamline.png",
                                          color: TColor.lightGray,
                                        );
                                      } else if (processingState !=
                                              ProcessingState.completed ||
                                          playing == true ||
                                          isRadioPaused) {
                                        return Image.asset(
                                          height: 30,
                                          width: 30,
                                          "assets/img/radio/antenna-bars-5-streamline.png",
                                          color: Colors.green,
                                        );
                                      } else {
                                        return (foundStations[index]
                                                    .stationStatus ==
                                                RadioStationConnectionStatus
                                                    .error)
                                            ? Image.asset(
                                                height: 30,
                                                width: 30,
                                                "assets/img/radio/antenna-bars-off-streamline-tabler.png",
                                                color: TColor.org,
                                              )
                                            : Image.asset(
                                                height: 30,
                                                width: 30,
                                                "assets/img/radio/antenna-bars-5-streamline.png",
                                                color: TColor.lightGray,
                                              );
                                      }
                                    },
                                  )
                                : (foundStations[index].stationStatus ==
                                        RadioStationConnectionStatus.error)
                                    ? Image.asset(
                                        height: 30,
                                        width: 30,
                                        "assets/img/radio/antenna-bars-off-streamline-tabler.png",
                                        color: TColor.org,
                                      )
                                    : Image.asset(
                                        height: 30,
                                        width: 30,
                                        "assets/img/radio/antenna-bars-5-streamline.png",
                                        color: TColor.lightGray,
                                      ),
                          ),
                          onTap: () async {
                            await playSearchedRadioStation(context, index);
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
