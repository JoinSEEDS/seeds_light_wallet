

import 'dart:typed_data';

import 'dart:convert';
import 'package:dartesr/eosio_signing_request.dart';
import 'package:eosdart/src/eosdart_base.dart';
import 'package:eosdart/src/serialize.dart' as ser;
import 'package:eosdart/src/models/abi.dart';
import 'package:archive/archive.dart';

import './request_abi.dart';
import './decode_string_request.dart';

bool isCompressed(int header) => (header & 1 << 7) != 0; 

dynamic parseRequestPath(String path) {

  print("request path: " + path);

  Uint8List requestWithHeader = decodeStringRequest(path);

  print("request path: " + requestWithHeader.toString());


  int header = requestWithHeader[0];
  Uint8List request = requestWithHeader.sublist(1);

  if (isCompressed(header)) {
    print("compressed... ");
    request = new Inflate(request).getBytes();
    
    print("inflated... "+request.toString());

  } 

  dynamic requestBuffer = ser.SerialBuffer(request);

  Map<String, Type> types = ser.getTypesFromAbi(
    ser.createInitialTypes(),
    Abi.fromJson(json.decode(requestAbi))
  );
    print("types... "+types.toString());

  Type requestType = types["signing_request"];

    print("requestType... "+requestType.name);

  dynamic signingRequest = requestType.deserialize(requestType, requestBuffer);
  
    print("signingRequest... "+signingRequest.toString());

  return signingRequest;
}