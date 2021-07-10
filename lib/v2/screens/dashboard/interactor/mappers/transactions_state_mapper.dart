import 'package:seeds/v2/domain-shared/page_state.dart';
import 'package:seeds/v2/screens/dashboard/interactor/viewmodels/transactions_list_state.dart';
import 'package:async/async.dart';

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
