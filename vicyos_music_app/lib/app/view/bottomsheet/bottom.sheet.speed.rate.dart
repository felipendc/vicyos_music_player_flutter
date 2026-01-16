import 'package:flutter/material.dart';
import 'package:vicyos_music/app/color_palette/color_extension.dart';
import 'package:vicyos_music/app/music_player/music.player.functions.and.more.dart';
import 'package:vicyos_music/app/music_player/music.player.stream.controllers.dart';
import 'package:vicyos_music/l10n/app_localizations.dart';

List<String> speedRates = [
  "2.0",
  "1.9",
  "1.8",
  "1.7",
  "1.6",
  "1.5",
  "1.4",
  "1.3",
  "1.2",
  "1.1",
  "1.0",
  "0.99",
  "0.98",
  "0.97",
  "0.96",
  "0.95",
  "0.94",
  "0.93",
  "0.92",
  "0.91",
  "0.90",
  "0.89",
  "0.88",
  "0.87",
  "0.86",
  "0.85",
  "0.84",
  "0.83",
  "0.82",
  "0.81",
  "0.80",
  "0.79",
  "0.78",
  "0.77",
  "0.76",
  "0.75",
];

List speedRatesToDouble = speedRates
    .map(
      (speed) => double.parse(speed),
    )
    .toList();

class SpeedRateBottomSheet extends StatelessWidget {
  const SpeedRateBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    late ScrollController scrollController;

    scrollController = ScrollController();

    WidgetsBinding.instance.addPostFrameCallback(
      (_) {
        double scrollPadding = 90;
        double tileHeight = 56;
        int defaultSpeedRate = speedRates.indexOf("1.0");
        double scrollOffset = defaultSpeedRate * tileHeight - scrollPadding;

        if (scrollController.hasClients) {
          scrollController.animateTo(
            scrollOffset,
            duration: Duration(seconds: 1),
            curve: Curves.easeInOut,
          );
        }
      },
    );

    return ClipRRect(
      borderRadius: const BorderRadius.vertical(
        top: Radius.circular(25),
        bottom: Radius.circular(0),
      ),
      child: Container(
        color: TColor.bg,
        height: deviceTypeIsTablet() ? 355 : 400, // Adjust the height
        padding: const EdgeInsets.fromLTRB(0, 5, 0, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            //===================================================================
            const SizedBox(height: 11),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 8, 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        AppLocalizations.of(context)!.playback_speed,
                        style: TextStyle(
                          color: TColor.primaryText28.withValues(alpha: 0.84),
                          fontSize: 15,
                          fontWeight: FontWeight.w400,
                          shadows: [
                            Shadow(
                              color: Colors.black.withValues(alpha: 0.2),
                              offset: Offset(1, 1),
                              blurRadius: 3,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 30,
                        width: 270,
                        // color: Colors.grey,
                        child: Text(
                          AppLocalizations.of(context)!.choose_a_speed,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: TColor.primaryText.withValues(alpha: 0.84),
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            shadows: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.2),
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
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
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
                                Navigator.pop(context, "");
                              },
                              icon: Image.asset(
                                "assets/img/menu/close.png",
                                color: TColor.lightGray,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            //===================================================================
            Expanded(
              child: StreamBuilder<void>(
                stream: rebuildSpeedRateBottomSheetStreamController.stream,
                builder: (context, snapshot) {
                  return Container(
                    color: TColor.bg,
                    child: ListView.separated(
                      controller: scrollController,
                      itemCount: speedRates.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Padding(
                          padding: const EdgeInsets.only(left: 4),
                          child: SizedBox(
                            height: 56,
                            child: Material(
                              color: Colors.transparent,
                              child: ListTile(
                                leading: index > speedRates.indexOf("1.0")
                                    ? Image.asset(
                                        "assets/img/speed_rate/turtle_64.png",
                                        width: 32,
                                        height: 32,
                                        color: TColor.focus,
                                      )
                                    : index < speedRates.indexOf("1.0")
                                        ? Image.asset(
                                            "assets/img/speed_rate/rocket_launch.png",
                                            width: 29,
                                            height: 29,
                                            color: TColor.focus,
                                          )
                                        : Image.asset(
                                            "assets/img/speed_rate/speed-fast.png",
                                            width: 34,
                                            height: 34,
                                            color: TColor.focus,
                                          ),
                                title: (speedRates[index] == "1.0")
                                    ? Text(
                                        "${speedRates[index]}x  -  ${AppLocalizations.of(context)!.default_playback_speed}",
                                        style: TextStyle(
                                          color: TColor.primaryText80,
                                          fontSize: 18,
                                        ))
                                    : Text(
                                        "${speedRates[index]}x",
                                        style: TextStyle(
                                          color: TColor.primaryText80,
                                          fontSize: 18,
                                        ),
                                      ),
                                onTap: () {
                                  audioPlayer
                                      .setSpeed(speedRatesToDouble[index]);
                                  rebuildSpeedRateBottomSheetNotifier();
                                },
                                trailing: (audioPlayer.speed ==
                                        speedRatesToDouble[index])
                                    ? Padding(
                                        padding:
                                            const EdgeInsets.only(right: 10.0),
                                        child: Icon(
                                          Icons.check,
                                          color: TColor.green,
                                        ),
                                      )
                                    : null,
                              ),
                            ),
                          ),
                        );
                      },
                      separatorBuilder: (BuildContext context, int index) {
                        return const Divider(
                          color: Colors.white12,
                          indent: 70,
                          endIndent: 25,
                          height: 1,
                        );
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
