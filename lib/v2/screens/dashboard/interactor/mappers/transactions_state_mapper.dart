import 'package:seeds/v2/datasource/remote/model/transaction_model.dart';
import 'package:seeds/v2/screens/dashboard/interactor/viewmodels/transactions_state.dart';

import 'package:async/src/result/result.dart';

class TransactionsStateMapper {
  TransactionsState mapResultToState(
      TransactionsState currentState, Result transactions) {
    return currentState.copyWith(
      transactions: transactions,
      isLoading: false,
    );
  }
}
