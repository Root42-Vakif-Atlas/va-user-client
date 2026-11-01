import '../mock_api.dart';

/// Yasal metin uç noktasının mock implementasyonu.
///
/// İçerik yalnızca geliştirme amaçlı **taslak** yer tutucudur ve bu açıkça
/// metnin içinde belirtilir; yürürlükteki metinler VGM hukuk birimi
/// tarafından sağlanır ve gerçek API üzerinden sunulur.
class LegalMockApi implements MockApi {
  static const String _version = '0.1-taslak';
  static const String _effectiveDate = '2026-10-17';

  @override
  List<MockRoute> get routes => [
    MockRoute('GET', 'legal/documents/:type', _document),
  ];

  MockResponse _document(MockRequest request) {
    final type = request.pathParameters['type'];
    final english = request.queryParameters['lang'] == 'en';
    final content = switch (type) {
      'terms-of-use' => english ? _termsEn : _termsTr,
      'privacy-notice' => english ? _privacyEn : _privacyTr,
      _ => null,
    };
    if (content == null) {
      return MockResponse.error(404, 'not_found');
    }
    return MockResponse.ok({
      'type': type!,
      'version': _version,
      'title': content.$1,
      'body': content.$2,
      'effectiveDate': _effectiveDate,
    });
  }

  static const (String, String) _termsTr = (
    'Kullanım Koşulları (Taslak)',
    'Bu metin geliştirme ortamı için hazırlanmış bir taslaktır ve hukuki '
        'bağlayıcılığı yoktur. Yürürlükteki Kullanım Koşulları Vakıflar Genel '
        'Müdürlüğü tarafından sağlanacaktır.\n\n'
        'Yürürlükteki metin; hizmetin kapsamını, kullanıcı yükümlülüklerini, '
        'Anı Köşesi ve Sivil Koruma paylaşımlarına ilişkin topluluk kurallarını '
        've hesabın sonlandırılma koşullarını düzenleyecektir.',
  );

  static const (String, String) _privacyTr = (
    'KVKK Aydınlatma Metni (Taslak)',
    'Bu metin geliştirme ortamı için hazırlanmış bir taslaktır ve hukuki '
        'bağlayıcılığı yoktur. Yürürlükteki Aydınlatma Metni veri sorumlusu '
        'tarafından sağlanacaktır.\n\n'
        'Yürürlükteki metin, 6698 sayılı Kişisel Verilerin Korunması Kanunu\'nun '
        '10. maddesi uyarınca; veri sorumlusunun kimliğini, kişisel verilerin '
        'hangi amaçla işleneceğini, kimlere ve hangi amaçla aktarılabileceğini, '
        'toplanma yöntemi ve hukuki sebebini ve ilgili kişinin 11. maddede '
        'sayılan haklarını içerecektir.',
  );

  static const (String, String) _termsEn = (
    'Terms of Use (Draft)',
    'This text is a draft prepared for the development environment and has no '
        'legal effect. The Terms of Use in force will be provided by the '
        'General Directorate of Foundations.\n\n'
        'The text in force will set out the scope of the service, user '
        'obligations, community rules for Memory Corner and Civil Protection '
        'posts, and the conditions for terminating an account.',
  );

  static const (String, String) _privacyEn = (
    'Privacy Notice (Draft)',
    'This text is a draft prepared for the development environment and has no '
        'legal effect. The Privacy Notice in force will be provided by the '
        'data controller.\n\n'
        'In accordance with Article 10 of the Turkish Personal Data Protection '
        'Law No. 6698, the text in force will state the identity of the data '
        'controller, the purposes of processing, to whom and why personal data '
        'may be transferred, the method and legal basis of collection, and the '
        'rights of the data subject listed in Article 11.',
  );
}
