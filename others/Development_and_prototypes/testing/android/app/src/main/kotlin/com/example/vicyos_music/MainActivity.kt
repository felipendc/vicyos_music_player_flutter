package com.example.vicyos_music

import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.EventChannel
import android.media.AudioManager

class MainActivity : FlutterActivity() {

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

                audioRouteCallback = AudioRouteCallback(audioManager, events)
                audioRouteCallback?.start()

                outputReceiver = AudioOutputReceiver(this@MainActivity, events)
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
