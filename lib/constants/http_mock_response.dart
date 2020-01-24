import 'package:seeds/models/models.dart';

class HttpMockResponse {
  static final members = [
    MemberModel(
      account: "sevenflash42",
      nickname: "Igor Berlenko",
      image: "",
    ),
  ];

  static final transactions = [
    TransactionModel("join.seeds", "sevenflash42", "15.0000 SEEDS", ""),
    TransactionModel("sevenflash42", "testingseeds", "5.0000 SEEDS", ""),
  ];

  static final balance = BalanceModel("10.0000 SEEDS");

  static final voice = VoiceModel(77);

  static final proposals = [
    ProposalModel(
      id: 1,
      creator: "creator",
      recipient: "recipient",
      quantity: "1000000.0000 SEEDS",
      staked: "1.0000 SEEDS",
      executed: 1,
      total: 1000,
      favour: 800,
      against: 200,
      title: "title",
      summary: "summary",
      description:
          "description description description description description description description description description description description description description description description description description ",
      image:
          "https://seeds-service.s3.amazonaws.com/development/a26a6d72-dd50-4c40-8504-00930b97961b/5bc29df1-1f72-4868-b900-3d177678ef77-1920.jpg",
      url:
          "https://ipfs.globalupload.io/QmVGQyjnRM77hAK4SfaVTVu45Lb7QoFpJRLeoYwA1XijyS",
      status: "status",
      stage: "active",
      fund: "fund",
      creationDate: 1000,
    ),
  ];

  static final invites = [
    InviteModel(
        inviteId: 1,
        transferQuantity: "10.0000 SEEDS",
        sowQuantity: "5.0000 SEEDS",
        sponsor: "sponsor",
        account: "account",
        inviteHash: "invite_hash",
        inviteSecret: "invite_secret"),
  ];

  static final transactionResult = {
    "transaction_id":
        "7bea4994d089a5afae4b5715500618b141cbbd62190811da0deb0b4142a3fa33"
  };
}
