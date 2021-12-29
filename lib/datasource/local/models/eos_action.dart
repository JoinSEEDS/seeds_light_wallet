import 'package:equatable/equatable.dart';
import 'package:seeds/crypto/dart_esr/dart_esr.dart' as esr;

/// Simple EOS Action data container
class EOSAction extends Equatable {
  final String accountName;
  final String actionName;
  final Map<String, dynamic> data;

  bool get isValid => accountName.isNotEmpty && actionName.isNotEmpty;

  const EOSAction({required this.accountName, required this.actionName, required this.data});

  factory EOSAction.fromESRAction(esr.Action action) {
    final Map<String, dynamic> data = Map<String, dynamic>.from(action.data! as Map<dynamic, dynamic>);
    return EOSAction(accountName: action.account!, actionName: action.name!, data: data);
  }

  @override
  List<Object?> get props => [accountName, actionName, data];
}
