import 'package:seeds/datasource/local/settings_storage.dart';
import 'package:seeds/datasource/remote/api/vouch_repository.dart';
import 'package:seeds/datasource/remote/model/transaction_response.dart';
import 'package:seeds/domain-shared/base_use_case.dart';

class VouchForAMemberUseCase extends InputUseCase<TransactionResponse, String> {
  final VouchRepository _vouchRepository = VouchRepository();

  @override
  Future<Result<TransactionResponse>> run(String input) {
    final account = settingsStorage.accountName;
    return _vouchRepository.vouch(accountName: account, vouchee: input);
  }
}
