import 'package:hive/hive.dart';
import 'package:seeds/models/models.dart';

class ItemAdapter extends TypeAdapter<ItemModel> {
  final typeId = 3;

  @override
  ItemModel read(BinaryReader reader) {
    var fields = [];
    reader.readByte();
    fields.add(reader.readString());
    reader.readByte();
    fields.add(reader.readDouble());

    return ItemModel(name: fields[0], price: fields[1]);
  }

  @override
  void write(BinaryWriter writer, ItemModel obj) {
    writer.writeByte(0);
    writer.writeString(obj.name);
    writer.writeByte(1);
    writer.writeDouble(obj.price);
  }
}
