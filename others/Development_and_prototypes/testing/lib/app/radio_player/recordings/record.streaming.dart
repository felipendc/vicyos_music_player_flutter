import 'dart:async';
import 'dart:collection';
import 'dart:io';

import 'package:ffmpeg_kit_flutter_new_full/ffmpeg_kit.dart';
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

  HttpClient? _client;
  IOSink? _sink;
  StreamSubscription<List<int>>? _subscription;

  bool _isRecording = false;
  bool _allowPlaybackSpeedBottomSheetToOpen = true;

  late File _tempFile;
  late Duration _finalDuration;

  // ================== GETTERS ==================

  bool get isRecording => _isRecording;

  bool get allowPlaybackSpeedBottomSheetToOpen =>
      _allowPlaybackSpeedBottomSheetToOpen;

  // ================== PROCESSOR QUEUE ==================

  Future<void> _processQueue() async {
    if (_isProcessingQueue) return;

    _isProcessingQueue = true;

    while (_queue.isNotEmpty) {
      final task = _queue.removeFirst();
      try {
        await task(); // Wait for the task to finish
      } catch (_) {}
    }

    _isProcessingQueue = false;
  }

  // ================== PUBLIC API ==================

  Future<void> startRecording(String streamUrl) async {
    _queue.add(() async {
      await _startRecordingInternal(streamUrl);
    });

    await _processQueue();
  }

  Future<void> stopRecording() async {
    _queue.add(() async {
      await _stopRecordingInternal();
    });

    await _processQueue();
  }

  // ================== START REAL ==================

  Future<void> _startRecordingInternal(String streamUrl) async {
    await requestAudioPermission();

    showStreamRecordingTimerNotifier(true);
    _allowPlaybackSpeedBottomSheetToOpen = false;

    final cacheDir = await getTemporaryDirectory();
    final formatter = DateFormat('yyyy-MM-dd_HH-mm-ss');
    final id = DateTime.now().microsecondsSinceEpoch;

    _tempFile = File(
      '${cacheDir.path}/radio_${formatter.format(DateTime.now())}_${id}_temp.m4a',
    );

    _client = HttpClient()..idleTimeout = Duration.zero;

    final request = await _client!.getUrl(Uri.parse(streamUrl));
    final response = await request.close();

    _sink = _tempFile.openWrite();
    _isRecording = true;

    _stopwatch
      ..reset()
      ..start();

    _startUiTimer();

    _subscription = response.listen(
      (data) {
        if (!_isRecording) return;
        _sink?.add(data);
      },
      onError: (_) => stopRecording(),
      onDone: stopRecording,
      cancelOnError: true,
    );
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

    final h = d.inHours.toString().padLeft(2, '0');
    final m = d.inMinutes.remainder(60).toString().padLeft(2, '0');
    final s = d.inSeconds.remainder(60).toString().padLeft(2, '0');

    return d.inHours > 0 ? '$h:$m:$s' : '$m:$s';
  }

  // ================== REAL STOP ==================

  Future<void> _stopRecordingInternal() async {
    if (!_isRecording) return;

    _isRecording = false;
    showStreamRecordingTimerNotifier(false);

    _stopwatch.stop();
    _finalDuration = _stopwatch.elapsed;
    _stopwatch.reset();

    _stopUiTimer();
    _allowPlaybackSpeedBottomSheetToOpen = true;

    await _subscription?.cancel();
    _subscription = null;

    await _sink?.flush();
    await _sink?.close();
    _sink = null;

    _client?.close(force: true);
    _client = null;

    if (_finalDuration.inSeconds > 0) {
      await _trimWithFfmpeg(); // lock queue
    }
  }

  // ================== FFMPEG ==================

  Future<void> _trimWithFfmpeg() async {
    final musicDir =
        Directory('/storage/emulated/0/Music/Vicyos Radio Recordings');

    if (!await musicDir.exists()) {
      await musicDir.create(recursive: true);
    }

    final finalPath = '${musicDir.path}/'
        '${_tempFile.uri.pathSegments.last.replaceAll('_temp.m4a', '.mp3')}';

    final cmd = '-y '
        '-i "${_tempFile.path}" '
        '-t ${_finalDuration.inSeconds} '
        '-c:a libmp3lame '
        '-b:a 96k '
        '-ac 2 '
        '-ar 44100 '
        '"$finalPath"';

    final session = await FFmpegKit.execute(cmd);
    final rc = await session.getReturnCode();

    if (rc?.isValueSuccess() == true) {
      await _tempFile.delete();
    }
  }
}
