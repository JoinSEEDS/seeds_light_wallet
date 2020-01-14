
class MemberModel {
  final String account;
  final String nickname;
  final String image;

  MemberModel({this.account, this.nickname, this.image});

  factory MemberModel.fromJson(Map<String, dynamic> json) {
    return MemberModel(
      account: json["account"],
      nickname: json["nickname"],
      image: json["image"],
    );
  }
}

class TransactionModel {
  final String from;
  final String to;
  final String quantity;
  final String memo;

  TransactionModel(this.from, this.to, this.quantity, this.memo);

  factory TransactionModel.fromJson(Map<String, dynamic> json) {
    return TransactionModel(
      json["from"],
      json["to"],
      json["quantity"],
      json["memo"],
    );
  }
}

class BalanceModel {
  final String quantity;

  BalanceModel(this.quantity);

  factory BalanceModel.fromJson(List<dynamic> json) {
    return BalanceModel(json[0] as String);
  }
}

class VoiceModel {
  final int amount;

  VoiceModel(this.amount);

  factory VoiceModel.fromJson(Map<String, dynamic> json) {
    return VoiceModel(json[0] as int);
  }
}

class ProposalModel {
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

  ProposalModel({
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

  factory ProposalModel.fromJson(Map<String, dynamic> json) {
    return ProposalModel(
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
      other is ProposalModel &&
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