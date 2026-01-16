import 'package:flutter/material.dart';
import 'package:vicyos_music/app/color_palette/color_extension.dart';
import 'package:vicyos_music/app/components/music_visualizer.player.preview.dart';
import 'package:vicyos_music/app/components/show.top.message.dart';
import 'package:vicyos_music/app/models/audio.info.dart';
import 'package:vicyos_music/app/music_player/music.player.functions.and.more.dart';
import 'package:vicyos_music/app/music_player/music.player.stream.controllers.dart';
import 'package:vicyos_music/app/radio_player/functions_and_streams/radio.functions.and.more.dart';
import 'package:vicyos_music/app/screen_orientation/screen.orientation.dart';
import 'package:vicyos_music/app/view/bottomsheet/bottom.sheet.song.selection.info.more.dart';
import 'package:vicyos_music/l10n/app_localizations.dart';

String currentSongPreview = "";

class MultiSelectionScreen extends StatelessWidget {
  final String? playlistName;
  final bool isFavoriteScreen;
  final bool isSongScreen;
  final bool isPlaylistScreen;
  final List<AudioInfo> songModelList;
  final String audioRoute;

  const MultiSelectionScreen({
    super.key,
    required this.isFavoriteScreen,
    required this.isSongScreen,
    required this.isPlaylistScreen,
    required this.songModelList,
    required this.audioRoute,
    this.playlistName,
  });

