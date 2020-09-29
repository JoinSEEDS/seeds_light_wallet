import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:seeds/providers/services/http_service.dart';

class VotedNotifier extends ChangeNotifier {
  Map<int, int> propVotes;// = {0: 0};

  HttpService _http;

  static of(BuildContext context, {bool listen = false}) =>
      Provider.of<VotedNotifier>(context, listen: listen);

  void init() {
    propVotes = {};
  }

  void update({HttpService http}) {
    _http = http;
  }

  Future<void> fetchVote({proposalId: int}) {
    return _http.getVote(proposalId: proposalId).then((result) {
      if (result != null) {
        propVotes[proposalId] = result;
      } else {
        propVotes.remove(proposalId);
      }
      notifyListeners();
    });
  }
}
