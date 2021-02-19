import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';
import 'package:seeds/providers/services/http_service.dart';
import 'package:seeds/utils/extensions/SafeHive.dart';

class VoteResult {
  int amount;
  bool voted;
  bool error;
  VoteResult(this.amount, this.voted, {this.error = false});
}

class VotedNotifier extends ChangeNotifier {
  HttpService _http;

  static VotedNotifier of(BuildContext context, {bool listen = false}) =>
      Provider.of<VotedNotifier>(context, listen: listen);
 
  void update({HttpService http}) {
    _http = http;
  }

  Future<VoteResult> fetchVote({proposalId = int}) async {
    Box box = await SafeHive.safeOpenBox<VoteResult>('votes.1.box');
    VoteResult result = box.get(proposalId);
    if (result == null) {
      result = await _http.getVote(proposalId: proposalId);
      if (result.voted && !result.error) {
        await box.put(proposalId, result);
      }
    }
    return result;
  }
}
