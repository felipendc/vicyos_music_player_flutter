import 'dart:async';

// Streams
StreamController<bool> hideMiniRadioPlayerStreamController =
    StreamController<bool>.broadcast();

StreamController<void> radioShuffleModeStreamController =
    StreamController<void>.broadcast();

StreamController<void> switchingToRadioStreamController =
    StreamController<void>.broadcast();

StreamController<void> updateRadioScreensStreamController =
    StreamController<void>.broadcast();

// Stream functions
void hideMiniRadioPlayerNotifier(bool value) {
  hideMiniRadioPlayerStreamController.sink.add(value);
}

void radioShuffleModeNotifier() {
  radioShuffleModeStreamController.sink.add(null);
}

void switchingToRadioNotifier() {
  switchingToRadioStreamController.sink.add(null);
}

Future<void> updateRadioScreensNotifier() async {
  updateRadioScreensStreamController.add(null);
}
