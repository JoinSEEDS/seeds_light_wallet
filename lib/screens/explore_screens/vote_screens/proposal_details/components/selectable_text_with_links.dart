import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:seeds/design/app_theme.dart';
import 'package:url_launcher/url_launcher.dart';

const String _urlPattern =
    r"((https?:www\.)|(https?:\/\/)|(www\.))?[\w/\-?=%.][-a-zA-Z0-9@:%._\+~#=]{1,256}\.[a-zA-Z0-9]{1,6}(\/[-a-zA-Z0-9()@:%_\+.~#?&\/=]*)?";
const String _emailPattern = r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+";
const String _phonePattern = r"^\D?(\d{3})\D?\D?(\d{3})\D?(\d{4})$";
final RegExp _linkRegExp = RegExp(
    r"(((https?:www\.)|(https?:\/\/)|(www\.))?[\w/\-?=%.][-a-zA-Z0-9@:%._\+~#=]{1,256}\.[a-zA-Z0-9]{1,6}(\/[-a-zA-Z0-9()@:%_\+.~#?&\/=]*)?)|(^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+)|(^\D?(\d{3})\D?\D?(\d{3})\D?(\d{4})$)",
    caseSensitive: false);

/// Creates a selectable text widget. Also It uses url_launcher
/// and currnetly supports URL, mail and phone links,
/// but can easily be expanded by adding more RegExps and handlers.
///
/// If the [style] argument is null, the text will use the style from the
/// closest enclosing [DefaultTextStyle].
///
class SelectableTextWithLinks extends StatelessWidget {
  final String text;
  final TextStyle? style;

  const SelectableTextWithLinks(this.text, {Key? key, this.style}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SelectableText.rich(TextSpan(children: _linkify(text, context)));
  }

  Future<void> _openUrl(String url) async {
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    } else {
      throw 'Could not launch $url';
    }
  }

  List<InlineSpan> _linkify(String text, BuildContext context) {
    final List<InlineSpan> list = <InlineSpan>[];
    final RegExpMatch? match = _linkRegExp.firstMatch(text);
    if (match == null) {
      list.add(TextSpan(text: text, style: style));
      return list;
    }

    if (match.start > 0) {
      list.add(TextSpan(text: text.substring(0, match.start), style: style));
    }

    final String linkText = match.group(0)!;
    // Remove <&& linkText.contains('https')> condition part
    // if you want to highlight bare domains like google.com
    if (linkText.contains(RegExp(_urlPattern, caseSensitive: false)) && linkText.contains('https')) {
      // Is a URL link
      list.add(
        TextSpan(
          text: linkText,
          style: Theme.of(context).textTheme.subtitle3LightGreen6,
          recognizer: TapGestureRecognizer()..onTap = () => _openUrl(linkText),
        ),
      );
    } else if (linkText.contains(RegExp(_emailPattern, caseSensitive: false))) {
      // Is a email link
      list.add(
        TextSpan(
          text: linkText,
          style: Theme.of(context).textTheme.subtitle3LightGreen6,
          recognizer: TapGestureRecognizer()..onTap = () => _openUrl('mailto:$linkText'),
        ),
      );
    } else if (linkText.contains(RegExp(_phonePattern, caseSensitive: false))) {
      // Is a phone link
      list.add(
        TextSpan(
          text: linkText,
          style: Theme.of(context).textTheme.subtitle3LightGreen6,
          recognizer: TapGestureRecognizer()..onTap = () => _openUrl('tel:$linkText'),
        ),
      );
    } else {
      list.add(TextSpan(text: text, style: style));
      // oh oh..
      print('Unexpected match: $linkText');
    }

    list.addAll(_linkify(text.substring(match.start + linkText.length), context));

    return list;
  }
}
