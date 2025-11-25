import 'dart:async';

import 'package:flutter/services.dart';

class AudioOutputService {
  static const EventChannel _channel = EventChannel('audioOutputChannel');

  Stream<dynamic>? _stream;

  Stream<dynamic> get stream {
    _stream ??= _channel.receiveBroadcastStream().map((event) => event);
    return _stream!;
  }

  void listen(void Function(dynamic) onData, {Function? onError}) {
    stream.listen(onData, onError: onError);
  }
}
