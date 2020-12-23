import 'dart:convert';
import 'package:http/http.dart';

extension ResponseExtension on Response {
  dynamic parseJson() {
    return json.decode(utf8.decode(this.bodyBytes));
  }
}
