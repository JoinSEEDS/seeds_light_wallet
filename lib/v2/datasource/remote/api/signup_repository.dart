import 'package:async/async.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:http/http.dart' as http;
import 'package:seeds/v2/datasource/remote/api/network_repository.dart';
import 'package:seeds/v2/datasource/remote/model/invite_model.dart';

class SignupRepository extends NetworkRepository {
  Future<Result> findInvite(String inviteHash) async {
    final inviteURL = '$hyphaURL/v1/chain/get_table_rows';

    final request =
        '{"json":true,"code":"join.seeds","scope":"join.seeds","table":"invites","lower_bound":"$inviteHash","upper_bound":"$inviteHash","index_position":2,"key_type":"sha256","limit":1,"reverse":false,"show_payer":false}';
    final headers = <String, String>{'Content-type': 'application/json'};

    try {
      final http.Response response = await http.post(Uri.parse(inviteURL),
          headers: headers, body: request);

      return mapHttpResponse(response, (dynamic body) {
        final rows = body['rows'];
        if (rows.isNotEmpty) {
          return InviteModel.fromJson(rows.first);
        } else {
          throw Exception('empty result at $inviteURL');
        }
      });
    } on Exception catch (error) {
      return mapHttpError(error);
    }
  }

  Future<Result> unpackDynamicLink(String scannedLink) async {
    final PendingDynamicLinkData? unpackedLink = await FirebaseDynamicLinks
        .instance
        .getDynamicLink(Uri.parse(scannedLink));

    if (unpackedLink == null) {
      return mapHttpError('Link is invalid');
    } else {
      final Map<String, String> queryParams =
          Uri.splitQueryString(unpackedLink.link.toString());
      final String? inviteMnemonic = queryParams["inviteMnemonic"];
      if (inviteMnemonic == null) {
        return mapHttpError('Link is invalid');
      } else {
        return ValueResult(inviteMnemonic);
      }
    }
  }
}
