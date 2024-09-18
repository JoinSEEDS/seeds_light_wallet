import 'dart:math' as math;

import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';


/// multilateral token swap pool
class OswapModel {
  static const Map<String, String> chainIds = 
    {'4667b205c6838ef70ff7988f6e8257e8be0e1284a2f59699054a018f743b1d11': 'Telos'};
  List<OswapPoolBalance> balances = [];

  OswapModel();

  OswapModel initTest() {

    balances.add(OswapPoolBalance(assetId: 0, tokenId: "Telos#token.seeds#SEEDS", balance: 1000, weight: 0.5));
    balances.add(OswapPoolBalance(assetId: 1, tokenId: "Telos#hypha.hypha#COSEEDS", balance: 2000, weight: 0.5));
    return this;
  }

  OswapModel loadTest() {
    return this;
  }

  SwapResult swapOutput({int? inAssetId, String? inTokenId, double? inAmount,
    int? outAssetId, String? outTokenId, double? outAmount}) {
    OswapPoolBalance? inputPoolBalance;
    OswapPoolBalance? outputPoolBalance;

      var inAsset = inAssetId;
      if(inTokenId != null && inAssetId == null) {
        // look up AssetId...
        inAsset = balances.firstWhereOrNull((bal) => bal.tokenId ==  inTokenId)?.assetId;
      }
      if(inAsset == null) {
        return SwapResult(error: "input asset not specified");
      }
      inputPoolBalance = balances.firstWhereOrNull((bal) => bal.assetId == inAsset!);
      if (inputPoolBalance == null) {
        return SwapResult(error: "invalid input asset $inAssetId");
      }

      var outAsset = outAssetId;
      if(outTokenId != null && outAssetId == null) {
        // look up AssetId...
        outAsset = balances.firstWhereOrNull((bal) => bal.tokenId ==  outTokenId)?.assetId;
      }
      if(outAsset == null) {
        return SwapResult(error: "output asset not specified");
      }
      outputPoolBalance = balances.firstWhereOrNull((bal) => bal.assetId == outAsset!);
      if (outputPoolBalance == null) {
        return SwapResult(error: "invalid output asset $outAssetId");
      }
      if(inAmount != null && outAmount == null) {
        // exact input
        // floating point calculation, exact in
        double in_bal_before = inputPoolBalance.balance;
        double in_amount = inAmount;
        double in_bal_after = in_bal_before + in_amount;
        double lc = math.log(in_bal_after/in_bal_before);
        double out_weight = outputPoolBalance.weight;
        double in_weight = inputPoolBalance.weight;
        double lnc = -in_weight/out_weight * lc;
        double out_bal_before = outputPoolBalance.balance;
        double out_bal_after = out_bal_before * math.exp(lnc);
        double computed_amt = out_bal_before - out_bal_after;

        return SwapResult(result: computed_amt);
      }
      if (inAmount == null && outAmount != null) {
        // exact output
        // floating point calculation, exact out
        double out_bal_before = outputPoolBalance!.balance;
        double out_amount = outAmount;
        double out_bal_after = out_bal_before - out_amount;
        if (out_bal_after <= 0) {
          return SwapResult(error: "pool contains ${out_bal_before} tokens; insufficient");
        }
        double lc = math.log(out_bal_after/out_bal_before);
        double out_weight = outputPoolBalance.weight;
        double in_weight = inputPoolBalance!.weight;
        double lnc = -out_weight/in_weight * lc;
        double in_bal_before = inputPoolBalance.balance;
        double in_bal_after = in_bal_before * math.exp(lnc);
        double computed_amt = in_bal_after - in_bal_before;

        return SwapResult(result: computed_amt);
      } else {
        return SwapResult(error: "swap config error");
    }
  }
}

class OswapPoolBalance {
  late int assetId;
  late  String tokenId;
  late double balance;
  late double weight;
  late bool active;

OswapPoolBalance({required this.assetId, required this.tokenId,
 this.weight = 1.0, this.balance = 0.0, this.active = false});
}

class SwapResult {
  String? error;
  double? result;

  SwapResult({this.error, this.result});
}

class OswapAsset {
  late int assetId;
  late String tokenId;
  bool active;
  String metadata;
  double weight;

  OswapAsset({required this.assetId, required this.tokenId, this.active = false, this.metadata = "", this.weight = 1.0});

  static OswapAsset? fromJson(Map<String, dynamic> json) {
    if (json.isEmpty) {
      return null;
    } else {
      final String chain_code = json['chain_code'] as String;
      final String? chainName = OswapModel.chainIds[chain_code];
      if (chainName == null) {
        return null;
      }
      final String contract_name = json['contract_name'] as String;
      final String symbol = json['symbol'] as String;
      final tokenId = '$chainName#$contract_name#$symbol';
      return OswapAsset(
        assetId: json['token_id'] as int,
        tokenId: tokenId,
        active: json['active'] as int != 0,
        metadata: json['metadata'] as String,
        weight: double.parse(json['weight'] as String),
      );
    }
  }
}