import 'package:flutter/services.dart';

class AudioMetadata {
  static const MethodChannel _channel = MethodChannel('audio_metadata');

  static Future<String> getFormattedDuration(String path) async {
    final durationMs =
        await _channel.invokeMethod<int>('getDuration', {'path': path}) ?? 0;

    final duration = Duration(milliseconds: durationMs);

    final hours = duration.inHours.toString().padLeft(2, '0');
    final minutes = duration.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = duration.inSeconds.remainder(60).toString().padLeft(2, '0');

    return duration.inHours >= 1
        ? '$hours:$minutes:$seconds'
        : '$minutes:$seconds';
  }
}
