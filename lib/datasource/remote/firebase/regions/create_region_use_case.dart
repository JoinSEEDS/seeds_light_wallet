import 'package:seeds/datasource/local/settings_storage.dart';
import 'package:seeds/datasource/remote/api/region_repository.dart';
import 'package:seeds/datasource/remote/firebase/regions/firebase_database_regions_repository.dart';
import 'package:seeds/datasource/remote/model/transaction_response.dart';
import 'package:seeds/domain-shared/base_use_case.dart';

class CreateRegionUseCase extends InputUseCase<TransactionResponse, _Input> {
  final RegionRepository _regionRepository = RegionRepository();
  final FirebaseDatabaseRegionsRepository _firebaseRegionsRepository = FirebaseDatabaseRegionsRepository();

  static _Input input(
          {required String regionAccount,
          required String title,
          required String description,
          required double latitude,
          required double longitude,
          required String imageUrl,
          required String regionAddress}) =>
      _Input(
          userAccount: settingsStorage.accountName,
          regionAccount: regionAccount,
          title: title,
          description: description,
          latitude: latitude,
          longitude: longitude,
          imageUrl: imageUrl,
          regionAddress: regionAddress);

  @override
  Future<Result<TransactionResponse>> run(_Input input) async {
    /// Create a region on firebase
    final Result<String> firebaseResult = await _firebaseRegionsRepository.createRegion(
      userAccount: input.userAccount,
      regionAccount: input.regionAccount,
      latitude: input.latitude,
      longitude: input.longitude,
      imageUrl: input.imageUrl,
    );

    if (firebaseResult.isValue) {
      final fee = await _regionRepository.getRegionFee();

      /// Save to chain
      final Result<TransactionResponse> createRegionResult = await _regionRepository.create(
        userAccount: input.userAccount,
        regionAccount: input.regionAccount,
        title: input.title,
        description: input.description,
        latitude: input.latitude,
        longitude: input.longitude,
        regionAddress: input.regionAddress,
        regionFee: fee.asValue!.value,
      );

      if (createRegionResult.isValue) {
        /// Happy Path, Region is fully created.
        return createRegionResult;
      } else {
        /// Error creating rergion on Chain. Delete from firebase
        await _firebaseRegionsRepository.deleteRegion(input.regionAccount);
        return Result.error("Oops, Something went wrong creating a region.");
      }
    } else {
      /// Send Opps error on region creation
      return Result.error("Oops, Something went wrong creating a region.");
    }
  }
}

class _Input {
  final String userAccount;
  final String regionAccount;
  final String title;
  final String description;
  final String imageUrl;
  final double latitude;
  final double longitude;
  final String regionAddress;

  const _Input({
    required this.userAccount,
    required this.regionAccount,
    required this.title,
    required this.imageUrl,
    required this.description,
    required this.latitude,
    required this.longitude,
    required this.regionAddress,
  });
}
