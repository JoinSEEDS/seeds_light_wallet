class TokenModel {
  final String chainName;
  final String contract;
  final String symbol;
  final String name;
  const TokenModel({
    required this.chainName,
    required this.contract,
    required this.symbol,
    required this.name,
    });
}

const SeedsToken = TokenModel(
  chainName: "Telos", 
  contract: "token.seeds", 
  symbol: "SEEDS", 
  name: "Seeds");

const HusdToken = TokenModel(
  chainName: "Telos", 
  contract: "husd.hypha", 
  symbol: "HUSD", 
  name: "HUSD");

const HyphaToken = TokenModel(
  chainName: "Telos", 
  contract: "token.hypha", 
  symbol: "HYPHA", 
  name: "Hypha");