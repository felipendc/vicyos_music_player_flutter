// ignore_for_file: avoid_print
// Run flutter clean in case of running this code in another computer.
// flutter run -d windows, if you are having problems to run this file.

import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'music_player.dart';

void main() {
  runApp(
    const MyApp(),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: AudioPlayerScreen(),
    );
  }
}

class AudioPlayerScreen extends StatefulWidget {
  const AudioPlayerScreen({super.key});

  @override
  AudioPlayerScreenState createState() => AudioPlayerScreenState();
}

class AudioPlayerScreenState extends State<AudioPlayerScreen> {
  @override
  void initState() {
    super.initState();
    audioPlayer = AudioPlayer();
  }

  @override
  void dispose() {
    audioPlayer.dispose();
    super.dispose();
  }

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
            ElevatedButton(
              onPressed: () {
                pickAndPlayAudio();
              },
              child: const Text('IMPORT AUDIOS'),
            ),
            ElevatedButton(
              child: const Text('Play or Pause'),
              // child: isPlaying ? const Text('Pause') : const Text('Play'),
              onPressed: () {
                playOrPause();
              },
            ),
            ElevatedButton(
              onPressed: () {
                nextSong();
              },
              child: const Text('Next Audio'),
            ),
            ElevatedButton(
              onPressed: () {
                previousSong();
              },
              child: const Text('Previous Audio'),
            ),
            ElevatedButton(
              onPressed: () {
                repeatMode();
              },
              child: const Text('Repeat'),
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
          ],
        ),
      ),
    );
  }
}
