import 'dart:io';

import 'package:async/async.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart' as path_lib;
import 'package:seeds/v2/datasource/local/settings_storage.dart';
import 'package:uuid/uuid.dart';

class SaveImageUseCase {
  Future<Result> run({required File file}) async {
    final String extensionName = path_lib.extension(file.path);
    final String path = 'ProfileImage/' '${settingsStorage.accountName}' '/' '${const Uuid().v4()}  $extensionName';
    final Reference reference = FirebaseStorage.instance.ref().child(path);
    final String fileType = extensionName.isNotEmpty ? extensionName.substring(1) : '*';
    await reference.putFile(file, SettableMetadata(contentType: "image/$fileType"));
    final url = await reference.getDownloadURL();
    return ValueResult(url);
  }
}
