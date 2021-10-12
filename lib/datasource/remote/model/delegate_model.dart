class DelegateModel {
  final String delegatee;

  const DelegateModel(this.delegatee);

  factory DelegateModel.fromJson(Map<String, dynamic>? json) {
    if (json != null && json['rows'].isNotEmpty) {
      final item = json['rows'].first;
      return DelegateModel(item['dlegatee']);
    } else {
      return const DelegateModel('');
    }
  }
}
