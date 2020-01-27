import 'package:flutter/material.dart';
import 'package:seeds/models/models.dart';
import 'package:seeds/providers/services/http_service.dart';
import 'package:provider/provider.dart';

class MembersNotifier extends ChangeNotifier {
  HttpService _http;

  List<MemberModel> allMembers;
  List<MemberModel> visibleMembers;

  static of(BuildContext context, {bool listen = false}) =>
      Provider.of<MembersNotifier>(context, listen: listen);

  void update({HttpService http}) {
    _http = http;
  }

  void fetchMembers() {
    _http.getMembers().then((result) {
      allMembers = result;
      visibleMembers = allMembers.where((MemberModel member) {
        return member.image != "" &&
            member.nickname != "" &&
            member.account != "";
      }).toList();
      notifyListeners();
    });
  }

  void filterMembers(String name) {
    if (name.isNotEmpty) {
      visibleMembers = allMembers.where((MemberModel member) {
        return member.nickname.contains(name) || member.account.contains(name);
      }).toList();
    } else {
      visibleMembers = allMembers.where((MemberModel member) {
        return member.image != "" &&
            member.nickname != "" &&
            member.account != "";
      }).toList();
    }
    notifyListeners();
  }
}
