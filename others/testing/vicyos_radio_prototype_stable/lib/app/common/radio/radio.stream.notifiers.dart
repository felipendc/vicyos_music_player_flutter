import 'dart:async';

// Streams
StreamController<bool> hideMiniRadioPlayerStreamController =
    StreamController<bool>.broadcast();

StreamController<void> rebuildRadioScreenStreamController =
    StreamController<void>.broadcast();

StreamController<void> radioShuffleModeStreamController =
    StreamController<void>.broadcast();

StreamController<void> switchingToRadioStreamController =
    StreamController<void>.broadcast();

// Stream functions
void hideMiniRadioPlayerStreamNotifier(bool value) {
  hideMiniRadioPlayerStreamController.sink.add(value);
}

void radioScreenStreamNotifier() {
  rebuildRadioScreenStreamController.sink.add(null);
}

void radioShuffleModeStreamNotifier() {
  radioShuffleModeStreamController.sink.add(null);
}

void switchingToRadioStreamNotifier() {
  switchingToRadioStreamController.sink.add(null);
}
