import 'dart:convert';
import 'package:async/async.dart';
import 'package:collection/collection.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:json_schema2/json_schema2.dart';
import 'package:seeds/datasource/remote/api/tokenmodels_repository.dart';
import 'package:seeds/datasource/remote/firebase/firebase_remote_config.dart';
import 'package:seeds/domain-shared/shared_use_cases/get_token_models_use_case.dart';
import 'package:seeds/screens/wallet/components/tokens_cards/components/currency_info_card.dart';


class TokenModel extends Equatable {
  static const seedsEcosysUsecase = 'seedsecosys';
  static List<TokenModel> allTokens = [seedsToken];
  static JsonSchema? tmastrSchema;
  static Map<String, int?> contractPrecisions = {"token.seeds#SEEDS": 4};
  final String chainName;
  final String contract;
  final String symbol;
  final String name;
  final String backgroundImageUrl;
  final String logoUrl;
  final String balanceSubTitle;
  final String overdraw;
  final int precision;
  final List<String>? usecases;

  String get id => "$contract#$symbol";

  ImageProvider get backgroundImage {
    return
      backgroundImageUrl.startsWith("assets") ?
      AssetImage(backgroundImageUrl) as ImageProvider :
      NetworkImage(backgroundImageUrl);
  }
  ImageProvider get logo {
    return
      logoUrl.startsWith("assets") ?
      AssetImage(logoUrl) as ImageProvider :
      NetworkImage(logoUrl);
  }

  const TokenModel({
    required this.chainName,
    required this.contract,
    required this.symbol,
    required this.name,
    required this.backgroundImageUrl,
    required this.logoUrl,
    required this.balanceSubTitle,
    required this.overdraw,
    this.precision = 4,
    this.usecases,
  });

  static Future<Result<void>> installSchema() async {
    final result = await TokenModelsRepository().getSchema();
      if(result.isValue) {
        final tmastrSchemaMap = result.asValue!.value;
        tmastrSchema = JsonSchema.createSchema(tmastrSchemaMap);
        return Result.value(null);
      }
      print('Error getting Token Master schema from chain');
      return result;
  }

  static TokenModel? fromJson(Map<String,dynamic> data) {
    final Map<String,dynamic> parsedJson = json.decode(data["json"]);
    bool extendJson(String dataField, String jsonField) {
      final jsonData = parsedJson[jsonField];
      if( jsonData != null && jsonData != data[dataField] ) {
        print('${data[dataField]}: mismatched $dataField in json'
            ' $jsonData, ${data[dataField]}');
        return false;
      } else {
        parsedJson[jsonField] ??= data[dataField];
        return true;
      }
    }
    if (!( extendJson("chainName", "chain") &&
           extendJson("contract", "account") &&
           extendJson("symbolcode", "symbol") &&
           extendJson("usecases", "usecases"))) {
      return null;
    }
    if(tmastrSchema == null) {
      return null;
    }
    final validationErrors = tmastrSchema!.validateWithErrors(parsedJson);
    if(validationErrors.isNotEmpty) {
      print('${data["symbolcode"]}:\t${validationErrors.map((e) => e.toString())}');
      return null;
    }
    return TokenModel(
        chainName: parsedJson["chain"]!,
        contract: parsedJson["account"]!,
        symbol: parsedJson["symbol"]!,
        name: parsedJson["name"]!,
        logoUrl: parsedJson["logo"]!,
        balanceSubTitle: parsedJson["subtitle"],
        backgroundImageUrl: parsedJson["bg_image"] ?? CurrencyInfoCard.defaultBgImage,
        overdraw: parsedJson["overdraw"] ?? "allow",
        precision: parsedJson["precision"] ?? 4,
        usecases: parsedJson["usecases"],
      );
  }

  factory TokenModel.fromId(String tokenId) {
    return allTokens.firstWhere((e) => e.id == tokenId);
  }

  static TokenModel? fromSymbolOrNull(String symbol) {
    return allTokens.firstWhereOrNull((e) => e.symbol == symbol);
  }

  @override
  List<Object?> get props => [chainName, contract, symbol];

  static String getAssetString(String? id, double quantity) {
    if (id!=null && contractPrecisions.containsKey(id)) {
      final symbol = TokenModel.fromId(id).symbol;
      return symbol==null ? "" : "${quantity.toStringAsFixed(contractPrecisions[id]!)} $symbol";
    } else {
      return "";
    }
  }

  void setPrecisionFromString(String s) {
    final amount = s.split(' ')[0];
    final ss = amount.split('.');
    if (ss.isEmpty) {
      return;
    }
    contractPrecisions[this.id] = ss.length==1 ? 0 : ss[1].length;
  }

