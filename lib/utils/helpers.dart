import 'package:flutter/services.dart';

Future<String> getClipboardData() async {
  final clipboardData = await Clipboard.getData('text/plain');
  return clipboardData?.text ?? '';
}
