class UserRecoversModel {
  final List<String> alreadySignedGuardians;
  final String publicKey;
  final int completeTimestamp;

  UserRecoversModel({
    required this.alreadySignedGuardians,
    required this.publicKey,
    required this.completeTimestamp,
  });

  factory UserRecoversModel.fromTableRows(List<dynamic> rows) {
    if (rows.isNotEmpty) {
      final data = rows[0];
      return UserRecoversModel(
        alreadySignedGuardians: List<String>.from(data['guardians']),
        publicKey: data['public_key'],
        completeTimestamp: data['complete_timestamp'],
      );
    } else {
      return UserRecoversModel(alreadySignedGuardians: [], publicKey: "", completeTimestamp: 0);
    }
  }
}
