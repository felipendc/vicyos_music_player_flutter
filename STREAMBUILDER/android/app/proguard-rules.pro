# Flutter-specific ProGuard rules
-keep class io.flutter.** { *; }
-keep class io.flutter.embedding.** { *; }

# Keep annotations
-keepattributes *Annotation*

# Keep application classes
-keep class com.example.vicyos_app.** { *; }

# Exclude R8 warnings
-dontwarn com.example.vicyos_app.**


# Keep all Flutter-related classes
# Prevent obfuscation for JSON serialization/deserialization
-keep class com.google.gson.** { *; }
