import 'package:hive/hive.dart';

/// The user's vote
class VoteModel {
  final int amount;
  final bool isVoted;

  const VoteModel({required this.amount, required this.isVoted});

  factory VoteModel.fromJson(Map<String, dynamic>? json) {
    if (json != null && json['rows'].isNotEmpty) {
      final vote = json['rows'].first;
      return VoteModel(amount: vote['favour'] == 1 ? vote['amount'] : -vote['amount'], isVoted: true);
    } else {
      return const VoteModel(amount: 0, isVoted: false);
    }
  }
}

class VoteModelAdapter extends TypeAdapter<VoteModel> {
  @override
  final typeId = 3;

  @override
  VoteModel read(BinaryReader reader) {
    final fields = [];
    reader.readByte();
    fields.add(reader.readInt());
    reader.readByte();
    fields.add(reader.readBool());
    return VoteModel(amount: fields[0], isVoted: fields[1]);
  }

  @override
  void write(BinaryWriter writer, VoteModel obj) {
    writer.writeByte(0);
    writer.writeInt(obj.amount);
    writer.writeByte(1);
    writer.writeBool(obj.isVoted);
  }
}
