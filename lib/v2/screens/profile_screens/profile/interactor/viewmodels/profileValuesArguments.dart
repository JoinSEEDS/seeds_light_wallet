import 'package:seeds/v2/datasource/remote/model/profile_model.dart';
import 'package:seeds/v2/datasource/remote/model/score_model.dart';

class ProfileValuesArguments {
  final ProfileModel profile;
  final ScoreModel scores;

  ProfileValuesArguments({required this.profile, required this.scores});
}
