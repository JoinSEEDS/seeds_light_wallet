import 'package:async/async.dart';
import 'package:http/http.dart' as http;
import 'package:seeds/v2/datasource/remote/api/network_repository.dart';
import 'package:seeds/v2/datasource/remote/model/voice_model_campaign.dart';

export 'package:async/src/result/error.dart';
export 'package:async/src/result/result.dart';

class VoiceRepository extends NetworkRepository {
  Future<Result> getCampaignVoice(String userAccount) async {
    print('[http] get seeds getCampaignVoice $userAccount');
    final voiceURL = '$baseURL/v1/chain/get_table_rows';

    var request =
        '{"json":true,"code":"funds.seeds","scope":"funds.seeds","table":"voice","table_key":"","lower_bound":"$userAccount","upper_bound":"$userAccount","index_position":1,"key_type":"i64","limit":"1","reverse":false,"show_payer":false}';

    return http
        .post(voiceURL, headers: headers, body: request)
        .then((http.Response response) => mapHttpResponse(response, (dynamic body) {
              return VoiceModelCampaign.fromJson(body);
            }))
        .catchError((error) => mapHttpError(error));
  }

  Future<Result> getAllianceVoice(String userAccount) async {
    print('[http] get seeds getAllianceVoice $userAccount');
    final voiceURL = '$baseURL/v1/chain/get_table_rows';

    var request =
        '{"json":true,"code":"funds.seeds","scope":"alliance","table":"voice","table_key":"","lower_bound":"$userAccount","upper_bound":"$userAccount","index_position":1,"key_type":"i64","limit":"1","reverse":false,"show_payer":false}';

    return http
        .post(voiceURL, headers: headers, body: request)
        .then((http.Response response) => mapHttpResponse(response, (dynamic body) {
              return VoiceModelCampaign.fromJson(body);
            }))
        .catchError((error) => mapHttpError(error));
  }
}
