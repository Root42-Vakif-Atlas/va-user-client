import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vakif_atlas/core/a11y/voice_io_service.dart';
import 'package:vakif_atlas/core/l10n/l10n.dart';
import 'package:vakif_atlas/shared/widgets/atoms/app_button.dart';

/// Eser metnini metinden sese (TTS) motoruyla okur / durdurur (TRD §7).
///
/// Sayfadan çıkıldığında süren seslendirme durdurulur.
class MonumentListenButton extends StatefulWidget {
  const MonumentListenButton({
    required this.text,
    required this.languageCode,
    super.key,
  });

  final String text;
  final String languageCode;

  @override
  State<MonumentListenButton> createState() => _MonumentListenButtonState();
}

class _MonumentListenButtonState extends State<MonumentListenButton> {
  late final VoiceIoService _voice = context.read<VoiceIoService>();
  StreamSubscription<TtsStatus>? _subscription;
  bool _speaking = false;

  @override
  void initState() {
    super.initState();
    _subscription = _voice.status.listen((status) {
      if (mounted) {
        setState(() => _speaking = status == TtsStatus.speaking);
      }
    });
  }

  @override
  void dispose() {
    unawaited(_subscription?.cancel());
    if (_speaking) {
      unawaited(_voice.stop());
    }
    super.dispose();
  }

  void _toggle() {
    if (_speaking) {
      unawaited(_voice.stop());
    } else {
      unawaited(_voice.speak(widget.text, languageCode: widget.languageCode));
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return AppButton.secondary(
      key: const Key('monument_listen_button'),
      label: _speaking ? l10n.monumentStopListening : l10n.monumentListen,
      icon: _speaking ? Icons.stop_circle_outlined : Icons.volume_up_outlined,
      onPressed: _toggle,
    );
  }
}
