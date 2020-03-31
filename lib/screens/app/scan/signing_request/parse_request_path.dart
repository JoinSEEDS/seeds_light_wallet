

import 'dart:typed_data';

import 'dart:convert';
import 'package:eosdart/src/eosdart_base.dart';
import 'package:eosdart/src/serialize.dart' as ser;
import 'package:eosdart/src/models/abi.dart';
import 'package:archive/archive.dart';

import './request_abi.dart';
import './decode_string_request.dart';

dynamic parseRequestPath(String path) {
  Uint8List requestWithHeader = decodeStringRequest(path);

  Uint8List compressedRequest = requestWithHeader.sublist(1);

  Uint8List requestBytes = new Inflate(compressedRequest).getBytes();

  dynamic requestBuffer = ser.SerialBuffer(requestBytes);

  Map<String, Type> types = ser.getTypesFromAbi(
    ser.createInitialTypes(),
    Abi.fromJson(json.decode(requestAbi))
  );

  Type requestType = types["signing_request"];

  dynamic signingRequest = requestType.deserialize(requestType, requestBuffer);

  return signingRequest;
}