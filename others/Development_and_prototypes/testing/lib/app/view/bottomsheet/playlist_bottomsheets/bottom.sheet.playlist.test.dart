// import 'package:flutter/material.dart';
// import 'package:vicyos_music/app/color_palette/color_extension.dart';
// import 'package:vicyos_music/app/components/show.top.message.dart';
// import 'package:vicyos_music/app/files_and_folders_handler/folders.and.files.related.dart';
// import 'package:vicyos_music/app/models/audio.info.dart';
// import 'package:vicyos_music/app/models/playlists.dart';
// import 'package:vicyos_music/app/music_player/music.player.functions.and.more.dart';
// import 'package:vicyos_music/app/music_player/music.player.stream.controllers.dart';
// import 'package:vicyos_music/app/navigation_animation/main.player.navigation.animation.dart';
// import 'package:vicyos_music/app/view/screens/main.player.view.screen.dart';
// import 'package:vicyos_music/l10n/app_localizations.dart';
//
// class PlaylistScreenBottomSheet extends StatelessWidget {
//   final List<Playlists> playlistModel;
//
//   const PlaylistScreenBottomSheet({
//     super.key,
//     required this.playlistModel,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return ClipRRect(
//       borderRadius: const BorderRadius.vertical(
//         top: Radius.circular(25),
//         bottom: Radius.circular(0),
//       ),
//       child: Container(
//         color: TColor.bg,
//         height: 300, // Adjust the height as needed
//         padding: const EdgeInsets.fromLTRB(0, 5, 0, 0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.center,
//           children: [
//             Padding(
//               padding: const EdgeInsets.only(top: 10.0),
//               child: Container(
//                 decoration: BoxDecoration(
//                   // color: Colors.grey,
//                   color: Color(0xff181B2C),
//                 ),
//                 height: 73, // Loading enabled
//                 child: Column(
//                   // mainAxisAlignment: MainAxisAlignment.center,
//                   crossAxisAlignment: CrossAxisAlignment.center,
//                   children: [
//                     Padding(
//                       padding: const EdgeInsets.fromLTRB(20, 0, 8, 10),
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               Text(
//                                 AppLocalizations.of(context)!.folder_name,
//                                 style: TextStyle(
//                                   color: TColor.primaryText28
//                                       .withValues(alpha: 0.84),
//                                   fontSize: 15,
//                                   fontWeight: FontWeight.w400,
//                                   shadows: [
//                                     Shadow(
//                                       color:
//                                           Colors.black.withValues(alpha: 0.2),
//                                       offset: Offset(1, 1),
//                                       blurRadius: 3,
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                               SizedBox(
//                                 height: 30,
//                                 width: 270,
//                                 // color: Colors.grey,
//                                 child: Text(
//                                   folderName(folderPath),
//                                   maxLines: 1,
//                                   overflow: TextOverflow.ellipsis,
//                                   style: TextStyle(
//                                     color: TColor.primaryText
//                                         .withValues(alpha: 0.84),
//                                     fontSize: 20,
//                                     fontWeight: FontWeight.w600,
//                                     shadows: [
//                                       BoxShadow(
//                                         color:
//                                             Colors.black.withValues(alpha: 0.2),
//                                         spreadRadius: 5,
//                                         blurRadius: 8,
//                                         offset: Offset(2, 4),
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                               ),
//                             ],
//                           ),
//                           Padding(
//                             padding: const EdgeInsets.all(8.0),
//                             child: Row(
//                               children: [
//                                 Material(
//                                   color: Colors.transparent,
//                                   child: SizedBox(
//                                     width: 35,
//                                     height: 35,
//                                     child: IconButton(
//                                       splashRadius: 20,
//                                       iconSize: 10,
//                                       onPressed: () async {
//                                         Navigator.pop(context);
//                                       },
//                                       icon: Image.asset(
//                                         "assets/img/menu/close.png",
//                                         color: TColor.lightGray,
//                                       ),
//                                     ),
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//
//             // Content
//             Expanded(
//               child: Container(
//                 color: TColor.bg,
//                 child: ListView(
//                   children: [
//                     Material(
//                       color: Colors.transparent,
//                       child: ListTile(
//                         leading: Padding(
//                           padding: const EdgeInsets.only(left: 17),
//                           child: Icon(
//                             Icons.create_new_folder_outlined,
//                             color: TColor.focus,
//                             size: 38,
//                           ),
//                         ),
//                         title: Text(
//                           AppLocalizations.of(context)!
//                               .add_folder_to_the_current_playlist,
//                           style: TextStyle(
//                             color: TColor.primaryText80,
//                             fontSize: 18,
//                           ),
//                         ),
//                         contentPadding: const EdgeInsets.fromLTRB(0, 4, 0, 4),
//                         onTap: () async {
//                           Navigator.pop(context);
//                           addFolderToPlaylist(
//                             currentFolder: folderSongList,
//                             context: context,
//                             audioRoute: NavigationButtons.music,
//                             audioRouteEmptyPlaylist: NavigationButtons.music,
//                           );
//
//                           showAddedToPlaylist(
//                               context,
//                               "Folder",
//                               folderName(folderPath),
//                               AppLocalizations.of(context)!
//                                   .added_to_the_current_playlist);
//                         },
//                       ),
//                     ),
//                     const Divider(
//                       color: Colors.white12,
//                       indent: 70,
//                       endIndent: 25,
//                       height: 1,
//                     ),
//                     Material(
//                       color: Colors.transparent,
//                       child: ListTile(
//                         leading: Padding(
//                           padding: const EdgeInsets.only(left: 17),
//                           child: Icon(
//                             Icons.queue_music_rounded,
//                             color: TColor.focus,
//                             size: 40,
//                           ),
//                         ),
//                         title: Text(
//                           AppLocalizations.of(context)!
//                               .play_all_the_songs_from_this_folder,
//                           style: TextStyle(
//                             color: TColor.primaryText80,
//                             fontSize: 18,
//                           ),
//                         ),
//                         contentPadding: const EdgeInsets.fromLTRB(0, 4, 0, 4),
//                         onTap: () async {
//                           if (deviceTypeIsSmartphone()) {
//                             mainPlayerIsOpen = true;
//                           }
//                           Navigator.pop(context);
//                           setFolderAsPlaylist(
//                             currentFolder: folderSongList,
//                             currentIndex: 0,
//                             context: context,
//                             audioRoute: NavigationButtons.music,
//                             audioRouteEmptyPlaylist: NavigationButtons.music,
//                           );
//
//                           if (deviceTypeIsTablet()) {
//                             showAddedToPlaylist(
//                                 context,
//                                 "Folder",
//                                 folderName(folderPath),
//                                 AppLocalizations.of(context)!
//                                     .playing_all_the_songs_from_this_folder);
//                           }
//
//                           if (deviceTypeIsSmartphone()) {
//                             Navigator.push(
//                               context,
//                               mainPlayerSlideUpDownTransition(
//                                 MainPlayerView(),
//                               ),
//                             ).whenComplete(
//                               () {
//                                 if (mainPlayerIsOpen) {
//                                   mainPlayerIsOpen = false;
//                                 }
//                                 hideMiniPlayerNotifier(false);
//                               },
//                             );
//                           }
//                         },
//                       ),
//                     ),
//                     const Divider(
//                       color: Colors.white12,
//                       indent: 70,
//                       endIndent: 25,
//                       height: 1,
//                     ),
//                     const SizedBox(
//                       height: 30,
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
