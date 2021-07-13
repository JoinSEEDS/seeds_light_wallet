import 'package:hive/hive.dart';
import 'package:seeds/v2/datasource/remote/model/member_model.dart';

class MemberModelCacheItem {
  MemberModel member;
  int refreshTimeStamp;
  MemberModelCacheItem(this.member, this.refreshTimeStamp);
}

class MemberModelCacheItemAdapter extends TypeAdapter<MemberModelCacheItem> {
  @override
  final typeId = 1;

  @override
  MemberModelCacheItem read(BinaryReader reader) {
    var fields = [];
    reader.readByte();
    fields.add(reader.readString());
    reader.readByte();
    fields.add(reader.readString());
    reader.readByte();
    fields.add(reader.readString());
    reader.readByte();
    fields.add(reader.readInt());

    return MemberModelCacheItem(
        MemberModel(
          account: fields[0] as String,
          nickname: fields[1] as String,
          image: fields[2] as String,
        ),
        fields[3] as int);
  }

  @override
  void write(BinaryWriter writer, MemberModelCacheItem obj) {
    writer.writeByte(0);
    writer.writeString(obj.member.account);
    writer.writeByte(1);
    writer.writeString(obj.member.nickname);
    writer.writeByte(2);
    writer.writeString(obj.member.image);
    writer.writeByte(3);
    writer.writeInt(obj.refreshTimeStamp);
  }
}
