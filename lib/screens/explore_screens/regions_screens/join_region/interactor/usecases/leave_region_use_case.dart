import 'package:seeds/datasource/remote/api/region_repository.dart';
import 'package:seeds/datasource/remote/model/transaction_response.dart';
import 'package:seeds/domain-shared/base_use_case.dart';

class LeaveRegionUseCase extends InputUseCase<TransactionResponse, _Input> {
  static _Input input({required String regionId, required String userAccount}) => _Input(regionId, userAccount);

  @override
  Future<Result<TransactionResponse>> run(_Input input) {
    return RegionRepository().leave(region: input.regionId, userAccount: input.userAccount);
  }
}

class _Input {
  final String regionId;
  final String userAccount;

  const _Input(this.regionId, this.userAccount);
}
