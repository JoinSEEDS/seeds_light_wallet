import 'package:async/async.dart';
import 'package:http/http.dart' as http;
import 'package:seeds/v2/datasource/remote/api/network_repository.dart';
import 'package:seeds/v2/datasource/remote/model/moon_phase_model.dart';
import 'package:seeds/v2/datasource/remote/model/proposals_model.dart';
import 'package:seeds/v2/screens/explore_screens/vote_screens/vote/interactor/viewmodels/proposal_type_model.dart';

class ProposalsRepository extends NetworkRepository {
  Future<Result> getMoonPhases() async {
    print('[http] get moon phases');

    var request = createRequest(
      code: account_cycle,
      scope: account_cycle,
      table: table_moonphases,
      limit: 4,
      keyType: '',
      lowerBound: '${DateTime.now().millisecondsSinceEpoch}',
    );

    final proposalsURL = Uri.parse('$baseURL/v1/chain/get_table_rows');

    return http
        .post(proposalsURL, headers: headers, body: request)
        .then((http.Response response) => mapHttpResponse(response, (dynamic body) {
              return MoonPhasesList.fromJson(body);
            }))
        .catchError((error) => mapHttpError(error));
  }

  Future<Result> getProposals(ProposalType proposalType) async {
    print('[http] get proposals type - ${proposalType.type}');

    var request = createRequest(code: account_funds, scope: account_funds, table: table_props, limit: 1000);

    final proposalsURL = Uri.parse('$baseURL/v1/chain/get_table_rows');

    return http
        .post(proposalsURL, headers: headers, body: request)
        .then((http.Response response) => mapHttpResponse(response, (dynamic body) {
              return ProposalsModel.fromJson(body);
            }))
        .catchError((error) => mapHttpError(error));
  }
}
