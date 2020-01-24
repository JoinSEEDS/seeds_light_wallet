import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:seeds/models/models.dart';
import 'package:seeds/providers/services/http_service.dart';

class MembersNotifier extends ChangeNotifier {
  HttpService _http;

  List<MemberModel> members;

  static of(BuildContext context, {bool listen = false}) =>
      Provider.of<MembersNotifier>(context, listen: listen);

  void update({HttpService http}) {
    _http = http;
  }

  void fetchMembers() {
    _http.getMembers().then((result) {
      members = result;
      notifyListeners();
    });
  }
}
