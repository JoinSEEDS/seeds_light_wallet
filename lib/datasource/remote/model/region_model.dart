import 'package:geoflutterfire/geoflutterfire.dart';

class RegionModel {
  final String id;
  final String founder;
  final String status;
  final String title;
  final String description;

  /// This Json will hold the region address
  final String locationJson;
  final double latitude;
  final double longitude;
  final int membersCount;
  final String createdAt;
  final String? imageUrl;

  const RegionModel(
      {required this.id,
      required this.founder,
      required this.status,
      required this.title,
      required this.description,
      required this.locationJson,
      required this.latitude,
      required this.longitude,
      required this.membersCount,
      required this.createdAt,
      this.imageUrl});

  double distanceTo(double lat, double lng) => GeoFirePoint(latitude, longitude).kmDistance(lat: lat, lng: lng);

  String get readableMembersCount {
    return membersCount > 1000 ? '${membersCount.toStringAsFixed(1)} K' : membersCount.toString();
  }

  factory RegionModel.fromJson(Map<String, dynamic> json) {
    // name id;
    // name founder;
    // name status; // "active" "inactive"
    // string description;
    // string locationjson; // json description of the area
    // float latitude;
    // float longitude;
    // uint64_t members_count;
    // time_point created_at = current_block_time().to_time_point();

    print("json source $json");

    return RegionModel(
      id: json['id'] as String,
      founder: json['founder'] as String,
      status: json['status'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      locationJson: json['locationjson'] as String,
      latitude: double.parse(json['latitude'] as String),
      longitude: double.parse(json['longitude'] as String),
      membersCount: json['members_count'] as int,
      createdAt: json['created_at'] as String,
    );
  }

  RegionModel addImageUrlToModel(String imageUrl) {
    return RegionModel(
      id: id,
      founder: founder,
      status: status,
      title: title,
      description: description,
      locationJson: locationJson,
      latitude: latitude,
      longitude: longitude,
      membersCount: membersCount,
      createdAt: createdAt,
      imageUrl: imageUrl,
    );
  }
}
