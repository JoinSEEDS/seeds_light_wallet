import 'dart:convert';
import 'package:collection/collection.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:json_schema2/json_schema2.dart';
import 'package:seeds/datasource/remote/api/tokenmodels_repository.dart';
import 'package:seeds/screens/wallet/components/tokens_cards/components/currency_info_card.dart';


class TokenModel extends Equatable {
  static const seedsEcosysUsecase = 'seedsecosys';
  static List<TokenModel> allTokens = [seedsToken];
  final String chainName;
  final String contract;
  final String symbol;
  final String name;
  final String backgroundImageUrl;
  final String logoUrl;
  final String balanceSubTitle;
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
    this.precision = 4,
    this.usecases,
  });

  // TODO(chuck): import tmastrSchemaText from public ecosystem-wide asset location
  static const String tmastrSchemaText = r'''
{
    "$schema": "http://json-schema.org/draft-04/schema#",
    "$id": "https://github.com/chuck-h/seeds-smart-contracts/blob/feature/master_token_list/assets/token_schema.json",
    "title": "token metadata",
    "description": "This document holds descriptive metadata (e.g. logo image) for cryptotokens used in the Seeds ecosystem",
    "type": "object",
    "properties": {
        "chain": {
            "description": "blockchain name",
            "type": "string",
            "enum": ["Telos","EOS","Wax"]
        },
        "symbol": {
            "description": "symbol ('ticker')",
            "type": "string",
            "minLength":1,
            "maxlength":7
        },
        "account": {
            "description": "account holding token contract",
            "type": "string",
            "minLength":3,
            "maxlength":13
        },
        "name": {
            "description": "short name of the token",
            "type": "string",
            "minLength":3,
            "maxlength":32
        },
        "logo": {
            "description": "url pointing to lo-res logo image",
            "type": "string",
            "minLength":3,
            "maxlength":128
        },
        "logo_lg": {
            "description": "url pointing to hi-res logo image",
            "type": "string",
            "minLength":3,
            "maxlength":128
        },
        "bg_image": {
            "description": "url pointing to card background image",
            "type": "string",
            "minLength":3,
            "maxlength":128
        },
        "subtitle": {
            "description": "wallet balance subtitle",
            "type": "string",
            "minLength":3,
            "maxlength":32
        },
        "precision": {
            "description": "decimal precision for display",
            "type": "integer",
            "minimum":0,
            "maximum":10
        },
        "web_link": {
            "description": "url to webpage with info about token host project",
            "type": "string",
            "minLength":3,
            "maxlength":128
        },
        "contact": {
            "description": "human contact",
            "type": "object",
            "properties": {
                "name": {
                    "description": "name of person",
                    "type": "string",
                    "maxLength": 64
                },
                "email": {
                    "description": "email",
                    "type": "string",
                    "maxLength": 64
                },
                "phone": {
                    "description": "telephone/text number",
                    "type": "string",
                    "maxLength": 32
                }
            }
        }
    },
    "required": [
        "chain",
        "symbol",
        "account",
        "name",
        "logo"
    ],
 "additionalProperties": true
}
      ''';
  static final tmastrSchema = JsonSchema.createSchema(tmastrSchemaText);
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
    final validationErrors = tmastrSchema.validateWithErrors(parsedJson);
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
        precision: parsedJson["precision"] ?? 4,
        usecases: parsedJson["usecases"],
      );
  }

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

  static Future<void> updateModels(List<String> useCaseList) async {
    await TokenModelsRepository().getTokenModels(useCaseList).then((models){
      if(models.isValue) {
        for(final newtoken in models.asValue!.value) {
          allTokens.removeWhere((token) => token.contract==newtoken.contract
                                           && token.symbol==newtoken.symbol);
        }
        allTokens.addAll(models.asValue!.value);
      } else if(models.isError) {
        print('Error updating Token Models from chain');
      }
    });
  }

  static Future<void> installModels(List<String> useCaseList) async {
    allTokens = [seedsToken];
    await updateModels(useCaseList);
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
  usecases: [TokenModel.seedsEcosysUsecase],
);

const husdToken = TokenModel(
  chainName: "Telos",
  contract: "husd.hypha",
  symbol: "HUSD",
  name: "HUSD",
  backgroundImageUrl: 'assets/images/wallet/currency_info_cards/husd/background.jpg',
  logoUrl: 'assets/images/wallet/currency_info_cards/husd/logo.jpg',
  balanceSubTitle: 'Wallet Balance',
  precision: 2,
);

const hyphaToken = TokenModel(
  chainName: "Telos",
  contract: "hypha.hypha",
  symbol: "HYPHA",
  name: "Hypha",
  backgroundImageUrl: 'assets/images/wallet/currency_info_cards/hypha/background.jpg',
  logoUrl: 'assets/images/wallet/currency_info_cards/hypha/logo.jpg',
  balanceSubTitle: 'Wallet Balance',
  precision: 2,
);

const localScaleToken = TokenModel(
  chainName: "Telos",
  contract: "token.local",
  symbol: "LSCL",
  name: "LocalScale",
  backgroundImageUrl: 'assets/images/wallet/currency_info_cards/lscl/background.jpg',
  logoUrl: 'assets/images/wallet/currency_info_cards/lscl/logo.png',
  balanceSubTitle: 'Wallet Balance',
);

const starsToken = TokenModel(
  chainName: "Telos",
  contract: "star.seeds",
  symbol: "STARS",
  name: "Stars",
  backgroundImageUrl: 'assets/images/wallet/currency_info_cards/stars/background.jpg',
  logoUrl: 'assets/images/wallet/currency_info_cards/stars/logo.jpg',
  balanceSubTitle: 'Wallet Balance',
);

const telosToken = TokenModel(
  chainName: "Telos",
  contract: "eosio.token",
  symbol: "TLOS",
  name: "Telos",
  backgroundImageUrl: 'assets/images/wallet/currency_info_cards/tlos/background.png',
  logoUrl: 'assets/images/wallet/currency_info_cards/tlos/logo.png',
  balanceSubTitle: 'Wallet Balance',
);
