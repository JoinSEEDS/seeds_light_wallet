// ignore: import_of_legacy_library_into_null_safe
import 'package:eosdart_ecc/eosdart_ecc.dart';

class AuthDataModel {
  final EOSPrivateKey eOSPrivateKey;
  final List<String> words;

  AuthDataModel(this.eOSPrivateKey, this.words);
}
