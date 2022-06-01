import 'dart:convert';
import 'package:collection/collection.dart';
import 'package:equatable/equatable.dart';
import 'package:json_schema2/json_schema2.dart';
import 'package:seeds/datasource/remote/api/tokenmodels_repository.dart';
import 'package:seeds/screens/wallet/components/tokens_cards/components/currency_info_card.dart';


class TokenModel extends Equatable {
  //static const allTokens = [seedsToken, husdToken, hyphaToken, localScaleToken, starsToken, telosToken];
  static List<TokenModel> allTokens = [seedsToken];
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
           extendJson("symbolcode", "symbol")   )) {
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
        logo: parsedJson["logo"]!,
        balanceSubTitle: parsedJson["subtitle"],
        backgroundImage: parsedJson["bg_image"] ?? CurrencyInfoCard.defaultBgImage,
        precision: parsedJson["precision"] ?? 4,
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
        allTokens.addAll(models.asValue!.value);
      } else if(models.isError) {
        print('Error updating Token Models from chain');
      }
    });
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
