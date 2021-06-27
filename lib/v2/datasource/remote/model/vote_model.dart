/// The user's vote
class VoteModel {
  final int amount;

  const VoteModel(this.amount);

  factory VoteModel.fromJson(Map<String, dynamic>? json) {
    if (json != null && json['rows'].isNotEmpty) {
      var vote = json['rows'].first;
      return VoteModel(vote['favour'] == 1 ? vote['amount'] : -vote['amount']);
    } else {
      return const VoteModel(0);
    }
  }
}
