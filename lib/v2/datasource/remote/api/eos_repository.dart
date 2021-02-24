import 'package:async/async.dart';
import 'package:eosdart/eosdart.dart';
import 'package:seeds/constants/config.dart';
import 'package:seeds/v2/datasource/remote/api/network_repository.dart';
import 'package:seeds/v2/datasource/remote/model/update_profile_response.dart';

class EosRepository extends NetworkRepository {
  String cpuPrivateKey = Config.cpuPrivateKey;

  Transaction buildFreeTransaction(List<Action> actions, String accountName) {
    var freeAuth = <Authorization>[
      Authorization()
        ..actor = 'harvst.seeds'
        ..permission = 'payforcpu',
      Authorization()
        ..actor = accountName
        ..permission = 'active'
    ];

    var freeAction = Action()
      ..account = 'harvst.seeds'
      ..name = 'payforcpu'
      ..authorization = freeAuth
      ..data = {'account': accountName};

    var transaction = Transaction()
      ..actions = [
        freeAction,
        ...actions,
      ];

    return transaction;
  }

  Future<Result> updateProfile({
    String nickname,
    String image,
    String story,
    String roles,
    String skills,
    String interests,
    String accountName,
    String privateKey,
    String nodeEndpoint,
  }) async {
    print('[eos] update profile');

    var transaction = buildFreeTransaction([
      Action()
        ..account = 'accts.seeds'
        ..name = 'update'
        ..authorization = [
          Authorization()
            ..actor = accountName
            ..permission = 'active'
        ]
        ..data = {
          'user': accountName,
          'type': 'individual',
          'nickname': nickname,
          'image': image,
          'story': story,
          'roles': roles,
          'skills': skills,
          'interests': interests
        }
    ], accountName);

    var client = EOSClient(nodeEndpoint, 'v1', privateKeys: [privateKey, cpuPrivateKey]);

    return client.pushTransaction(transaction, broadcast: true).then((dynamic response) {
      return ValueResult(UpdateProfileResponse.fromJson(Map<String, dynamic>.from(response)));
    }).catchError((error) => mapError(error));
  }
}
