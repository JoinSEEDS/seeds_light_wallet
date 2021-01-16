class ContractModel {
  final String name;
  final String account;

  ContractModel({this.name, this.account});
}

class ActionModel {
  final String name;
  final List<String> fields;

  ActionModel({this.name, this.fields});
}
