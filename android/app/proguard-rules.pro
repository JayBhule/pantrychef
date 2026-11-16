# Keep Flutter engine classes
-keep class io.flutter.** { *; }
-keep class io.flutter.plugins.** { *; }
# Keep HTTP classes used by the Groq service
-keepattributes Signature
-keepattributes *Annotation*
# Prevent obfuscation of JSON model classes (Recipe model)
-keep class com.pantrychef.pantrychef.** { *; }

# Suppress Play Core warnings in R8
-dontwarn com.google.android.play.core.**
