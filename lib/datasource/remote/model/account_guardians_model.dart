class UserGuardiansModel {
  final List<String> guardians;
  final int timeDelaySec;

  UserGuardiansModel({required this.guardians, required this.timeDelaySec});

  factory UserGuardiansModel.fromTableRows(List<dynamic> rows) {
    if (rows.isNotEmpty && rows[0]['account'].isNotEmpty) {
      final List<String> guardians = List<String>.from(rows[0]['guardians']);
      final int timeDelaySec = rows[0]['time_delay_sec'];
      return UserGuardiansModel(guardians: guardians, timeDelaySec: timeDelaySec);
    } else {
      return UserGuardiansModel(guardians: [], timeDelaySec: 0);
    }
  }
}
