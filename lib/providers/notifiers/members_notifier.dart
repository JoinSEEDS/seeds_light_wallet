import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:seeds/models/models.dart';
import 'package:seeds/providers/services/http_service.dart';
import 'package:provider/provider.dart';
import 'package:seeds/constants/system_accounts.dart';

class MembersNotifier extends ChangeNotifier {
  HttpService _http;

  List<MemberModel> allMembers;
  List<MemberModel> visibleMembers;

  static of(BuildContext context, {bool listen = false}) =>
      Provider.of<MembersNotifier>(context, listen: listen);

  String filterName = '';

  void update({HttpService http}) async {
    _http = http;
  }

  void updateVisibleMembers() {
    if (filterName.isNotEmpty) {
      visibleMembers = allMembers.where((MemberModel member) {
        return member.nickname.contains(filterName) || member.account.contains(filterName);
      }).toList();
    } else {
      visibleMembers = allMembers.where((MemberModel member) {
        return member.image != "" &&
            member.nickname != "" &&
            member.account != "";
      }).toList();
    }
  }

  Future<MemberModel> getAccountDetails(String accountName) async {
    var box = await Hive.openBox<MemberModel>("members");

    if (isSystemAccount(accountName)) {
      return getSystemAccount(accountName);
    }

    if (!box.containsKey(accountName)) {
      MemberModel member = await _http.getMember(accountName);

      if (member != null) {
        box.put(accountName, member);
      }
    }

    return box.get(accountName) ?? MemberModel(
      account: accountName,
      nickname: "Anonymous",
      image: "",
    );
  }

  Future<void> refreshMembers() async {
    var cacheMembers = await Hive.openBox<MemberModel>("members");

    var actualMembers = await _http.getMembers();

    actualMembers.forEach((actualMember) {
      var memberKey = actualMember.account;

      var cacheMember = cacheMembers.get(memberKey);

      if (cacheMember == null || cacheMember != actualMember) {
        cacheMembers.put(memberKey, cacheMember);
      }
    });

    allMembers = cacheMembers.values.toList();

    updateVisibleMembers();

    notifyListeners();
  }

  void filterMembers(String name) {
    filterName = name;

    updateVisibleMembers();

    notifyListeners();
  }
}
