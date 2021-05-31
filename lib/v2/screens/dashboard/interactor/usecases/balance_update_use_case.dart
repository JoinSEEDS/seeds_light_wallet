import 'package:async/async.dart';
import 'package:seeds/v2/datasource/local/settings_storage.dart';
import 'package:seeds/v2/datasource/remote/api/balance_repository.dart';
import 'package:seeds/v2/datasource/remote/api/members_repository.dart';
import 'package:seeds/v2/datasource/remote/api/planted_repository.dart';
import 'package:seeds/v2/datasource/remote/api/profile_repository.dart';
import 'package:seeds/v2/datasource/remote/api/voice_repository.dart';
import 'package:seeds/v2/datasource/local/models/token_model.dart';

export 'package:async/src/result/error.dart';
export 'package:async/src/result/result.dart';

class BalanceUpdateUseCase {
  Future<Result> run(TokenModel token) {
    var account = settingsStorage.accountName;
    return  BalanceRepository().getTokenBalance(account, token);
  }
}
