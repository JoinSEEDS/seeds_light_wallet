import 'package:seeds/datasource/remote/firebase/regions/firebase_database_regions_repository.dart';
import 'package:seeds/datasource/remote/model/firebase_models/region_location_model.dart';
import 'package:seeds/domain-shared/base_use_case.dart';

class GetFirebaseRegionsUseCase extends InputUseCase<List<RegionLocation>, _Input> {
  static _Input input({required double lat, required double lng, required double radius}) => _Input(lat, lng, radius);

  @override
  Future<Result<List<RegionLocation>>> run(_Input input) async {
    try {
      final regions = await FirebaseDatabaseRegionsRepository()
          .findRegionsByLocation(latitude: input.lat, longitude: input.lng, radius: input.radius);
      return Result.value(regions);
    } catch (e) {
      return Result.error(e);
    }
  }
}

class _Input {
  final double lat;
  final double lng;
  final double radius;

  const _Input(this.lat, this.lng, this.radius);
}
