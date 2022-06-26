import 'package:async/async.dart';
import 'package:seeds/datasource/remote/api/http_repo/http_repository.dart';
import 'package:seeds/datasource/remote/api/http_repo/seeds_scopes.dart';
import 'package:seeds/datasource/remote/api/http_repo/seeds_tables.dart';
import 'package:seeds/datasource/remote/model/profile_model.dart';

class MembersRepository extends HttpRepository {
  Future<Result<List<ProfileModel>>> getMembers() {
    print('[http] get members');

    final membersURL = Uri.parse('$baseURL/v1/chain/get_table_rows');

    final request = createRequest(
        code: SeedsCode.accountAccounts,
        scope: SeedsCode.accountAccounts.value,
        table: SeedsTable.tableUsers,
        limit: 1000);

    return http
        .post(membersURL, body: request)
        .then((response) => mapHttpResponse<List<ProfileModel>>(response, (body) {
              final List<dynamic> allAccounts = body['rows'].toList();
              return allAccounts.map((item) => ProfileModel.fromJson(item)).toList();
            }))
        .catchError((error) => mapHttpError(error));
  }

  /// Filter must be greater than 2 or we return empty list of users.
  Future<Result<List<ProfileModel>>> getMembersWithFilter(String filter) {
    print('[http] getMembersWithFilter $filter ');
    assert(filter.length > 2);

    final lowerBound = filter;
    final upperBound = filter.padRight(12, 'z');

    final membersURL = Uri.parse('$baseURL/v1/chain/get_table_rows');

    final request = createRequest(
        code: SeedsCode.accountAccounts,
        scope: SeedsCode.accountAccounts.value,
        table: SeedsTable.tableUsers,
        lowerBound: lowerBound,
        upperBound: upperBound,
        limit: 100);

    return http
        .post(membersURL, body: request)
        .then((response) => mapHttpResponse<List<ProfileModel>>(response, (body) {
              final List<dynamic> allAccounts = body['rows'].toList();
              return allAccounts.map((item) => ProfileModel.fromJson(item)).toList();
            }))
        .catchError((error) => mapHttpError(error));
  }

  Future<Result<List<ProfileModel>>> getFullNameSearchMembers(String filter) async {
    print("[http] getFullNameSearchMembers $filter");

    final mongoUrl = Uri.parse("https://mongo-api.hypha.earth/find");

    final params = '''
    {
      "collection": "accts.seeds-users",
      "query": {
          "nickname": {
              "\$regex": "$filter",
              "\$options": "i"
          }
      },
      "projection": {},
      "sort": {
          "block_num": -1
      },
      "skip": 0,
      "limit": 20,
      "reverse": false
    }
    ''';

    return http
        .post(mongoUrl, body: params)
        .then((response) => mapHttpResponse<List<ProfileModel>>(response, (body) {
              final List<dynamic> allAccounts = body['items'].toList();
              return allAccounts.map((item) => ProfileModel.fromJson(item)).toList();
            }))
        .catchError((error) => mapHttpError(error));
  }

  // for now this returns 0 or 1 results
  /// I THINK THIS CALL IS NOT WORKING AS EXPECTED
  Future<Result<List<ProfileModel>>> getTelosAccounts(String filter) async {
    print('[http] getTelosAccounts');
    final url = Uri.parse('$baseURL/v1/chain/get_account');
    final body = '{ "account_name": "$filter" }';

    return http
        .post(url, body: body)
        .then((response) => mapHttpResponse<List<ProfileModel>>(response, (body) {
              return [
                ProfileModel.usingDefaultValues(
                  account: filter,
                  image: "assets/images/send/telos_logo.png",
                )
              ];
            }))
        .catchError((error) => mapHttpError(error));
  }

  /// accountName must be greater than 2 or we return empty list of users.
  /// This will return one account if found or null if not found.
  Future<Result<ProfileModel?>> getMemberByAccountName(String accountName) {
    print('[http] getMemberByAccountName $accountName ');
    assert(accountName.length > 2);

    final membersURL = Uri.parse('$baseURL/v1/chain/get_table_rows');

    final request = createRequest(
        code: SeedsCode.accountAccounts,
        scope: SeedsCode.accountAccounts.value,
        table: SeedsTable.tableUsers,
        lowerBound: accountName,
        upperBound: accountName);

    return http
        .post(membersURL, body: request)
        .then((response) => mapHttpResponse<ProfileModel?>(response, (body) {
              final List<dynamic> allAccounts = body['rows'].toList();
              if (allAccounts.isNotEmpty) {
                return ProfileModel.fromJson(allAccounts[0]);
              } else {
                return null;
              }
            }))
        .catchError((error) => mapHttpError(error));
  }
}
