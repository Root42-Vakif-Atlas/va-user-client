import java.io.FileInputStream
import java.util.Properties

plugins {
    id("com.android.application")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

// Release imzalama bilgileri CI'da veya yerelde `android/key.properties` dosyasından okunur.
// Dosya yoksa yalnızca dev flavor'ının release derlemesi debug anahtarıyla imzalanır;
// staging/prod release derlemesi durdurulur (debug imzalı paket dağıtıma çıkmasın).
// Yerel deneme için bilinçli olarak: `-PallowDebugSigning=true`.
val keystoreProperties = Properties().apply {
    val keystorePropertiesFile = rootProject.file("key.properties")
    if (keystorePropertiesFile.exists()) {
        FileInputStream(keystorePropertiesFile).use { load(it) }
    }
}
val hasReleaseKeystore = !keystoreProperties.isEmpty
val allowDebugSigning = (findProperty("allowDebugSigning") as String?)?.toBoolean() == true

android {
    namespace = "tr.gov.vgm.vakif_atlas"
    // permission_handler_android 14.x API 37'ye karşı derlenmeyi gerektirir.
    // Yalnızca derleme API'sidir; çalışma davranışı targetSdk ile belirlenir.
    compileSdk = maxOf(flutter.compileSdkVersion, 37)
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    defaultConfig {
        applicationId = "tr.gov.vgm.vakif_atlas"
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    buildFeatures {
        resValues = true
    }

    flavorDimensions += "environment"
    productFlavors {
        create("dev") {
            dimension = "environment"
            applicationIdSuffix = ".dev"
            resValue("string", "app_name", "Vakıf Atlas Dev")
        }
        create("staging") {
            dimension = "environment"
            applicationIdSuffix = ".staging"
            resValue("string", "app_name", "Vakıf Atlas Staging")
        }
        create("prod") {
            dimension = "environment"
            resValue("string", "app_name", "Vakıf Atlas")
        }
    }

    signingConfigs {
        if (hasReleaseKeystore) {
            create("release") {
                keyAlias = keystoreProperties.getProperty("keyAlias")
                keyPassword = keystoreProperties.getProperty("keyPassword")
                storeFile = file(keystoreProperties.getProperty("storeFile"))
                storePassword = keystoreProperties.getProperty("storePassword")
            }
        }
    }

    buildTypes {
        release {
            signingConfig = if (hasReleaseKeystore) {
                signingConfigs.getByName("release")
            } else {
                signingConfigs.getByName("debug")
            }
            proguardFiles(
                getDefaultProguardFile("proguard-android-optimize.txt"),
                "proguard-rules.pro",
            )
        }
    }
}

tasks.configureEach {
    if (!hasReleaseKeystore && !allowDebugSigning &&
        name.matches(Regex("^pre(Staging|Prod)ReleaseBuild$"))
    ) {
        doFirst {
            throw GradleException(
                "android/key.properties bulunamadı: staging/prod release derlemesi " +
                    "debug anahtarıyla imzalanamaz. Yerel deneme için -PallowDebugSigning=true.",
            )
        }
    }
}

kotlin {
    compilerOptions {
        jvmTarget = org.jetbrains.kotlin.gradle.dsl.JvmTarget.JVM_17
    }
}

flutter {
    source = "../.."
}
