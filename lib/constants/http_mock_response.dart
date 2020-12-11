import 'package:eosdart/eosdart.dart';
import 'package:seeds/models/models.dart';

class HttpMockResponse {
  static final requiredAuth = RequiredAuth()
    ..threshold = 1
    ..waits = []
    ..accounts = []
    ..keys = [];

  static final accountPermissions = [
    Permission()
      ..permName = "active"
      ..parent = "owner"
      ..requiredAuth = requiredAuth,
    Permission()
      ..permName = "owner"
      ..parent = ""
      ..requiredAuth = requiredAuth
  ];

  static final members = [
    MemberModel(
      account: "sevenflash42",
      nickname: "Igor Berlenko",
      image: "",
    ),
    MemberModel(
      account: "sevenflash24",
      nickname: "Andrey MK",
      image: "",
    ),
    MemberModel(
      account: "fghreww",
      nickname: "Linda Lynch",
      image: "",
    ),
    MemberModel(
      account: "semfg",
      nickname: "Sean West",
      image: "",
    ),
    MemberModel(
      account: "joihjkl4",
      nickname: "John Rice",
      image: "",
    ),
    MemberModel(
      account: "jkl9jj",
      nickname: "Joe Collins",
      image: "",
    ),
    MemberModel(
      account: "grsw4fr",
      nickname: "Keith Graham",
      image: "",
    ),
    MemberModel(
      account: "silvaG",
      nickname: "Gloria Silva",
      image: "",
    )
  ];

  static final transactions = [
    TransactionModel(
        "join.seeds",
        "sevenflash42",
        "15.0000 SEEDS",
        "",
        "2020-02-05T17:24:28.500",
        "b58a4db809b97e1480b3f8c5d5e181b49196b34705568ad3eeb18b075fc46c55"),
    TransactionModel(
        "sevenflash42",
        "testingseeds",
        "5.0000 SEEDS",
        "",
        "2020-02-05T17:24:28.500",
        "b58a4db809b97e1480b3f8c5d5e181b49196b34705568ad3eeb18b075fc46c55"),
  ];

  static final balance = BalanceModel("10.0000 SEEDS", false);

  static final rate = RateModel(0.011, false);

  static final telosBalance = BalanceModel("10.0000 TLOS", false);

  static final voice = VoiceModel(77);

  static final planted = PlantedModel("5.0000 SEEDS");

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
      inviteSecret: "invite_secret",
    ),
    InviteModel(
      inviteId: 2,
      transferQuantity: "10.0000 SEEDS",
      sowQuantity: "5.0000 SEEDS",
      sponsor: "sponsor",
      account: "",
      inviteHash: "invite_hash",
      inviteSecret: "",
    ),
  ];

  static final invite = invites[0];

  static final keyAccounts = ["sevenflash42", "testingseeds"];

  static final transactionResult = {
    "transaction_id":
        "7bea4994d089a5afae4b5715500618b141cbbd62190811da0deb0b4142a3fa33"
  };

  static final harvest = HarvestModel(
    planted: "5.0000 SEEDS",
    reward: "0.0000 SEEDS",
  );

  static final score = ScoreModel(
    plantedScore: 50,
    transactionsScore: 50,
    reputationScore: 50,
    communityBuildingScore: 50,
    contributionScore: 50,
  );

  static final exchangeConfig = ExchangeModel(
    rate: "7.0000 SEEDS",
    citizenLimit: "250000.0000 SEEDS",
    residentLimit: "250000.0000 SEEDS",
    visitorLimit: "25000.0000 SEEDS",
  );

  static final profile = ProfileModel(
    account: "illumination",
    status: "citizen",
    type: "individual",
    nickname: "Nikolaus",
    image:
        "https://seeds-service.s3.amazonaws.com/development/e46ea503-b743-44b0-901a-4fe07e4d781f/87b2c661-7af6-4b82-9cbe-0a352b5b248c-1920.jpg",
    story: "Seeds Team",
    roles: '["#light #support #askmeanything"]',
    skills: "[]",
    interests: "[]",
    reputation: 0,
    timestamp: 1577382580,
  );
}
