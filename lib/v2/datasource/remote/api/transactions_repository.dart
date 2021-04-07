import 'dart:convert';

import 'package:seeds/models/models.dart';
import 'package:seeds/v2/datasource/remote/api/network_repository.dart';
import 'package:async/async.dart';
import 'package:http/http.dart';

class TransactionsRepository extends NetworkRepository {
  Future<Result> getSeedsTransactions(String userAccount) async {
    print('[http] get seeds transactions $userAccount');

    try {
      final response = await post(
        '$mongoURL/find',
        headers: headers,
        body: jsonEncode({
          "collection": "action_traces",
          "query": {
            "act.account": "token.seeds",
            "act.name": "transfer",
            "\$or": [
              {"act.data.from": userAccount},
              {"act.data.to": userAccount},
            ],
          }
        }),
      );

      return mapHttpResponse(response, (body) {
        return body['items']
            .map(
              (item) => TransactionModel.fromJsonMongo(item),
            )
            .toList();
      });
    } catch (err) {
      return mapHttpError(err);
    }
  }

  Future<Result> getHyphaTransactions(String userAccount) async {
    print('[http] get hypha transactions $userAccount');

    try {
      final response = await post(
        '$mongoURL/find',
        headers: headers,
        body: jsonEncode({
          "collection": "action_traces",
          "query": {
            "act.account": "token.hypha",
            "act.name": "transfer",
            "\$or": [
              {"act.data.from": userAccount},
              {"act.data.to": userAccount},
            ],
          }
        }),
      );

      return mapHttpResponse(
          response,
          (body) => body['items']
              .map(
                (item) => TransactionModel.fromJsonMongo(item),
              )
              .toList());
    } catch (err) {
      return mapHttpError(err);
    }
  }

  Future<Result> getPlantedTransactions(String userAccount) async {
    print('[http] get planted transactions $userAccount');

    try {
      final response = await post(
        '$mongoURL/find',
        headers: headers,
        body: jsonEncode({
          "collection": "action_traces",
          "query": {
            "act.account": "token.seeds",
            "act.name": "transfer",
            "\$or": [
              {"act.data.from": "harvst.seeds"},
              {"act.data.to": "harvst.seeds"}
            ],
          }
        }),
      );

      return mapHttpResponse(
        response,
        (body) => body['items'].map((item) => TransactionModel.fromJsonMongo(item)).toList();
      );
    } catch (err) {
      return mapHttpError(err);
    }
  }
}
