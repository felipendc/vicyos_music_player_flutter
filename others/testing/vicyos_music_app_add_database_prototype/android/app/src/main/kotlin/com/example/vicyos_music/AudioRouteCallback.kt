package com.example.vicyos_music

import android.media.AudioDeviceCallback
import android.media.AudioDeviceInfo
import android.media.AudioManager
import io.flutter.plugin.common.EventChannel

class AudioRouteCallback(
    private val audioManager: AudioManager,
    private val events: EventChannel.EventSink?
) : AudioDeviceCallback() {

    override fun onAudioDevicesAdded(addedDevices: Array<out AudioDeviceInfo>) {
        send("added", addedDevices)
    }

    override fun onAudioDevicesRemoved(removedDevices: Array<out AudioDeviceInfo>) {
        send("removed", removedDevices)
    }

    private fun send(type: String, devices: Array<out AudioDeviceInfo>?) {
        val list = devices?.map { d ->
            mapOf(
                "type" to type,
                "id" to d.id,
                "name" to d.productName.toString(),
                "kind" to d.type
            )
        }
        events?.success(list)
    }

    fun start() {
        audioManager.registerAudioDeviceCallback(this, null)
    }

    fun stop() {
        audioManager.unregisterAudioDeviceCallback(this)
    }
}
