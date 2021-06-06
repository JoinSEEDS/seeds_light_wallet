import 'package:async/async.dart';
import 'package:http/http.dart' as http;
import 'package:seeds/v2/datasource/remote/api/network_repository.dart';
import 'package:seeds/v2/datasource/remote/model/proposals_model.dart';

class VotesRepository extends NetworkRepository {
  Future<Result> getProposals() async {
    print('[http] get proposals');

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
