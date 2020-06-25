import '../utils/double_extension.dart';

class InviteModel {
  final int inviteId;
  final String transferQuantity;
  final String sowQuantity;
  final String sponsor;
  final String account;
  final String inviteHash;
  final String inviteSecret;

  InviteModel({
    this.inviteId,
    this.transferQuantity,
    this.sowQuantity,
    this.sponsor,
    this.account,
    this.inviteHash,
    this.inviteSecret,
  });

  factory InviteModel.fromJson(Map<String, dynamic> json) {
    return InviteModel(
      inviteId: json["invite_id"],
      transferQuantity: json["transfer_quantity"],
      sowQuantity: json["sow_quantity"],
      sponsor: json["sponsor"],
      account: json["account"],
      inviteHash: json["invite_hash"],
      inviteSecret: json["invite_secret"],
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is InviteModel &&
          inviteId == other.inviteId &&
          transferQuantity == other.transferQuantity &&
          sowQuantity == other.sowQuantity &&
          sponsor == other.sponsor &&
          account == other.account &&
          inviteHash == other.inviteHash &&
          inviteSecret == other.inviteSecret;

  @override
  int get hashCode => super.hashCode;
}

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

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MemberModel &&
          account == other.account &&
          nickname == other.nickname &&
          image == other.image;

  @override
  int get hashCode => super.hashCode;
}

class TransactionModel {
  final String from;
  final String to;
  final String quantity;
  final String memo;
  final String timestamp;
  final String transactionId;

  TransactionModel(this.from, this.to, this.quantity, this.memo, this.timestamp, this.transactionId);

  factory TransactionModel.fromJson(Map<String, dynamic> json) {
    return TransactionModel(
      json["act"]["data"]["from"],
      json["act"]["data"]["to"],
      json["act"]["data"]["quantity"],
      json["act"]["data"]["memo"],
      json["@timestamp"],
      json["trx_id"],
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TransactionModel &&
          from == other.from &&
          to == other.to &&
          quantity == other.quantity &&
          memo == other.memo;

  @override
  int get hashCode => super.hashCode;
}

class BalanceModel {
  final String quantity;
  final double numericQuantity;
  final bool error;

  BalanceModel(this.quantity, this.error) : numericQuantity = _parseQuantityString(quantity);

  factory BalanceModel.fromJson(List<dynamic> json) {
    if (json != null && json.isNotEmpty) {
      return BalanceModel(json[0] as String, false);
    } else {
      return BalanceModel("0.0000 SEEDS", true);
    }
  }

  static double _parseQuantityString(String quantityString) {
    if(quantityString == null) {
      return 0;
    }
    return double.parse(quantityString.split(" ")[0]);
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BalanceModel && quantity == other.quantity;

  @override
  int get hashCode => super.hashCode;
}

class RateModel {
  final double seedsPerUSD;
  final bool error;

  RateModel(
    this.seedsPerUSD,
    this.error
  );

  factory RateModel.fromJson(Map<String, dynamic> json) {
    if (json != null && json.isNotEmpty) {
      return RateModel(_parseQuantityString(json["rows"][0]["current_seeds_per_usd"] as String), false);
    } else {
      return RateModel(0, true);
    }
  }

  static double _parseQuantityString(String quantityString) {
    if(quantityString == null) {
      return 0;
    }
    return double.parse(quantityString.split(" ")[0]);
  }

  double convert(double seedsAmount) {
    return seedsPerUSD > 0 ? seedsAmount / seedsPerUSD : 0;
  }

  String usdString(double seedsAmount) {
    return convert(seedsAmount).fiatFormatted + " USD"; 
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RateModel && seedsPerUSD == other.seedsPerUSD;

  @override
  int get hashCode => super.hashCode;
}

class PlantedModel {
  final String quantity;

  PlantedModel(this.quantity);

  factory PlantedModel.fromJson(Map<String, dynamic> json) {
    if (json != null && json["rows"].isNotEmpty) {
      return PlantedModel(json["rows"][0]["planted"] as String);
    } else {
      return PlantedModel("0.0000 SEEDS");
    }
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PlantedModel && quantity == other.quantity;

  @override
  int get hashCode => super.hashCode;
}

class HarvestModel {
  final String planted;
  final String reward;

  HarvestModel({this.planted, this.reward});

  factory HarvestModel.fromJson(Map<String, dynamic> json) {
    return HarvestModel(
      planted: json["rows"][0]["planted"],
      reward: json["rows"][0]["reward"],
    );
  }
}

class ScoreModel {
  int plantedScore;
  int transactionsScore;
  int reputationScore;
  int communityBuildingScore;
  int contributionScore;

  ScoreModel({
    this.plantedScore,
    this.transactionsScore,
    this.reputationScore,
    this.communityBuildingScore,
    this.contributionScore,
  });

  factory ScoreModel.fromJson(Map<String, dynamic> json) {
    Map<String, dynamic> item = json["rows"][0];

    return ScoreModel(
      plantedScore: item["planted_score"],
      transactionsScore: item["transactions_score"],
      reputationScore: item["reputation_score"],
      communityBuildingScore: item["community_building_score"],
      contributionScore: item["contribution_score"],
    );
  }
}

class ExchangeModel {
  final String rate;
  final String citizenLimit;
  final String residentLimit;
  final String visitorLimit;

  ExchangeModel({
    this.rate,
    this.citizenLimit,
    this.residentLimit,
    this.visitorLimit,
  });

  factory ExchangeModel.fromJson(Map<String, dynamic> json) {
    var item = json["rows"][0];

    return ExchangeModel(
      rate: item["rate"],
      citizenLimit: item["citizen_limit"],
      residentLimit: item["resident_limit"],
      visitorLimit: item["visitor_limit"],
    );
  }
}

class VoiceModel {
  final int amount;

  VoiceModel(this.amount);

  factory VoiceModel.fromJson(Map<String, dynamic> json) {
    if (json != null && json["rows"].isNotEmpty) {
      return VoiceModel(json["rows"][0]["balance"] as int);
    } else {
      return VoiceModel(0);
    }
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is VoiceModel && amount == other.amount;

  @override
  int get hashCode => super.hashCode;
}

class ProfileModel {
  final String account;
  final String status;
  final String type;
  final String nickname;
  final String image;
  final String story;
  final String roles;
  final String skills;
  final String interests;
  final int reputation;
  final int timestamp;

  ProfileModel({
    this.account,
    this.status,
    this.type,
    this.nickname,
    this.image,
    this.story,
    this.roles,
    this.skills,
    this.interests,
    this.reputation,
    this.timestamp,
  });

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    return ProfileModel(
      account: json["account"],
      status: json["status"],
      type: json["type"],
      nickname: json["nickname"],
      image: json["image"],
      story: json["story"],
      roles: json["roles"],
      skills: json["skills"],
      interests: json["interests"],
      reputation: json["reputation"],
      timestamp: json["timestamp"],
    );
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

const proposalTypes = {
  // NOTE: 
  // The keys here need to have i18n entries 
  // in the ecosystem.i18n.dart file
  'Staged': {
    'stage': 'staged',
    'status': 'open'
  },
  'Open': {
    'stage': 'active',
    'status': 'open'
  },
  'Passed': {
    'stage': 'done',
    'status': 'passed'
  },
  'Failed': {
    'stage': 'done',
    'status': 'rejected'
  },
};
