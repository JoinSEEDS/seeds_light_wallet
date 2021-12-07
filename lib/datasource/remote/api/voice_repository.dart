import 'package:async/async.dart';
import 'package:http/http.dart' as http;
import 'package:seeds/datasource/remote/api/http_repo/seeds_scopes.dart';
import 'package:seeds/datasource/remote/api/http_repo/seeds_tables.dart';
import 'package:seeds/datasource/remote/api/network_repository.dart';
import 'package:seeds/datasource/remote/model/voice_model.dart';
import 'package:seeds/domain-shared/app_constants.dart';

class VoiceRepository extends NetworkRepository {
  Future<Result<VoiceModel>> getCampaignVoice(String userAccount) {
    print('[http] get campaign voice: $userAccount');
    final voiceURL = Uri.parse('$baseURL/v1/chain/get_table_rows');

    final request = createRequest(
      code: SeedsScope.accountFunds,
      scope: SeedsScope.accountFunds.value,
      table: SeedsTable.tableVoice,
      lowerBound: userAccount,
      upperBound: userAccount,
    );

    return http
        .post(voiceURL, headers: headers, body: request)
        .then((http.Response response) => mapHttpResponse<VoiceModel>(response, (dynamic body) {
              return VoiceModel.fromJson(body);
            }))
        .catchError((error) => mapHttpError(error));
  }

  Future<Result<VoiceModel>> getAllianceVoice(String userAccount) {
    print('[http] get alliance voice: $userAccount');
    final voiceURL = Uri.parse('$baseURL/v1/chain/get_table_rows');

    final request = createRequest(
      code: SeedsScope.accountFunds,
      scope: 'alliance',
      table: SeedsTable.tableVoice,
      lowerBound: userAccount,
      upperBound: userAccount,
    );

    return http
        .post(voiceURL, headers: headers, body: request)
        .then((http.Response response) => mapHttpResponse<VoiceModel>(response, (dynamic body) {
              return VoiceModel.fromJson(body);
            }))
        .catchError((error) => mapHttpError(error));
  }

  Future<Result<VoiceModel>> getMilestoneVoice(String userAccount) {
    print('[http] get milestone voice: $userAccount');
    final voiceURL = Uri.parse('$baseURL/v1/chain/get_table_rows');

    final request = createRequest(
      code: SeedsScope.accountFunds,
      scope: 'milestone',
      table: SeedsTable.tableVoice,
      lowerBound: userAccount,
      upperBound: userAccount,
    );

    return http
        .post(voiceURL, headers: headers, body: request)
        .then((http.Response response) => mapHttpResponse<VoiceModel>(response, (dynamic body) {
              return VoiceModel.fromJson(body);
            }))
        .catchError((error) => mapHttpError(error));
  }

  Future<Result<VoiceModel>> getReferendumVoice(String userAccount) {
    print("[http] get referendum voice: $userAccount");
    final voiceURL = Uri.parse('$baseURL/v1/chain/get_table_rows');

    final request = createRequest(
        code: SeedsScope.accountRules,
        scope: SeedsScope.accountRules.value,
        table: SeedsTable.tableBalances,
        lowerBound: userAccount,
        upperBound: userAccount);

    return http
        .post(voiceURL, headers: headers, body: request)
        .then((http.Response response) => mapHttpResponse<VoiceModel>(response, (dynamic body) {
              return VoiceModel.fromBalanceJson(body);
            }))
        .catchError((error) => mapHttpError(error));
  }
}
