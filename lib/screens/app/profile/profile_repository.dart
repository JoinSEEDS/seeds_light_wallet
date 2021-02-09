import 'dart:convert';

import 'package:seeds/models/models.dart';
import 'package:http/http.dart' as http;

class ProfileRepository {
  Future<ProfileModel> getProfile() async {
    final String profileURL = 'https://mainnet.telosusa.io/v1/chain/get_table_rows';

    String request =
        '{"json":true,"code":"accts.seeds","scope":"accts.seeds","table":"users","table_key":"","lower_bound":" raul11111111","upper_bound":" raul11111111","index_position":1,"key_type":"i64","limit":1,"reverse":false,"show_payer":false}';
    Map<String, String> headers = {"Content-type": "application/json"};

    final res = await http.post(profileURL, headers: headers, body: request);
    if (res.statusCode == 200) {
      var body = json.decode(res.body);
      return ProfileModel.fromJson(body["rows"][0]);
    } else {
      print('Cannot fetch profile...');
      return ProfileModel();
    }
  }
}
