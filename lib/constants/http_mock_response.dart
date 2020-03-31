import 'package:teloswallet/models/models.dart';

class HttpMockResponse {
  static final transactions = [
    TransactionModel("sevenflash12", "sevenflash42", "15.0000 TLOS", "", "2020-02-05T17:24:28.500", "b58a4db809b97e1480b3f8c5d5e181b49196b34705568ad3eeb18b075fc46c55"),
    TransactionModel("sevenflash42", "sevenflash12", "5.0000 TLOS", "", "2020-02-05T17:24:28.500", "b58a4db809b97e1480b3f8c5d5e181b49196b34705568ad3eeb18b075fc46c55"),
  ];

  static final telosBalance = BalanceModel("10.0000 TLOS");

  static final keyAccounts = ["sevenflash42", "sevenflash12"];

  static final transactionResult = {
    "transaction_id":
        "7bea4994d089a5afae4b5715500618b141cbbd62190811da0deb0b4142a3fa33"
  };

  static final resources = ResourcesModel(
    cpuWeight: '1.0000 TLOS',
    netWeight: '1.0000 TLOS',
    ramBytes: 100
  );
}
