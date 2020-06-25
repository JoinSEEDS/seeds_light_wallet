import 'package:dartesr/eosio_signing_request.dart';
import 'package:eosdart/eosdart.dart';

class EsrService {

  EOSClient _eosClient;

  EsrService();

  void update(EOSClient client) {
    this._eosClient = client;
  }

  Stream<EosioSigningRequest> test(String esrUri, String account) {
    return EosioSigningRequest
      .factory(_eosClient, esrUri, account)
      .asStream()
      .map((EosioSigningRequest esr) => esr);
  }
  
}