// part 'balances.g.dart';

// class BalancesStore = BalancesStoreBase with _$BalancesStore;

// abstract class BalancesStoreBase with Store {
//   @observable
//   BalanceData? native;

//   @observable
//   List<TokenBalanceData> tokens = [];

//   @observable
//   bool isTokensFromCache = false;

//   @observable
//   List<ExtraTokenData>? extraTokens;

//   @action
//   void setBalance(BalanceData data) {
//     native = data;
//   }

//   @action
//   void setTokens(List<TokenBalanceData> ls, {bool isFromCache = false}) {
//     final data = ls;
//     if (!isFromCache) {
//       tokens.toList().forEach((old) {
//         final newDataIndex = ls.indexWhere((token) {
//           if (old.tokenNameId == null) {
//             // check by token.symbol with old data cache
//             return token.symbol == old.symbol || token.symbol == old.id;
//           } else {
//             // or check by tokenNameId with new data
//             return token.tokenNameId == old.tokenNameId;
//           }
//         });
//         if (newDataIndex < 0) {
//           data.add(old);
//         }
//       });
//     }

//     tokens = data;
//     isTokensFromCache = isFromCache;
//   }

//   @action
//   void setExtraTokens(List<ExtraTokenData> ls) {
//     extraTokens = ls;
//   }
// }

class ExtraTokenData {
  ExtraTokenData({this.title, this.tokens});
  final String? title;
  final List<TokenBalanceData>? tokens;
}

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
