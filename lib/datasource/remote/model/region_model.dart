class RegionModel {
  final String id;
  final String founder;
  final String status;
  final String description;
  final String locationJson;
  final double latitude;
  final double longitude;
  final int membersCount;
  final String createdAt;

  const RegionModel({
    required this.id,
    required this.founder,
    required this.status,
    required this.description,
    required this.locationJson,
    required this.latitude,
    required this.longitude,
    required this.membersCount,
    required this.createdAt,
  });

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

    return RegionModel(
      id: json['id'],
      founder: json['founder'],
      status: json['status'],
      description: json['description'],
      locationJson: json['locationjson'],
      latitude: json['latitude'],
      longitude: json['longitude'],
      membersCount: json['members_count'],
      createdAt: json['created_at'],
    );
  }
}
