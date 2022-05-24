// we need TokenBalanceData - move to its own files

// class ExtraTokenData {
//   ExtraTokenData({this.title, this.tokens});
//   final String? title;
//   final List<TokenBalanceData>? tokens;
// }

/// none-native token data
/// 1. [id] foreign asset id (Acala tokens module).
/// 2. [name] <kUSD> for Karura USD.
/// 3. [symbol] <KUSD> for Karura USD.
/// 4. [fullName] <Karura US Dollar> for Karura USD.
/// 5. [type] <Token | DexShare | ForeignAsset> for Karura tokens.
/// 6. [tokenNameId] acala.js formatted tokenNameId, <fa://0> for {ForeignAsset: 0}.
/// 6. [currencyId] acala currencyId type, {ForeignAsset: 0} for <fa://0>.
class TokenBalanceData {
  TokenBalanceData(
      {this.id,
      this.name,
      this.tokenNameId,
      this.symbol,
      this.type = 'Token',
      this.currencyId,
      this.src,
      this.minBalance,
      this.fullName,
      this.decimals,
      this.amount,
      this.locked,
      this.reserved,
      this.detailPageRoute,
      this.price,
      this.isCacheChange = false});

  final String? id;
  final String? name;
  final String? tokenNameId;
  final String? symbol;
  final String type;
  final Map? currencyId;
  final Map? src;
  final String? minBalance;
  final String? fullName;
  final int? decimals;
  String? amount;
  final String? locked;
  final String? reserved;

  String? detailPageRoute;
  final double? price;
  bool isCacheChange;
}
