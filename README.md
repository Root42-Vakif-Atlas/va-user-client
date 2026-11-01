# Vakıf Atlas — Flutter uygulaması

Kurulum, tüm yığını çalıştırma ve dağıtım: **[kök README](../README.md)**.
Mimari ve kod kuralları: [`../CLAUDE.md`](../CLAUDE.md).

```sh
make setup        # pub get + kod üretimi + l10n
make run-dev      # yerel backend ile (vakif-atlas-microservices/deploy/compose açık olmalı; Android'de adb reverse otomatik)
                  # demo: vatandas@vakifatlas.dev / Atlas2026! · yeni hesap kodları: http://localhost:8025 (Mailpit)
make run-remote   # yayındaki backend ile (https://vakif-atlas.odx.studio/v1/)
make test         # birim + widget testleri (ağa çıkmaz; test/support/mock_api sahte backend)
make analyze
make contract-check   # DTO'lar ↔ çalışan backend
make backend-e2e      # uygulamanın kendisi ↔ çalışan backend
make help         # tüm hedefler
```

| Config | Kullanım |
|:---|:---|
| `config/dev.json` | Yerel backend, `http://localhost:8080/v1/` |
| `config/remote.json` | Yayındaki backend, `https://vakif-atlas.odx.studio/v1/` (dev ortamıyla: `main_dev.dart`, SSL pinning kapalı) |
| `config/staging.json`, `config/prod.json` | Gerçek ortamlar — `API_BASE_URL`, `SSL_PINS`, harita karo sunucusu doldurulmalı |

## Yayındaki backend ile çalıştırma

`config/remote.json` uygulamayı `https://vakif-atlas.odx.studio/v1/` adresine bağlar. Yerel backend,
`adb reverse` veya Mailpit gerekmez.

```sh
cd vakif_atlas_user_client
make setup          # ilk seferde
flutter devices     # cihaz kimliğini bul
make run-remote     # Android / iOS (dev flavor); belirli cihaz için aşağıdaki komuta -d <cihaz> ekleyin
```

| Hedef | Komut |
|:---|:---|
| Android telefon / emülatör | `make run-remote` veya `flutter run --flavor dev -t lib/main_dev.dart --dart-define-from-file=config/remote.json -d <cihaz>` |
| iOS simülatör / iPhone | `flutter run --flavor dev -t lib/main_dev.dart --dart-define-from-file=config/remote.json -d <cihaz>` |
| Web (Chrome) | `flutter run -d chrome -t lib/main_dev.dart --dart-define-from-file=config/remote.json` (web'de `--flavor` yok) |
| macOS masaüstü | `flutter run -d macos -t lib/main_dev.dart --dart-define-from-file=config/remote.json` (`--flavor` yok) |
| Web yayın derlemesi | `make build-web ENV=dev CONFIG=config/remote.json` → `build/web/` |

Notlar:

- Dev girişi kullanılır: SSL pinning kapalı, ayrıntılı log açık (sunucunun pin'leri config'de yok).
- Demo hesabı (`vatandas@vakifatlas.dev` / `Atlas2026!`) yalnızca sunucu demo verisiyle açıldıysa
  vardır. Yeni hesabın doğrulama kodu sunucunun gönderdiği e-postayla gelir (yerel Mailpit değil).
- Sunucu ayakta mı: `https://vakif-atlas.odx.studio/v1/health` → `{"status":"ok"}`.
- İstemci DTO'larını yayındaki sunucuya karşı doğrulamak:
  `flutter test tool/backend_contract_check_test.dart --dart-define=API=https://vakif-atlas.odx.studio/v1/`
  (araçlar `API` tanımını okur, config dosyasını değil; verilmezse `localhost` denenir)

### Nesne deposu

Nesne deposu (`https://vakif-atlas-s3.odx.studio`) uygulamada yapılandırılmaz: fotoğraf / PDF yükleme
adresleri (`uploadUrl`) ve medya adresleri sunucudan gelir. Sunucuda `deploy/compose/.env` →
`PUBLIC_S3_URL=https://vakif-atlas-s3.odx.studio` ve `PUBLIC_BASE_URL=https://vakif-atlas.odx.studio`
olmalıdır; yoksa yükleme adresleri `localhost` olur ve telefondan yükleme başarısız olur.
Uygulama tarafındaki tek ayar `STORAGE_SSL_PINS`'tir (bu alan adının SPKI özetleri; staging/prod).
Web derlemesinde tarayıcıdan `PUT` için depo alan adında uygulamanın kökenine CORS izni gerekir.
