import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';

class I18n {
  I18n(this.locale);

  final Locale locale;

  static I18n? of(BuildContext context) {
    return Localizations.of<I18n>(context, I18n);
  }

  Map<String, String>? getDic(
      Map<String, Map<String, Map<String, String>>> fullDic, String module) {
    return fullDic[locale.languageCode]![module];
  }
}

class AppLocalizationsDelegate extends LocalizationsDelegate<I18n> {
  const AppLocalizationsDelegate(this.overriddenLocale);

  final Locale overriddenLocale;

  @override
  bool isSupported(Locale locale) => ['en', 'zh'].contains(locale.languageCode);

  @override
  Future<I18n> load(Locale locale) {
    return SynchronousFuture<I18n>(I18n(overriddenLocale));
  }

  @override
  bool shouldReload(AppLocalizationsDelegate old) => true;
}
