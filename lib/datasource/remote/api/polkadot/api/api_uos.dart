import 'package:seeds/datasource/remote/api/polkadot/api/polkawallet_api.dart';
import 'package:seeds/datasource/remote/api/polkadot/api/types/txInfoData.dart';
import 'package:seeds/datasource/remote/api/polkadot/api/types/uosQrParseResultData.dart';
import 'package:seeds/datasource/remote/api/polkadot/service/uos.dart';
import 'package:seeds/datasource/remote/api/polkadot/storage/keyring.dart';

/// Steps to complete offline-signature as a cold-wallet:
/// 1. parseQrCode: parse raw data of QR code, and get signer address from it.
/// 2. signAsync: sign the extrinsic with password, get signature.
/// 3. addSignatureAndSend: send tx with address of step1 & signature of step2.
///
/// Support offline-signature as a hot-wallet: makeQrCode
class ApiUOS {
  ApiUOS(this.apiRoot, this.service);

  final PolkawalletApi apiRoot;
  final ServiceUOS service;

  /// parse data of QR code.
  /// @return: [UosQrParseResultData]
  Future<UosQrParseResultData> parseQrCode(Keyring keyring, String data) async {
    final res = await service.parseQrCode(keyring.store.list.toList(), data);
    return UosQrParseResultData.fromJson(res);
  }

  /// this function must be called after parseQrCode.
  /// @return: signature [String]
  Future<String?> signAsync(String chain, String password) async {
    return service.signAsync(chain, password);
  }

  /// [onStatusChange] is a callback when tx status change.
  /// @return txHash [string] if tx finalized success.
  Future<Map?> addSignatureAndSend(
    String address,
    dynamic signed,
    Function(String) onStatusChange,
  ) async {
    final res = service.addSignatureAndSend(
      address,
      signed,
      onStatusChange,
    );
    return res;
  }

  Future<Map?> makeQrCode(TxInfoData txInfo, List params, {String? rawParam}) async {
    final Map? res = await service.makeQrCode(
      txInfo.toJson(),
      params,
      rawParam: rawParam,
      ss58: apiRoot.connectedNode!.ss58,
    );
    return res;
  }
}
