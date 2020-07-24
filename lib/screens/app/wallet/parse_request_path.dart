

import 'dart:typed_data';

import 'dart:convert';
import 'package:eosdart/src/eosdart_base.dart';
import 'package:eosdart/src/serialize.dart' as ser;
import 'package:eosdart/src/models/abi.dart';
import 'package:archive/archive.dart';

import './request_abi.dart';
import './decode_string_request.dart';

bool isCompressed(int header) => (header & 1 << 7) != 0; 

dynamic parseRequestPath(String path) {
  print(path);

  Uint8List requestWithHeader = decodeStringRequest(path);

  int header = requestWithHeader[0];
  Uint8List request = requestWithHeader.sublist(1);

  if (isCompressed(header)) {
    request = new Inflate(request).getBytes();
  }

  dynamic requestBuffer = ser.SerialBuffer(request);

  Map<String, Type> types = ser.getTypesFromAbi(
    ser.createInitialTypes(),
    Abi.fromJson(json.decode(requestAbi))
  );

  Type requestType = types["signing_request"];

  dynamic signingRequest = requestType.deserialize(requestType, requestBuffer);

  return signingRequest;
}