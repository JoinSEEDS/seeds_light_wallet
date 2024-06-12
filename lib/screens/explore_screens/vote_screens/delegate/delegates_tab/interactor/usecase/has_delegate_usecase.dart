import 'package:seeds/datasource/local/settings_storage.dart';
import 'package:seeds/datasource/remote/api/http_repo/seeds_smart_contract_accounts.dart';
import 'package:seeds/datasource/remote/api/proposals_repository.dart';
import 'package:seeds/datasource/remote/model/delegate_model.dart';

/// whether or not a user has set a voice delegate
/// Feel free to juse use the getDelegate use case and call hasDelegate on
/// the result and delete this use case again.
class HasDelegateUseCase {
  final ProposalsRepository _proposalsRepository = ProposalsRepository();

  Future<bool> run() async {
    final account = settingsStorage.accountName;

    return _proposalsRepository
        .getDelegate(account, SeedsCode.voiceScopeCampaign)
        .then((value) => (value.asValue as DelegateModel?)?.hasDelegate ?? false);
  }
}
