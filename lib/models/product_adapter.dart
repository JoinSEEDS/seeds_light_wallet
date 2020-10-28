import 'package:hive/hive.dart';
import 'package:seeds/models/models.dart';

class ProductAdapter extends TypeAdapter<ProductModel> {
  final typeId = 4;

  @override
  ProductModel read(BinaryReader reader) {
    var fields = [];
    reader.readByte();
    fields.add(reader.readString());
    reader.readByte();
    fields.add(reader.readString());
    reader.readByte();
    fields.add(reader.readDouble());

    return ProductModel(name: fields[0], picture: fields[1], price: fields[2]);
  }

  @override
  void write(BinaryWriter writer, ProductModel obj) {
    writer.writeByte(1);
    writer.writeString(obj.name);
    writer.writeByte(2);
    writer.writeString(obj.picture);
    writer.writeByte(3);
    writer.writeDouble(obj.price);
  }
}
