# Flutter-specific rules
-keep class io.flutter.** { *; }
-keep class io.flutter.embedding.** { *; }
-keepclassmembers class * {
    native <methods>;
}

# Retain all classes that extend FlutterActivity or FlutterFragment
-keep public class * extends io.flutter.embedding.android.FlutterActivity
-keep public class * extends io.flutter.embedding.android.FlutterFragment

# Retain specific libraries
-keep class com.google.gson.** { *; }
-dontwarn com.google.gson.**
