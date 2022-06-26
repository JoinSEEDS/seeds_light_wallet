// ignore_for_file: directives_ordering

import 'package:async/async.dart';
import 'package:seeds/crypto/eosdart/eosdart.dart';
import 'package:seeds/crypto/eosdart_ecc/eosdart_ecc.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:seeds/datasource/remote/api/eos_repo/eos_repository.dart';
import 'package:seeds/datasource/remote/api/eos_repo/seeds_eos_actions.dart';
import 'package:seeds/datasource/remote/api/http_repo/http_repository.dart';

class SignupRepository extends EosRepository with HttpRepository {
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

  /// Checks the availability of the given username on the blockchain, it will return the success response if the username
  /// is taken, otherwise returns an error
  Future<Result> isUsernameTaken(String username) async {
    final keyAccountsURL = '$baseURL/v1/chain/get_account';

    final requestBody = '{ "account_name": "$username" }';

    return http
        .post(Uri.parse(keyAccountsURL), body: requestBody)
        .then((response) => mapHttpResponse(response, (body) {
              // Username exists on the blockchain and is not available
              return null;
            }))
        .catchError((error) => mapHttpError(error));
  }

  Future<Result> createAccount({
    required String accountName,
    required String inviteSecret,
    required String displayName,
    required EOSPrivateKey privateKey,
  }) async {
    final EOSPublicKey publicKey = privateKey.toEOSPublicKey();

    final actions = <Action>[
      Action()
        ..account = onboardingAccountName
        ..name = SeedsEosAction.actionNameAcceptnew.value
        ..authorization = <Authorization>[
          Authorization()
            ..actor = onboardingAccountName
            ..permission = permissionApplication
        ]
        ..data = {
          'account': accountName,
          'publicKey': publicKey.toString(),
          'invite_secret': inviteSecret,
          'fullname': displayName,
        }
    ];

    final transaction = Transaction()..actions = actions;

    try {
      final dynamic response = await buildEosClient().pushTransaction(transaction);

      return mapEosResponse(response, (dynamic map) {
        return response['transaction_id'];
      });
    } catch (error) {
      print('SignupRepository:createAccount error $error');
      return mapEosError(error);
    }
  }
}
