import 'package:hive/hive.dart';
import 'package:seeds/datasource/remote/model/profile_model.dart';

class MemberModelCacheItem {
  ProfileModel member;
  int refreshTimeStamp;
  MemberModelCacheItem(this.member, this.refreshTimeStamp);
}

class MemberModelCacheItemAdapter extends TypeAdapter<MemberModelCacheItem> {
  @override
  final typeId = 1;

  @override
  MemberModelCacheItem read(BinaryReader reader) {
    final fields = [];
    /// account
    reader.readByte();
    fields.add(reader.readString());
    /// nickname
    reader.readByte();
    fields.add(reader.readString());
    /// image
    reader.readByte();
    fields.add(reader.readString());
    /// status
    reader.readByte();
    fields.add(reader.readInt());
    /// refreshTimeStamp
    reader.readByte();
    fields.add(reader.readInt());
    /// type
    reader.readByte();
    fields.add(reader.readString());
    /// story
    reader.readByte();
    fields.add(reader.readString());
    /// roles
    reader.readByte();
    fields.add(reader.readString());
    /// skills
    reader.readByte();
    fields.add(reader.readString());
    /// interests
    reader.readByte();
    fields.add(reader.readString());
    /// reputation
    reader.readByte();
    fields.add(reader.readInt());
    /// timestamp
    reader.readByte();
    fields.add(reader.readInt());

    return MemberModelCacheItem(
      ProfileModel(
        account: fields[0] as String,
        nickname: fields[1] as String,
        image: fields[2] as String,
        status: ProfileStatus.values[(fields[3] as int)],
        type: fields[5] as String,
        story: fields[6] as String,
        roles: fields[7] as String,
        skills: fields[8] as String,
        interests: fields[9] as String,
        reputation: fields[10] as int,
        timestamp: fields[12] as int,
      ),
      fields[4] as int,
    );
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
    writer.writeInt(obj.member.status.index);
    writer.writeByte(5);
    writer.writeString(obj.member.type);
    writer.writeByte(6);
    writer.writeString(obj.member.story);
    writer.writeByte(7);
    writer.writeString(obj.member.roles);
    writer.writeByte(8);
    writer.writeString(obj.member.skills);
    writer.writeByte(9);
    writer.writeString(obj.member.interests);
    writer.writeByte(10);
    writer.writeInt(obj.member.reputation);
    writer.writeByte(11);
    writer.writeInt(obj.member.timestamp);
    writer.writeByte(4);
    writer.writeInt(obj.refreshTimeStamp);
  }
}
