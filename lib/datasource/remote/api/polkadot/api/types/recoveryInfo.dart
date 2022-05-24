class RecoveryInfo extends _RecoveryInfo {
  // ignore: prefer_constructors_over_static_methods
  static RecoveryInfo fromJson(Map<String, dynamic> json) {
    final RecoveryInfo info = RecoveryInfo();
    info.address = json['address'];
    info.delayPeriod = json['delayPeriod'];
    info.threshold = json['threshold'];
    info.friends = List<String>.from(json['friends'] ?? []);
    info.deposit = BigInt.parse((json['deposit'] ?? 0).toString());
    return info;
  }
}

abstract class _RecoveryInfo {
  String? address;
  int? delayPeriod;
  int? threshold;
  List<String>? friends;
  BigInt? deposit;
}
