import 'package:flutter/material.dart';
import 'package:seeds/models/models.dart';
import 'package:seeds/providers/services/http_service.dart';
import 'package:provider/provider.dart';

class MembersNotifier extends ChangeNotifier {
  HttpService _http;

  List<MemberModel> members;
  List<MemberModel> membersSearch;

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
      membersSearch = result;
      notifyListeners();
    });
  }

  List<MemberModel> searchMembers(String name) {
    if (members != null) {
       print("searchMembers is working:$name");
    }
    if (name !='') {
        List<MemberModel> res = [];
        for (var item in members) {
            if (item.nickname.startsWith(name) ){
                res.add(item);
            }
        }
       membersSearch = res; 
    } else {
      membersSearch = members;
    }
    return membersSearch;
  }
}