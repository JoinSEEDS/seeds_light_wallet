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
  final bool historyV1;
  const Endpoint(this.url, this.ping, this.lastChecked, this.historyV1);

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
  String historyEndpoint = Config.defaultEndpoint;
  int currentEndpointPing = 0;
  List<Endpoint> allEndpoints = [];

  List<String> hardCodedEndpoints = [
    Config.defaultEndpoint,
    "https://api.telos.kitchen",
    "https://node.hypha.earth",
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
    print("[loadServerEndpoints]");
    var snapshot = await FirebaseDatabaseService().getNodeEndpoints();
    serverEndpoints = List<String>.from(snapshot.docs.map((e) => e.url())
      .where((element) => element != null));
    discoverEndpoints();
  }

  void discoverEndpoints() async {
    
    print("[discoverEndpoints] [${serverEndpoints.length}]");

    List<Future> checks = List<Future>();

    List<String> endpoints = serverEndpoints.length >= 2 ? serverEndpoints : (hardCodedEndpoints + serverEndpoints).toSet().toList();

    for (var endpoint in endpoints) {
      checks.add(checkEndpoint(endpoint));
    }

    var responses = await Future.wait(checks);

    responses.sort((a, b) => a.ping - b.ping);

    allEndpoints = List<Endpoint>.from(responses);

    currentEndpoint = responses[0].url;

    historyEndpoint = responses.firstWhere((element) => element.historyV1)?.url;

    print("[ConnectionNotifier] using endpoint $currentEndpoint ${responses[0].ping} historyV1: $historyEndpoint");
    
    currentEndpointPing = responses[0].ping;
    
    notifyListeners();

  }

  Future<Endpoint> checkEndpoint(String endpointURL) async {
    try {
      var ping = Stopwatch()..start();
      Response res = await get("$endpointURL/v1/chain/get_info");
      ping.stop();
      if (res.statusCode == 200) {
        var history = await testHasHistory(endpointURL);
        //print("has history: $endpointURL: $history ${ping.elapsedMilliseconds} ms");
        return Endpoint(endpointURL, ping.elapsedMilliseconds, DateTime.now(), history);
      } else {
        return Endpoint(endpointURL, infinitePing, DateTime.now(), false);
      }
    } catch (err) {
      print("error pinging: ${err.toString()}");
      return Endpoint(endpointURL, doubleInfinitePing, DateTime.now(), false);
    }
  }
}
  Future<bool> testHasHistory(String endpointURL) async {
    final String url = "$endpointURL/v1/history/get_actions";
    var params = '''{ 
      "account_name": "testingseeds",
      "pos": -1,
      "offset": -1
    }''';
    Map<String, String> headers = {"Content-type": "application/json"};
    Response res = await post(url, headers: headers, body: params);
    if (res.statusCode == 200) {
      return true;
    } else {
      return false;
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