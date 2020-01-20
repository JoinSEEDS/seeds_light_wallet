import 'package:flutter/foundation.dart';
import 'package:seeds/constants/config.dart';

class ConnectionNotifier extends ChangeNotifier {
  String currentEndpoint = Config.defaultEndpoint;

  final availableEndpoints = [
    'https://mainnet.telosusa.io',
    'https://telos.eosphere.io',
    'https://telos.caleos.io',
    'https://api.telosfoundation.io'
  ];

  void init() {
    discoverEndpoints();
  }

  void discoverEndpoints() {
    Future.delayed(Duration(seconds: 1), () {
      currentEndpoint = availableEndpoints[2];
      notifyListeners();
    });
  }
}