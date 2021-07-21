import 'package:seeds/v2/datasource/remote/model/planted_model.dart';
import 'package:seeds/v2/datasource/remote/model/transaction_model.dart';
import 'package:seeds/v2/domain-shared/page_state.dart';
import 'package:seeds/v2/domain-shared/result_to_state_mapper.dart';
import 'package:seeds/v2/i18n/explore_screens/explore/explore.i18n.dart';
import 'package:seeds/v2/screens/profile_screens/citizenship/interactor/viewmodels/citizenship_state.dart';

class SetDataStateMapper extends StateMapper {
  CitizenshipState mapResultsToState(CitizenshipState currentState, List<Result> results) {
    if (areAllResultsError(results)) {
      return currentState.copyWith(pageState: PageState.failure, errorMessage: 'Error Loading Page'.i18n);
    } else {
      results.retainWhere((Result i) => i.isValue);
      var values = results.map((Result i) => i.asValue!.value).toList();
      List <TransactionModel> transactions;
      //List <TransactionModel> seedsTransactions = TransactionModel();

      PlantedModel? plantedSeeds = values.firstWhere((i) => i is PlantedModel, orElse: () => null);
      transactions = values.firstWhere((i) => i is List, orElse: () => null);

     //transactions.forEach((element) { element.transactionId == 'Seeds'? seedsTransactions.add(element) });

      return currentState.copyWith(
        pageState: PageState.success,
        plantedSeeds: plantedSeeds?.quantity,
        transactionsWithSeeds: transactions.length,
      );
    }
  }
}
