import 'package:flutter/material.dart';
import 'package:vicyos_music/app/common/color_palette/color_extension.dart';
import 'package:vicyos_music/app/common/music_player/music.player.functions.and.more.dart';
import 'package:vicyos_music/app/common/radio/radio.functions.and.more.dart';

List<String> speedRates = [
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

class RadioSpeedRateBottomSheet extends StatelessWidget {
  const RadioSpeedRateBottomSheet({super.key});

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
        height: 400, // Adjust the height
        padding: const EdgeInsets.fromLTRB(0, 5, 0, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Top button indicator
            Container(
              width: 100,
              margin: const EdgeInsets.only(top: 10, bottom: 10),
              height: 5,
              decoration: BoxDecoration(
                color: TColor.secondaryText,
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            const SizedBox(height: 7),
            Text(
              "PLAYBACK SPEED",
              style: TextStyle(
                fontWeight: FontWeight.w900,
                color: TColor.org,
                fontSize: 19,
              ),
            ),
            const SizedBox(height: 20),

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
                        return SizedBox(
                          height: 56,
                          child: Material(
                            color: Colors.transparent,
                            child: ListTile(
                              leading: index > speedRates.indexOf("1.0")
                                  ? Image.asset(
                                      "assets/img/turtle_64.png",
                                      width: 33,
                                      height: 33,
                                      color: TColor.focus,
                                    )
                                  : index < speedRates.indexOf("1.0")
                                      ? Image.asset(
                                          "assets/img/rocket_launch.png",
                                          width: 30,
                                          height: 30,
                                          color: TColor.focus,
                                        )
                                      : Image.asset(
                                          "assets/img/speed-fast.png",
                                          width: 35,
                                          height: 35,
                                          color: TColor.focus,
                                        ),
                              title: (speedRates[index] == "1.0")
                                  ? Text("${speedRates[index]}x  -  Default",
                                      style: TextStyle(
                                        color: TColor.primaryText80,
                                        fontSize: 19,
                                      ))
                                  : Text(
                                      "${speedRates[index]}x",
                                      style: TextStyle(
                                        color: TColor.primaryText80,
                                        fontSize: 19,
                                      ),
                                    ),
                              onTap: () {
                                radioPlayer.setSpeed(speedRatesToDouble[index]);
                                rebuildSpeedRateBottomSheetStreamNotifier();
                              },
                              trailing: (radioPlayer.speed ==
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
