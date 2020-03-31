// Copyright 2018 DebuggerX <dx8917312@gmail.com>. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:io';

var preview_server_port = 2227;

void main() async {
  bool working = false;
  var pubSpec = File('pubspec.yaml');
  var pubLines = pubSpec.readAsLinesSync();
  var Lines = <String>[];
  var resource = <String>[];
  for (var line in pubLines) {
    if (line.contains('begin') && line.contains('#') &&
        line.contains('assets')) {
      working = true;
      Lines.add(line);
    }
    if (line.contains('end') && line.contains('#') && line.contains('assets'))
      working = false;

    if (working) {
      if (line.trim().startsWith('#') && line.trim().endsWith('*')) {
        Lines.add(line);
        var directory = Directory(
            line.replaceAll('#', '').replaceAll('*', '').trim());
        if (directory.existsSync()) {
          var list = directory.listSync(recursive: true);
          for (var file in list) {
            if (File(file.path)
                .statSync()
                .type == FileSystemEntityType.file) {
              var path = file.path.replaceAll('\\', '/');
              var varName = path.replaceAll('/', '_')
                  .replaceAll('.', '_')
                  .replaceAll('-', '_');

              var dashCount = '/'
                  .allMatches(path)
                  .length;

              // convert the under_score to lower camel case.
              List<String> tokens = varName.split('_');
              varName = tokens.sublist(dashCount, tokens.length - 1).map((s) {
                return '${s[0].toUpperCase()}${s.substring(1)}';
              }).join();
              varName = '${varName[0].toLowerCase()}${varName.substring(1)}';

              if (isNumeric(varName[0])) varName = 'im_$varName';

              resource.add(
                  "/// ![](http://127.0.0.1:$preview_server_port/$path)");
              resource.add("static final String $varName = '$path';");
              Lines.add('    - $path');
            }
          }
        } else {
          throw FileSystemException('Directory wrong');
        }
      }
    } else {
      Lines.add(line);
    }
  }

  var r = File('lib/generated/r.dart');
  if (r.existsSync()) {
    r.deleteSync();
  }
  r.createSync();
  var content = 'class R {\n';
  for (var line in resource) {
    content = '$content  $line\n';
  }
  content = '$content}\n';
  r.writeAsStringSync(content);

  var spec = '';
  for (var line in Lines) {
    spec = '$spec$line\n';
  }
  pubSpec.writeAsStringSync(spec);

  var ser;
  try {
    ser = await HttpServer.bind('127.0.0.1', preview_server_port);
    print(
        'Successfully launched the image preview server on this machine <$preview_server_port> port');
    ser.listen((req) {
      var index = req.uri.path.lastIndexOf('.');
      var subType = req.uri.path.substring(index);
      req.response
        ..headers.contentType = ContentType('image', subType)
        ..add(File('.${req.uri.path}').readAsBytesSync())
        ..close();
    },);
  } catch (e) {
    print('The image preview server is up or the port is occupied');
  }
}

bool isNumeric(String string) => num.tryParse(string) != null;