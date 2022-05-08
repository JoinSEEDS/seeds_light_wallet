import 'package:seeds/datasource/local/settings_storage.dart';
import 'package:seeds/datasource/remote/api/region_repository.dart';
import 'package:seeds/datasource/remote/model/transaction_response.dart';
import 'package:seeds/domain-shared/base_use_case.dart';

class EditRegionDescriptionUseCase extends InputUseCase<TransactionResponse, _Input> {
  final RegionRepository _regionRepository = RegionRepository();

  static _Input input({
    required String regionAccount,
    required String title,
    required String description,
    required double latitude,
    required double longitude,
    required String regionAddress,
  }) =>
      _Input(
        userAccount: settingsStorage.accountName,
        regionAccount: regionAccount,
        title: title,
        description: description,
        latitude: latitude,
        longitude: longitude,
        regionAddress: regionAddress,
      );

  @override
  Future<Result<TransactionResponse>> run(_Input input) async {
    final Result<TransactionResponse> editRegionResult = await _regionRepository.update(
      userAccount: input.userAccount,
      regionAccount: input.regionAccount,
      title: input.title,
      description: input.description,
      latitude: input.latitude,
      longitude: input.longitude,
      regionAddress: input.regionAddress,
    );

    return editRegionResult;
  }
}

class _Input {
  final String userAccount;
  final String regionAccount;
  final String title;
  final String description;
  final double latitude;
  final double longitude;
  final String regionAddress;

  const _Input({
    required this.userAccount,
    required this.regionAccount,
    required this.title,
    required this.description,
    required this.latitude,
    required this.longitude,
    required this.regionAddress,
  });
}
