## ===================================================
## Keep application classes
## ===================================================
#-keep class com.example.vicyos_music.** { *; }
#
## ===================================================
## Keep Flutter-related classes
## ===================================================
#-keep class io.flutter.** { *; }
#-keep class io.flutter.embedding.engine.deferredcomponents.** { *; }
#
## ===================================================
## Keep Kotlin metadata
## ===================================================
#-keep class kotlin.** { *; }
#
## ===================================================
## Keep Google Play Core classes
## ===================================================
#-keep class com.google.android.play.** { *; }
#
## ===================================================
## Keep your custom native audio classes
## ===================================================
#-keep class com.example.vicyos_music.AudioAacEncoder { *; }
#-keep class com.example.vicyos_music.AudioAacTrimmer { *; }
#
## ===================================================
## Keep MediaCodec, MediaMuxer and related classes
## ===================================================
#-keep class android.media.** { *; }
#-keep class java.nio.** { *; }
#
## ===================================================
## Keep native methods called via System.loadLibrary
## ===================================================
#-keepclasseswithmembers class * {
#    native <methods>;
#}
#
## ===================================================
## Keep constructors for reflection (safety)
## ===================================================
#-keepnames class * {
#    public <init>(...);
#}

# Keep application classes
-keep class com.yourpackage.** { *; }

# Keep all Flutter-related classes
-keep class io.flutter.** { *; }

# Keep necessary Kotlin metadata
-keep class kotlin.** { *; }

# Keep Google Play Core classes
-keep class com.google.android.play.** { *; }
-keep class io.flutter.embedding.engine.deferredcomponents.** { *; }

# Keep any additional classes as needed
-keepnames class * {
    public <init>(...);
}

# FFmpeg (if using FFmpegKit or other native libraries)
-keep class com.antonkarpenko.** { *; }
