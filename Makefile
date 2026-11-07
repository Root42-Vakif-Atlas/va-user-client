# Vakıf Atlas — Flutter Developer Automation (Vibe Coding DX)

.PHONY: help setup codegen codegen-clean analyze format format-check test test-coverage clean run-dev run-remote run-staging run-prod l10n check-a11y contract-check backend-e2e adb-reverse ci build-apk build-appbundle build-ipa build-web

help: ## Mevcut komutları listele
	@echo "Vakıf Atlas — Geliştirici ve Agent Komutları:"
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-20s\033[0m %s\n", $$1, $$2}'

setup: ## Proje bağımlılıklarını kur ve kod üretimini çalıştır
	flutter pub get
	dart run build_runner build --delete-conflicting-outputs
	flutter gen-l10n

codegen: ## freezed, injectable, json_serializable kod üretimini tetikle
	dart run build_runner build --delete-conflicting-outputs

codegen-watch: ## Kod üretimini izleme modunda başlat
	dart run build_runner watch --delete-conflicting-outputs

codegen-clean: ## Üretilen dosyaları temizleyip sıfırdan üret
	dart run build_runner clean
	dart run build_runner build --delete-conflicting-outputs

l10n: ## Yerelleştirme dosyalarını güncelle (ARB -> Dart)
	flutter gen-l10n

analyze: ## Statik kod analizi yap
	flutter analyze lib/ test/

format: ## Kod formatla (Dart 80/120 karakter standardı)
	dart format lib/ test/

format-check: ## Kod formatını kontrol et
	dart format --output=none --set-exit-if-changed lib/ test/

test: ## Tüm birim ve widget testlerini çalıştır
	flutter test

test-coverage: ## Testleri coverage raporu ile çalıştır
	flutter test --coverage
	genhtml coverage/lcov.info -o coverage/html
	@echo "Coverage raporu: coverage/html/index.html"

check-a11y: ## Erişilebilirlik guideline testlerini çalıştır
	flutter test test/core/a11y/ test/shared/widgets/

adb-reverse: ## Android cihaz/emülatörde localhost:8080 (API) ve :8333 (ön imzalı yüklemeler) yönlendirmesi
	@command -v adb >/dev/null 2>&1 || exit 0; \
	for serial in $$(adb devices | awk 'NR > 1 && $$2 == "device" { print $$1 }'); do \
		adb -s $$serial reverse tcp:8080 tcp:8080 >/dev/null && \
		adb -s $$serial reverse tcp:8333 tcp:8333 >/dev/null && \
		echo "adb reverse ($$serial): 8080, 8333"; \
	done

ios-release:
	flutter build ios --release -t lib/main_dev.dart --dart-define-from-file=config/remote.json
	flutter install --release

run-dev: adb-reverse ## Yerel backend'e (backend/deploy/compose, http://localhost:8080/v1/) karşı dev flavor ile çalıştır
	flutter run --flavor dev -t lib/main_dev.dart --dart-define-from-file=config/dev.json

run-remote: ## Yayındaki backend'e (https://vakif-atlas.odx.studio/v1/; depo adresleri sunucudan: https://vakif-atlas-s3.odx.studio) karşı dev flavor ile çalıştır (SSL pinning kapalı)
	flutter run --flavor dev -t lib/main_dev.dart --dart-define-from-file=config/remote.json

contract-check: ## İstemci DTO'larını çalışan backend'e karşı doğrula (varsayılan http://localhost:8080/v1/)
	flutter test tool/backend_contract_check_test.dart

backend-e2e: ## Uygulamanın kendisi (DI + ekranlar) çalışan backend'e karşı uçtan uca (Mailpit gerekir)
	flutter test tool/backend_app_e2e_test.dart

run-staging: ## Staging ortamında çalıştır
	flutter run --flavor staging -t lib/main_staging.dart --dart-define-from-file=config/staging.json

run-prod: ## Production ortamında çalıştır
	flutter run --flavor prod -t lib/main_prod.dart --dart-define-from-file=config/prod.json

# ── Release derlemeleri ────────────────────────────────────────────────
# Ortam: ENV=dev|staging|prod (varsayılan staging). CONFIG, CI'da secret'lardan
# üretilen dosyayla değiştirilebilir (repodaki staging/prod.json boş şablondur):
#   make build-appbundle ENV=prod CONFIG=$$RUNNER_TEMP/prod.json
# Dart kodu karartılır; sembol dosyaları build/symbols/<ENV>'e yazılır
# (Crashlytics/Play Console yığın izi çözümü için saklanmalıdır).
ENV ?= staging
CONFIG ?= config/$(ENV).json
RELEASE_FLAGS = --release -t lib/main_$(ENV).dart --dart-define-from-file=$(CONFIG)
OBFUSCATE = --obfuscate --split-debug-info=build/symbols/$(ENV)

build-apk: ## Android APK (ENV=staging|prod; key.properties gerekir)
	flutter build apk --flavor $(ENV) $(RELEASE_FLAGS) $(OBFUSCATE)

build-appbundle: ## Android App Bundle — Play Store (ENV=staging|prod)
	flutter build appbundle --flavor $(ENV) $(RELEASE_FLAGS) $(OBFUSCATE)

build-ipa: ## iOS IPA — App Store / TestFlight (ENV=staging|prod; imzalama Xcode'da)
	flutter build ipa --flavor $(ENV) $(RELEASE_FLAGS) $(OBFUSCATE)

build-web: ## Web (ENV=staging|prod); web'de flavor yoktur, ortam entrypoint'ten gelir. Yayındaki backend: ENV=dev CONFIG=config/remote.json
	# .map dosyaları hata izleme için saklanır; herkese açık sunucuya yüklenmemelidir.
	flutter build web $(RELEASE_FLAGS) --source-maps

ci: format-check analyze test ## CI kapısı: format + analiz + testler

clean: ## Flutter ve build kalıntılarını temizle
	flutter clean
	rm -rf coverage/
