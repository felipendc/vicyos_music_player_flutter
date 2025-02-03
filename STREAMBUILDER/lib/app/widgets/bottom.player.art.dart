// import 'package:flutter/material.dart';
// import 'package:sleek_circular_slider/sleek_circular_slider.dart';
// import 'package:vicyos_music/app/common/color_extension.dart';
// import 'package:vicyos_music/app/functions/music_player.dart';

// class BottomPlayerArt extends StatelessWidget {
//   const BottomPlayerArt({super.key});

//   @override
//   Widget build(BuildContext context) {
//     var media = MediaQuery.sizeOf(context);
//     return Positioned(
//       bottom: 14,
//       left: 13,
//       child: Stack(
//         children: [
//           ClipRRect(
//             borderRadius: BorderRadius.circular(media.width * 0.7),
//             child: Image.asset(
//               "assets/img/lofi-woman-album-cover-art_10.png",
//               width: media.width * 0.15,
//               height: media.width * 0.15,
//               fit: BoxFit.cover,
//             ),
//           ),
//           SizedBox(
//             width: media.width * 0.15,
//             height: media.width * 0.15,
//             child: SleekCircularSlider(
//               appearance: CircularSliderAppearance(
//                   customWidths: CustomSliderWidths(
//                       trackWidth: 3.5, progressBarWidth: 3.5, shadowWidth: 10),
//                   customColors: CustomSliderColors(
//                       dotFillColor: const Color(0xffFFB1B2),
//                       trackColor: const Color(0xffffffff).withValues(alpha: 0.3),
//                       progressBarColors: [TColor.focusStart, TColor.focusStart],
//                       shadowColor: const Color(0xffFFB1B2),
//                       shadowMaxOpacity: 0.05),
//                   infoProperties: InfoProperties(
//                     topLabelStyle: const TextStyle(
//                         color: Colors.transparent,
//                         fontSize: 0,
//                         fontWeight: FontWeight.w400),
//                     topLabelText: 'Elapsed',
//                     bottomLabelStyle: const TextStyle(
//                         color: Colors.transparent,
//                         fontSize: 0,
//                         fontWeight: FontWeight.w400),
//                     bottomLabelText: 'time',
//                     mainLabelStyle: const TextStyle(
//                         color: Colors.transparent,
//                         fontSize: 00,
//                         fontWeight: FontWeight.w600),
//                     // modifier: (double value) {
//                     //   final time = print(Duration(
//                     //       seconds: value.toInt()));
//                     //   return '$time';
//                     // },
//                   ),
//                   startAngle: 270,
//                   angleRange: 360,
//                   size: 350.0),
//               min: 0,
//               max: sleekCircularSliderDuration,

//               // The initValue has been renamed to value.
//               value: sleekCircularSliderPosition,
//               onChange: (value) {
//                 if (value < 0) {
//                   return;
//                 } else {
//                   audioPlayer.seek(Duration(seconds: value.toInt()));
//                 }

//                 // callback providing a value while its being changed (with a pan gesture)
//               },
//               // onChangeStart: (double startValue) {
//               //   // callback providing a starting value (when a pan gesture starts)
//               // },
//               // onChangeEnd: (double endValue) {
//               //   // ucallback providing an ending value (when a pan gesture ends)
//               // },
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
