import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:seeds/v2/constants/system_accounts.dart';
import 'package:seeds/v2/datasource/local/member_model_cache_item.dart';
import 'package:seeds/v2/domain-shared/page_state.dart';
import 'package:seeds/v2/screens/dashboard/wallet/components/transactions/interactor/mappers/member_state_mapper.dart';
import 'package:seeds/v2/screens/dashboard/wallet/components/transactions/interactor/usecases/load_member_data_usecase.dart';
import 'package:seeds/v2/screens/dashboard/wallet/components/transactions/interactor/viewmodels/member_events.dart';
import 'package:seeds/v2/screens/dashboard/wallet/components/transactions/interactor/viewmodels/member_state.dart';


const cacheExpiryMinutes = 30;

class MemberBloc extends Bloc<MemberEvent, MemberState> {
  MemberBloc(String accountName) : super(MemberState.initial(accountName));

  @override
  Stream<MemberState> mapEventToState(MemberEvent event) async* {
    if (event is OnLoadMemberData) {
      var account = event.account;

      // handle special system accounts
      if (SystemAccounts.isSystemAccount(account)) {
        yield state.copyWith(pageState: PageState.success, member: SystemAccounts.getSystemAccount(account)!);
        return;
      }

      yield state.copyWith(pageState: PageState.loading);
      var box = await Hive.openBox('members_box');

      // If we have a cached item, use it
      MemberModelCacheItem? cacheItem = box.get(account);
      if (cacheItem != null) {
        yield state.copyWith(pageState: PageState.success, member: cacheItem.member);
        if (cacheItem.refreshTimeStamp < DateTime.now().millisecondsSinceEpoch) {
          return;
        }
      }

      final result = await LoadMemberDataUseCase().run(account);

      // store result in cache
      if (!result.isError && result.asValue != null) {
        await box.put(
            account,
            MemberModelCacheItem(result.asValue!.value,
                DateTime.now().millisecondsSinceEpoch + Duration.millisecondsPerMinute * cacheExpiryMinutes));
      }

      yield MemberStateMapper().mapResultToState(state, result);
    }
  }
}
