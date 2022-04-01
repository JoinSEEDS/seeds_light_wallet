import 'package:seeds/datasource/local/settings_storage.dart';
import 'package:seeds/datasource/remote/api/region_repository.dart';
import 'package:seeds/datasource/remote/model/transaction_response.dart';
import 'package:seeds/domain-shared/base_use_case.dart';

class CreateRegionUseCase extends InputUseCase<TransactionResponse, _Input> {
  static _Input input(
          {required String regionAccount,
          required String title,
          required String description,
          required double latitude,
          required double longitude,
          required String regionAddress}) =>
      _Input(
        regionAccount,
        title,
        description,
        latitude,
        longitude,
        regionAddress,
      );
  final RegionRepository _profileRepository = RegionRepository();

  @override
  Future<Result<TransactionResponse>> run(_Input input) async {
    return _profileRepository.create(
        regionAddress: input.regionAddress,
        userAccount: settingsStorage.accountName,
        description: input.description,
        regionAccount: input.regionAccount,
        longitude: input.longitude,
        latitude: input.latitude,
        title: input.title);
  }
}

class _Input {
  final String regionAccount;
  final String title;
  final String description;
  final double latitude;
  final double longitude;
  final String regionAddress;

  const _Input(
    this.regionAccount,
    this.title,
    this.description,
    this.latitude,
    this.longitude,
    this.regionAddress,
  );
}
