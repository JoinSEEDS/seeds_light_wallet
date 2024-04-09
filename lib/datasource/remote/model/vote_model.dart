/// The user's vote
class VoteModel {
  final int amount;
  final bool isVoted;

  const VoteModel({required this.amount, required this.isVoted});

  factory VoteModel.fromJson(Map<String, dynamic>? json) {
    if (json != null && (json['rows'] as List).isNotEmpty) {
      final vote = json['rows'].first as Map<String, dynamic>;
      return VoteModel(amount: vote['favour'] == 1 ? vote['amount'] as int : -vote['amount'] as int, isVoted: true);
    } else {
      return const VoteModel(amount: 0, isVoted: false);
    }
  }

  factory VoteModel.fromJsonReferendum(Map<String, dynamic>? json) {
    if (json != null && (json['rows'] as List).isNotEmpty) {
      final vote = json['rows'].first as Map<String, dynamic>;
      return VoteModel(amount: vote['favoured'] == 1 ? vote['amount'] as int : -vote['amount'] as int, isVoted: true);
    } else {
      return const VoteModel(amount: 0, isVoted: false);
    }
  }
}
