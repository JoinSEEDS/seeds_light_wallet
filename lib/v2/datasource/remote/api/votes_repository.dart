import 'package:async/async.dart';
import 'package:http/http.dart' as http;
import 'package:seeds/v2/datasource/remote/api/network_repository.dart';
import 'package:seeds/v2/datasource/remote/model/proposals_model.dart';
import 'package:seeds/v2/screens/explore_screens/vote/interactor/viewmodels/proposal_type_model.dart';

class VotesRepository extends NetworkRepository {
  Future<Result> getProposals(ProposalType proposalType) async {
    print('[http] get proposals type - ${proposalType.type}');

    final proposalsURL = Uri.parse('$baseURL/v1/chain/get_table_rows');

    var request =
        '{"json":true,"code":"funds.seeds","scope":"funds.seeds","table":"props","table_key":"","lower_bound":"","upper_bound":"","index_position":1,"key_type":"i64","limit":"1000","reverse":false,"show_payer":false}';

    return http
        .post(proposalsURL, headers: headers, body: request)
        .then((http.Response response) => mapHttpResponse(response, (dynamic body) {
              return ProposalsModel.fromJson(body);
            }))
        .catchError((error) => mapHttpError(error));
  }
}
