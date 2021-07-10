import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:seeds/v2/constants/system_accounts.dart';
import 'package:seeds/v2/datasource/remote/model/member_model.dart';
import 'package:seeds/v2/domain-shared/page_state.dart';
import 'package:seeds/v2/screens/dashboard/components/transactions_list/interactor/mappers/member_state_mapper.dart';
import 'package:seeds/v2/screens/dashboard/components/transactions_list/interactor/usecases/load_member_data_usecase.dart';
import 'package:seeds/v2/screens/dashboard/components/transactions_list/interactor/viewmodels/member_events.dart';
import 'package:seeds/v2/screens/dashboard/components/transactions_list/interactor/viewmodels/member_state.dart';

const timePostFix = "-time";

class MemberBloc extends Bloc<MemberEvent, MemberState> {
  MemberBloc(String accountName) : super(MemberState.initial(accountName));

  @override
  Stream<MemberState> mapEventToState(MemberEvent event) async* {
    if (event is LoadMemberDataEvent) {
      if (SystemAccounts.isSystemAccount(event.account)) {
        yield state.copyWith(pageState: PageState.success, member: SystemAccounts.getSystemAccount(event.account)!);
        return;
      }

      var box = await Hive.openBox('members');

      MemberModel? cachedMember = box.get(event.account);
      if (cachedMember != null) {
        print("mmeber cached ${event.account}");
        yield state.copyWith(pageState: PageState.success, member: cachedMember);
        int time = box.get(event.account + timePostFix);
        int age = DateTime.now().millisecondsSinceEpoch - time;
        if (Duration(milliseconds: age).inMinutes < 30) {
          print("not reloading age: ${Duration(milliseconds: age).inSeconds} s");
          return;
        }
      } else {
        yield state.copyWith(pageState: PageState.loading);
      }

      final result = await LoadMemberDataUseCase().run(event.account);

      if (result.isValue && result.asValue != null && result.asValue!.value != cachedMember) {
        await box.put(event.account, result.asValue!.value);
        await box.put(event.account + timePostFix, DateTime.now().millisecondsSinceEpoch);
        yield state.copyWith(pageState: PageState.loading);
      }

      yield MemberStateMapper().mapResultToState(state, result);
    }
  }
}
