import 'package:seeds/domain-shared/page_command.dart';
import 'package:seeds/screens/transfer/receive/receive_detail_qr_code/interactor/viewmodels/receive_details.dart';

class NavigateToReceiveDetails extends PageCommand {
  final ReceiveDetails details;

  NavigateToReceiveDetails(this.details);
}

class ShowTransactionFail extends PageCommand {}
