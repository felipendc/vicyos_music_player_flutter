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

# Try to shrink the app but keeping important classes
-keep class com.arthenica.** { *; }
-dontwarn com.arthenica.**