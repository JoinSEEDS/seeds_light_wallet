import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';

class MemberModel extends Equatable {
  final String account;
  final String nickname;
  final String image;

  const MemberModel({required this.account, required this.nickname, required this.image});

  factory MemberModel.fromJson(Map<String, dynamic> json) {
    return MemberModel(
      account: json['account'],
      nickname: json['nickname'],
      image: json['image'],
    );
  }

  @override
  List<Object?> get props => [account, nickname, image];
}

class MemberModelAdapter extends TypeAdapter<MemberModel> {
  @override
  final typeId = 1;

  @override
  MemberModel read(BinaryReader reader) {
    var fields = [];
    reader.readByte();
    fields.add(reader.readString());
    reader.readByte();
    fields.add(reader.readString());
    reader.readByte();
    fields.add(reader.readString());

    return MemberModel(
      account: fields[0] as String,
      nickname: fields[1] as String,
      image: fields[2] as String,
    );
  }

  @override
  void write(BinaryWriter writer, MemberModel obj) {
    writer.writeByte(0);
    writer.writeString(obj.account);
    writer.writeByte(1);
    writer.writeString(obj.nickname);
    writer.writeByte(2);
    writer.writeString(obj.image);
  }
}
