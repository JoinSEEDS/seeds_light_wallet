import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:seeds/v2/domain-shared/page_state.dart';
import 'package:seeds/v2/screens/dashboard/wallet/components/transactions/interactor/mappers/member_state_mapper.dart';
import 'package:seeds/v2/screens/dashboard/wallet/components/transactions/interactor/usecases/load_member_data_usecase.dart';
import 'package:seeds/v2/screens/dashboard/wallet/components/transactions/interactor/viewmodels/member_events.dart';
import 'package:seeds/v2/screens/dashboard/wallet/components/transactions/interactor/viewmodels/member_state.dart';


class MemberBloc extends Bloc<MemberEvent, MemberState> {
  MemberBloc(String accountName) : super(MemberState.initial(accountName));

  @override
  Stream<MemberState> mapEventToState(MemberEvent event) async* {
    if (event is OnLoadMemberData) {
      yield state.copyWith(pageState: PageState.loading);

      final result = await LoadMemberDataUseCase().run(event.account);

      yield MemberStateMapper().mapResultToState(state, result);
    }
  }
}
