import 'package:flutter/material.dart';
import 'package:seeds/models/models.dart';
import 'package:seeds/services/http_service.dart';

class MembersModel extends ChangeNotifier {
  HttpService _http;

  MembersModel({ http }) {
    _http = http;
  }

  List<Member> members;

  void fetchMembers() {
    print("fetch members");

    _http.getMembers().then((result) {
      print("done - fetch members");
      members = result;
      notifyListeners();
    });
  }

  void initDependencies(HttpService http) {
    print("members init dependencies...");

    if (_http == null) {
      _http = http;
      fetchMembers();
    }
  }
}