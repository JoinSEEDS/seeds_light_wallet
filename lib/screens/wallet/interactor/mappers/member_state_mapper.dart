import 'package:async/async.dart';
import 'package:seeds/datasource/remote/model/profile_model.dart';
import 'package:seeds/domain-shared/page_state.dart';
import 'package:seeds/screens/wallet/interactor/viewmodels/member_bloc.dart';

class MemberStateMapper {
  MemberState mapResultToState(MemberState currentState, Result result) {
    return result.isError
        ? currentState.copyWith(pageState: PageState.failure)
        : currentState.copyWith(
            member: result.asValue?.value as ProfileModel?,
            pageState: PageState.success,
          );
  }
}
