import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

class Config {
  static Map<String, dynamic> _config = <String, dynamic>{};

  static Future<Config> init(String filename) async {
    _config = await _load(filename);
    return Config();
  }

  String value(String key) => _config[key] ?? '';

  static Future<Map<String, dynamic>> _load(String filename) async {
    print('"filename = [$filename]"');
    try {
      WidgetsFlutterBinding.ensureInitialized();
      final str = await rootBundle.loadString("assets/config/$filename");
      print("str = $str");
      if (str?.isNotEmpty == true) return jsonDecode(str);
    } catch (e) {
      print('error: $e');
      return null;
    }
    return null;
  }

  @override
  String toString() {
    return 'Config{_config: ${jsonEncode(_config)}}';
  }
}
