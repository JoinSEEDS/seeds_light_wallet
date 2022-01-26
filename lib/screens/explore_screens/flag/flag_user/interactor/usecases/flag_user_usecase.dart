import 'package:seeds/datasource/local/settings_storage.dart';
import 'package:seeds/datasource/remote/api/flag_repository.dart';
import 'package:seeds/datasource/remote/model/transaction_response.dart';
import 'package:seeds/domain-shared/base_use_case.dart';

class FlagUserUseCase extends InputUseCase<TransactionResponse, String> {
  final FlagRepository _flagRepository = FlagRepository();

  @override
  Future<Result<TransactionResponse>> run(String input) {
    final account = settingsStorage.accountName;
    return _flagRepository.flag(from: account, to: input);
  }
}
