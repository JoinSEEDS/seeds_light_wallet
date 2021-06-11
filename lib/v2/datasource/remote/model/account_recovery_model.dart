class AccountRecoveryModel {
  final List<String> guardians;
  final int timeDelaySec;

  AccountRecoveryModel({required this.guardians, required this.timeDelaySec});

  factory AccountRecoveryModel.fromTableRows(List<dynamic> rows) {
    if (rows.isNotEmpty && rows[0]['account'].isNotEmpty) {
      List<String> guardians = List<String>.from(rows[0]['guardians']);
      int timeDelaySec = rows[0]['time_delay_sec'];
      return AccountRecoveryModel(guardians: guardians, timeDelaySec: timeDelaySec);
    } else {
      return AccountRecoveryModel(guardians: [], timeDelaySec: 0);
    }
  }
}
