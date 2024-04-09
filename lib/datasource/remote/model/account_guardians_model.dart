class UserGuardiansModel {
  final List<String> guardians;
  final int timeDelaySec;

  UserGuardiansModel({required this.guardians, required this.timeDelaySec});

  factory UserGuardiansModel.fromTableRows(List<Map<String, dynamic>> rows) {
    if (rows.isNotEmpty && rows[0]['account'] != null) {
      final List<String> guardians = List<String>.from(rows[0]['guardians'] as List);
      final int timeDelaySec = rows[0]['time_delay_sec'] as int;
      return UserGuardiansModel(guardians: guardians, timeDelaySec: timeDelaySec);
    } else {
      return UserGuardiansModel(guardians: [], timeDelaySec: 0);
    }
  }
}
