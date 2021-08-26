import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:seeds/constants/system_accounts.dart';
import 'package:seeds/datasource/local/cache_repository.dart';
import 'package:seeds/datasource/local/member_model_cache_item.dart';
import 'package:seeds/datasource/remote/model/member_model.dart';
import 'package:seeds/domain-shared/page_state.dart';
import 'package:seeds/screens/wallet/components/transactions_list/interactor/mappers/member_state_mapper.dart';
import 'package:seeds/screens/wallet/components/transactions_list/interactor/usecases/load_member_data_usecase.dart';
import 'package:seeds/screens/wallet/components/transactions_list/interactor/viewmodels/member_events.dart';
import 'package:seeds/screens/wallet/components/transactions_list/interactor/viewmodels/member_state.dart';

const int _cacheExpiryMinutes = 30;

class MemberBloc extends Bloc<MemberEvent, MemberState> {
  MemberBloc(String accountName) : super(MemberState.initial(accountName));

  @override
  Stream<MemberState> mapEventToState(MemberEvent event) async* {
    if (event is OnLoadMemberData) {
      final account = event.account;

      // handle special system accounts
      if (SystemAccounts.isSystemAccount(account)) {
        yield state.copyWith(pageState: PageState.success, member: SystemAccounts.getSystemAccount(account));
        return;
      }

      yield state.copyWith(pageState: PageState.loading);
      final CacheRepository _cacheRepository = const CacheRepository();

      // If we have a cached item, use it
      final cacheItem = await _cacheRepository.getMemberCacheItem(account);
      if (cacheItem != null) {
        yield state.copyWith(pageState: PageState.success, member: cacheItem.member);
        if (cacheItem.refreshTimeStamp < DateTime.now().millisecondsSinceEpoch) {
          return;
        }
      }

      final result = await LoadMemberDataUseCase().run(account);

      // store result in cache
      if (!result.isError && result.asValue != null && result.asValue!.value is MemberModel) {
        final MemberModel member = result.asValue!.value;
        await _cacheRepository.saveMemberCacheItem(
            account,
            MemberModelCacheItem(
                member, DateTime.now().millisecondsSinceEpoch + Duration.millisecondsPerMinute * _cacheExpiryMinutes));
      }

      yield MemberStateMapper().mapResultToState(state, result);
    }
  }
}
