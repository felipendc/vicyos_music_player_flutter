package com.example.vicyos_music

import android.media.AudioManager
import android.media.MediaMetadataRetriever
import com.ryanheise.audioservice.AudioServiceActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodChannel

class MyAudioActivity : AudioServiceActivity() {

    private val AUDIO_CHANNEL = "audioOutputChannel"
    private val MEDIASTORE_CHANNEL = "mediastore_music_changes"
    private val CHANNEL = "audio_metadata"

    private var audioRouteCallback: AudioRouteCallback? = null
    private var outputReceiver: AudioOutputReceiver? = null
    private var mediaStoreObserver: MediaStoreMusicObserver? = null

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        // --------------------------------
        // 🎵 Audio metadata (duration)
        // --------------------------------
        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            CHANNEL
        ).setMethodCallHandler { call, result ->

            if (call.method == "getDuration") {
                val path = call.argument<String>("path")

                if (path.isNullOrEmpty()) {
                    result.success(0L)
                    return@setMethodCallHandler
                }

                try {
                    val retriever = MediaMetadataRetriever()
                    retriever.setDataSource(path)

                    val durationMs =
                        retriever.extractMetadata(
                            MediaMetadataRetriever.METADATA_KEY_DURATION
                        )?.toLong() ?: 0L

                    retriever.release()
                    result.success(durationMs)

                } catch (e: Exception) {
                    // Nunca quebra o Dart
                    result.success(0L)
                }
            } else {
                result.notImplemented()
            }
        }

        // --------------------------------
        // 🔊 Audio output listener
        // --------------------------------
        EventChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            AUDIO_CHANNEL
        ).setStreamHandler(object : EventChannel.StreamHandler {

            override fun onListen(args: Any?, events: EventChannel.EventSink?) {
                val audioManager =
                    getSystemService(AUDIO_SERVICE) as AudioManager

                // AudioDeviceCallback (API 23+)
                audioRouteCallback =
                    AudioRouteCallback(audioManager, events)
                audioRouteCallback?.start()

                // Legacy receiver (headset / BT / noisy)
                outputReceiver =
                    AudioOutputReceiver(this@MyAudioActivity, events)
                outputReceiver?.startListening()
            }

            override fun onCancel(args: Any?) {
                audioRouteCallback?.stop()
                audioRouteCallback = null

                outputReceiver?.stopListening()
                outputReceiver = null
            }
        })

        // --------------------------------
        // 🎵 MediaStore listener
        // --------------------------------
        EventChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            MEDIASTORE_CHANNEL
        ).setStreamHandler(object : EventChannel.StreamHandler {

            override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
                mediaStoreObserver =
                    MediaStoreMusicObserver(contentResolver, events)
                mediaStoreObserver?.start()
            }

            override fun onCancel(arguments: Any?) {
                mediaStoreObserver?.stop()
                mediaStoreObserver = null
            }
        })
    }
}
