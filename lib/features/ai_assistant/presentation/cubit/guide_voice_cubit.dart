import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:vakif_atlas/core/a11y/speech_input_service.dart';
import 'package:vakif_atlas/core/permissions/permission_service.dart';

part 'guide_voice_cubit.freezed.dart';

enum GuideVoiceStatus {
  idle,

  /// Mikrofon izni denetleniyor / isteniyor.
  preparing,
  listening,
}

/// Sesli sorunun alınamama nedeni; kullanıcıya gösterilir ve duyurulur.
enum GuideVoiceIssue {
  /// İzin bu sefer verilmedi; bir sonraki dokunuşta yeniden sorulur.
  permissionDenied,

  /// İzin kalıcı olarak kapalı → uygulama ayarları.
  permissionBlocked,

  /// Cihazda/tarayıcıda konuşma tanıma yok.
  unavailable,

  /// Konuşma algılanmadı.
  noMatch,
  failed,
}

@freezed
abstract class GuideVoiceState with _$GuideVoiceState {
  const factory GuideVoiceState({
    @Default(GuideVoiceStatus.idle) GuideVoiceStatus status,

    /// Bu oturumda tanınan metin (dinlerken kısmi).
    @Default('') String transcript,
    GuideVoiceIssue? issue,

    /// `false` → mikrofon butonu gösterilmez.
    @Default(true) bool isAvailable,
    @Default(false) bool canOpenSettings,

    /// Her dinleme oturumunda artar.
    @Default(0) int session,
  }) = _GuideVoiceState;

  const GuideVoiceState._();

  bool get isListening => status == GuideVoiceStatus.listening;

  /// Tanınan metin kişisel veridir; loglara yazılmaz (ADR 14).
  @override
  String toString() =>
      'GuideVoiceState($status, session: $session, issue: $issue)';
}

/// Dijital Rehber'e sesli soru (ekran bazlı).
///
/// - Mikrofon izni yalnızca kullanıcı mikrofon butonuna dokununca istenir;
///   kalıcı retde ayarlara yönlendiren mesaj gösterilir.
/// - Tanınan metin soru alanına yazılır; soru **otomatik gönderilmez**,
///   kullanıcı gözden geçirip gönderir (WCAG 3.3.4).
@injectable
class GuideVoiceCubit extends Cubit<GuideVoiceState> {
  GuideVoiceCubit(this._speech, this._permissions)
    : super(
        GuideVoiceState(
          isAvailable: _speech.isSupported,
          canOpenSettings: _permissions.canOpenAppSettings,
        ),
      );

  final SpeechInputService _speech;
  final PermissionService _permissions;

  StreamSubscription<SpeechInputEvent>? _subscription;

  /// Dinlemiyorsa başlatır, dinliyorsa bitirir.
  Future<void> toggle({required String languageCode}) async {
    switch (state.status) {
      case GuideVoiceStatus.listening:
        await _speech.stop();
      case GuideVoiceStatus.preparing:
        return;
      case GuideVoiceStatus.idle:
        await _start(languageCode);
    }
  }

  Future<void> openSettings() => _permissions.openAppSettings();

  /// Kullanıcı mesajı okudu / soru gönderildi.
  void clearIssue() {
    if (state.issue != null) {
      emit(state.copyWith(issue: null));
    }
  }

  Future<void> _start(String languageCode) async {
    if (!state.isAvailable) {
      return;
    }
    emit(
      state.copyWith(
        status: GuideVoiceStatus.preparing,
        transcript: '',
        issue: null,
      ),
    );
    final access = switch (await _permissions.check(AppPermission.microphone)) {
      PermissionAccess.denied => await _permissions.request(
        AppPermission.microphone,
      ),
      final current => current,
    };
    if (isClosed) {
      return;
    }
    final issue = switch (access) {
      PermissionAccess.granted => null,
      PermissionAccess.denied => GuideVoiceIssue.permissionDenied,
      PermissionAccess.deniedForever => GuideVoiceIssue.permissionBlocked,
      PermissionAccess.unsupported => GuideVoiceIssue.unavailable,
    };
    if (issue != null) {
      emit(
        state.copyWith(
          status: GuideVoiceStatus.idle,
          issue: issue,
          isAvailable: issue != GuideVoiceIssue.unavailable,
        ),
      );
      return;
    }
    // İki hızlı başlatma aynı eski aboneliği iptal edip birinin yeni
    // aboneliğini sızdırmasın: önce yeni oturum alınır, sonra eski abonelik
    // devralınıp iptal edilir.
    final previous = _subscription;
    _subscription = null;
    await previous?.cancel();
    if (isClosed || _subscription != null) {
      return;
    }
    final session = state.session + 1;
    emit(state.copyWith(status: GuideVoiceStatus.listening, session: session));
    _subscription = _speech
        .listen(languageCode: languageCode)
        .listen(
          (event) => _onEvent(session, event),
          onDone: () => _onDone(session),
        );
  }

  void _onEvent(int session, SpeechInputEvent event) {
    if (isClosed || session != state.session) {
      return;
    }
    switch (event) {
      case SpeechHeard(:final text):
        emit(state.copyWith(transcript: text));
      case SpeechInputFailed(:final issue):
        final mapped = switch (issue) {
          SpeechInputIssue.unavailable => GuideVoiceIssue.unavailable,
          SpeechInputIssue.noMatch => GuideVoiceIssue.noMatch,
          SpeechInputIssue.permissionDenied =>
            GuideVoiceIssue.permissionBlocked,
          SpeechInputIssue.failed => GuideVoiceIssue.failed,
        };
        emit(
          state.copyWith(
            issue: mapped,
            isAvailable: mapped != GuideVoiceIssue.unavailable,
          ),
        );
    }
  }

  void _onDone(int session) {
    if (isClosed || session != state.session) {
      return;
    }
    final heardNothing = state.issue == null && state.transcript.trim().isEmpty;
    emit(
      state.copyWith(
        status: GuideVoiceStatus.idle,
        issue: heardNothing ? GuideVoiceIssue.noMatch : state.issue,
      ),
    );
  }

  @override
  Future<void> close() async {
    await _subscription?.cancel();
    if (state.isListening) {
      await _speech.cancel();
    }
    return super.close();
  }
}
