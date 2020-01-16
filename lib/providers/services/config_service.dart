import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

class ConfigService {
  static Map<String, dynamic> _config = <String, dynamic>{};

  static of(BuildContext context, {bool listen = false}) =>
      Provider.of<ConfigService>(context, listen: listen);

  void init(List<Map<String, dynamic>> files) async {
    for (var file in files)
      await _load(file);
  }

  Future<void> _load(Map<String, dynamic> file) async {
    String filename = file["name"];
    bool isRequired = file["isRequired"];
    try {
      final String loadedConfig = await rootBundle.loadString("assets/config/$filename");
      final Map<String, dynamic> parsedConfig = jsonDecode(loadedConfig);
      _config.addAll(parsedConfig);
    } on FlutterError {
      if (isRequired == true) {
        throw "Cannot load config: $filename";
      }
    }
  }

  String value(String key) => _config[key] ?? '';

  @override
  String toString() {
    return 'Config{_config: ${jsonEncode(_config)}}';
  }
}
