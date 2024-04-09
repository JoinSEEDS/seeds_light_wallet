class DelegateModel {
  final String delegatee;
  bool get hasDelegate => delegatee.isNotEmpty;

  const DelegateModel(this.delegatee);

  factory DelegateModel.fromJson(Map<String, dynamic>? json) {
    if (json != null && (json['rows'] as List).isNotEmpty) {
      final item = json['rows'].first;
      return DelegateModel(item['delegatee'] as String);
    } else {
      return const DelegateModel('');
    }
  }
}
