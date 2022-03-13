import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart' as path_lib;
import 'package:seeds/domain-shared/base_use_case.dart';
import 'package:uuid/uuid.dart';

class SaveImageUseCase extends InputUseCase<String, SaveImageUseCaseInput> {
  @override
  Future<Result<String>> run(SaveImageUseCaseInput input) async {
    final String extensionName = path_lib.extension(input.file.path);
    final String path =
        '${input.pathPrefix.pathPrefixString()}/${input.creatorId}/${const Uuid().v4()}  $extensionName';
    final Reference reference = FirebaseStorage.instance.ref().child(path);
    final String fileType = extensionName.isNotEmpty ? extensionName.substring(1) : '*';
    await reference.putFile(input.file, SettableMetadata(contentType: "image/$fileType"));
    final String url = await reference.getDownloadURL();
    return Result.value(url);
  }
}

enum PathPrefix { profileImage, regionImage }

extension PathPrefixToString on PathPrefix {
  String pathPrefixString() {
    switch (this) {
      case PathPrefix.profileImage:
        return "ProfileImage";
      case PathPrefix.regionImage:
        return "regionImage";
    }
  }
}

class SaveImageUseCaseInput {
  File file;
  PathPrefix pathPrefix;
  String creatorId;

  SaveImageUseCaseInput({required this.file, required this.pathPrefix, required this.creatorId});
}
