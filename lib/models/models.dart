
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

class Voice {
  final int amount;

  Voice(this.amount);

  factory Voice.fromJson(Map<String, dynamic> json) {
    return Voice(json[0] as int);
  }
}

class Proposal {
  final int id;
  final String creator;
  final String recipient;
  final String quantity;
  final String staked;
  final int executed;
  final int total;
  final int favour;
  final int against;
  final String title;
  final String summary;
  final String description;
  final String image;
  final String url;
  final String status;
  final String stage;
  final String fund;
  final int creationDate;

  Proposal({
    this.id,
    this.creator,
    this.recipient,
    this.quantity,
    this.staked,
    this.executed,
    this.total,
    this.favour,
    this.against,
    this.title,
    this.summary,
    this.description,
    this.image,
    this.url,
    this.status,
    this.stage,
    this.fund,
    this.creationDate,
  });

  factory Proposal.fromJson(Map<String, dynamic> json) {
    return Proposal(
      id: json["id"],
      creator: json["creator"],
      recipient: json["recipient"],
      quantity: json["quantity"],
      staked: json["staked"],
      executed: json["executed"],
      total: json["total"],
      favour: json["favour"],
      against: json["against"],
      title: json["title"],
      summary: json["summary"],
      description: json["description"],
      image: json["image"],
      url: json["url"],
      status: json["status"],
      stage: json["stage"],
      fund: json["fund"],
      creationDate: json["creation_date"],
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Proposal &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          creator == other.creator &&
          recipient == other.recipient &&
          quantity == other.quantity &&
          staked == other.staked &&
          executed == other.executed &&
          total == other.total &&
          favour == other.favour &&
          against == other.against &&
          title == other.title &&
          summary == other.summary &&
          description == other.description &&
          image == other.image &&
          url == other.url &&
          status == other.status &&
          stage == other.stage &&
          fund == other.fund &&
          creationDate == other.creationDate;

  @override
  int get hashCode =>
      id.hashCode ^
      creator.hashCode ^
      recipient.hashCode ^
      quantity.hashCode ^
      staked.hashCode ^
      executed.hashCode ^
      total.hashCode ^
      favour.hashCode ^
      against.hashCode ^
      title.hashCode ^
      summary.hashCode ^
      description.hashCode ^
      image.hashCode ^
      url.hashCode ^
      status.hashCode ^
      stage.hashCode ^
      fund.hashCode ^
      creationDate.hashCode;

  @override
  String toString() {
    return 'Proposal{id: $id, creator: $creator, recipient: $recipient, quantity: $quantity, staked: $staked, executed: $executed, total: $total, favour: $favour, against: $against, title: $title, summary: $summary, description: $description, image: $image, url: $url, status: $status, stage: $stage, fund: $fund, creationDate: $creationDate}';
  }
}

// TODO add the missing keys
// the key is the tab text, the value is the server key
const proposalTypes = {
  'Open': 'active',
  'Excuted': '',
  'Cancled': '',
  'Expired': 'done',
};