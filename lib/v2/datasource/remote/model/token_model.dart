import 'package:equatable/equatable.dart';

class TokenModel extends Equatable {
  static const AllTokens = [SeedsToken, HusdToken, HyphaToken, LocalScaleToken];

  final String chainName;
  final String contract;
  final String symbol;
  final String name;
  final String backgroundImage;
  final String logo;
  final String balanceSubTitle;

  String get id => "$contract#$symbol";

  const TokenModel({
    required this.chainName,
    required this.contract,
    required this.symbol,
    required this.name,
    required this.backgroundImage,
    required this.logo,
    required this.balanceSubTitle,
  });

  @override
  List<Object?> get props => [chainName, contract, symbol];
}

const SeedsToken = TokenModel(
    chainName: "Telos",
    contract: "token.seeds",
    symbol: "SEEDS",
    name: "Seeds",
    backgroundImage: 'assets/images/wallet/currency_info_cards/seeds/background.jpg',
    logo: 'assets/images/wallet/currency_info_cards/seeds/logo.jpg',
    balanceSubTitle: 'Wallet Balance');

const HusdToken = TokenModel(
    chainName: "Telos",
    contract: "husd.hypha",
    symbol: "HUSD",
    name: "HUSD",
    backgroundImage: 'assets/images/wallet/currency_info_cards/hypha/background.jpg',
    logo: 'assets/images/wallet/currency_info_cards/hypha/logo.jpg',
    balanceSubTitle: 'Wallet Balance');

const HyphaToken = TokenModel(
    chainName: "Telos",
    contract: "token.hypha",
    symbol: "HYPHA",
    name: "Hypha",
    backgroundImage: 'assets/images/wallet/currency_info_cards/hypha/background.jpg',
    logo: 'assets/images/wallet/currency_info_cards/hypha/logo.jpg',
    balanceSubTitle: 'Wallet Balance');

const LocalScaleToken = TokenModel(
    chainName: "Telos",
    contract: "token.local",
    symbol: "LSCL",
    name: "LocalScale",
    backgroundImage: 'assets/images/wallet/currency_info_cards/hypha/background.jpg',
    logo: 'assets/images/wallet/currency_info_cards/hypha/logo.jpg',
    balanceSubTitle: 'Wallet Balance');
