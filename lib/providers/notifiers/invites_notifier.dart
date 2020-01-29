import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:seeds/models/models.dart';
import 'package:seeds/providers/notifiers/members_notifier.dart';
import 'package:seeds/providers/services/http_service.dart';

class InvitesNotifier extends ChangeNotifier {
  HttpService _http;

  List<InviteModel> invites;

  static of(BuildContext context, {bool listen = false}) =>
      Provider.of<MembersNotifier>(context, listen: listen);

  void init({HttpService http}) {
    print("init invites... ");
    print(http);
    _http = http;
  }

  Future fetchInvites() async {
    invites = await _http.getInvites();
    notifyListeners();
  }
}
