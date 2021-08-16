import 'package:flutter_test/flutter_test.dart';
import 'package:seeds/v2/datasource/local/util/seeds_esr.dart';

void main() {
  group('dartesr', () {
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

    test('login signing', () async {
      final esr =
          'esr:AgACAwACO2h0dHBzOi8vY2IuYW5jaG9yLmxpbmsvODE3NzNjYWUtYjUzZS00YTdmLTg2ZjctNzJmOTQzZjhiYTk3AQRsaW5rKgAIAAAA06oHAAKLu05xjZ9d38TXa0W9f_WH76gGXk4wxIzEw31kEpVMQg';

      final request = SeedsESR(uri: esr);

      await request.resolve(account: "illumination");

      print("identity action: ${request.actions.first.toJson()}");

      final action = request.actions.first;

      expect(action.name, 'identity');
    });
  });
}
