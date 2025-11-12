// import 'package:flutter/material.dart';
// import 'package:vicyos_music/app/common/color_palette/color_extension.dart';
// import 'package:vicyos_music/app/common/music_player/music.player.dart';
// import 'package:vicyos_music/app/common/navigation_animation/song.files.screen.navigation.animation.dart';
// import 'package:vicyos_music/app/common/radio/radio.functions.dart'
//     show playRadioStation, turnOffRadioStation;
// import 'package:vicyos_music/app/common/radio_stations/radio.stations.list.dart';
// import 'package:vicyos_music/app/common/screen_orientation/screen.orientation.dart';
// import 'package:vicyos_music/app/is_smartphone/view/screens/song.search.screen.dart';
//
// class RadioStationsScreen extends StatelessWidget {
//   const RadioStationsScreen({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     Color getCardColor(int index, int length) {
//       const baseColor = Color(0xff2A2D40);
//       const int toneStep = 0x00040404;
//
//       // 3 primeiros — escuro → claro (levemente mais claros)
//       if (index < 3) {
//         return Color(0xff262838 + (index * toneStep));
//       }
//
//       // 3 últimos — claro → escuro (espelhado)
//       if (index >= length - 3) {
//         int pos = index - (length - 3);
//         return Color(0xff242635 + ((2 - pos) * toneStep));
//       }
//
//       // meio mantém o tom base
//       return baseColor;
//     }
//
//     // Set the preferred orientations to portrait mode when this screen is built
//     setScreenOrientation();
//
//     radioStationList;
//
//     var media = MediaQuery.sizeOf(context);
//
//     return StreamBuilder<void>(
//       stream: rebuildSongsListScreenStreamController.stream,
//       builder: (context, snapshot) {
//         return SafeArea(
//           child: Scaffold(
//             // appBar: songsListAppBar(folderPath: folderPath, context: context),
//             body: Column(
//               children: [
//                 Padding(
//                   padding: const EdgeInsets.only(top: 10.0),
//                   child: Container(
//                     decoration: BoxDecoration(
//                       // color: Colors.grey,
//                       color: Color(0xff181B2C),
//                     ),
//                     height: 130, // Loading enabled
//                     child: Column(
//                       // mainAxisAlignment: MainAxisAlignment.center,
//                       crossAxisAlignment: CrossAxisAlignment.center,
//                       children: [
//                         Padding(
//                           padding: const EdgeInsets.fromLTRB(20, 0, 8, 10),
//                           child: Row(
//                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                             children: [
//                               Column(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   Text(
//                                     "Online",
//                                     style: TextStyle(
//                                       color: TColor.primaryText28
//                                           .withValues(alpha: 0.84),
//                                       fontSize: 14,
//                                       fontWeight: FontWeight.w400,
//                                       shadows: [
//                                         Shadow(
//                                           color: Colors.black
//                                               .withValues(alpha: 0.2),
//                                           offset: Offset(1, 1),
//                                           blurRadius: 3,
//                                         ),
//                                       ],
//                                     ),
//                                   ),
//                                   SizedBox(
//                                     height: 26,
//                                     width: 180,
//                                     // color: Colors.grey,
//                                     child: Text(
//                                       "Radio",
//                                       maxLines: 1,
//                                       overflow: TextOverflow.ellipsis,
//                                       style: TextStyle(
//                                         color: TColor.primaryText
//                                             .withValues(alpha: 0.84),
//                                         fontSize: 21,
//                                         fontWeight: FontWeight.w600,
//                                         shadows: [
//                                           BoxShadow(
//                                             color: Colors.black
//                                                 .withValues(alpha: 0.2),
//                                             spreadRadius: 5,
//                                             blurRadius: 8,
//                                             offset: Offset(2, 4),
//                                           ),
//                                         ],
//                                       ),
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                               Row(
//                                 children: [
//                                   Material(
//                                     color: Colors.transparent,
//                                     child: SizedBox(
//                                       width: 35,
//                                       height: 35,
//                                       child: IconButton(
//                                         splashRadius: 20,
//                                         iconSize: 10,
//                                         onPressed: () async {
//                                           hideMiniPlayerStreamNotifier(true);
//                                           Navigator.pop(context);
//                                         },
//                                         icon: Image.asset(
//                                           "assets/img/arrow_back_ios.png",
//                                           color: TColor.lightGray,
//                                         ),
//                                       ),
//                                     ),
//                                   ),
//                                   Material(
//                                     color: Colors.transparent,
//                                     child: SizedBox(
//                                       width: 45,
//                                       height: 45,
//                                       child: IconButton(
//                                         splashRadius: 20,
//                                         iconSize: 10,
//                                         icon: StreamBuilder<void>(
//                                           stream:
//                                               rebuildRadioScreenStreamController
//                                                   .stream,
//                                           builder: (context, snapshot) {
//                                             return Image.asset(
//                                               "assets/img/power_btn_300p.png",
//                                               color: radioStationBtn,
//                                             );
//                                           },
//                                         ),
//                                         onPressed: () async {
//                                           isRadioOn
//                                               ? await turnOffRadioStation()
//                                               : playRadioStation(context, 1);
//                                         },
//                                       ),
//                                     ),
//                                   ),
//                                   Padding(
//                                       padding:
//                                           const EdgeInsets.fromLTRB(9, 0, 8, 0),
//                                       child: Container(
//                                         decoration: BoxDecoration(
//                                           borderRadius: BorderRadius.circular(
//                                               media.width * 0.2),
//                                           boxShadow: [
//                                             BoxShadow(
//                                               color: Colors.black
//                                                   .withValues(alpha: 0.2),
//                                               spreadRadius: 5,
//                                               blurRadius: 8,
//                                               offset: Offset(2, 4),
//                                             ),
//                                           ],
//                                         ),
//                                         child: ClipRRect(
//                                           borderRadius: BorderRadius.circular(
//                                               media.width * 0.2),
//                                           child: StreamBuilder<void>(
//                                             stream: null,
//                                             builder: (context, snapshot) {
//                                               return Image.asset(
//                                                 "assets/img/pics/default.png",
//                                                 width: media.width * 0.13,
//                                                 height: media.width * 0.13,
//                                                 fit: BoxFit.cover,
//                                               );
//                                             },
//                                           ),
//                                         ),
//                                       )),
//                                 ],
//                               ),
//                             ],
//                           ),
//                         ),
//
//                         // Search Box
//                         Padding(
//                           padding: const EdgeInsets.fromLTRB(10, 8, 10, 8),
//                           child: GestureDetector(
//                             onTap: () async {
//                               Navigator.push(
//                                   context,
//                                   slideRightLeftTransition(
//                                     const SearchScreen(),
//                                   )).whenComplete(
//                                 () {
//                                   searchBoxController.dispose();
//                                   searchBoxController.dispose();
//                                 },
//                               );
//                             },
//                             child: Container(
//                               padding:
//                                   const EdgeInsets.symmetric(horizontal: 16),
//                               decoration: BoxDecoration(
//                                 color: const Color(
//                                     0xff24273A), // Background color of the container
//                                 borderRadius: BorderRadius.circular(30),
//                               ),
//                               child: TextField(
//                                 // Attach FocusNode to the TextField
//                                 autofocus:
//                                     false, // Ensure the TextField doesn't autofocus
//                                 enabled:
//                                     false, // Disable the TextField to avoid interaction
//                                 style: const TextStyle(color: Colors.white),
//                                 decoration: InputDecoration(
//                                   hintText: 'Search...',
//                                   hintStyle:
//                                       const TextStyle(color: Colors.white60),
//                                   filled: false,
//                                   fillColor: Colors
//                                       .transparent, // Transparent background for TextField
//                                   contentPadding: const EdgeInsets.symmetric(
//                                       vertical: 12, horizontal: 0),
//                                   border: InputBorder
//                                       .none, // Removing border from TextField
//                                   suffixIcon: Padding(
//                                     padding: const EdgeInsets.only(left: 50),
//                                     child: const Icon(Icons.search,
//                                         color: Colors.white70),
//                                   ),
//                                 ),
//                               ),
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//                 StreamBuilder<void>(
//                   stream: getCurrentSongFullPathStreamController.stream,
//                   builder: (context, snapshot) {
//                     return Expanded(
//                       child: ListView.separated(
//                         padding: const EdgeInsets.only(bottom: 112),
//                         itemCount: radioStationList.length,
//                         itemBuilder: (context, index) {
//                           return Padding(
//                             padding: const EdgeInsets.fromLTRB(15, 8, 15, 8),
//                             child: Container(
//                               padding: const EdgeInsets.fromLTRB(0, 8, 0, 5),
//                               // height: 90,
//                               decoration: BoxDecoration(
//                                 color: getCardColor(
//                                     index, radioStationList.length),
//
//                                 // boxShadow: [
//                                 //   BoxShadow(
//                                 //     color: const Color(0xff24273A),
//                                 //     spreadRadius: 0.2,
//                                 //     blurRadius: 5,
//                                 //     offset: Offset(1, 1),
//                                 //   ),
//                                 // ],
//                                 borderRadius: BorderRadius.circular(10),
//                               ),
//                               child: GestureDetector(
//                                 onLongPress: () {},
//                                 child: ListTile(
//                                   key: ValueKey(
//                                       radioStationList[index].radioUrl),
//                                   // leading: (index + 1 == currentRadioIndex)
//                                   //     ? Padding(
//                                   //         padding: const EdgeInsets.only(
//                                   //             top: 10.0, left: 5.0, bottom: 10.0),
//                                   //         child: SizedBox(
//                                   //           height: 27,
//                                   //           width: 30,
//                                   //           child: MusicVisualizer(
//                                   //             barCount: 6,
//                                   //             colors: [
//                                   //               TColor.focus,
//                                   //               TColor.secondaryEnd,
//                                   //               TColor.focusStart,
//                                   //               Colors.blue[900]!,
//                                   //             ],
//                                   //             duration: const [
//                                   //               900,
//                                   //               700,
//                                   //               600,
//                                   //               800,
//                                   //               500
//                                   //             ],
//                                   //           ),
//                                   //         ),
//                                   //       )
//                                   //     : Image.asset(
//                                   //         width: 36,
//                                   //         height: 36,
//                                   //         "assets/img/radio_icon.png",
//                                   //         color: TColor.focus,
//                                   //       ),
//                                   // Icon(
//                                   //         Icons.music_note_rounded,
//                                   //         color: TColor.focus,
//                                   //         size: 36,
//                                   //       ),
//                                   title: Text(
//                                     radioStationList[index].radioSimpleName,
//                                     textAlign: TextAlign.start,
//                                     maxLines: 1,
//                                     overflow: TextOverflow.ellipsis,
//                                     style: TextStyle(
//                                       color: TColor.secondaryText,
//                                       fontSize: 12,
//                                     ),
//                                   ),
//                                   subtitle: Text(
//                                     radioStationList[index].radioStation,
//                                     textAlign: TextAlign.start,
//                                     maxLines: 1,
//                                     overflow: TextOverflow.ellipsis,
//                                     style: TextStyle(
//                                       fontWeight: FontWeight.w500,
//                                       // color: Colors.white70,
//                                       color: (index + 1 == currentRadioIndex)
//                                           ? Color(0xFFFF0F7B)
//                                           : Colors.white70,
//
//                                       fontSize: 30,
//                                     ),
//                                   ),
//
//                                   trailing: IconButton(
//                                     splashRadius: 24,
//                                     iconSize: 20,
//                                     icon: (radioStationFetchError &&
//                                             radioStationErrorIndex == index)
//                                         ? Image.asset(
//                                             "assets/img/antenna-bars-off-streamline-tabler.png",
//                                             color: Color(0xFFFF0F7B),
//                                           )
//                                         : Image.asset(
//                                             "assets/img/antenna-bars-5-streamline.png",
//                                             color:
//                                                 (index + 1 == currentRadioIndex)
//                                                     ? TColor.green
//                                                     : TColor.lightGray,
//                                           ),
//                                     onPressed: null,
//                                   ),
//                                   onTap: () async {
//                                     await playRadioStation(context, index);
//                                   },
//                                 ),
//                               ),
//                             ),
//                           );
//                         },
//                         separatorBuilder: (BuildContext context, int index) {
//                           return Container();
//                         },
//                       ),
//                     );
//                   },
//                 ),
//               ],
//             ),
//           ),
//         );
//       },
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:vicyos_music/app/common/color_palette/color_extension.dart';
import 'package:vicyos_music/app/common/music_player/music.player.dart';
import 'package:vicyos_music/app/common/navigation_animation/song.files.screen.navigation.animation.dart'
    show slideRightLeftTransition;
import 'package:vicyos_music/app/common/radio/radio.functions.dart'
    show radioHasLogo, radioLogo, playRadioStation, turnOffRadioStation;
import 'package:vicyos_music/app/common/radio/radio.stream.notifiers.dart';
import 'package:vicyos_music/app/common/radio_stations/radio.stations.list.dart';
import 'package:vicyos_music/app/common/screen_orientation/screen.orientation.dart';
import 'package:vicyos_music/app/is_smartphone/view/screens/song.search.screen.dart';
import 'package:vicyos_music/app/is_smartphone/widgets/music_visualizer.dart';

class RadioStationsScreen extends StatelessWidget {
  const RadioStationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Set the preferred orientations to portrait mode when this screen is built
    setScreenOrientation();

    var media = MediaQuery.sizeOf(context);

    return StreamBuilder<void>(
      stream: rebuildSongsListScreenStreamController.stream,
      builder: (context, snapshot) {
        return SafeArea(
          child: Scaffold(
            // appBar: songsListAppBar(folderPath: folderPath, context: context),
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
                                    "Online",
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
                                      "Radio",
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
                                          hideMiniPlayerStreamNotifier(true);
                                          Navigator.pop(context);
                                        },
                                        icon: Image.asset(
                                          "assets/img/arrow_back_ios.png",
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
                                              rebuildRadioScreenStreamController
                                                  .stream,
                                          builder: (context, snapshot) {
                                            return Image.asset(
                                              "assets/img/power_btn_300p.png",
                                              color: radioStationBtn,
                                            );
                                          },
                                        ),
                                        onPressed: () async {
                                          isRadioOn
                                              ? await turnOffRadioStation()
                                              : playRadioStation(context, 1);
                                        },
                                      ),
                                    ),
                                  ),
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
                              Navigator.push(
                                  context,
                                  slideRightLeftTransition(
                                    const SearchScreen(),
                                  )).whenComplete(
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
                                  hintText: 'Search...',
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
                  stream: getCurrentSongFullPathStreamController.stream,
                  builder: (context, snapshot) {
                    return Expanded(
                      child: ListView.separated(
                        padding: const EdgeInsets.only(
                            bottom: 112, left: 5, right: 5),
                        itemCount: radioStationList.length,
                        itemBuilder: (context, index) {
                          return SizedBox(
                            height: 67,
                            child: GestureDetector(
                              onLongPress: () {},
                              child: ListTile(
                                key: ValueKey(radioStationList[index].radioUrl),
                                leading: (index + 1 == currentRadioIndex)
                                    ? Padding(
                                        padding: const EdgeInsets.only(
                                            top: 10.0, left: 5.0, bottom: 10.0),
                                        child: SizedBox(
                                          height: 30,
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
                                      )
                                    : Image.asset(
                                        width: radioHasLogo(index) ? 45 : 32,
                                        height: radioHasLogo(index) ? 45 : 32,
                                        radioHasLogo(index)
                                            ? radioStationList[index]
                                                .ratioStationLogo!
                                            : radioLogo(),
                                        color: radioHasLogo(index)
                                            ? null
                                            : TColor.focus,
                                      ),
                                // Icon(
                                //         Icons.music_note_rounded,
                                //         color: TColor.focus,
                                //         size: 36,
                                //       ),

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
                                  radioStationList[index].radioInfo,
                                  textAlign: TextAlign.start,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    color: TColor.secondaryText,
                                    fontSize: 15,
                                  ),
                                ),
                                trailing: (index + 1 == currentRadioIndex)
                                    ? Image.asset(
                                        height: 30,
                                        width: 30,
                                        "assets/img/radio/antenna-bars-5-streamline.png",
                                        color: TColor.green)
                                    : Image.asset(
                                        height: 30,
                                        width: 30,
                                        "assets/img/radio/antenna-bars-5-streamline.png",
                                        color: TColor.lightGray,
                                      ),

                                // IconButton(
                                //   splashRadius: 5,
                                //   // iconSize: 5,
                                //   icon: Image.asset(
                                //     "assets/img/arrow_forward_ios.png",
                                //     color: (index + 1 == currentRadioIndex)
                                //         ? TColor.green
                                //         : TColor.lightGray,
                                //   ),
                                //   onPressed: () async {},
                                // ),
                                //
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
            ),
          ),
        );
      },
    );
  }
}
