// import 'package:hive/hive.dart';
// import 'package:seeds/providers/notifiers/voted_notifier.dart';
//
// class VoteResultAdapter extends TypeAdapter<VoteResult> {
//   @override
//   final typeId = 3;
//
//   @override
//   VoteResult read(BinaryReader reader) {
//     var fields = [];
//     reader.readByte();
//     fields.add(reader.readBool());
//     reader.readByte();
//     fields.add(reader.readInt());
//     return VoteResult(fields[1], fields[0]);
//   }
//
//   @override
//   void write(BinaryWriter writer, VoteResult obj) {
//     writer.writeByte(0);
//     writer.writeBool(obj.voted);
//     writer.writeByte(1);
//     writer.writeInt(obj.amount);
//   }
// }

// @dart=2.9
