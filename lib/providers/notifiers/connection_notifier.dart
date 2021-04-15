import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart';
import 'package:seeds/constants/config.dart';
import 'package:seeds/providers/services/firebase/firebase_database_map_keys.dart';
import 'package:seeds/providers/services/firebase/firebase_database_service.dart';

class Endpoint {
  final String url;
  final int ping;
  final DateTime lastChecked;
  const Endpoint(this.url, this.ping, this.lastChecked);

  @override
  String toString() {
    return "Endpoint: $url ping: $ping ";
  }

  bool get valid => ping < 60000;
}

const infinitePing = 1000000;
const doubleInfinitePing = 2000000;

class ConnectionNotifier extends ChangeNotifier {
  bool status = true;

  String currentEndpoint = Config.defaultEndpoint;
  int currentEndpointPing = 0;
  List<Endpoint> allEndpoints = [];

  List<String> hardCodedEndpoints = [
    Config.defaultEndpoint,
    "https://api.telos.kitchen",
    "https://node.hypha.earth",
    'https://mainnet.telosusa.io',
    'https://telos.eosphere.io',
    'https://telos.caleos.io',
    'https://api.eos.miami',
  ];

  List<String> serverEndpoints = [];

  void init() {
    discoverEndpoints();
    loadServerEndpoints();
    final CollectionReference reference = FirebaseFirestore.instance.collection(NODES_COLLECTION_KEY);
    reference.snapshots().listen((querySnapshot) {
        print("[ConnectionNotifier] changed endpoints");
        loadServerEndpoints();
    });

  }

  void loadServerEndpoints() async {
    var snapshot = await FirebaseDatabaseService().getNodeEndpoints();
    serverEndpoints = List<String>.from(snapshot.docs.map((e) => e.url())
      .where((element) => element != null));
    discoverEndpoints();
  }

  void discoverEndpoints() async {
    List<Future> checks = List<Future>();

    List<String> endpoints = serverEndpoints.length >= 2 ? serverEndpoints : (hardCodedEndpoints + serverEndpoints).toSet().toList();

    for (var endpoint in endpoints) {
      checks.add(checkEndpoint(endpoint));
    }

    var responses = await Future.wait(checks);

    responses.sort((a, b) => a.ping - b.ping);

    allEndpoints = List<Endpoint>.from(responses);

    currentEndpoint = responses[0].url;

    print("[ConnectionNotifier] using endpoint $currentEndpoint");
    
    currentEndpointPing = responses[0].ping;
    
    notifyListeners();

  }

  Future<Endpoint> checkEndpoint(String endpointURL) async {
    try {
      var ping = Stopwatch()..start();
      Response res = await get("$endpointURL/v1/chain/get_info");
      ping.stop();
      if (res.statusCode == 200) {
        int endpointPing = ping.elapsedMilliseconds;
        return Endpoint(endpointURL, endpointPing, DateTime.now());
      } else {
        return Endpoint(endpointURL, infinitePing, DateTime.now());
      }
    } catch (err) {
      print("error pinging: " + err);
      return Endpoint(endpointURL, doubleInfinitePing, DateTime.now());
    }
  }
}

extension EndpointSnapshot on QueryDocumentSnapshot {
  String url() {
      String url = this['url'];
      if (Uri.tryParse(url).isAbsolute) {
        return (url[url.length-1] == "/") ? 
          url.substring(0, url.length - 1) :
          url;
      } else {
        print("invalid endpoint URL: "+url);
        return null;
      }
  }
}