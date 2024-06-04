import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:vicyos_music_player/app/reusable_functions/music_player.dart';

class AudioPlayerScreen extends StatelessWidget {
  const AudioPlayerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Audio Player with File Picker'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // ElevatedButton(
            //   onPressed: () {
            //   },
            //   // Text('Current Time: ${)} / ${formatDuration(totalDuration)}')
            //   child: const Text('Current Time: '),
            // ),
            ElevatedButton(
              onPressed: () {},
              // Text('Current Time: ${)} / ${formatDuration(_totalDuration)}')
              // child: Obx(() => Text('${controller.songIsPlaying.value}')),

              child: Obx(() =>
                  Text('Current Index: ${controller.currentIndex?.value}')),
              // Text('Song: : ${controller.currentSongName.value}')),
            ),
            ElevatedButton(
              onPressed: () {
                cleanPlaylist();
              },
              // Text('Current Time: ${)} / ${formatDuration(_totalDuration)}')
              child: const Text('Clean playlist'),
            ),
            ElevatedButton(
              onPressed: () async {
                await pickFolder();
              },
              child: const Text('Open folder'),
            ),
            ElevatedButton(
              onPressed: () async {
                await pickAndPlayAudio();
              },
              child: const Text('IMPORT AUDIOS'),
            ),
            Obx(
              () => ElevatedButton(
                child: controller.songIsPlaying.value
                    ? const Text('Pause')
                    : const Text('Play'),
                // child: isPlaying ? const Text('Pause') : const Text('Play'),
                onPressed: () {
                  playOrPause();
                },
              ),
            ),
            ElevatedButton(
                onPressed: () {
                  nextSong();
                },
                child: const Text('Next')),

            ElevatedButton(
              onPressed: () {
                previousSong();
              },
              child: const Text('Previous'),
            ),

            Obx(
              () => ElevatedButton(
                onPressed: () {
                  repeatMode();
                },
                child: Text(controller.currentLoopModeLabel.value),
              ),
            ),

            ElevatedButton(
              onPressed: () {
                forward();
              },
              child: const Text('Forward'),
            ),
            ElevatedButton(
              onPressed: () {
                rewind();
              },
              child: const Text('Rewind'),
            ),
            ElevatedButton(
              onPressed: () {
                songSpeedRate1();
              },
              child: const Text('Speed Rate 1.0'),
            ),
            ElevatedButton(
              onPressed: () {
                songSpeedRate2();
              },
              child: const Text('Speed Rate 2.0'),
            ),
          ],
        ),
      ),
    );
  }
}
