import 'package:seeds/domain-shared/page_state.dart';
import 'package:seeds/domain-shared/result_to_state_mapper.dart';
import 'package:seeds/screens/transfer/receive/receive_detail_qr_code/interactor/viewmodels/receive_details.dart';
import 'package:seeds/screens/transfer/receive/receive_enter_data/interactor/usecases/receive_seeds_invoice_use_case.dart';
import 'package:seeds/screens/transfer/receive/receive_enter_data/interactor/viewmodels/page_commands.dart';
import 'package:seeds/screens/transfer/receive/receive_enter_data/interactor/viewmodels/receive_enter_data_bloc.dart';
import 'package:seeds/utils/result_extension.dart';

class CreateInvoiceResultMapper extends StateMapper {
  ReceiveEnterDataState mapResultToState(ReceiveEnterDataState currentState, Result<ReceiveInvoiceResponse> result) {
    if (result.isError) {
      print('Error invoice hash not retrieved');
      return currentState.copyWith(pageState: PageState.success, pageCommand: ShowTransactionFail());
    } else {
      return currentState.copyWith(
        pageState: PageState.success,
        pageCommand: NavigateToReceiveDetails(
          ReceiveDetails(
            fiatAmount: currentState.fiatAmount,
            invoiceLink: result.valueOrCrash.invoice,
            invoiceLinkUri: result.valueOrCrash.invoiceDeepLink,
            tokenAmount: currentState.tokenAmount,
            memo: currentState.memo,
          ),
        ),
      );
    }
  }
}
