class ReferendumInfo extends _ReferendumInfo {
  // ignore: prefer_constructors_over_static_methods
  static ReferendumInfo fromJson(Map<String, dynamic> json) {
    final ReferendumInfo info = ReferendumInfo();
    info.index = BigInt.parse(json['index'].toString());
    info.imageHash = json['imageHash'];
    info.status = json['status'];
    info.image = json['image'];
    info.detail = json['detail'];

    info.isPassing = json['isPassing'];
    info.voteCountAye = json['voteCountAye'];
    info.voteCountNay = json['voteCountNay'];
    info.votedAye = json['votedAye'].toString();
    info.votedNay = json['votedNay'].toString();
    info.votedTotal = json['votedTotal'].toString();
    info.changeAye = info.detail!['changes']['changeAye'].toString();
    info.changeNay = info.detail!['changes']['changeNay'].toString();

    info.userVoted = info.detail!['userVoted'];
    return info;
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        'index': index,
        'imageHash': imageHash,
        'status': status,
        'image': image,
        'detail': detail,
        'isPassing': isPassing,
        'voteCountAye': voteCountAye,
        'voteCountNay': voteCountNay,
        'votedTotal': votedTotal,
        'votedAye': votedAye,
        'votedNay': votedNay,
        'changeAye': changeAye,
        'changeNay': changeNay,
        'userVoted': userVoted,
      };
}

abstract class _ReferendumInfo {
  BigInt? index;
  String? imageHash;

  bool? isPassing;
  int? voteCountAye;
  int? voteCountNay;
  String? votedAye;
  String? votedNay;
  String? votedTotal;
  String? changeAye;
  String? changeNay;

  Map<String, dynamic>? status;
  Map<String, dynamic>? image;
  Map<String, dynamic>? detail;

  Map<String, dynamic>? userVoted;
}
