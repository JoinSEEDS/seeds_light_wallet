import 'package:seeds/crypto/dart_esr/dart_esr.dart' as esr;
import 'package:seeds/crypto/eosdart/eosdart.dart' as eos;

/// Simple EOS Action data container
class EOSAction {
  String? account;
  String? name;
  List<eos.Authorization?>? authorization;
  Object? data;

  bool get isValid => account != null && name != null && account!.isNotEmpty && name!.isNotEmpty;

  EOSAction() : super();

  Map<String, dynamic>? get dataMap {
    /// In the original ESR design data can be a String, a map,
    /// or esr.Identity and possibly also a uint8 list.
    ///
    /// ESR will modify the data object, for example when sending an action to the chain, it will serialize the map
    /// into a hex string. This makes it really hard to deal with.
    ///
    /// In our internal representation of EOSAction, we don't modify data so it should
    /// always be a map.
    /// Explore if we can type it as map internally.

    if (data is Map<dynamic, dynamic>) {
      return data as Map<String, dynamic>?;
    } else if (data is Map<String, dynamic>) {
      return data as Map<String, dynamic>?;
    } else if (data is esr.Identity) {
      return (data as esr.Identity?)?.toJson();
    } else {
      print("data is not a map $data");
      return null;
    }
  }

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
