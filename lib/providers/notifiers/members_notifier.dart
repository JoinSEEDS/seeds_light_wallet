import 'package:flutter/material.dart';
import 'package:seeds/models/models.dart';
import 'package:seeds/providers/services/http_service.dart';
import 'package:provider/provider.dart';

class MembersNotifier extends ChangeNotifier {
  HttpService _http;

  List<MemberModel> members;

  static of(BuildContext context, {bool listen = false}) =>
      Provider.of<MembersNotifier>(context, listen: listen);

  void init({ HttpService http }) {
    if (_http == null) {
      _http = http;
      fetchMembers();
    }
  }

  void fetchMembers() {
    _http.getMembers().then((result) {
      members = result;
      notifyListeners();
    });
  }

  List<MemberModel> searchMembers(name) {
    if (members != null) {
       print("searchMembers is working:$name");
    }
    print("searchMembers return:$members[0]");
    return members;
  }
}