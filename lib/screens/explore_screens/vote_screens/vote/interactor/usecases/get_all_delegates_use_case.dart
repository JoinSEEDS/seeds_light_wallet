import 'package:seeds/datasource/local/settings_storage.dart';
import 'package:seeds/datasource/remote/api/http_repo/seeds_smart_contract_accounts.dart';
import 'package:seeds/datasource/remote/api/proposals_repository.dart';
import 'package:seeds/domain-shared/result_to_state_mapper.dart';

class GetAllDelegatesDataUseCase {
  final ProposalsRepository _proposalsRepository = ProposalsRepository();

  Future<List<Result>> run() async {
    final account = settingsStorage.accountName;
    return Future.wait([
      _proposalsRepository.getDelegate(account, SeedsCode.voiceScopeAlliance),
      _proposalsRepository.getDelegate(account, SeedsCode.voiceScopeCampaign),
      _proposalsRepository.getDelegate(account, SeedsCode.voiceScopeMilestone)
    ]);
  }
}
