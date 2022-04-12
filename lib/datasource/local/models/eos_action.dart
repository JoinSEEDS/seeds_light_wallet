import 'package:seeds/crypto/dart_esr/dart_esr.dart' as esr;
import 'package:seeds/crypto/eosdart/eosdart.dart' as eos;

/// Simple EOS Action data container
class EOSAction {
  String? account;
  String? name;
  List<eos.Authorization?>? authorization;
  Map<String, dynamic>? data;

  bool get isValid => account != null && name != null && account!.isNotEmpty && name!.isNotEmpty;

  EOSAction() : super();

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

  eos.Action get toEosAction => eos.Action()
    ..account = account
    ..name = name
    ..data = data
    ..authorization = authorization;
}
