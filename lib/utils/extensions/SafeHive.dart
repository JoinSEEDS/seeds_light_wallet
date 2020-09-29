import 'package:hive/hive.dart';

extension SafeHive on HiveInterface {
    static Future<Box<E>> safeOpenBox<E>(String name) async {
      var box;
      try {
        if (Hive.isBoxOpen(name)) {
          return Hive.box(name);
        }
        box = await Hive.openBox<E>(name);
      } catch (e){
        print("Hive error ${e.toString()}");
        await Hive.deleteBoxFromDisk(name);
        box = await Hive.openBox<E>(name);
        print("recovered Hive $name.");
      }
      return box;
    }
}