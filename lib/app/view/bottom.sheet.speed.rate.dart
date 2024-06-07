import 'package:flutter/material.dart';
import 'package:vicyos_music_player/app/common/color_extension.dart';
import 'package:vicyos_music_player/app/reusable_functions/music_player.dart';

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
      initialScrollOffset: 4 * 73.0,
    );
  }

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    return ClipRRect(
      borderRadius: const BorderRadius.vertical(
        top: Radius.circular(25),
        bottom: Radius.circular(0),
      ),
      child: Container(
        color: TColor.bg,
        height: 400, // Adjust the height as needed
        padding: const EdgeInsets.fromLTRB(16, 5, 16, 16),
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
            Text(
              "________",
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
                width: media.width * 0.9,
                child: ListView(
                  controller: scrollController,
                  padding: EdgeInsets.zero,
                  children: [
                    ListTile(
                      leading: Image.asset(
                        "assets/img/speed-fast.png",
                        width: 35,
                        height: 35,
                        color: TColor.focus,
                      ),
                      title: Text(
                        "1.6",
                        style: TextStyle(
                          color: TColor.primaryText80,
                          fontSize: 19,
                        ),
                      ),
                      contentPadding: const EdgeInsets.fromLTRB(0, 4, 0, 4),
                      onTap: () async {
                        audioPlayer.setSpeed(1.6);
                      },
                    ),
                    const Divider(
                      color: Colors.white12,
                      indent: 58,
                      endIndent: 10,
                      height: 1,
                    ),
                    ListTile(
                      leading: Image.asset(
                        "assets/img/speed-fast.png",
                        width: 35,
                        height: 35,
                        color: TColor.focus,
                      ),
                      title: Text(
                        "1.5",
                        style: TextStyle(
                          color: TColor.primaryText80,
                          fontSize: 19,
                        ),
                      ),
                      contentPadding: const EdgeInsets.fromLTRB(0, 4, 0, 4),
                      onTap: () async {
                        audioPlayer.setSpeed(1.5);
                      },
                    ),
                    const Divider(
                      color: Colors.white12,
                      indent: 58,
                      endIndent: 10,
                      height: 1,
                    ),
                    ListTile(
                      leading: Image.asset(
                        "assets/img/speed-fast.png",
                        width: 35,
                        height: 35,
                        color: TColor.focus,
                      ),
                      title: Text(
                        "1.4",
                        style: TextStyle(
                          color: TColor.primaryText80,
                          fontSize: 19,
                        ),
                      ),
                      contentPadding: const EdgeInsets.fromLTRB(0, 4, 0, 4),
                      onTap: () async {
                        audioPlayer.setSpeed(1.4);
                      },
                    ),
                    const Divider(
                      color: Colors.white12,
                      indent: 58,
                      endIndent: 10,
                      height: 1,
                    ),
                    ListTile(
                      leading: Image.asset(
                        "assets/img/speed-fast.png",
                        width: 35,
                        height: 35,
                        color: TColor.focus,
                      ),
                      title: Text(
                        "1.3",
                        style: TextStyle(
                          color: TColor.primaryText80,
                          fontSize: 19,
                        ),
                      ),
                      contentPadding: const EdgeInsets.fromLTRB(0, 4, 0, 4),
                      onTap: () async {
                        audioPlayer.setSpeed(1.3);
                      },
                    ),
                    const Divider(
                      color: Colors.white12,
                      indent: 58,
                      endIndent: 10,
                      height: 1,
                    ),
                    ListTile(
                      leading: Image.asset(
                        "assets/img/speed-fast.png",
                        width: 35,
                        height: 35,
                        color: TColor.focus,
                      ),
                      title: Text(
                        "1.2",
                        style: TextStyle(
                          color: TColor.primaryText80,
                          fontSize: 19,
                        ),
                      ),
                      contentPadding: const EdgeInsets.fromLTRB(0, 4, 0, 4),
                      onTap: () async {
                        audioPlayer.setSpeed(1.2);
                      },
                    ),
                    const Divider(
                      color: Colors.white12,
                      indent: 58,
                      endIndent: 10,
                      height: 1,
                    ),
                    ListTile(
                      leading: Image.asset(
                        "assets/img/speed-fast.png",
                        width: 35,
                        height: 35,
                        color: TColor.focus,
                      ),
                      title: Text(
                        "1.1",
                        style: TextStyle(
                          color: TColor.primaryText80,
                          fontSize: 19,
                        ),
                      ),
                      contentPadding: const EdgeInsets.fromLTRB(0, 4, 0, 4),
                      onTap: () async {
                        audioPlayer.setSpeed(1.1);
                      },
                    ),
                    const Divider(
                      color: Colors.white12,
                      indent: 58,
                      endIndent: 10,
                      height: 1,
                    ),
                    ListTile(
                      leading: Image.asset(
                        "assets/img/speed-fast.png",
                        width: 35,
                        height: 35,
                        color: TColor.focus,
                      ),
                      title: Text(
                        "1.0   -  Default",
                        style: TextStyle(
                          color: TColor.primaryText80,
                          fontSize: 19,
                        ),
                      ),
                      contentPadding: const EdgeInsets.fromLTRB(0, 4, 0, 4),
                      onTap: () async {
                        audioPlayer.setSpeed(1.0);
                      },
                    ),
                    const Divider(
                      color: Colors.white12,
                      indent: 58,
                      endIndent: 10,
                      height: 1,
                    ),
                    ListTile(
                      leading: Image.asset(
                        "assets/img/turtle-fast.png",
                        width: 35,
                        height: 35,
                        color: TColor.focus,
                      ),
                      title: Text(
                        "0.99",
                        style: TextStyle(
                          color: TColor.primaryText80,
                          fontSize: 19,
                        ),
                      ),
                      contentPadding: const EdgeInsets.fromLTRB(0, 4, 0, 4),
                      onTap: () async {
                        audioPlayer.setSpeed(0.99);
                      },
                    ),
                    const Divider(
                      color: Colors.white12,
                      indent: 58,
                      endIndent: 10,
                      height: 1,
                    ),
                    ListTile(
                      leading: Image.asset(
                        "assets/img/turtle-fast.png",
                        width: 35,
                        height: 35,
                        color: TColor.focus,
                      ),
                      title: Text(
                        "0.98",
                        style: TextStyle(
                          color: TColor.primaryText80,
                          fontSize: 19,
                        ),
                      ),
                      contentPadding: const EdgeInsets.fromLTRB(0, 4, 0, 4),
                      onTap: () async {
                        audioPlayer.setSpeed(0.98);
                      },
                    ),
                    const Divider(
                      color: Colors.white12,
                      indent: 58,
                      endIndent: 10,
                      height: 1,
                    ),
                    ListTile(
                      leading: Image.asset(
                        "assets/img/turtle-fast.png",
                        width: 35,
                        height: 35,
                        color: TColor.focus,
                      ),
                      title: Text(
                        "0.97",
                        style: TextStyle(
                          color: TColor.primaryText80,
                          fontSize: 19,
                        ),
                      ),
                      contentPadding: const EdgeInsets.fromLTRB(0, 4, 0, 4),
                      onTap: () async {
                        audioPlayer.setSpeed(0.97);
                      },
                    ),
                    const Divider(
                      color: Colors.white12,
                      indent: 58,
                      endIndent: 10,
                      height: 1,
                    ),
                    ListTile(
                      leading: Image.asset(
                        "assets/img/slug.png",
                        width: 35,
                        height: 35,
                        color: TColor.focus,
                      ),
                      title: Text(
                        "0.96",
                        style: TextStyle(
                          color: TColor.primaryText80,
                          fontSize: 19,
                        ),
                      ),
                      contentPadding: const EdgeInsets.fromLTRB(0, 4, 0, 4),
                      onTap: () async {
                        audioPlayer.setSpeed(0.96);
                      },
                    ),
                    const Divider(
                      color: Colors.white12,
                      indent: 58,
                      endIndent: 10,
                      height: 1,
                    ),
                    ListTile(
                      leading: Image.asset(
                        "assets/img/slug.png",
                        width: 35,
                        height: 35,
                        color: TColor.focus,
                      ),
                      title: Text(
                        "0.95",
                        style: TextStyle(
                          color: TColor.primaryText80,
                          fontSize: 19,
                        ),
                      ),
                      contentPadding: const EdgeInsets.fromLTRB(0, 4, 0, 4),
                      onTap: () async {
                        audioPlayer.setSpeed(0.95);
                      },
                    ),
                    const Divider(
                      color: Colors.white12,
                      indent: 58,
                      endIndent: 10,
                      height: 1,
                    ),
                    ListTile(
                      leading: Image.asset(
                        "assets/img/slug.png",
                        width: 35,
                        height: 35,
                        color: TColor.focus,
                      ),
                      title: Text(
                        "0.94",
                        style: TextStyle(
                          color: TColor.primaryText80,
                          fontSize: 19,
                        ),
                      ),
                      contentPadding: const EdgeInsets.fromLTRB(0, 4, 0, 4),
                      onTap: () async {
                        audioPlayer.setSpeed(0.94);
                      },
                    ),
                    const Divider(
                      color: Colors.white12,
                      indent: 58,
                      endIndent: 10,
                      height: 1,
                    ),
                    ListTile(
                      leading: Image.asset(
                        "assets/img/slug.png",
                        width: 35,
                        height: 35,
                        color: TColor.focus,
                      ),
                      title: Text(
                        "0.93",
                        style: TextStyle(
                          color: TColor.primaryText80,
                          fontSize: 19,
                        ),
                      ),
                      contentPadding: const EdgeInsets.fromLTRB(0, 4, 0, 4),
                      onTap: () async {
                        audioPlayer.setSpeed(0.93);
                      },
                    ),
                    const Divider(
                      color: Colors.white12,
                      indent: 58,
                      endIndent: 10,
                      height: 1,
                    ),
                    ListTile(
                      leading: Image.asset(
                        "assets/img/slug.png",
                        width: 35,
                        height: 35,
                        color: TColor.focus,
                      ),
                      title: Text(
                        "0.92",
                        style: TextStyle(
                          color: TColor.primaryText80,
                          fontSize: 19,
                        ),
                      ),
                      contentPadding: const EdgeInsets.fromLTRB(0, 4, 0, 4),
                      onTap: () async {
                        audioPlayer.setSpeed(0.92);
                      },
                    ),
                    const Divider(
                      color: Colors.white12,
                      indent: 58,
                      endIndent: 10,
                      height: 1,
                    ),
                    ListTile(
                      leading: Image.asset(
                        "assets/img/slug.png",
                        width: 35,
                        height: 35,
                        color: TColor.focus,
                      ),
                      title: Text(
                        "0.91",
                        style: TextStyle(
                          color: TColor.primaryText80,
                          fontSize: 19,
                        ),
                      ),
                      contentPadding: const EdgeInsets.fromLTRB(0, 4, 0, 4),
                      onTap: () async {
                        audioPlayer.setSpeed(0.91);
                      },
                    ),
                    const Divider(
                      color: Colors.white12,
                      indent: 58,
                      endIndent: 10,
                      height: 1,
                    ),
                    ListTile(
                      leading: Image.asset(
                        "assets/img/slug.png",
                        width: 35,
                        height: 35,
                        color: TColor.focus,
                      ),
                      title: Text(
                        "0.90",
                        style: TextStyle(
                          color: TColor.primaryText80,
                          fontSize: 19,
                        ),
                      ),
                      contentPadding: const EdgeInsets.fromLTRB(0, 4, 0, 4),
                      onTap: () async {
                        audioPlayer.setSpeed(0.90);
                      },
                    ),
                    const Divider(
                      color: Colors.white12,
                      indent: 58,
                      endIndent: 10,
                      height: 1,
                    ),

                    // Add more list tiles or widgets as needed
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
