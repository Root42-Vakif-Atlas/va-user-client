import 'package:flutter_test/flutter_test.dart';
import 'package:vakif_atlas/shared/widgets/molecules/account_avatar.dart';

void main() {
  test('baş harfler ilk ve son kelimeden, Türkçe büyük harfle', () {
    expect(AccountAvatar.initialsOf('ayşe nur yılmaz'), 'AY');
    expect(AccountAvatar.initialsOf('ilker'), 'İ');
    expect(AccountAvatar.initialsOf('  Ömer   Işık '), 'ÖI');
    expect(AccountAvatar.initialsOf('   '), '');
  });
}
