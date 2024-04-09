/// The total Number Of Transactions with seeds
class SeedsHistoryModel {
  final int totalNumberOfTransactions;

  const SeedsHistoryModel(this.totalNumberOfTransactions);

  factory SeedsHistoryModel.fromJson(Map<String, dynamic> json) {
    if ((json['rows'] as List).isNotEmpty) {
      return SeedsHistoryModel(json['rows'][0]["total_number_of_transactions"] as int);
    } else {
      return const SeedsHistoryModel(0);
    }
  }
}
