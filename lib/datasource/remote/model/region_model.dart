import 'package:geoflutterfire2/geoflutterfire2.dart';

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

  double distanceTo(double lat, double lng) => GeoFirePoint(latitude, longitude).distance(lat: lat, lng: lng);

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
      id: json['id'],
      founder: json['founder'],
      status: json['status'],
      title: json['title'],
      description: json['description'],
      locationJson: json['locationjson'],
      latitude: double.parse(json['latitude']),
      longitude: double.parse(json['longitude']),
      membersCount: json['members_count'],
      createdAt: json['created_at'],
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
