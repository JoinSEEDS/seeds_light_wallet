import 'package:flutter/cupertino.dart';
import 'package:hive/hive.dart';
import 'package:seeds/models/models.dart';

class MemberAdapter extends TypeAdapter<MemberModel> {
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