  // enabling 'send' transfer validity checks, e.g. Mutual Credit,
  //  membership limitations
  bool blockTransfer(double insufficiency, String? toAccount) {
    if (overdraw == "block") {
      return insufficiency > 0;
    } else if (overdraw == "allow") {
      return false;
    }
    print("unexpected overdraw field: $overdraw");
    return false;
  }
  String? warnTransfer(double insufficiency, String? toAccount) {
    return insufficiency > 0 ? "insufficient balance" : null;
  }

  static Future<void> updateModels(List<String> acceptList, [List<String>? infoList]) async {
    final selector = TokenModelSelector(acceptList: acceptList, infoList: infoList);
    final tokenListResult = await GetTokenModelsUseCase().run(selector);
    if(tokenListResult.isError) {
      return;
    }
    final tokenList = tokenListResult.asValue!.value;
    for(final newtoken in tokenList) {
      allTokens.removeWhere((token) => token.contract==newtoken.contract
                                       && token.chainName==newtoken.chainName
                                       && token.symbol==newtoken.symbol);
    }
    allTokens.addAll(tokenList);
  }

  static Future<void> installModels(List<String> acceptList, [List<String>? infoList]) async {
    if( remoteConfigurations.featureFlagTokenMasterListEnabled) {
      final installResult = await installSchema();
      if(installResult.isValue) {
        allTokens = [seedsToken];
        await updateModels(acceptList, infoList);
        return;
      }
    }
    allTokens = _staticTokenList;
    contractPrecisions = Map.fromEntries(allTokens.map((t) => MapEntry(t.id , t.precision)));
  }

  static void pruneRemoving(List<String> useCaseList) {
    allTokens.removeWhere((token) =>
        token.usecases?.any((uc) => useCaseList.contains(uc)) ?? false);
  }

  static void pruneKeeping(List<String> useCaseList) {
    allTokens.removeWhere((token) => !
    (token.usecases?.any((uc) => useCaseList.contains(uc)) ?? false));
  }
}

const seedsToken = TokenModel(
  chainName: "Telos",
  contract: "token.seeds",
  symbol: "SEEDS",
  name: "Seeds",
  backgroundImageUrl: 'assets/images/wallet/currency_info_cards/seeds/background.jpg',
  logoUrl: 'assets/images/wallet/currency_info_cards/seeds/logo.jpg',
  balanceSubTitle: 'Wallet Balance',
  overdraw: "block",
  usecases: ["lightwallet", TokenModel.seedsEcosysUsecase],
);

final _staticTokenList = [seedsToken, _husdToken, _hyphaToken, _localScaleToken, _starsToken, _telosToken];
const _husdToken = TokenModel(
  chainName: "Telos",
  contract: "husd.hypha",
  symbol: "HUSD",
  name: "HUSD",
  backgroundImageUrl: 'assets/images/wallet/currency_info_cards/husd/background.jpg',
  logoUrl: 'assets/images/wallet/currency_info_cards/husd/logo.jpg',
  balanceSubTitle: 'Wallet Balance',
  overdraw: "block",
  precision: 2,
  usecases: ["lightwallet", TokenModel.seedsEcosysUsecase],
);

const _hyphaToken = TokenModel(
  chainName: "Telos",
  contract: "hypha.hypha",
  symbol: "HYPHA",
  name: "Hypha",
  backgroundImageUrl: 'assets/images/wallet/currency_info_cards/hypha/background.jpg',
  logoUrl: 'assets/images/wallet/currency_info_cards/hypha/logo.jpg',
  balanceSubTitle: 'Wallet Balance',
  overdraw: "block",
  precision: 2,
  usecases: ["lightwallet", TokenModel.seedsEcosysUsecase],
);

const _localScaleToken = TokenModel(
  chainName: "Telos",
  contract: "token.local",
  symbol: "LSCL",
  name: "LocalScale",
  backgroundImageUrl: 'assets/images/wallet/currency_info_cards/lscl/background.jpg',
  logoUrl: 'assets/images/wallet/currency_info_cards/lscl/logo.png',
  balanceSubTitle: 'Wallet Balance',
  overdraw: "block",
  usecases: ["lightwallet"],
);

const _starsToken = TokenModel(
  chainName: "Telos",
  contract: "star.seeds",
  symbol: "STARS",
  name: "Stars",
  backgroundImageUrl: 'assets/images/wallet/currency_info_cards/stars/background.jpg',
  logoUrl: 'assets/images/wallet/currency_info_cards/stars/logo.jpg',
  balanceSubTitle: 'Wallet Balance',
  overdraw: "block",
  usecases: ["lightwallet"],
);

const _telosToken = TokenModel(
  chainName: "Telos",
  contract: "eosio.token",
  symbol: "TLOS",
  name: "Telos",
  backgroundImageUrl: 'assets/images/wallet/currency_info_cards/tlos/background.png',
  logoUrl: 'assets/images/wallet/currency_info_cards/tlos/logo.png',
  balanceSubTitle: 'Wallet Balance',
  overdraw: "block",
  usecases: ["lightwallet"],
);
