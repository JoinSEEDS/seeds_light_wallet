import 'package:async/async.dart';
import 'package:http/http.dart' as http;
import 'package:seeds/datasource/remote/api/network_repository.dart';
import 'package:seeds/datasource/remote/model/member_model.dart';
import 'package:seeds/domain-shared/app_constants.dart';

class MembersRepository extends NetworkRepository {
  Future<Result> getMembers() {
    print('[http] get members');

    final membersURL = Uri.parse('$baseURL/v1/chain/get_table_rows');

    final request = createRequest(code: account_accounts, scope: account_accounts, table: tableUsers, limit: 1000);

    return http
        .post(membersURL, headers: headers, body: request)
        .then((http.Response response) => mapHttpResponse(response, (dynamic body) {
              final List<dynamic> allAccounts = body['rows'].toList();
              return allAccounts.map((item) => MemberModel.fromJson(item)).toList();
            }))
        .catchError((error) => mapHttpError(error));
  }

  /// Filter must be greater than 2 or we return empty list of users.
  Future<Result> getMembersWithFilter(String filter) {
    print('[http] getMembersWithFilter $filter ');
    assert(filter.length > 2);

    final lowerBound = filter;
    final upperBound = filter.padRight(12, 'z');

    final membersURL = Uri.parse('$baseURL/v1/chain/get_table_rows');

    final request = createRequest(
        code: account_accounts,
        scope: account_accounts,
        table: tableUsers,
        lowerBound: lowerBound,
        upperBound: upperBound,
        limit: 100);

    return http
        .post(membersURL, headers: headers, body: request)
        .then((http.Response response) => mapHttpResponse(response, (dynamic body) {
              final List<dynamic> allAccounts = body['rows'].toList();
              return allAccounts.map((item) => MemberModel.fromJson(item)).toList();
            }))
        .catchError((error) => mapHttpError(error));
  }

  /// accountName must be greater than 2 or we return empty list of users.
  /// This will return one account if found or null if not found.
  Future<Result> getMemberByAccountName(String accountName) {
    print('[http] getMemberByAccountName $accountName ');
    assert(accountName.length > 2);

    final membersURL = Uri.parse('$baseURL/v1/chain/get_table_rows');

    final request = createRequest(
        code: account_accounts,
        scope: account_accounts,
        table: tableUsers,
        lowerBound: accountName,
        upperBound: accountName);

    return http
        .post(membersURL, headers: headers, body: request)
        .then((http.Response response) => mapHttpResponse(response, (dynamic body) {
              final List<dynamic> allAccounts = body['rows'].toList();
              if (allAccounts.isNotEmpty) {
                return MemberModel.fromJson(allAccounts[0]);
              } else {
                return null;
              }
            }))
        .catchError((error) => mapHttpError(error));
  }

  Future<Result> getMembersWithFilterMongo(String filter) {
    print('[http] getMembersWithFilterMongo $filter ');
    assert(filter.length > 2);

  // TODO(n13): figure out if we want to do an "or" query here, or 2 queries
  // I think 2 queries is better, one on chain, one on this API, and combine the found results.
  
    final body = '''
  { 
      "collection":"accts.seeds-users",
      "query": { 
        "nickname": { "\$regex" : "$filter", "\$options" : "i" }
      },
      "projection":{
          "account":true,
          "status":true,
          "nickname":true,
          "type":true,
          "image":true,
          "reputation":true
      },
      "sort":{
        "nickname": 1
      },
      "skip":0,
      "limit": 12,
      "reverse": false
    }
        ''';

    return http
        .post(Uri.parse(mongodbURL), headers: headers, body: body)
        .then((http.Response response) => mapHttpResponse(response, (dynamic body) {
              final List<dynamic> allAccounts = body['rows'].toList();
              return allAccounts.map((item) => MemberModel.fromJson(item)).toList();
            }))
        .catchError((error) => mapHttpError(error));
  }
}
