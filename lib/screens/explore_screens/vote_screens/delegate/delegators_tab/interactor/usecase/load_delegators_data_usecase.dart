import 'package:async/async.dart';
import 'package:seeds/datasource/local/settings_storage.dart';
import 'package:seeds/datasource/remote/api/eos_repository.dart';
import 'package:seeds/datasource/remote/api/members_repository.dart';
import 'package:seeds/datasource/remote/api/proposals_repository.dart';
import 'package:seeds/datasource/remote/model/delegator_model.dart';

class LoadDelegatorsDataUseCase {
  final ProposalsRepository _proposalsRepository = ProposalsRepository();
  final MembersRepository _membersRepository = MembersRepository();

  Future<List<Result>> run() async {
    final account = settingsStorage.accountName;
    final result = await _proposalsRepository.getDelegators(account, EosRepository.voiceScopeCampaign);

    if (result.isError) {
      final List<Result> delegatorsResult = [result];
      return delegatorsResult;
    } else {
      final List<DelegatorModel> delegators = result.asValue!.value;

      final Iterable<Future<Result>> futures =
          delegators.map((e) => _membersRepository.getMemberByAccountName(e.delegator));

      return Future.wait(futures);
    }
  }
}
