class DelegateModel {
  final String delegatee;

  const DelegateModel({
    required this.delegatee,
  });

  static DelegateModel? fromJson(
    Map<String, dynamic>? json,
  ) {
    if (json != null && json['rows'].isNotEmpty) {
      final item = json['rows'].first;
      return DelegateModel(delegatee: item['delegatee']);
    } else {
      return const DelegateModel(delegatee: '');
    }
  }
}
