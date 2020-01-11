
class Member {
  final String account;
  final String nickname;
  final String image;

  Member({this.account, this.nickname, this.image});

  factory Member.fromJson(Map<String, dynamic> json) {
    return Member(
      account: json["account"],
      nickname: json["nickname"],
      image: json["image"],
    );
  }
}

class Transaction {
  final String from;
  final String to;
  final String quantity;
  final String memo;

  Transaction(this.from, this.to, this.quantity, this.memo);

  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      json["from"],
      json["to"],
      json["quantity"],
      json["memo"],
    );
  }
}

class Balance {
  final String quantity;

  Balance(this.quantity);

  factory Balance.fromJson(List<dynamic> json) {
    return Balance(json[0] as String);
  }
}
