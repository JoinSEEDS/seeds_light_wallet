// ignore_for_file: directives_ordering

import 'package:async/async.dart';
import 'package:seeds/crypto/eosdart/eosdart.dart';
import 'package:seeds/crypto/dart_esr/dart_esr.dart' as esr;

import 'package:seeds/crypto/eosdart_ecc/eosdart_ecc.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:http/http.dart' as http;
import 'package:seeds/datasource/remote/api/eos_repo/eos_repository.dart';
import 'package:seeds/datasource/remote/api/eos_repo/seeds_eos_actions.dart';
import 'package:seeds/datasource/remote/api/http_repo/http_repository.dart';
import 'package:seeds/datasource/remote/api/http_repo/seeds_scopes.dart';
import 'package:seeds/datasource/remote/firebase/firebase_remote_config.dart';
import 'package:seeds/domain-shared/app_constants.dart';

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
        .post(
          Uri.parse(keyAccountsURL),
          body: requestBody,
        )
        .then((http.Response response) => mapHttpResponse(response, (dynamic body) {
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
        ..account = SeedsCode.accountJoin.value
        ..name = SeedsEosAction.actionNameAcceptnew.value
        ..authorization = <Authorization>[
          Authorization()
            ..actor = SeedsCode.accountJoin.value
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

  Future<Result<String>> generateEsrUrl(List<esr.Action> actions) async {
    print('[ESR] generateEsrUrl: ');

    final esr.SigningRequestCreateArguments args =
        esr.SigningRequestCreateArguments(actions: actions, chainId: telosChainId);

    return esr.SigningRequestManager.create(args,
            options: esr.defaultSigningRequestEncodingOptions(
              nodeUrl: remoteConfigurations.hyphaEndPoint,
            ))
        .then((esr.SigningRequestManager response) => ValueResult(response.encode()))
        // ignore: return_of_invalid_type_from_catch_error
        .catchError((error) => mapEosError(error));
  }

  Future<Result<String>> acceptExistAction({
    required String accountName,
    required String inviteSecret,
  }) async {
    final action = esr.Action()
      ..account = SeedsCode.accountJoin.value
      ..name = SeedsEosAction.actionNameAcceptExisting.value
      ..authorization = <esr.Authorization>[
        esr.Authorization()
          ..actor = SeedsCode.accountJoin.value
          ..permission = permissionApplication
      ]
      ..data = {
        'account': accountName,
        'invite_secret': inviteSecret,
      };
    final esrUrl = await generateEsrUrl([action]);
    return esrUrl;
  }
}
