import 'package:seeds/v2/domain-shared/page_state.dart';
import 'package:async/async.dart';
import 'package:seeds/v2/screens/wallet/components/transactions/interactor/viewmodels/transactions_list_state.dart';

class TransactionsListStateMapper {
  TransactionsListState mapResultToState(TransactionsListState currentState, Result transactionsResult) {
    return transactionsResult.isError
        ? currentState.copyWith(pageState: PageState.failure)
        : currentState.copyWith(
            transactions: transactionsResult.asValue?.value,
            pageState: PageState.success,
          );
  }
}
