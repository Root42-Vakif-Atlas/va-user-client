import 'package:vakif_atlas/features/feedback/data/sources/feedback_remote_data_source.dart';

import '../auth/auth_mock_api.dart';
import '../mock_api.dart';

/// Mock Feedback API (Feedback servisiyle aynı sözleşme): giriş gerekmez;
/// gönderilen Bearer geçersizse `401`; kategori zorunlu, puan (1–5) veya
/// metinden biri gerekli, metin ≤ 2000; saatte 5 gönderim.
class FeedbackMockApi implements MockApi {
  FeedbackMockApi(this._auth, {DateTime Function()? clock})
    : _clock = clock ?? DateTime.now;

  final AuthMockApi _auth;
  final DateTime Function() _clock;

  static const Set<String> categories = {
    'bug',
    'suggestion',
    'accessibility',
    'content',
    'other',
  };
  static const Set<String> platforms = {
    'android',
    'ios',
    'web',
    'macos',
    'windows',
    'linux',
  };
  static const int maxMessage = 2000;
  static const int maxPerHour = 5;

  /// Kaydedilen geri bildirimler (testler okur).
  final List<Map<String, Object?>> received = [];
  final Map<String, List<DateTime>> _recent = {};
  int _counter = 0;

  @override
  List<MockRoute> get routes => [
    MockRoute('POST', FeedbackEndpoints.feedback, _submit),
  ];

  Future<MockResponse> _submit(MockRequest request) async {
    final account = await _auth.accountFor(request);
    if (account == null && request.bearerToken != null) {
      return MockResponse.error(401, 'unauthorized');
    }
    final category = request.field('category');
    final rating = request.field('rating');
    final message = request.field('message');
    final appVersion = request.field('appVersion');
    final platform = request.field('platform');
    final text = message is String ? message.trim() : '';
    final valid =
        category is String &&
        categories.contains(category) &&
        (rating == null || (rating is int && rating >= 1 && rating <= 5)) &&
        (message == null || message is String) &&
        text.length <= maxMessage &&
        (rating != null || text.isNotEmpty) &&
        (appVersion == null ||
            (appVersion is String &&
                RegExp(r'^[0-9A-Za-z.+\-]{1,40}$').hasMatch(appVersion))) &&
        (platform == null || platforms.contains(platform));
    if (!valid) {
      return MockResponse.error(400, 'invalid_feedback');
    }

    final now = _clock();
    final key = account?.id ?? 'guest';
    final recent = (_recent[key] ?? [])
      ..removeWhere((at) => now.difference(at) >= const Duration(hours: 1));
    if (recent.length >= maxPerHour) {
      return MockResponse(
        429,
        body: {
          'code': 'too_many_requests',
          'retryAfter': 3600 - now.difference(recent.first).inSeconds,
        },
      );
    }
    _recent[key] = recent..add(now);

    final id = 'fb_${++_counter}';
    received.add({
      'id': id,
      'category': category,
      'rating': rating,
      'message': text,
      'appVersion': appVersion,
      'platform': platform,
      'userId': account?.id,
    });
    return MockResponse(
      201,
      body: {'id': id, 'createdAt': now.toUtc().toIso8601String()},
    );
  }
}
