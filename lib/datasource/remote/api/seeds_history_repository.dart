import 'package:async/async.dart';
import 'package:seeds/datasource/remote/api/http_repo/http_repository.dart';
import 'package:seeds/datasource/remote/api/http_repo/seeds_scopes.dart';
import 'package:seeds/datasource/remote/api/http_repo/seeds_tables.dart';
import 'package:seeds/datasource/remote/model/seeds_history_model.dart';

///Seeds History Table
class SeedsHistoryRepository extends HttpRepository {
  Future<Result<SeedsHistoryModel>> getNumberOfTransactions(String userAccount) {
    print('[http] get seeds seeds history for account: $userAccount ');

    final String request = createRequest(
      code: SeedsCode.historySeeds,
      scope: SeedsCode.historySeeds.value,
      table: SeedsTable.tableTotals,
      lowerBound: userAccount,
      upperBound: userAccount,
    );

    final seedsHistoryURL = Uri.parse('$hyphaURL/v1/chain/get_table_rows');

    return http
        .post(seedsHistoryURL, body: request)
        .then((response) => mapHttpResponse<SeedsHistoryModel>(response, (body) => SeedsHistoryModel.fromJson(body)))
        .catchError((error) => mapHttpError(error));
  }
}
