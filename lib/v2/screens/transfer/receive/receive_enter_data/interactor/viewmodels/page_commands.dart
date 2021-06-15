import 'package:seeds/v2/domain-shared/page_command.dart';
import 'package:seeds/v2/screens/transfer/receive/receive_detail_qr_code/interactor/viewmodels/receive_detail_arguments.dart';

class NavigateToReceiveDetails extends PageCommand {
  final ReceiveDetailArguments receiveDetailArguments;

  NavigateToReceiveDetails({required this.receiveDetailArguments});
}

class ShowTransactionFail extends PageCommand {}
