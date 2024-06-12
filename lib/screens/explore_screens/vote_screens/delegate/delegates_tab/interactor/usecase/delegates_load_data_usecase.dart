import 'package:async/async.dart';
import 'package:seeds/datasource/local/settings_storage.dart';
import 'package:seeds/datasource/remote/api/http_repo/seeds_smart_contract_accounts.dart';
import 'package:seeds/datasource/remote/api/members_repository.dart';
import 'package:seeds/datasource/remote/api/proposals_repository.dart';
import 'package:seeds/datasource/remote/model/delegate_model.dart';

class DelegatesLoadDataUseCase {
  final ProposalsRepository _proposalsRepository = ProposalsRepository();
  final MembersRepository _membersRepository = MembersRepository();

  Future<Result?> run() async {
    final account = settingsStorage.accountName;
    final result = await _proposalsRepository.getDelegate(account, SeedsCode.voiceScopeCampaign);

    if (result.isError) {
      return null;
    } else {
      final DelegateModel delegate = result.asValue!.value;
      if (delegate.delegatee.isEmpty) {
        return result;
      } else {
        return _membersRepository.getMemberByAccountName(delegate.delegatee);
      }
    }
  }
}
