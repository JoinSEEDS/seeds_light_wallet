class DelegateModel {
  final String delegatee;
  bool get hasDelegate => delegatee.isNotEmpty;
  final String delegator;

  const DelegateModel(this.delegatee, this.delegator);

  factory DelegateModel.fromJson(Map<String, dynamic>? json) {
    if (json != null && json['rows'].isNotEmpty) {
      final item = json['rows'].first;
      return DelegateModel(item['delegatee'], item['delegator']);
    } else {
      return const DelegateModel('', '');
    }
  }
}
