import 'package:dartesr/eosio_signing_request.dart';
import 'package:eosdart/eosdart.dart';
import 'package:flutter/cupertino.dart';

class EsrService {

  EOSClient _eosClient;

  EsrService();

  void update(EOSClient client) {
    this._eosClient = client;
  }

  void test(String esrUri, String account) async {
    final bla = await EosioSigningRequest
      .factory(_eosClient, esrUri, account)
      .then((value) {
        debugPrint("what: $value");
      }).catchError((error) {
        debugPrint("error: $error");
      });

    debugPrint("bla: $bla");

    /*return EosioSigningRequest
      .factory(_eosClient, esrUri, account)
      .asStream()
      .map((EosioSigningRequest esr) => esr);*/
    //return Stream.value(null);
  }
  
}