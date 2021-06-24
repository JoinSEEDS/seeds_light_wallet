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
    if (rows.isNotEmpty && rows[0]['account'].isNotEmpty) {
      return UserRecoversModel(
        alreadySignedGuardians: List<String>.from(rows[0]['guardians']),
        publicKey: rows[0]['public key'],
        completeTimestamp: DateTime.now().millisecondsSinceEpoch ~/ 1000,
      );
    } else {
      return UserRecoversModel(
          alreadySignedGuardians: [], publicKey: "", completeTimestamp: DateTime.now().millisecondsSinceEpoch ~/ 1000);
    }
  }
}
