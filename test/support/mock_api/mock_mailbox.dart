import 'dart:async';

import 'package:flutter/foundation.dart';

enum MockEmailKind {
  /// E-posta doğrulama kodu.
  verificationCode,

  /// Şifre sıfırlama kodu.
  passwordResetCode,

  /// Kayıtlı bir adresle tekrar kayıt denendi (numaralandırma koruması).
  accountAlreadyExists,
}

/// Mock API'nin "gönderdiği" e-posta.
@immutable
final class MockEmail {
  const MockEmail({required this.to, required this.kind, this.code});

  final String to;
  final MockEmailKind kind;
  final String? code;
}

/// Sahte backend'in e-posta kutusu: testler doğrulama ve sıfırlama
/// kodlarını buradan okur (gerçek backend'de Mailpit / e-posta servisi).
class MockMailbox {
  final StreamController<MockEmail> _emails =
      StreamController<MockEmail>.broadcast();

  Stream<MockEmail> get emails => _emails.stream;

  void deliver(MockEmail email) {
    if (!_emails.isClosed) {
      _emails.add(email);
    }
  }

  Future<void> dispose() => _emails.close();
}