  @override
  Widget build(BuildContext context) {
    // Clear all the songs from the selectedItems and songModelListGlobal lists
    // to avoid overload of unwanted files!
    selectedItemsFromMultiselectionScreen = {};
    songModelListGlobal = [];

    // Make a copy of this list to manipulate the listview screen state
    songModelListGlobal = songModelList;

    // Set the preferred orientations to portrait mode when this screen is built
    setScreenOrientation();

    bool selectAllItems = false;

    var media = MediaQuery.sizeOf(context);

    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 13.0),
              child: Container(
                decoration: BoxDecoration(
                  // color: Colors.grey,
                  color: Color(0xff181B2C),
                ),
                // height: deviceTypeIsTablet() ? 135 : 130, // Loading enabled
                child: Column(
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
                              SizedBox(
                                height: 30,
                                width: 200,
                                // color: Colors.grey,
                                child: Text(
                                  AppLocalizations.of(context)!.select_files,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    color: TColor.primaryText
                                        .withValues(alpha: 0.84),
                                    fontSize: 20,
                                    fontWeight: FontWeight.w600,
                                    shadows: [
                                      BoxShadow(
                                        color:
                                            Colors.black.withValues(alpha: 0.2),
                                        spreadRadius: 5,
                                        blurRadius: 8,
                                        offset: Offset(2, 4),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 190,
                                child: StreamBuilder(
                                    stream:
                                        rebuildMultiSelectionScreenStreamController
                                            .stream,
                                    builder: (context, asyncSnapshot) {
                                      return Text(
                                        AppLocalizations.of(context)!
                                            .total_of_songs_selected(
                                                selectedItemsFromMultiselectionScreen
                                                    .length),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
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
                                    onPressed: () {
                                      selectAllItems = !selectAllItems;

                                      if (selectAllItems == true) {
                                        selectedItemsFromMultiselectionScreen
                                            .addAll(songModelListGlobal);
                                        rebuildMultiSelectionScreenNotifier();
                                      } else {
                                        selectedItemsFromMultiselectionScreen
                                            .clear();
                                        rebuildMultiSelectionScreenNotifier();
                                      }
                                    },
                                    icon: Icon(
                                      Icons.select_all_rounded,
                                      color: TColor.lightGray,
                                      size: 26,
                                    ),

                                    // Image.asset(
                                    //   "assets/img/menu/menu_open.png",
                                    //   color: TColor.lightGray,
                                    // ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.fromLTRB(9, 0, 8, 0),
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(
                                        media.width * 0.2),
                                    boxShadow: [
                                      BoxShadow(
                                        color:
                                            Colors.black.withValues(alpha: 0.2),
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
                  ],
                ),
              ),
            ),

            Expanded(
              child: StreamBuilder(
                  stream: rebuildMultiSelectionScreenStreamController.stream,
                  builder: (context, asyncSnapshot) {
                    return StreamBuilder<void>(
                        stream: flutterSoundPlayerOnSongChangeStreamController
                            .stream,
                        builder: (context, snapshot) {
                          return ListView.separated(
                            padding: const EdgeInsets.only(bottom: 112),
                            itemCount: songModelListGlobal.length,
                            itemBuilder: (context, index) {
                              final song = songModelListGlobal[index];
                              return SizedBox(
                                height: 67,
                                child: GestureDetector(
                                  child: ListTile(
                                    key: ValueKey(song.path),
                                    leading: (song.path == currentSongPreview)
                                        ? Padding(
                                            padding: const EdgeInsets.only(
                                                top: 10.0,
                                                left: 5.0,
                                                bottom: 10.0),
                                            child: SizedBox(
                                              height: 27,
                                              width: 30,
                                              child:
                                                  VisualizerFlutterSoundPlayerPreview(
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
                                    trailing: SizedBox(
                                      height:
                                          (selectedItemsFromMultiselectionScreen
                                                  .contains(song))
                                              ? 38
                                              : 35,
                                      width: 48,
                                      child: IconButton(
                                        splashRadius: 24,
                                        iconSize: 20,
                                        icon:
                                            (selectedItemsFromMultiselectionScreen
                                                    .contains(song))
                                                ? Image.asset(
                                                    "assets/img/bottomsheet/checked_box_flaticon.png",
                                                    color: Colors.green,
                                                  )
                                                : Image.asset(
                                                    "assets/img/bottomsheet/unchecked_box_flaticon.png",
                                                    color: TColor.lightGray,
                                                  ),
                                        onPressed: () async {
                                          if (selectedItemsFromMultiselectionScreen
                                              .contains(song)) {
                                            selectedItemsFromMultiselectionScreen
                                                .remove(song);
                                          } else {
                                            selectedItemsFromMultiselectionScreen
                                                .add(song);
                                          }
                                          rebuildMultiSelectionScreenNotifier();
                                        },
                                      ),
                                    ),
                                    onTap: () async {
                                      if (radioPlayer.playing) {
                                        radioPlayOrPause(context);
                                      }

                                      if (audioPlayerWasPlaying) {
                                        await audioPlayer.pause();
                                      }

                                      if (audioPlayer.playing) {
                                        await audioPlayer.pause();
                                      }

                                      ///////// CONTROLLING THE PREVIEW PLAYER //////

                                      // flutterSoundPlayer for the multi screen song preview.
                                      // It's faster!

                                      if (currentSongPreview != song.path) {
                                        currentSongPreview = song.path;
                                        flutterSoundPlayerOnSongChangeNotifier();

                                        // if (flutterSoundPlayer.isPlaying) {
                                        //   await flutterSoundPlayer.stopPlayer();
                                        // }

                                        await flutterSoundPlayer.startPlayer(
                                          fromURI: song.path,
                                          whenFinished: () {
                                            currentSongPreview = "";
                                          },
                                        );
                                      } else {
                                        if (flutterSoundPlayer.isPlaying) {
                                          await flutterSoundPlayer
                                              .pausePlayer();
                                        } else {
                                          await flutterSoundPlayer
                                              .resumePlayer();
                                        }
                                      }
                                      //////////////////////////////////////////////
                                    },
                                  ),
                                ),
                              );
                            },
                            separatorBuilder:
                                (BuildContext context, int index) {
                              return Container();
                            },
                          );
                        });
                  }),
            ),

            ///////////////////
            Divider(
              color: Colors.white12,
              indent: 25,
              endIndent: 25,
              height: 2,
            ),
            SizedBox(
              height: 90,
              // color: Colors.white24,
              child: Center(
                child: TextButton(
                  onPressed: () async {
                    if (selectedItemsFromMultiselectionScreen.isEmpty) {
                      selectSomethingFirstSnackBar(
                        context: context,
                        text: AppLocalizations.of(context)!.zero_songs_selected,
                        message: AppLocalizations.of(context)!
                            .select_something_first,
                      );
                    } else {
                      hideMiniPlayerNotifier(true);

                      showModalBottomSheet<String>(
                        isScrollControlled: true,
                        backgroundColor: Colors.transparent,
                        context: context,
                        builder: (BuildContext context) {
                          return Padding(
                            padding: EdgeInsets.only(
                              bottom: MediaQuery.of(context).viewInsets.bottom,
                            ),
                            child: SongSelectionInfoMoreBottomSheet(
                              playListName: playlistName,
                              isFromSongsScreen: isSongScreen,
                              isFromPlaylistSongScreen: isPlaylistScreen,
                              isSongFavorite: isFavoriteScreen,
                              isFromFavoriteScreen: isFavoriteScreen,
                              audioRoute: audioRoute,
                              selectedItems:
                                  selectedItemsFromMultiselectionScreen,
                            ),
                          );
                        },
                      );
                    }
                  },
                  style: TextButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    foregroundColor: Theme.of(context).colorScheme.onPrimary,
                    padding: EdgeInsets.only(
                        left: 20, right: 20, top: 10, bottom: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: Text(
                    AppLocalizations.of(context)!.what_to_do,
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}
