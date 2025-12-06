import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:vicyos_music/app/common/build_flags/build.flags.dart';
import 'package:vicyos_music/app/common/color_palette/color_extension.dart';
import 'package:vicyos_music/app/common/files_and_folders_handler/folders.and.files.related.dart';
import 'package:vicyos_music/app/common/lifecycle_handler/permission.lifecycle.handler.dart';
import 'package:vicyos_music/app/common/music_player/music.player.functions.and.more.dart';
import 'package:vicyos_music/app/common/music_player/music.player.stream.controllers.dart';
import 'package:vicyos_music/app/common/navigation_animation/song.files.screen.navigation.animation.dart';
import 'package:vicyos_music/app/common/radio_player/functions_and_streams/radio.functions.and.more.dart';
import 'package:vicyos_music/app/common/radio_player/functions_and_streams/radio.stream.controllers.dart';
import 'package:vicyos_music/app/common/radio_player/screens/radio.station.list.screen.dart';
import 'package:vicyos_music/app/common/screen_orientation/screen.orientation.dart';
import 'package:vicyos_music/app/common/screens/loading.screen.dart';
import 'package:vicyos_music/app/is_smartphone/widgets/music_visualizer.dart';
import 'package:vicyos_music/app/is_tablet/view/bottomsheet/bottom.sheet.folders.to.playlist.dart';
import 'package:vicyos_music/app/is_tablet/view/screens/list.songs.screen.dart';
import 'package:vicyos_music/app/is_tablet/view/screens/song.search.screen.dart';

class HomePageFolderListTablet extends StatelessWidget {
  HomePageFolderListTablet({super.key}) {
    _lifecycle = PermissionLifecycleHandler(
      onResume: () async {
        if (appSettingsWasOpened) {
          musicFolderPaths.clear();
          await listMusicFolders();
        }

        appSettingsWasOpened = false;
      },
    );
  }

  // ignore: unused_field
  late final PermissionLifecycleHandler _lifecycle;

