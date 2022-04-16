import 'package:equatable/equatable.dart';
import 'package:seeds/crypto/dart_esr/dart_esr.dart' as esr;
import 'package:seeds/datasource/local/models/eos_action.dart';
import 'package:seeds/domain-shared/app_constants.dart';

class EOSTransaction extends Equatable {
  final List<EOSAction> actions;
  bool get isValid => actions.isNotEmpty;

  bool get isTransfer => actions.length == 1 && actions.first.name == transferAction;

  const EOSTransaction(this.actions);

  @override
  List<Object?> get props => [actions];

  factory EOSTransaction.fromESRActionsList(List<esr.Action> esrActions) {
    final eosActions = esrActions.map((e) => EOSAction.fromESRAction(e)).where((item) => item.isValid).toList();
    return EOSTransaction(eosActions);
  }

  factory EOSTransaction.fromAction({
    required String account,
    required String actionName,
    required Map<String, dynamic> data,
  }) =>
      EOSTransaction([
        EOSAction()
          ..account = account
          ..name = actionName
          ..data = data
      ]);
}
