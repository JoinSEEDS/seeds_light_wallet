import 'package:async/async.dart';
import 'package:http/http.dart' as http;
import 'package:seeds/v2/datasource/remote/api/network_repository.dart';
import 'package:seeds/v2/datasource/remote/model/voice_model_alliance.dart';
import 'package:seeds/v2/datasource/remote/model/voice_model_campaign.dart';
import 'package:seeds/v2/domain-shared/app_constants.dart';

export 'package:async/src/result/result.dart';

class VoiceRepository extends NetworkRepository {
  Future<Result> getCampaignVoice(String userAccount) async {
    print('[http] get seeds getCampaignVoice $userAccount');
    final voiceURL = Uri.parse('$baseURL/v1/chain/get_table_rows');

    var request = createRequest(
        code: account_funds,
        scope: account_funds,
        table: table_voice,
        lowerBound: userAccount,
        upperBound: userAccount,
        limit: 1);

    return http
        .post(voiceURL, headers: headers, body: request)
        .then((http.Response response) => mapHttpResponse(response, (dynamic body) {
              return VoiceModelCampaign.fromJson(body);
            }))
        .catchError((error) => mapHttpError(error));
  }

  Future<Result> getAllianceVoice(String userAccount) async {
    print('[http] get seeds getAllianceVoice $userAccount');
    final voiceURL = Uri.parse('$baseURL/v1/chain/get_table_rows');

    var request = createRequest(
        code: account_funds,
        scope: account_alliance,
        table: table_voice,
        lowerBound: userAccount,
        upperBound: userAccount,
        limit: 1);

    return http
        .post(voiceURL, headers: headers, body: request)
        .then((http.Response response) => mapHttpResponse(response, (dynamic body) {
              return VoiceModelAlliance.fromJson(body);
            }))
        .catchError((error) => mapHttpError(error));
  }
}
