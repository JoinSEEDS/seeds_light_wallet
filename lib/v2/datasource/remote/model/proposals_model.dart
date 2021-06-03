enum ProposalType { alliance, campaign, hypha }

class ProposalsModel {
  final List<ProposalModel> proposals;

  ProposalsModel(this.proposals);

  factory ProposalsModel.fromJson(Map<String, dynamic> json) {
    if (json['rows'] != null) {
      return ProposalsModel(json['rows'].map((i) => ProposalModel.fromJson(i)).toList());
    } else {
      return ProposalsModel([]);
    }
  }
}

class ProposalModel {
  final int? id;
  final String? creator;
  final String? recipient;
  final String? quantity;
  final String? staked;
  final int? executed;
  final int? total;
  final int? favour;
  final int? against;
  final String? title;
  final String? summary;
  final String? description;
  final String? image;
  final String? url;
  final String? status;
  final String? stage;
  final String? fund;
  final int? creationDate;

  ProposalType get type {
    return fund == 'allies.seeds'
        ? ProposalType.alliance
        : fund == 'hypha.seeds'
            ? ProposalType.hypha
            : ProposalType.campaign;
  }

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
      id: json['id'],
      creator: json['creator'],
      recipient: json['recipient'],
      quantity: json['quantity'],
      staked: json['staked'],
      executed: json['executed'],
      total: json['total'],
      favour: json['favour'],
      against: json['against'],
      title: json['title'],
      summary: json['summary'],
      description: json['description'],
      image: json['image'],
      url: json['url'],
      status: json['status'],
      stage: json['stage'],
      fund: json['fund'],
      creationDate: json['creation_date'],
    );
  }
}
