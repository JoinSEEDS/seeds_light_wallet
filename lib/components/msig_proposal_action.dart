import 'dart:async';

import 'package:seeds/crypto/dart_esr/dart_esr.dart' as esr;
import 'package:seeds/crypto/dart_esr/src/models/authorization.dart';
import 'package:seeds/crypto/eosdart/eosdart.dart' as eos;
import 'package:seeds/datasource/remote/api/eosaccount_repository.dart';
import 'package:seeds/datasource/remote/firebase/firebase_remote_config.dart';
import 'package:seeds/design/app_colors.dart';
import 'package:seeds/domain-shared/app_constants.dart';
import 'package:seeds/utils/result_extension.dart';


class MsigProposal {
  // note we only pay attention to the first auth entry
  static FutureOr<esr.Action?> msigProposalAction(
    {required List<esr.Action> actions, required List<esr.Authorization?> auth, required String proposer, required String proposalName, int version = 2}) async {
        final _accountRepository = EOSAccountRepository();
        final account_info = (await _accountRepository.getEOSAccount(auth[0]!.actor!)).asValue!.value;
        final requiredAuthAccounts = account_info.permissions.permissions
          .firstWhere((p) => p.perm_name == auth[0]!.permission!).required_auth.accounts
          .where((a) => a.permission != "eosio.code");
        if (requiredAuthAccounts.isEmpty) {
          return null;
        }
      final requested = requiredAuthAccounts.map((e) => { "actor": e.permission.actor, "permission": e.permission.permission}).toList();
  
        final esr.SigningRequestCreateArguments args = esr.SigningRequestCreateArguments(actions: actions, chainId: chainId);

        var request = await esr.SigningRequestManager.create(args,
            options: esr.defaultSigningRequestEncodingOptions(
              nodeUrl: remoteConfigurations.defaultEndPointUrl,
            ));

        var ax = request.signingRequest.req![1] as Map<String, dynamic>;
        var trx = {
          "expiration" : DateTime.now().add(Duration(days: 1)).toString(),
          "ref_block_num" : 0,
          "ref_block_prefix" : 0,
          "context_free_actions" : [],
          "transaction_extensions" : [],
          "delay_sec" : 0,
          "max_cpu_usage_ms" : 0,
          "max_net_usage_words" : 0,
          "actions" : [ ax ] // >1 actions?
        };
        return esr.Action()
          ..account = "eosio.msig"
          ..name = "propose"
          ..data = {
            "proposal_name": proposalName,
            "proposer": proposer,
            "requested": requested,
            "trx": trx,
          }
          ..authorization = [esr.Authorization() ..actor = proposer ..permission =  "active"]
        ;
  }

  static FutureOr<bool> IsMsigCandidate(String errorString, eos.Transaction transaction) async {
    if (!(errorString.contains('missing_auth_exception')
      || errorString.contains('unsatisfied_authorization'))) {
        return false;
      };
    // TODO check that the threshold is greater than 1 and 
    // that there are at least two "account" type auths (excluding eosio.code's)
    return true;
  }
}
