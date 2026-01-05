package com.example.vicyos_music

import com.ryanheise.audioservice.AudioServiceActivity
import android.media.AudioManager
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.EventChannel

class MyAudioActivity : AudioServiceActivity() {

    private val AUDIO_CHANNEL = "audioOutputChannel"
    private val MEDIASTORE_CHANNEL = "mediastore_music_changes"

    private var audioRouteCallback: AudioRouteCallback? = null
    private var outputReceiver: AudioOutputReceiver? = null
    private var mediaStoreObserver: MediaStoreMusicObserver? = null

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        // -------------------------------
        // 🔊 Audio output listener
        // -------------------------------
        EventChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            AUDIO_CHANNEL
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

        // -------------------------------
        // 🎵 MediaStore listener
        // -------------------------------
        EventChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            MEDIASTORE_CHANNEL
        ).setStreamHandler(object : EventChannel.StreamHandler {
            override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
                // Create the observer of songs and start it
                mediaStoreObserver = MediaStoreMusicObserver(
                    contentResolver,
                    events
                )
                mediaStoreObserver?.start()
            }

            override fun onCancel(arguments: Any?) {
                // Stop the observer when it is no longer needed
                mediaStoreObserver?.stop()
                mediaStoreObserver = null
            }
        })
    }
}
