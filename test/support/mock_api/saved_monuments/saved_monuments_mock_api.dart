import 'package:vakif_atlas/core/storage/installation_id_service.dart';
import 'package:vakif_atlas/features/saved_monuments/data/sources/saved_monuments_remote_data_source.dart';

import '../auth/auth_mock_api.dart';
import '../mock_api.dart';

/// `saved-monuments` sahte uç noktaları (backend Routes servisiyle aynı
/// sözleşme): oturum açıksa küme hesaba (`u:<kullanıcı>`; girişte kurulumun
/// misafir kümesi birleştirilir), değilse kuruluma aittir; `PUT` tümüyle
/// değiştirir; geçersiz Bearer → 401.
class SavedMonumentsMockApi implements MockApi {
  SavedMonumentsMockApi({AuthMockApi? auth}) : _auth = auth {
    auth?.addAccountDeletionListener((userId) => saved.remove('u:$userId'));
  }

  static const int maxSaved = 100;

  final AuthMockApi? _auth;

  /// Sahip (kurulum kimliği veya `u:<kullanıcı>`) → eser kimliği → kaydetme
  /// zamanı (ISO 8601).
  final Map<String, Map<String, String>> saved = {};

  @override
  List<MockRoute> get routes => [
    MockRoute('GET', SavedMonumentEndpoints.savedMonuments, _list),
    MockRoute('PUT', SavedMonumentEndpoints.savedMonuments, _replace),
  ];

  Future<MockResponse> _list(MockRequest request) async {
    final (owner, rejection) = await _owner(request);
    if (owner == null) {
      return rejection!;
    }
    return MockResponse.ok(_json(owner));
  }

  Future<MockResponse> _replace(MockRequest request) async {
    final (owner, rejection) = await _owner(request);
    if (owner == null) {
      return rejection!;
    }
    final body = request.body;
    final items = body is Map<String, dynamic> ? body['items'] : null;
    if (items is! List || items.length > maxSaved) {
      return MockResponse.error(400, 'invalid_saved_monuments');
    }
    final next = <String, String>{};
    for (final item in items) {
      final id = item is Map ? item['monumentId'] : null;
      final savedAt = item is Map ? item['savedAt'] : null;
      if (id is! String ||
          savedAt is! String ||
          DateTime.tryParse(savedAt) == null ||
          next.containsKey(id)) {
        return MockResponse.error(400, 'invalid_saved_monuments');
      }
      next[id] = DateTime.parse(savedAt).toUtc().toIso8601String();
    }
    saved[owner] = next;
    return MockResponse.ok(_json(owner));
  }

  Map<String, dynamic> _json(String owner) {
    final entries = (saved[owner] ?? const {}).entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    return {
      'items': [
        for (final entry in entries)
          {'monumentId': entry.key, 'savedAt': entry.value},
      ],
    };
  }

  Future<(String?, MockResponse?)> _owner(MockRequest request) async {
    final installation = _installation(request);
    if (installation == null) {
      return (null, _installationRequired);
    }
    final auth = _auth;
    if (auth == null || request.headers['authorization'] == null) {
      return (installation, null);
    }
    final account = await auth.accountFor(request);
    if (account == null) {
      return (null, MockResponse.error(401, 'unauthorized'));
    }
    final owner = 'u:${account.id}';
    final guest = saved.remove(installation);
    if (guest != null) {
      final merged = {...?saved[owner]};
      for (final MapEntry(:key, :value) in guest.entries) {
        final existing = merged[key];
        if (existing == null || value.compareTo(existing) < 0) {
          merged[key] = value;
        }
      }
      saved[owner] = merged;
    }
    return (owner, null);
  }

  static final MockResponse _installationRequired = MockResponse.error(
    400,
    'installation_id_required',
  );

  static String? _installation(MockRequest request) {
    final id = request.headers['x-installation-id'];
    return id != null && InstallationIdService.isValid(id) ? id : null;
  }
}
