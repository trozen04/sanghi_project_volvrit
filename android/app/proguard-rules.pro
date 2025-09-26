# ===============================
# FLUTTER CORE CLASSES
# ===============================
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.** { *; }
-keep class io.flutter.embedding.** { *; }
-keep class io.flutter.util.** { *; }
-keep class io.flutter.view.** { *; }

# Keep annotations used in reflection
-keepattributes *Annotation*

# ===============================
# ACTIVITIES, FRAGMENTS, VIEWS
# ===============================
-keep class * extends android.app.Activity
-keep class * extends android.app.Fragment
-keep class * extends androidx.fragment.app.Fragment
-keep class * extends android.view.View { *; }

# ===============================
# SERIALIZABLE SUPPORT
# ===============================
-keepclassmembers class * implements java.io.Serializable {
    static final long serialVersionUID;
    private static final java.io.ObjectStreamField[] serialPersistentFields;
    private void writeObject(java.io.ObjectOutputStream);
    private void readObject(java.io.ObjectInputStream);
    java.lang.Object readResolve();
    java.lang.Object writeReplace();
}

# ===============================
# BLOC PACKAGE
# ===============================
-keep class bloc.** { *; }
-keep class flutter_bloc.** { *; }

# ===============================
# HTTP PACKAGE
# ===============================
-dontwarn okhttp3.**
-dontwarn okio.**
-dontwarn http.**

# ===============================
# SHARED PREFERENCES
# ===============================
-dontwarn android.content.SharedPreferences
-keep class android.content.SharedPreferences { *; }

# ===============================
# SHIMMER PACKAGE
# ===============================
-keep class com.facebook.shimmer.** { *; }

# ===============================
# CUpertino Icons
# ===============================
-keep class cupertino_icons.** { *; }

# ===============================
# IGNORE WARNINGS FOR OTHER LIBRARIES
# ===============================
-dontwarn javax.annotation.**
-dontwarn sun.misc.**
-dontwarn kotlin.**
-dontwarn org.json.**
-dontwarn org.xmlpull.v1.**
