import 'package:async/async.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:eosdart/eosdart.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:seeds/v2/datasource/remote/api/eos_repository.dart';
import 'package:seeds/v2/datasource/remote/api/network_repository.dart';
import 'package:seeds/v2/datasource/remote/model/transaction_response.dart';
import 'package:seeds/v2/domain-shared/app_constants.dart';
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
        ..account = account_token
        ..name = transfer
        ..authorization = [
          Authorization()
            ..actor = accountName
            ..permission = permission_active
        ]
        ..data = {
          'from': accountName,
          'to': account_join,
          'quantity': '${quantity.toStringAsFixed(4)} $currencySeedsCode',
          'memo': '',
        },
      Action()
        ..account = account_join
        ..name = invite
        ..authorization = [
          Authorization()
            ..actor = accountName
            ..permission = permission_active
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
      uriPrefix: domain_app_uri_prefix,
      link: Uri.parse('$target_link$inviteMnemonic'),
      androidParameters: AndroidParameters(packageName: android_pacakage_name),
      iosParameters: IosParameters(bundleId: ios_bundle_id, appStoreId: ios_app_store_id),
    );

    final dynamicUrl = (await parameters.buildShortLink()).shortUrl;

    return ValueResult(dynamicUrl);
  }
}
