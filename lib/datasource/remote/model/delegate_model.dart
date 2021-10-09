class DelegateModel {
  final String delegator;
  final String delegatee;
  final String scope;

  const DelegateModel({required this.delegator, required this.delegatee, required this.scope});

  static DelegateModel? fromJson(Map<String, dynamic>? json, String scope) {
    if (json != null && json['rows'].isNotEmpty) {
      final item = json['rows'].first;
      return DelegateModel(
        delegator: item['delegator'],
        delegatee: item['delegatee'],
        scope: scope,
      );
    } else {
      return null;
    }
  }
}
