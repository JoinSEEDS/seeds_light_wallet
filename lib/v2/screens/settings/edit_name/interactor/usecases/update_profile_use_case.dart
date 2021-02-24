import 'package:async/async.dart';
import 'package:meta/meta.dart';
import 'package:seeds/v2/datasource/remote/api/eos_repository.dart';

export 'package:async/src/result/result.dart';

class UpdateProfileUseCase {
  final EosRepository _eosRepository = EosRepository();

  Future<Result> run({@required String name, String accountName, String privateKey, String nodeEndpoint}) {
    return _eosRepository.updateProfile(
      nickname: name,
      image: '',
      story: '',
      roles: '',
      skills: '',
      interests: '',
      accountName: accountName,
      privateKey: privateKey,
      nodeEndpoint: nodeEndpoint,
    );
  }
}
