import 'package:seeds/datasource/remote/api/region_repository.dart';
import 'package:seeds/datasource/remote/model/transaction_response.dart';
import 'package:seeds/domain-shared/base_use_case.dart';

class JoinRegionUseCase extends InputUseCase<TransactionResponse, _Input> {
  static _Input input({required String region, required String userAccount}) =>
      _Input(region: region, userAccount: userAccount);

  @override
  Future<Result<TransactionResponse>> run(_Input input) async {
    return RegionRepository().join(region: input.region, userAccount: input.userAccount);
  }
}

class _Input {
  final String region;
  final String userAccount;

  const _Input({required this.region, required this.userAccount});
}
