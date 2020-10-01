import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:seeds/providers/services/http_service.dart';

class VoteResult {
  int amount;
  bool voted;
  bool error;
  VoteResult(this.amount, this.voted, {this.error = false});
}

class VotedNotifier extends ChangeNotifier {
  HttpService _http;

  static of(BuildContext context, {bool listen = false}) =>
      Provider.of<VotedNotifier>(context, listen: listen);
 
  void update({HttpService http}) {
    _http = http;
  }

  Future<VoteResult> fetchVote({proposalId: int}) async {
     return _http.getVote(proposalId: proposalId);
  }
}
