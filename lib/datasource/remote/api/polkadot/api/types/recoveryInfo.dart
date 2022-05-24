class RecoveryInfo extends _RecoveryInfo {
  static RecoveryInfo fromJson(Map<String, dynamic> json) {
    RecoveryInfo info = RecoveryInfo();
    if (json == null) {
      return info;
    }
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
