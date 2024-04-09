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
  final List<int> payPercentages;
  final int passedCycle;
  final int age;
  final String currentPayout;
  final String campaignType;
  final String maxAmountPerInvite;
  final String planted;
  final String reward;
  final int campaignId;

  ProposalModel({
    required this.id,
    required this.creator,
    required this.recipient,
    required this.quantity,
    required this.staked,
    required this.executed,
    required this.total,
    required this.favour,
    required this.against,
    required this.title,
    required this.summary,
    required this.description,
    required this.image,
    required this.url,
    required this.status,
    required this.stage,
    required this.fund,
    required this.creationDate,
    required this.payPercentages,
    required this.passedCycle,
    required this.age,
    required this.currentPayout,
    required this.campaignType,
    required this.maxAmountPerInvite,
    required this.planted,
    required this.reward,
    required this.campaignId,
  });

  factory ProposalModel.fromJson(Map<String, dynamic> json) {
    return ProposalModel(
      id: json['id'] as int,
      creator: json['creator'] as String,
      recipient: json['recipient'] as String,
      quantity: json['quantity'] as String,
      staked: json['staked'] as String,
      executed: json['executed'] as int,
      total: json['total'] as int,
      favour: json['favour'] as int,
      against: json['against'] as int,
      title: json['title'] as String,
      summary: json['summary'] as String,
      description: json['description'] as String,
      image: json['image'] as String,
      url: json['url'] as String,
      status: json['status'] as String,
      stage: json['stage'] as String,
      fund: json['fund'] as String,
      creationDate: json['creation_date'] as int,
      payPercentages: List<int>.from(json['pay_percentages'] as List),
      passedCycle: json['passed_cycle'] as int,
      age: json['age'] as int,
      currentPayout: json['current_payout'] as String,
      campaignType: json['campaign_type'] as String,
      maxAmountPerInvite: json['max_amount_per_invite'] as String,
      planted: json['planted'] as String,
      reward: json['reward'] as String,
      campaignId: json['campaign_id'] as int,
    );
  }
}
