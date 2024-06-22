import 'package:flutter_test/flutter_test.dart';
import 'package:seeds/crypto/dart_esr/dart_esr.dart' as esr;
import 'package:seeds/datasource/local/models/token_data_model.dart';
import 'package:seeds/datasource/local/util/seeds_esr.dart';
import 'package:seeds/datasource/remote/api/invoice_repository.dart';
import 'package:seeds/datasource/remote/firebase/firebase_remote_config.dart';
import 'package:seeds/datasource/remote/model/token_model.dart';

void main() {
  group('dartesr', () {
    setUp(() {
      expect(unitTestMode, true, reason: "unitTestMode must be true to run these tests");
      expect(testnetMode, true, reason: "testnetMode must be true to run these tests");
    });
    test('decode esr', () async {
      final esr =
          'esr://gmNcs7jsE9uOP6rL3rrcvpMWUmN27LCdleD836_eTzFz-vCSjQEMXhmEFohe6ry3yuguIyNEiIEJSgvCBA58nnUl1dgwlAEoAAA';

      final request = SeedsESR(uri: esr);

      await request.resolve(account: "bukabukabuka");

      final action = request.actions.first;
      final data = Map<String, dynamic>.from(action.data! as Map<dynamic, dynamic>);

      expect(request.actions.first.account, 'eosio');
      expect(request.actions.first.name, 'voteproducer');
      expect(data['voter'], 'bukabukabuka');
      expect(data['proxy'], 'eosnationftw');
      expect(data['producers'], []);
    });

    test('decode esr 2', () async {
      final esr = 'esr://gmNgYmAoCOJqXqlwloGBIVzX5uxZRkYGCGCC0oowAYeHIR9XFWsWFwhCRFiCXV1dgoEMIBcA';

      final request = SeedsESR(uri: esr);

      await request.resolve(account: "bukabukabuka");

      print("2 action: ${request.actions.first.toJson()}");

      final action = request.actions.first;
      final data = Map<String, dynamic>.from(action.data! as Map<dynamic, dynamic>);

      expect(request.actions.first.account, 'token.seeds');
      expect(request.actions.first.name, 'transfer');
      expect(data['from'], 'bukabukabuka');
      expect(data['to'], 'igorberlenko');
      expect(data['quantity'], '7.0000 SEEDS');
      expect(data['memo'], '');
    });

    test('decode esr 3', () async {
      final esr =
          'esr:gmN0S9_Eeqy57zv_9xn9eU3hL_bxCbUs-jptJqsXY3-JtawgU09qb_yjZdUau3YzAAEjQ0EQV_NKhbNAdriuzdmzjIwMEMAEpTVgAgeWdbM9zBDoDTgM4bMEu7q6BDMwsJekFpdk5qUDzWIAAA';

      final request = SeedsESR(uri: esr);

      await request.resolve(account: "illumination");

      print("3 action: ${request.actions.first.toJson()}");

      final action = request.actions.first;
      final data = Map<String, dynamic>.from(action.data! as Map<dynamic, dynamic>);

      expect(request.actions.first.account, 'token.seeds');
      expect(request.actions.first.name, 'transfer');
      expect(data['from'], 'illumination');
      expect(data['to'], 'localscaling');
      expect(data['quantity'], '5.0000 SEEDS');
      expect(data['memo'], 'testing');
    });

    test('decode esr with 112 Seeds', () async {
      final esr =
          'esr://gmN0S9_Eeqy57zv_9xn9eU3hL_bxCbUs-jptJqsXY3-JtawgA0NBEFfzSoWzDAwM4bo2Z88yMjJAABOUVoQJGKw8nWa1MrnkhZQgmM8S7OrqEgxkABUAAA';

      final request = SeedsESR(uri: esr);

      await request.resolve(account: "bukabukabuka");

      print("1 action: ${request.actions.first.toJson()}");

      final action = request.actions.first;
      final data = Map<String, dynamic>.from(action.data! as Map<dynamic, dynamic>);

      expect(request.actions.first.account, 'token.seeds');
      expect(request.actions.first.name, 'transfer');
      expect(data['from'], 'bukabukabuka');
      expect(data['to'], 'illumination');
      expect(data['quantity'], '112.1000 SEEDS');
      expect(data['memo'], '');
    });

    test('Encode and decode ESR code', () async {
      final result = await InvoiceRepository().createInvoice(
        tokenAmount: TokenDataModel(100, token: seedsToken),
        accountName: "harvst.seeds",
        tokenContract: "token.seeds",
      );
      final String esr = result.asValue!.value;

      print("esr: $esr");
      // esr://gmN0S9_Eeqy57zv_9xn9eU3hL_bxCbUs-jptJqsXY3-JtawgA0NBEFfzSoWzDAwM4bo2Z88yMjJAABOUVoQJNEwOkkjZsz7TwYkfzGcJdnV1CQYygAoA
      // compare: https://eosio.to/gmN0S9_Eeqy57zv_9xn9eU3hL_bxCbUs-jptJqsXY3-JtawgA0NBEFfzSoWzDAwM4bo2Z88yMjJAABOUVoQJNEwOkkjZsz7TwYkfzGcJdnV1CQYygAoA

      final request = SeedsESR(uri: esr);

      await request.resolve(account: "bukabukabuka");

      print("1 action: ${request.actions.first.toJson()}");

      final action = request.actions.first;
      final data = Map<String, dynamic>.from(action.data! as Map<dynamic, dynamic>);

      expect(request.actions.first.account, 'token.seeds');
      expect(request.actions.first.name, 'transfer');
      expect(data['from'], 'bukabukabuka');
      expect(data['to'], "harvst.seeds");
      expect(data['quantity'], '100.0000 SEEDS');
      expect(data['memo'], '');
    });

    test('ESR encode and decode with multiple actions', () async {
      final actions = [
        esr.Action()
          ..account = "accts.seeds"
          ..name = "vouch"
          ..authorization = [esr.ESRConstants.PlaceholderAuth]
          ..data = {
            "sponsor": esr.ESRConstants.PlaceholderName,
            "account": "illumination",
          },
        esr.Action()
          ..account = "harvst.seeds"
          ..name = "unplant"
          ..authorization = [esr.ESRConstants.PlaceholderAuth]
          ..data = {
            "from": esr.ESRConstants.PlaceholderName,
            "quantity": "11.0000 SEEDS",
          },
      ];

      const telosChainId = "4667b205c6838ef70ff7988f6e8257e8be0e1284a2f59699054a018f743b1d11";

      final esr.SigningRequestCreateArguments args =
          esr.SigningRequestCreateArguments(actions: actions, chainId: telosChainId);

      final signingRequestManager = await esr.SigningRequestManager.create(args,
          options: esr.defaultSigningRequestEncodingOptions(
            nodeUrl: remoteConfigurations.hyphaEndPoint,
          ));

      final esrURL = signingRequestManager.encode();

      print("esr: $esrURL");
      /* compare here:
      http://eosio.to/gmN0S9_Eeqy57zv_9xn9eU3hL_bxCbUs-jptJqsXY3-JtawgIxNDQRAX8xxBIwYgaGgzucvIyAABTFBaACZgsPJ0mtXK5JKGyUESKXvWZwKFFPyFX1_B0CEBE9iwFsJiCXZ1dQlmYADyAA
      */

      final request = SeedsESR(uri: esrURL);

      await request.resolve(account: "bukabukabuka");
      final jsonActions = request.actions.map((e) => e.toJson());

      expect(
        esrURL,
        'esr://gmN0S9_Eeqy57zv_9xn9eU3hL_bxCbUs-jptJqsXY3-JtawgIxNDQRAX8xxBIwYgaGgzucvIyAABTFBaACZgsPJ0mtXK5JKGyUESKXvWZwKFFPyFX1_B0CEBE9iwFsJiCXZ1dQlmYADyAA',
      );

      expect(request.actions.first.account, 'accts.seeds');
      expect(request.actions.first.name, 'vouch');
      expect(jsonActions.first["data"]['sponsor'], 'bukabukabuka');
      expect(jsonActions.first["data"]['account'], "illumination");

      expect(request.actions.last.account, 'harvst.seeds');
      expect(request.actions.last.name, 'unplant');
      expect(jsonActions.last["data"]['from'], 'bukabukabuka');
      expect(jsonActions.last["data"]['quantity'], "11.0000 SEEDS");
    });

    test('Signing request V2', () async {
      final esr =
          'esr:AgACAwACO2h0dHBzOi8vY2IuYW5jaG9yLmxpbmsvODE3NzNjYWUtYjUzZS00YTdmLTg2ZjctNzJmOTQzZjhiYTk3AQRsaW5rKgAIAAAA06oHAAKLu05xjZ9d38TXa0W9f_WH76gGXk4wxIzEw31kEpVMQg';

      final request = SeedsESR(uri: esr);

      await request.resolve(account: "illumination");

      print("identity action: ${request.actions.first.toJson()}");

      final action = request.actions.first;

      expect(action.name, 'identity');
      expect(action.authorization?.first?.actor, 'illumination');
      expect(action.authorization?.first?.permission, 'active');
    });

    test('idenity request V3', () async {
      // actual hypha v3 login
      final esr =
          'esr:gz2NP08CMRyG78C_iV_A7bcJhuu13BWQY8FFDRBjIOpGerUXmmvaS3sJiR_AGAcHV-POB2B2d3JxMG5-E5GB9cn7Po_nVz3P-_IPZM-rJLOyLFw3DHmKmOYzY5GSOg8jzNhdhjtBlsYsiNudVpASzAOS4vgkipuCCVrZ-p9--Btbdfdn__nhtbG8Whz_fr8UT8vuJ3_U-aKf7BweRe-9N7-_bgzXCRShDpxaM3fCTizTrjC2XOEmojAy91IpFlKEoTZiXOrSuFkCF7oUClYALsdwCwRPCZ2269AvCiVuRDqQZdjCFBFEKNQG55PRsAFK5gLOBM9NHa6FddLokFAUw5hlzMrNYdtxU4i9VJncIWn-AA';

      final request = SeedsESR(uri: esr);

      await request.resolve(account: "illumination");

      print("identity action: ${request.actions.first.toJson()}");

      print("callback: ${request.manager.signingRequest.callback}");
      print("SR: ${request.manager.signingRequest}");

      final action = request.actions.first;

      expect(action.name, 'identity');
      expect(action.authorization?.first?.actor, 'illumination');
      expect(action.authorization?.first?.permission, 'active');
    });
  });
}
