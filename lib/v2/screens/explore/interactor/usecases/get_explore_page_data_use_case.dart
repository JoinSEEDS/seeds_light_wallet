import 'package:async/async.dart';
import 'package:seeds/v2/datasource/remote/api/balance_repository.dart';
import 'package:seeds/v2/datasource/remote/api/hypha_repository.dart';
import 'package:seeds/v2/datasource/remote/api/planted_repository.dart';
import 'package:seeds/v2/datasource/remote/api/profile_repository.dart';
import 'package:seeds/v2/datasource/remote/api/voice_repository.dart';

export 'package:async/src/result/error.dart';
export 'package:async/src/result/result.dart';

class GetExploreUseCase {
  final BalanceRepository _balanceRepository = BalanceRepository();
  final VoiceRepository _voiceRepository = VoiceRepository();
  final PlantedRepository _plantedRepository = PlantedRepository();
  final HyphaRepository _hyphaRepository = HyphaRepository();

  Future<List<Result>> run(String userAccount) {
    var futures = [
      _balanceRepository.getBalance(userAccount),
      _plantedRepository.getPlanted(userAccount),
      _voiceRepository.getAllianceVoice(userAccount),
      _voiceRepository.getCampaignVoice(userAccount),
      _hyphaRepository.getHyphaVoice(userAccount)
    ];
    return Future.wait(futures);
  }
}
