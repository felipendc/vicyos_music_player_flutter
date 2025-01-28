import 'package:flutter/material.dart';
import 'package:vicyos_music/app/common/color_extension.dart';
import 'package:vicyos_music/app/functions/music_player.dart';

List<String> speedRates = [
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
  "0.90"
];

List speedRatestoDouble = speedRates
    .map(
      (speed) => double.parse(speed),
    )
    .toList();

class SpeedRateBottomSheet extends StatefulWidget {
  const SpeedRateBottomSheet({super.key});

  @override
  State<SpeedRateBottomSheet> createState() => _SpeedRateBottomSheetState();
}

class _SpeedRateBottomSheetState extends State<SpeedRateBottomSheet> {
  late ScrollController scrollController;

  @override
  void initState() {
    super.initState();
    // Initialize the ScrollController
    scrollController = ScrollController(
      // Set the initial scroll offset to the height of 4 tiles
      initialScrollOffset: 4 * 53.0,
    );
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.vertical(
        top: Radius.circular(25),
        bottom: Radius.circular(0),
      ),
      child: Container(
        color: TColor.bg,
        height: 400, // Adjust the height as needed
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
            const SizedBox(height: 10),
            Text(
              "PLAYBACK SPEED",
              style: TextStyle(
                fontWeight: FontWeight.w900,
                color: TColor.org,
                fontSize: 19,
              ),
            ),
            const SizedBox(height: 20),
            // Content
            Expanded(
              child: Container(
                color: TColor.bg,
                // width: media.width * 0.9,
                child: ListView.separated(
                  controller: scrollController,
                  itemCount: speedRates.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Material(
                      color: Colors.transparent,
                      child: ListTile(
                        leading: Image.asset(
                          "assets/img/speed-fast.png",
                          width: 35,
                          height: 35,
                          color: TColor.focus,
                        ),
                        title: (index == 6)
                            ? Text("${speedRates[index]}  -  Default",
                                style: TextStyle(
                                  color: TColor.primaryText80,
                                  fontSize: 19,
                                ))
                            : Text(
                                speedRates[index],
                                style: TextStyle(
                                  color: TColor.primaryText80,
                                  fontSize: 19,
                                ),
                              ),
                        onTap: () {
                          audioPlayer.setSpeed(speedRatestoDouble[index]);
                        },
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
              ),
            ),
          ],
        ),
      ),
    );
  }
}
