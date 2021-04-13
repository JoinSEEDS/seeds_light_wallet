

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:seeds/models/models.dart';
import 'package:seeds/providers/services/http_service.dart';

class InvitesNotifier extends ChangeNotifier {
  HttpService? _http;

  List<InviteModel>? activeInvites;
  List<String?>? invitedMembers;
  Map<String, String>? inviteSecrets;

  static InvitesNotifier of(BuildContext context, {bool listen = false}) =>
      Provider.of<InvitesNotifier>(context, listen: listen);

  void init({HttpService? http}) {
    _http = http;
  }

  Future fetchInvites() async {
    var allInvites = await (_http!.getInvites());

    activeInvites = allInvites!.where((invite) => invite.account!.isEmpty).toList();
    invitedMembers = allInvites
        .where((invite) => invite.account!.isNotEmpty)
        .map((invite) => invite.account)
        .toList();
    inviteSecrets = retrieveFromSharedPreferences(activeInvites);

    notifyListeners();
  }

  Map<String, String> retrieveFromSharedPreferences(List<InviteModel>? invites) {
    return {};
  }
}
