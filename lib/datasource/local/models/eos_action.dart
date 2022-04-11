import 'package:seeds/crypto/dart_esr/dart_esr.dart' as esr;
import 'package:seeds/crypto/eosdart/eosdart.dart' as eos;

/// Simple EOS Action data container
class EOSAction extends eos.Action {
  bool get isValid => account != null && name != null && account!.isNotEmpty && name!.isNotEmpty;

  EOSAction() : super();

  Map<String, dynamic>? get dataMap => data as Map<String, dynamic>?;

  factory EOSAction.fromESRAction(esr.Action action) {
    final Map<String, dynamic> data = Map<String, dynamic>.from(action.data! as Map<dynamic, dynamic>);
    final List<eos.Authorization>? auth = action.authorization
        ?.map((e) => eos.Authorization()
          ..actor = e?.actor
          ..permission = e?.permission)
        .toList();
    return EOSAction()
      ..account = action.account
      ..name = action.name
      ..data = data
      ..authorization = auth;
  }
}
