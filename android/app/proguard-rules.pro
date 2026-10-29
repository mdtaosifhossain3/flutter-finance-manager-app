# Android Lifecycle
-keep class androidx.lifecycle.** { *; }
# ML Kit text recognition: only the Latin model is bundled; the plugin
# references the other script models as compileOnly.
-dontwarn com.google.mlkit.vision.text.chinese.**
-dontwarn com.google.mlkit.vision.text.devanagari.**
-dontwarn com.google.mlkit.vision.text.japanese.**
-dontwarn com.google.mlkit.vision.text.korean.**
