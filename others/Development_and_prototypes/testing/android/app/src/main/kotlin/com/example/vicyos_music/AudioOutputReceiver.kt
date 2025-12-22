
package com.example.vicyos_music

import android.bluetooth.BluetoothAdapter
import android.bluetooth.BluetoothDevice
import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.content.IntentFilter
import android.media.AudioManager
import io.flutter.plugin.common.EventChannel

class AudioOutputReceiver(
    private val context: Context,
    private val events: EventChannel.EventSink?
) : BroadcastReceiver() {

    private val filter = IntentFilter().apply {
        addAction(AudioManager.ACTION_AUDIO_BECOMING_NOISY)
        addAction(Intent.ACTION_HEADSET_PLUG)
        addAction(BluetoothAdapter.ACTION_CONNECTION_STATE_CHANGED)
        addAction(BluetoothDevice.ACTION_ACL_CONNECTED)
        addAction(BluetoothDevice.ACTION_ACL_DISCONNECTED)
    }

    fun startListening() {
        try {
            context.registerReceiver(this, filter)
        } catch (e: Exception) {
            // ignore if already registered
        }
    }

    fun stopListening() {
        try {
            context.unregisterReceiver(this)
        } catch (e: Exception) {
            // ignore if not registered
        }
    }

    override fun onReceive(context: Context?, intent: Intent?) {
        val audioManager = context?.getSystemService(Context.AUDIO_SERVICE) as? AudioManager
        if (audioManager == null) {
            events?.success(mapOf("output" to "unknown"))
            return
        }

        // Primary guess based on AudioManager
        val output = when {
            audioManager.isBluetoothA2dpOn -> "bluetooth"
            audioManager.isSpeakerphoneOn -> "speaker"
            audioManager.isWiredHeadsetOn -> "wired_headset"
            else -> "unknown"
        }

        // Send simple event plus optional action info
        val action = intent?.action
        val payload = mapOf(
            "output" to output,
            "action" to (action ?: "unknown")
        )
        events?.success(payload)
    }
}