  @override
  Widget build(BuildContext context) {
    // Set the preferred orientations to landscape mode when this screen is built
    setScreenOrientation();

    var media = MediaQuery.of(context).size;

    return StreamBuilder<FetchingSongs>(
      stream: rebuildHomePageFolderListStreamController.stream,
      builder: (context, snapshot) {
        final FetchingSongs fetchingResult =
            snapshot.data ?? FetchingSongs.nullValue;

        return SafeArea(
          child: Scaffold(
            body: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 10.0),
                  child: Container(
                    decoration: BoxDecoration(
                      // color: Colors.grey,
                      color: Color(0xff181B2C),
                    ),
                    height: 135, // Loading enabled
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
                                    "Welcome to...",
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
                                  Text(
                                    "Vicyos Music",
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
                                ],
                              ),
                              Row(
                                children: [
                                  Material(
                                    color: Colors.transparent,
                                    child: SizedBox(
                                      width: 130 * 0.32,
                                      height: 130 * 0.32,
                                      child: IconButton(
                                        splashRadius: 20,
                                        iconSize: 10,
                                        onPressed: () async {
                                          musicFolderPaths.clear();
                                          await listMusicFolders();
                                        },
                                        icon: Image.asset(
                                          "assets/img/menu/autorenew.png",
                                          color: TColor.lightGray,
                                        ),
                                      ),
                                    ),
                                  ),
                                  (vicyosMusicAppHasRadio)
                                      ? StreamBuilder(
                                          stream:
                                              updateRadioScreensStreamController
                                                  .stream,
                                          builder: (context, asyncSnapshot) {
                                            return Stack(
                                              children: [
                                                Positioned(
                                                  height: 78,
                                                  child: (isRadioOn)
                                                      ? Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .only(
                                                                  left: 11),
                                                          child: LoadingAnimationWidget
                                                              .progressiveDots(
                                                            color: TColor
                                                                .lightGray, // Colors.green,
                                                            size: 20,
                                                          ),
                                                        )
                                                      : Container(),
                                                ),
                                                Material(
                                                  color: Colors.transparent,
                                                  // color: Colors.white30,
                                                  child: SizedBox(
                                                    width: 43,
                                                    height: 43,
                                                    child: IconButton(
                                                      splashRadius: 20,
                                                      iconSize: 20,
                                                      onPressed: () async {
                                                        Navigator.push(
                                                          context,
                                                          slideRightLeftTransition(
                                                            RadioStationsScreen(
                                                              scaffoldKey:
                                                                  mainRadioScreenKey,
                                                            ),
                                                          ),
                                                        );
                                                      },
                                                      icon: SizedBox(
                                                        height: 60,
                                                        child: Image.asset(
                                                          "assets/img/radio/radio_icon.png",
                                                          color:
                                                              TColor.lightGray,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            );
                                          },
                                        )
                                      : Container(),
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
                                              width: 130 * 0.44,
                                              height: 130 * 0.44,
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
                          padding: const EdgeInsets.fromLTRB(10, 8, 10, 8),
                          child: GestureDetector(
                            onTap: () async {
                              Navigator.push(
                                context,
                                slideRightLeftTransition(
                                  const SearchScreen(),
                                ),
                              ).whenComplete(
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
                                color: const Color(0xff24273A),
                                // Background color of the container
                                borderRadius: BorderRadius.circular(30),
                              ),
                              child: TextField(
                                // Attach FocusNode to the TextField
                                autofocus: false,
                                // Ensure the TextField doesn't autofocus
                                enabled: false,
                                // Disable the TextField to avoid interaction
                                style: const TextStyle(color: Colors.white),
                                decoration: InputDecoration(
                                  hintText: 'Search...',
                                  hintStyle:
                                      const TextStyle(color: Colors.white60),
                                  filled: false,
                                  fillColor: Colors.transparent,
                                  // Transparent background for TextField
                                  contentPadding: const EdgeInsets.symmetric(
                                      vertical: 12, horizontal: 0),
                                  border: InputBorder.none,
                                  // Removing border from TextField
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
                      flex: 1,
                      child: (fetchingResult == FetchingSongs.done)
                          ? ListView.separated(
                              padding: const EdgeInsets.only(
                                bottom: 112,
                              ),
                              itemCount: musicFolderPaths.length,
                              itemBuilder: (context, index) {
                                return SizedBox(
                                  height: 70,
                                  child: GestureDetector(
                                    onLongPress: () {
                                      showModalBottomSheet<void>(
                                        backgroundColor: Colors.transparent,
                                        context: context,
                                        builder: (BuildContext context) {
                                          return FolderToPlaylistBottomSheet(
                                              folderPath:
                                                  musicFolderPaths[index].path);
                                        },
                                      );
                                    },
                                    child: ListTile(
                                      leading: (musicFolderPaths[index].path ==
                                              getCurrentSongParentFolder(
                                                  currentSongFullPath))
                                          ? Stack(
                                              children: [
                                                Icon(
                                                  Icons.folder,
                                                  color: TColor.darkGray,
                                                  size: 47,
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          top: 20.0,
                                                          left: 8.5,
                                                          bottom: 0.0),
                                                  child: SizedBox(
                                                    height: 12,
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
                                                ),
                                              ],
                                            )
                                          : Icon(
                                              Icons.folder,
                                              color: TColor.focusSecondary,
                                              size: 40,
                                            ),
                                      title: Text(
                                        folderName(
                                            musicFolderPaths[index].path),
                                        textAlign: TextAlign.start,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          color: TColor.lightGray,
                                          fontSize: 20,
                                        ),
                                      ),
                                      subtitle: Text(
                                        musicFolderPaths[index].songs > 1
                                            ? '${musicFolderPaths[index].songs.toString()} songs'
                                            : '${musicFolderPaths[index].songs.toString()} song',
                                        style: const TextStyle(
                                            fontFamily: "Circular Std",
                                            fontSize: 15,
                                            color: Colors.white70),
                                      ),
                                      trailing: Material(
                                        color: Colors.transparent,
                                        child: SizedBox(
                                          width: 35,
                                          height: 35,
                                          child: IconButton(
                                            splashRadius: 20,
                                            iconSize: 10,
                                            onPressed: () async {
                                              Navigator.push(
                                                context,
                                                slideRightLeftTransition(
                                                  SongsListScreen(
                                                      folderPath:
                                                          musicFolderPaths[
                                                                  index]
                                                              .path),
                                                ),
                                              );
                                            },
                                            icon: Image.asset(
                                              "assets/img/menu/arrow_forward_ios.png",
                                              color: TColor.lightGray,
                                            ),
                                          ),
                                        ),
                                      ),
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          slideRightLeftTransition(
                                            SongsListScreen(
                                                folderPath:
                                                    musicFolderPaths[index]
                                                        .path),
                                          ),
                                        );
                                        // Handle tile tap
                                      },
                                    ),
                                  ),
                                );
                              },
                              separatorBuilder:
                                  (BuildContext context, int index) {
                                return Container();
                              },
                            )
                          : LoadingScreen(
                              currentStatus: fetchingResult,
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
