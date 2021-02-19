import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';
import 'package:seeds/constants/system_accounts.dart';
import 'package:seeds/models/models.dart';
import 'package:seeds/providers/services/http_service.dart';
import 'package:seeds/utils/extensions/SafeHive.dart';

class MembersNotifier extends ChangeNotifier {
  HttpService _http;

  List<MemberModel> allMembers = [];
  List<MemberModel> visibleMembers = [];

  static of(BuildContext context, {bool listen = false}) =>
      Provider.of<MembersNotifier>(context, listen: listen);

  String filterName = '';

  void update({HttpService http}) async {
    _http = http;
  }

  void updateVisibleMembers() {
    if (filterName.isNotEmpty) {
      visibleMembers = allMembers.where((MemberModel member) {
        return member.nickname.toLowerCase().contains(filterName) ||
            member.account.contains(filterName);
      }).toList();
    } else {
      visibleMembers = allMembers.where((MemberModel member) {
        return member.image != '' &&
            member.nickname != '' &&
            member.account != '';
      }).toList();
    }
  }

  Future<MemberModel> getAccountDetails(String accountName) async {
    var box = await SafeHive.safeOpenBox('members');

    if (isSystemAccount(accountName)) {
      return getSystemAccount(accountName);
    }

    if (!box.containsKey(accountName)) {
      var member = await _http.getMember(accountName);

      if (member != null) {
        await box.put(accountName, member);
      } else {
        await box.put(
          accountName,
          MemberModel(
            account: accountName,
            nickname: 'Telos Account',
            image: '',
          ),
        );
      }
    }

    return box.get(accountName);
  }

  Future<void> fetchMembersCache() async {
    Box cacheMembers = await SafeHive.safeOpenBox<MemberModel>('members');

    if (cacheMembers != null && cacheMembers.isNotEmpty) {
      allMembers = cacheMembers.values.toList();
      updateVisibleMembers();
      notifyListeners();
    }
  }

  Future<void> addMembers(List<MemberModel> members) async {
    Box cacheMembers = await SafeHive.safeOpenBox<MemberModel>('members');
    members.forEach((actualMember) {
      var memberKey = actualMember.account;

      var cacheMember = cacheMembers.get(memberKey);

      if (cacheMember == null || cacheMember != actualMember) {
        cacheMembers.put(
          memberKey,
          MemberModel(
            nickname: actualMember.nickname.isNotEmpty
                ? actualMember.nickname
                : 'Seeds Account',
            account: actualMember.account,
            image: actualMember.image,
          ),
        );
      }
    });
    allMembers = cacheMembers.values.toList();
    updateVisibleMembers();

  }

  Future<void> refreshMembers() async {

    var actualMembers = await _http.getMembers();

    await addMembers(actualMembers);

    notifyListeners();
  }


  Future<void> filterMembers(String name) async {
    filterName = name.toLowerCase();

    updateVisibleMembers();

    if (filterName.length > 1 && visibleMembers.length < 10) {
      var moreMembers = await _http.getMembersWithFilter(filterName);
      await addMembers(moreMembers);
    }

    notifyListeners();
  }
}

