import 'package:seeds/datasource/remote/model/invite_model.dart';
import 'package:seeds/datasource/remote/model/profile_model.dart';

class InvitesItemsData {
  final InviteModel invite;
  final ProfileModel? profileModel;

  InvitesItemsData(this.invite, this.profileModel);
}
