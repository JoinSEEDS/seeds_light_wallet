import 'package:async/async.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:eosdart/eosdart.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:seeds/v2/datasource/remote/api/eos_repository.dart';
import 'package:seeds/v2/datasource/remote/api/network_repository.dart';
import 'package:seeds/v2/datasource/remote/model/transaction_response.dart';
import 'package:seeds/v2/domain-shared/ui_constants.dart';

class InviteRepository extends NetworkRepository with EosRepository {
  Future<Result> createInvite({
    required double quantity,
    required String inviteHash,
    required String accountName,
  }) async {
    print('[eos] create invite $inviteHash ($quantity)');

    var sowQuantity = 5;
    var transferQuantity = quantity - sowQuantity;

    var transaction = buildFreeTransaction([
      Action()
        ..account = 'token.seeds'
        ..name = 'transfer'
        ..authorization = [
          Authorization()
            ..actor = accountName
            ..permission = 'active'
        ]
        ..data = {
          'from': accountName,
          'to': 'join.seeds',
          'quantity': '${quantity.toStringAsFixed(4)} $currencySeedsCode',
          'memo': '',
        },
      Action()
        ..account = 'join.seeds'
        ..name = 'invite'
        ..authorization = [
          Authorization()
            ..actor = accountName
            ..permission = 'active'
        ]
        ..data = {
          'sponsor': accountName,
          'transfer_quantity': '${transferQuantity.toStringAsFixed(4)} $currencySeedsCode',
          'sow_quantity': '${sowQuantity.toStringAsFixed(4)} $currencySeedsCode',
          'invite_hash': inviteHash,
        }
    ], accountName);

    return buildEosClient()
        .pushTransaction(transaction, broadcast: true)
        .then((dynamic response) => mapEosResponse(response, (dynamic map) {
              return TransactionResponse.fromJson(map);
            }))
        .catchError((error) => mapEosError(error));
  }

  Future<Result> createInviteLink(String? inviteMnemonic) async {
    final parameters = DynamicLinkParameters(
      uriPrefix: 'https://seedswallet.page.link',
      link: Uri.parse('https://joinseeds.com/?placeholder=&inviteMnemonic=$inviteMnemonic'),
      androidParameters: AndroidParameters(packageName: 'com.joinseeds.seedswallet'),
      iosParameters: IosParameters(
        bundleId: 'com.joinseeds.seedslight',
        appStoreId: '1507143650',
      ),
    );

    final dynamicUrl = (await parameters.buildShortLink()).shortUrl;

    return ValueResult(dynamicUrl);
  }
}
