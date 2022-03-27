import 'package:collection/collection.dart';
import 'package:equatable/equatable.dart';

class TokenModel extends Equatable {
  static const allTokens = [seedsToken, husdToken, hyphaToken, localScaleToken, starsToken, telosToken];

  final String chainName;
  final String contract;
  final String symbol;
  final String name;
  final String backgroundImage;
  final String logo;
  final String balanceSubTitle;
  final int precision;

  String get id => "$contract#$symbol";

  const TokenModel({
    required this.chainName,
    required this.contract,
    required this.symbol,
    required this.name,
    required this.backgroundImage,
    required this.logo,
    required this.balanceSubTitle,
    this.precision = 4,
  });

  factory TokenModel.fromSymbol(String symbol) {
    return allTokens.firstWhere((e) => e.symbol == symbol);
  }

  static TokenModel? fromSymbolOrNull(String symbol) {
    return allTokens.firstWhereOrNull((e) => e.symbol == symbol);
  }

  @override
  List<Object?> get props => [chainName, contract, symbol];

  String getAssetString(double quantity) {
    return "${quantity.toStringAsFixed(precision)} $symbol";
  }
}

const seedsToken = TokenModel(
  chainName: "Telos",
  contract: "token.seeds",
  symbol: "SEEDS",
  name: "Seeds",
  backgroundImage: 'assets/images/wallet/currency_info_cards/seeds/background.jpg',
  logo: 'assets/images/wallet/currency_info_cards/seeds/logo.jpg',
  balanceSubTitle: 'Wallet Balance',
);

const husdToken = TokenModel(
  chainName: "Telos",
  contract: "husd.hypha",
  symbol: "HUSD",
  name: "HUSD",
  backgroundImage: 'assets/images/wallet/currency_info_cards/husd/background.jpg',
  logo: 'assets/images/wallet/currency_info_cards/husd/logo.jpg',
  balanceSubTitle: 'Wallet Balance',
  precision: 2,
);

const hyphaToken = TokenModel(
  chainName: "Telos",
  contract: "hypha.hypha",
  symbol: "HYPHA",
  name: "Hypha",
  backgroundImage: 'assets/images/wallet/currency_info_cards/hypha/background.jpg',
  logo: 'assets/images/wallet/currency_info_cards/hypha/logo.jpg',
  balanceSubTitle: 'Wallet Balance',
  precision: 2,
);

const localScaleToken = TokenModel(
  chainName: "Telos",
  contract: "token.local",
  symbol: "LSCL",
  name: "LocalScale",
  backgroundImage: 'assets/images/wallet/currency_info_cards/lscl/background.jpg',
  logo: 'assets/images/wallet/currency_info_cards/lscl/logo.png',
  balanceSubTitle: 'Wallet Balance',
);

const starsToken = TokenModel(
  chainName: "Telos",
  contract: "star.seeds",
  symbol: "STARS",
  name: "Stars",
  backgroundImage: 'assets/images/wallet/currency_info_cards/stars/background.jpg',
  logo: 'assets/images/wallet/currency_info_cards/stars/logo.jpg',
  balanceSubTitle: 'Wallet Balance',
);

const telosToken = TokenModel(
  chainName: "Telos",
  contract: "eosio.token",
  symbol: "TLOS",
  name: "Telos",
  backgroundImage: 'assets/images/wallet/currency_info_cards/tlos/background.png',
  logo: 'assets/images/wallet/currency_info_cards/tlos/logo.png',
  balanceSubTitle: 'Wallet Balance',
);
