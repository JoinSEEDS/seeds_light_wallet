import 'package:async/async.dart';
import 'package:seeds/v2/datasource/local/settings_storage.dart';
import 'package:seeds/v2/datasource/remote/api/profile_repository.dart';
import 'package:seeds/v2/datasource/remote/api/proposals_repository.dart';
import 'package:seeds/v2/datasource/remote/api/voice_repository.dart';
import 'package:seeds/v2/datasource/remote/model/proposals_model.dart';

class GetProposalDataUseCase {
  final ProfileRepository _profileRepository = ProfileRepository();
  final ProposalsRepository _proposalsRepository = ProposalsRepository();
  final VoiceRepository _voiceRepository = VoiceRepository();

  Future<List<Result>> run(ProposalModel proposal) {
    final userAccount = settingsStorage.accountName;
    final _getVoice = proposal.campaignType == 'alliance'
        ? _voiceRepository.getAllianceVoice(userAccount)
        : _voiceRepository.getCampaignVoice(userAccount);

    var futures = [
      _profileRepository.getProfile(proposal.creator),
      _proposalsRepository.getVote(proposal.id, userAccount),
      _getVoice,
    ];
    return Future.wait(futures);
  }
}
