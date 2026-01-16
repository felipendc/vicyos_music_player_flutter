package com.example.vicyos_music

import android.content.ContentResolver
import android.database.ContentObserver
import android.os.Handler
import android.os.Looper
import android.provider.MediaStore
import io.flutter.plugin.common.EventChannel

class MediaStoreMusicObserver(
    private val contentResolver: ContentResolver,
    private val events: EventChannel.EventSink?
) {

    private val handler = Handler(Looper.getMainLooper())
    private var lastMusicSnapshot: Map<String, String> = emptyMap() // path -> title

    private val observer = object : ContentObserver(handler) {
        override fun onChange(selfChange: Boolean, uri: android.net.Uri?) {
            super.onChange(selfChange, uri)
            // Process changes immediately
            processChanges()
        }
    }

    fun start() {
        lastMusicSnapshot = queryAllMusicPathsWithTitle()
        contentResolver.registerContentObserver(
            MediaStore.Audio.Media.EXTERNAL_CONTENT_URI,
            true,
            observer
        )
    }

    fun stop() {
        contentResolver.unregisterContentObserver(observer)
    }

    private fun processChanges() {
        val currentSnapshot = queryAllMusicPathsWithTitle()

        val oldPaths = lastMusicSnapshot.keys
        val newPaths = currentSnapshot.keys

        val added = newPaths - oldPaths
        val removed = oldPaths - newPaths

        val renamed = mutableListOf<Map<String, String>>()
        // Detect renames: same path but title changed
        for ((path, title) in currentSnapshot) {
            val oldTitle = lastMusicSnapshot[path]
            if (oldTitle != null && oldTitle != title) {
                renamed.add(mapOf("path" to path, "oldTitle" to oldTitle, "newTitle" to title))
            }
        }

        lastMusicSnapshot = currentSnapshot

        if (added.isNotEmpty() || removed.isNotEmpty() || renamed.isNotEmpty()) {
            events?.success(
                mapOf(
                    "type" to "MEDIASTORE_UPDATED",
                    "added" to added.toList(),
                    "removed" to removed.toList(),
                    "renamed" to renamed
                )
            )
        }
    }

    private fun queryAllMusicPathsWithTitle(): Map<String, String> {
        val map = mutableMapOf<String, String>()
        val projection = arrayOf(
            MediaStore.Audio.Media.DATA,
            MediaStore.Audio.Media.TITLE
        )

        val cursor = contentResolver.query(
            MediaStore.Audio.Media.EXTERNAL_CONTENT_URI,
            projection,
            null,
            null,
            null
        )

        cursor?.use {
            while (it.moveToNext()) {
                val path = it.getString(0)
                val title = it.getString(1)
                map[path] = title
            }
        }

        return map
    }
}
