# Vakıf Atlas — release (R8) koruma kuralları.
# Flutter Gradle eklentisi kendi kurallarını ekler; burada yalnızca yansıma
# (reflection) / JNI ile erişilen ve eklentilerin tüketici kuralı taşımadığı
# sınıflar korunur. Her değişiklikten sonra `make build-apk-staging` ile
# üretilen APK cihazda denenmelidir (TTS, sesli soru, cihaz bütünlüğü).

# flutter_tts: TextToSpeech motor geri çağrıları.
-keep class com.eyedeadevelopment.fluttertts.** { *; }

# speech_to_text: RecognitionListener geri çağrıları.
-keep class com.csdcorp.speech_to_text.** { *; }

# jailbreak_root_detection + RootBeer: yerel (JNI) kütüphane yöntemleri.
-keep class com.w3conext.jailbreak_root_detection.** { *; }
-keep class com.scottyab.rootbeer.** { *; }
-keepclasseswithmembernames class * {
    native <methods>;
}

# Hata ayıklama için yığın izlerinde satır numaraları (Crashlytics eşlemesi).
-keepattributes SourceFile,LineNumberTable
-renamesourcefileattribute SourceFile
