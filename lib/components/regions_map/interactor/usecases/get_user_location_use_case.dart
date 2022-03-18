import 'package:geolocator/geolocator.dart';
import 'package:seeds/datasource/local/location_service.dart';
import 'package:seeds/domain-shared/base_use_case.dart';

class GetUserLocationUseCase extends NoInputUseCase<Position> {
  @override
  Future<Result<Position>> run() => LocationService().getCurrentPosition();
}
