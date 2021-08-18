import 'package:seeds/datasource/remote/model/profile_model.dart';
import 'package:seeds/screens/profile_screens/contribution/interactor/viewmodels/scores_view_model.dart';

class ProfileValuesArguments {
  final ProfileModel profile;
  final ScoresViewModel scores;

  ProfileValuesArguments({required this.profile, required this.scores});
}
