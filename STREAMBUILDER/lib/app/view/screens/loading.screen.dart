import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:vicyos_music/app/common/color_extension.dart';
import 'package:vicyos_music/app/functions/folders.and.files.related.dart';
import 'package:vicyos_music/app/functions/music_player.dart';

class LoadingScreen extends StatelessWidget {
  const LoadingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.sizeOf(context);

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
                height: 130, // Loading enabled
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
                                      color:
                                          Colors.black.withValues(alpha: 0.2),
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
                                      color:
                                          Colors.black.withValues(alpha: 0.2),
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
                                  width: 40,
                                  height: 40,
                                  child: IconButton(
                                    splashRadius: 20,
                                    iconSize: 10,
                                    onPressed: () async {
                                      musicFolderPaths.clear();
                                      listMusicFolders();
                                      listPlaylistFolderStreamNotifier();
                                    },
                                    icon: Image.asset(
                                      "assets/img/autorenew.png",
                                      color: TColor.lightGray,
                                    ),
                                  ),
                                ),
                              ),
                              // Material(
                              //   color: Colors.transparent,
                              //   child: SizedBox(
                              //     width: 38,
                              //     height: 38,
                              //     child: IconButton(
                              //       splashRadius: 20,
                              //       iconSize: 10,
                              //       onPressed: () async {
                              //         //TODO
                              //         Navigator.push(
                              //           context,
                              //           slideRightLeftTransition(
                              //             const SearchScreen(),
                              //           ),
                              //         );
                              //       },
                              //       icon: Image.asset(
                              //         "assets/img/search.png",
                              //         color: TColor.lightGray,
                              //       ),
                              //     ),
                              //   ),
                              // ),
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
                                      child: StreamBuilder<bool>(
                                        stream: albumArtStreamController.stream,
                                        builder: (context, snapshot) {
                                          return Image.asset(
                                            "assets/img/pics/default.png",
                                            width: media.width * 0.13,
                                            height: media.width * 0.13,
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
                          // Do nothing...
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
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
                              hintText: 'Search...',
                              hintStyle: const TextStyle(color: Colors.white60),
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
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(
                  height: 300,
                ),
                Center(
                  child: LoadingAnimationWidget.staggeredDotsWave(
                    size: 40,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
