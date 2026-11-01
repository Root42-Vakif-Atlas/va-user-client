package tr.gov.vgm.vakif_atlas

import android.os.Build
import android.os.Bundle
import io.flutter.embedding.android.FlutterActivity

class MainActivity : FlutterActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        // PrivacyScreenGuard (TRD §10.A): son uygulamalar ekranında içerik
        // görüntüsü alınmaz. FLAG_SECURE'un aksine kullanıcının ekran görüntüsü
        // almasını engellemez. Daha eski sürümlerde Flutter tarafındaki örtü
        // katmanı kullanılır.
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU) {
            setRecentsScreenshotEnabled(false)
        }
    }
}
