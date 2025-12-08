import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:vicyos_music/app/common/color_palette/color_extension.dart';
import 'package:vicyos_music/app/common/music_player/music.player.functions.and.more.dart';
import 'package:vicyos_music/app/common/music_player/music.player.stream.controllers.dart';
import 'package:vicyos_music/app/common/navigation_animation/song.files.screen.navigation.animation.dart'
    show slideRightLeftTransition;
import 'package:vicyos_music/app/common/radio_player/functions_and_streams/radio.functions.and.more.dart';
import 'package:vicyos_music/app/common/radio_player/functions_and_streams/radio.stream.controllers.dart'
    show updateRadioScreensStreamController;
import 'package:vicyos_music/app/common/radio_player/radio_stations/radio.stations.list.dart';
import 'package:vicyos_music/app/common/radio_player/screens/radio.search.screen.dart';
import 'package:vicyos_music/app/common/radio_player/widgets/radio.music.visualizer.dart';
import 'package:vicyos_music/app/common/screen_orientation/screen.orientation.dart';
import 'package:vicyos_music/l10n/app_localizations.dart';

final GlobalKey mainRadioScreenKey = GlobalKey();

class RadioStationsScreen extends StatelessWidget {
  final GlobalKey scaffoldKey;
  const RadioStationsScreen({
    super.key,
    required this.scaffoldKey,
  });

  @override
  Widget build(BuildContext context) {
    // Set the preferred orientations to portrait mode when this screen is built
    setScreenOrientation();

    var media = MediaQuery.sizeOf(context);

    return SafeArea(
      child: Scaffold(
        body: StreamBuilder<void>(
            stream: updateRadioScreensStreamController.stream,
            builder: (context, snapshot) {
              return Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 10.0),
                    child: Container(
                      decoration: BoxDecoration(
                        // color: Colors.grey,
                        color: Color(0xff181B2C),
                      ),
                      height: (deviceType == DeviceType.tablet)
                          ? 135
                          : 130, // Loading enabled
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
                                      AppLocalizations.of(context)!.online,
                                      style: TextStyle(
                                        color: TColor.primaryText28
                                            .withValues(alpha: 0.84),
                                        fontSize: 14,
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
                                      height: 26,
                                      width: 180,
                                      // color: Colors.grey,
                                      child: Text(
                                        AppLocalizations.of(context)!.radio,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          color: TColor.primaryText
                                              .withValues(alpha: 0.84),
                                          fontSize: 21,
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
                                            hideMiniPlayerNotifier(true);
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
                                          icon: StreamBuilder<void>(
                                            stream:
                                                updateRadioScreensStreamController
                                                    .stream,
                                            builder: (context, snapshot) {
                                              return Image.asset(
                                                "assets/img/radio/power_btn_300p.png",
                                                color: radioStationBtn,
                                              );
                                            },
                                          ),
                                          onPressed: () async {
                                            isRadioOn
                                                ? await turnOffRadioStation()
                                                : playRadioStation(context, 0);
                                          },
                                        ),
                                      ),
                                    ),
                                    Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            9, 0, 8, 0),
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
                                                  width: (deviceType ==
                                                          DeviceType.tablet)
                                                      ? 130 * 0.44
                                                      : media.width * 0.13,
                                                  height: (deviceType ==
                                                          DeviceType.tablet)
                                                      ? 130 * 0.44
                                                      : media.width * 0.13,
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
                                            const RadioSearchScreen()))
                                    .whenComplete(
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
                    stream: updateRadioScreensStreamController.stream,
                    builder: (context, snapshot) {
                      return Expanded(
                        child: ListView.separated(
                          padding: const EdgeInsets.only(bottom: 112),
                          itemCount: radioStationList.length,
                          itemBuilder: (context, index) {
                            return SizedBox(
                              height: 67,
                              child: GestureDetector(
                                onLongPress: () {},
                                child: ListTile(
                                  key: ValueKey(
                                      radioStationList[index].radioUrl),
                                  leading: Container(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 5),
                                    child: (radioStationList[index].id ==
                                            currentRadioStationID)
                                        ? StreamBuilder<PlayerState>(
                                            stream:
                                                radioPlayer.playerStateStream,
                                            builder: (context, snapshot) {
                                              if (isRadioPaused ||
                                                  isRadioPlaying) {
                                                return Padding(
                                                  padding:
                                                      const EdgeInsets.only(
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
                                                  width: radioHasLogo(index)
                                                      ? 45
                                                      : 32,
                                                  height: radioHasLogo(index)
                                                      ? 45
                                                      : 32,
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
                                            width:
                                                radioHasLogo(index) ? 45 : 32,
                                            height:
                                                radioHasLogo(index) ? 45 : 32,
                                            radioHasLogo(index)
                                                ? radioStationList[index]
                                                    .ratioStationLogo!
                                                : radioLogo(),
                                            color: radioHasLogo(index)
                                                ? null
                                                : TColor.focus,
                                          ),
                                  ),
                                  title: Text(
                                    radioStationList[index].radioName,
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
                                    radioStationList[index].radioLocation,
                                    textAlign: TextAlign.start,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      color: TColor.secondaryText,
                                      fontSize: 15,
                                    ),
                                  ),
                                  trailing: Container(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 5),
                                    child: (radioStationList[index].id ==
                                            currentRadioStationID)
                                        ? StreamBuilder<PlayerState>(
                                            stream:
                                                radioPlayer.playerStateStream,
                                            builder: (context, snapshot) {
                                              final playerState = snapshot.data;
                                              final processingState =
                                                  playerState?.processingState;
                                              final playing =
                                                  playerState?.playing;

                                              if (processingState ==
                                                      ProcessingState.loading ||
                                                  processingState ==
                                                      ProcessingState
                                                          .buffering) {
                                                return Container(
                                                  margin:
                                                      const EdgeInsets.all(8.0),
                                                  width: 18.0,
                                                  height: 18.0,
                                                  child:
                                                      // const CircularProgressIndicator(),
                                                      Center(
                                                    child:
                                                        LoadingAnimationWidget
                                                            .inkDrop(
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
                                                      ProcessingState
                                                          .completed ||
                                                  playing == true ||
                                                  isRadioPaused) {
                                                return Image.asset(
                                                  height: 30,
                                                  width: 30,
                                                  "assets/img/radio/antenna-bars-5-streamline.png",
                                                  color: Colors.green,
                                                );
                                              } else {
                                                return (radioStationList[index]
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
                                        : (radioStationList[index]
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
                                              ),
                                  ),
                                  onTap: () async {
                                    await playRadioStation(context, index);
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
              );
            }),
      ),
    );
  }
}
