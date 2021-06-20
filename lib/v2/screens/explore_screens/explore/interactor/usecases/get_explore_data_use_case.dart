import 'package:seeds/v2/datasource/local/settings_storage.dart';
import 'package:seeds/v2/datasource/remote/api/balance_repository.dart';
import 'package:seeds/v2/datasource/remote/api/planted_repository.dart';
import 'package:seeds/v2/datasource/remote/api/profile_repository.dart';
import 'package:seeds/v2/datasource/remote/api/voice_repository.dart';

class GetExploreDataUseCase {
  final BalanceRepository _balanceRepository = BalanceRepository();
  final VoiceRepository _voiceRepository = VoiceRepository();
  final PlantedRepository _plantedRepository = PlantedRepository();
  final ProfileRepository _profileRepository = ProfileRepository();

  Future<List<Result>> run() {
    var account = settingsStorage.accountName;
    var futures = [
      _balanceRepository.getBalance(account),
      _plantedRepository.getPlanted(account),
      _voiceRepository.getAllianceVoice(account),
      _voiceRepository.getCampaignVoice(account),
      _profileRepository.isDHOMember(account)
    ];
    return Future.wait(futures);
  }
}
