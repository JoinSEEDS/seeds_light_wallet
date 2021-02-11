import 'package:async/async.dart';
import 'package:flutter/material.dart';
import 'package:seeds/v2/repositories/remote/profile_repository.dart';

export 'package:async/src/result/error.dart';
export 'package:async/src/result/result.dart';

class GetProfileUseCase {
  final ProfileRepository _profileRepository;

  GetProfileUseCase({@required ProfileRepository profileRepository})
      : assert(profileRepository != null),
        _profileRepository = profileRepository,
        super();

  Future<Result> run(String accountName) {
    return _profileRepository.getProfile(accountName);
  }
}
