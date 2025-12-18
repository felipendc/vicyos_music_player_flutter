package com.example.vicyos_music

import com.ryanheise.audioservice.AudioServiceActivity
import android.media.AudioManager
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.EventChannel

class MyAudioActivity : AudioServiceActivity() {

    private val CHANNEL = "audioOutputChannel"
    private var audioRouteCallback: AudioRouteCallback? = null
    private var outputReceiver: AudioOutputReceiver? = null

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        EventChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            CHANNEL
        ).setStreamHandler(object : EventChannel.StreamHandler {
            override fun onListen(args: Any?, events: EventChannel.EventSink?) {
                val audioManager = getSystemService(AUDIO_SERVICE) as AudioManager

                // AudioDeviceCallback (API 23+)
                audioRouteCallback = AudioRouteCallback(audioManager, events)
                audioRouteCallback?.start()

                // Legacy receiver for noisy/headset plug/Bluetooth intents
                outputReceiver = AudioOutputReceiver(this@MyAudioActivity, events)
                outputReceiver?.startListening()
            }

            override fun onCancel(args: Any?) {
                audioRouteCallback?.stop()
                audioRouteCallback = null
                outputReceiver?.stopListening()
                outputReceiver = null
            }
        })
    }
}
