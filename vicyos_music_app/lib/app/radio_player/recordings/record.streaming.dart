import 'dart:async';
import 'dart:collection';
import 'dart:io';

import 'package:ffmpeg_kit_flutter_new/ffmpeg_kit.dart';
import 'package:ffmpeg_kit_flutter_new/ffmpeg_session.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:vicyos_music/app/permission_handler/permission.handler.dart';
import 'package:vicyos_music/app/radio_player/functions_and_streams/radio.stream.controllers.dart';

class StreamRecorder {
  // ================== QUEUE ==================

  final Queue<Future<void> Function()> _queue = Queue();
  bool _isProcessingQueue = false;

  // ================== STATE ==================

  final Stopwatch _stopwatch = Stopwatch();
  Timer? _uiTimer;

  FFmpegSession? _recordSession;

  bool _isRecording = false;
  bool _allowPlaybackSpeedBottomSheetToOpen = true;

  late File _tempFile;
  late File _finalFile;
  late Duration _finalDuration;

  // ================== GETTERS ==================

  bool get isRecording => _isRecording;

  bool get allowPlaybackSpeedBottomSheetToOpen =>
      _allowPlaybackSpeedBottomSheetToOpen;

  // ================== QUEUE ==================

  Future<void> _processQueue() async {
    if (_isProcessingQueue) return;
    _isProcessingQueue = true;

    while (_queue.isNotEmpty) {
      final task = _queue.removeFirst();
      try {
        await task();
      } catch (e) {
        debugPrint('QUEUE ERROR: $e');
      }
    }

    _isProcessingQueue = false;
  }

  // ================== API ==================

  Future<void> startRecording(String streamUrl) async {
    _queue.add(() async => _startRecordingInternal(streamUrl));
    await _processQueue();
  }

  Future<void> stopRecording() async {
    _queue.add(() async => _stopRecordingInternal());
    await _processQueue();
  }

  // ================== START ==================

  Future<void> _startRecordingInternal(String streamUrl) async {
    if (_isRecording) return;

    await requestAudioPermission();

    showStreamRecordingTimerNotifier(true);
    _allowPlaybackSpeedBottomSheetToOpen = false;

    final cacheDir = await getTemporaryDirectory();
    final formatter = DateFormat('yyyy-MM-dd_HH-mm-ss');

    final baseName = 'radio_${formatter.format(DateTime.now())}';

    _tempFile = File('${cacheDir.path}/$baseName.raw.m4a');
    _finalFile = File('${cacheDir.path}/$baseName.m4a');

    final cmd = '-y '
        '-flags low_delay '
        '-reconnect 1 '
        '-reconnect_streamed 1 '
        '-reconnect_delay_max 5 '
        '-i "$streamUrl" '
        '-vn '
        '-c:a aac '
        '-b:a 96k '
        '-ar 44100 '
        '-ac 2 '
        '-f mp4 '
        '"${_tempFile.path}"';

    _isRecording = true;

    _stopwatch
      ..reset()
      ..start();

    _startUiTimer();

    _recordSession = await FFmpegKit.executeAsync(
      cmd,
      (session) async {
        final rc = await session.getReturnCode();
        debugPrint('RECORD RETURN CODE: $rc');
      },
      (log) => debugPrint('FFMPEG: ${log.getMessage()}'),
      null,
    );
  }

  // ================== STOP ==================

  Future<void> _stopRecordingInternal() async {
    if (!_isRecording) return;

    _isRecording = false;
    showStreamRecordingTimerNotifier(false);

    _stopwatch.stop();
    _finalDuration = _stopwatch.elapsed;
    _stopwatch.reset();

    _stopUiTimer();
    _allowPlaybackSpeedBottomSheetToOpen = true;

    if (_recordSession != null) {
      await FFmpegKit.cancel(_recordSession!.getSessionId());
      _recordSession = null;
    }

    // Wait FFmpeg finish the container
    await Future.delayed(const Duration(seconds: 1));

    if (!await _tempFile.exists() || await _tempFile.length() < 1024) {
      debugPrint('Invalid TEMP file ');
      return;
    }

    await _cutExactly();
    await _copyToFinalFolder();
  }

  // ================== CUT EXACT ==================

  Future<void> _cutExactly() async {
    final seconds = (_finalDuration.inMilliseconds / 1000).toStringAsFixed(3);

    final cutCmd = '-y '
        '-i "${_tempFile.path}" '
        '-t $seconds '
        '-c:a aac '
        '-b:a 96k '
        '-ar 44100 '
        '-ac 2 '
        '-f mp4 '
        '"${_finalFile.path}"';

    await FFmpegKit.execute(cutCmd);

    await _tempFile.delete();
  }

  // ================== FINAL COPY ==================

  Future<void> _copyToFinalFolder() async {
    final musicDir =
        Directory('/storage/emulated/0/Music/Vicyos Radio Recordings');

    if (!await musicDir.exists()) {
      await musicDir.create(recursive: true);
    }

    final finalPath = '${musicDir.path}/${_finalFile.uri.pathSegments.last}';

    await _finalFile.copy(finalPath);
    await _finalFile.delete();

    debugPrint('File saved at: $finalPath');
  }

  // ================== UI TIMER ==================

  void _startUiTimer() {
    _uiTimer = Timer.periodic(
      const Duration(seconds: 1),
      (_) => updateStreamRecorderProgressNotifier(),
    );
  }

  void _stopUiTimer() {
    _uiTimer?.cancel();
    _uiTimer = null;
  }

  // ================== DISPLAY ==================

  String displayTimerProgress() {
    final d = _stopwatch.elapsed;
    final m = d.inMinutes.remainder(60).toString().padLeft(2, '0');
    final s = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$m:$s';
  }
}
