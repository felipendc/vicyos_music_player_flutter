import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:vicyos_music/app/color_palette/color_extension.dart';
import 'package:vicyos_music/app/components/marquee.text.dart';
import 'package:vicyos_music/app/music_player/music.player.functions.and.more.dart';
import 'package:vicyos_music/app/navigation_animation/main.player.navigation.animation.dart'
    show mainPlayerSlideUpDownTransition;
import 'package:vicyos_music/app/radio_player/functions_and_streams/radio.functions.and.more.dart';
import 'package:vicyos_music/app/radio_player/functions_and_streams/radio.stream.controllers.dart';
import 'package:vicyos_music/app/view/screens/main.radio.player.screen.dart';
import 'package:vicyos_music/l10n/app_localizations.dart';

class BottomRadioPlayer extends StatelessWidget {
  const BottomRadioPlayer({super.key});

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.sizeOf(context);

    return Stack(
      children: [
        Column(
          children: [
            Container(
              width: media.width * 0.94,
              margin: const EdgeInsets.only(top: 0, bottom: 18),
              height: 72,
              decoration: BoxDecoration(
                color: Color(0xff2A2D40),
                boxShadow: [
                  BoxShadow(
                    color: Color(0xff000000).withValues(alpha: 0.5),
                    spreadRadius: 0.4,
                    blurRadius: 12,
                    offset: Offset(1, 1),
                  ),
                ],
                borderRadius: BorderRadius.circular(20),
              ),
              child: Material(
                color: Colors.transparent,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(14, 5, 10, 5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          StreamBuilder(
                            stream: updateRadioScreensStreamController.stream,
                            builder: (context, asyncSnapshot) {
                              return Stack(
                                children: [
                                  Positioned(
                                    height: 103,
                                    child: (isRadioOn)
                                        //  flickr
                                        ? Padding(
                                            padding: const EdgeInsets.only(
                                                left: 15.2),
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
                                      width: 52,
                                      height: 53,
                                      child: IconButton(
                                        iconSize: 20,
                                        onPressed: null,
                                        icon: SizedBox(
                                          height: 60,
                                          child: Image.asset(
                                            "assets/img/radio/radio_icon.png",
                                            color: TColor.lightGray,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            },
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    hideMiniRadioPlayerNotifier(true);

                                    Navigator.push(
                                      context,
                                      mainPlayerSlideUpDownTransition(
                                        MainRadioPlayerView(
                                          scaffoldKey: mainRadioPlayerViewKey,
                                        ),
                                      ),
                                    ).whenComplete(
                                      () {
                                        if (mainPlayerIsOpen) {
                                          mainPlayerIsOpen = false;
                                        }
                                        hideMiniRadioPlayerNotifier(false);
                                      },
                                    );
                                  },
                                  child: StreamBuilder<void>(
                                    stream: radioPlayer.sequenceStateStream,
                                    builder: (context, snapshot) {
                                      return Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          SizedBox(
                                            width: media.width * 0.35,
                                            height: media.width * 0.06,
                                            child: LayoutBuilder(
                                              builder: (context, constraints) {
                                                // Gets the width of Expanded
                                                final double width =
                                                    constraints.maxWidth;
                                                return MarqueeText(
                                                  centerText: false,
                                                  // Forces rebuild when song changes
                                                  key: ValueKey(
                                                      currentRadioStationID),
                                                  // Set dynamically based on layout
                                                  maxWidth: width,
                                                  text: isRadioOn
                                                      ? currentRadioStationName
                                                      : AppLocalizations.of(
                                                              context)!
                                                          .the_radio_is_turned_off,

                                                  style: TextStyle(
                                                    color: TColor.primaryText
                                                        .withValues(
                                                            alpha: 0.84),
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                );
                                              },
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                left: 0.0),
                                            child: SizedBox(
                                              width: media.width * 0.30,
                                              child: Row(
                                                children: [
                                                  StreamBuilder<void>(
                                                    stream:
                                                        updateRadioScreensStreamController
                                                            .stream,
                                                    builder:
                                                        (context, snapshot) {
                                                      // Check if snapshot has data
                                                      if (!isRadioOn) {
                                                        return Text(
                                                          '0',
                                                          style: TextStyle(
                                                              color: TColor
                                                                  .secondaryText,
                                                              fontSize: 15),
                                                        );
                                                      }
                                                      return Text(
                                                        "${currentRadioIndex + 1}",
                                                        style: TextStyle(
                                                            color: TColor
                                                                .secondaryText,
                                                            fontSize: 15),
                                                      );
                                                    },
                                                  ),
                                                  StreamBuilder<void>(
                                                    stream:
                                                        updateRadioScreensStreamController
                                                            .stream,
                                                    builder:
                                                        (context, snapshot) {
                                                      return Text(
                                                        isRadioOn
                                                            ? " ${AppLocalizations.of(context)!.prepositionOf} ${radioPlayer.audioSources.length}"
                                                            : " ${AppLocalizations.of(context)!.prepositionOf} 0",
                                                        style: TextStyle(
                                                            color: TColor
                                                                .secondaryText,
                                                            fontSize: 15),
                                                      );
                                                    },
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: 40,
                            height: 40,
                            child: IconButton(
                              splashRadius: 20,
                              iconSize: 10,
                              onPressed: () async {
                                await radioSeekToPrevious();
                              },
                              icon: Image.asset(
                                "assets/img/bottom_player/skip_previous.png",
                                color: TColor.lightGray,
                              ),
                            ),
                          ),
                          StreamBuilder<PlayerState>(
                            stream: radioPlayer.playerStateStream,
                            builder: (context, snapshot) {
                              final playerState = snapshot.data;
                              final playing = playerState?.playing;
                              if (playing != true) {
                                return SizedBox(
                                  width: 45,
                                  height: 45,
                                  child: IconButton(
                                    splashRadius: 20,
                                    onPressed: () async {
                                      await radioPlayOrPause();
                                    },
                                    icon: Image.asset(
                                      "assets/img/bottom_player/motion_play.png",
                                      color: TColor.lightGray,
                                    ),
                                  ),
                                );
                              } else {
                                return SizedBox(
                                  width: 45,
                                  height: 45,
                                  child: IconButton(
                                    splashRadius: 20,
                                    onPressed: () async {
                                      await radioPlayOrPause();
                                    },
                                    icon: Image.asset(
                                      "assets/img/bottom_player/motion_paused.png",
                                      color: TColor.lightGray,
                                    ),
                                  ),
                                );
                              }
                            },
                          ),
                          SizedBox(
                            width: 40,
                            height: 40,
                            child: IconButton(
                              iconSize: 10,
                              splashRadius: 20,
                              onPressed: () async {
                                await radioSeekToNext();
                              },
                              icon: Image.asset(
                                "assets/img/bottom_player/skip_next.png",
                                color: TColor.lightGray,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
