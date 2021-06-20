import 'package:async/async.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:http/http.dart' as http;
import 'package:seeds/v2/datasource/remote/api/network_repository.dart';
import 'package:seeds/v2/datasource/remote/model/invite_model.dart';
import 'package:seeds/v2/domain-shared/app_constants.dart';

export 'package:async/src/result/result.dart';

class SignupRepository extends NetworkRepository {
  Future<Result> findInvite(String inviteHash) async {
    final inviteURL = '$hyphaURL/v1/chain/get_table_rows';

    var request = createRequest(
        code: account_join,
        scope: account_join,
        table: table_invites,
        lowerBound: inviteHash,
        upperBound: inviteHash,
        indexPosition: 2,
        keyType: 'sha256',
        limit: 1);

    return await http
        .post(Uri.parse(inviteURL), headers: headers, body: request)
        .then(
          (http.Response response) => mapHttpResponse(response, (dynamic body) {
            final rows = body['rows'];
            if (rows.isNotEmpty) {
              return InviteModel.fromJson(rows.first);
            } else {
              throw Exception('empty result at $inviteURL');
            }
          }),
        )
        .catchError((error) => mapHttpError(error));
  }

  Future<Result> unpackDynamicLink(String scannedLink) async {
    final PendingDynamicLinkData? unpackedLink =
        await FirebaseDynamicLinks.instance.getDynamicLink(Uri.parse(scannedLink));

    if (unpackedLink == null) {
      return mapHttpError('Link is invalid');
    } else {
      final Map<String, String> queryParams = Uri.splitQueryString(unpackedLink.link.toString());
      final String? inviteMnemonic = queryParams["inviteMnemonic"];
      if (inviteMnemonic == null) {
        return mapHttpError('Link is invalid');
      } else {
        return ValueResult(inviteMnemonic);
      }
    }
  }
}
