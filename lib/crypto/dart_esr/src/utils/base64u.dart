// ignore_for_file: unnecessary_parenthesis, prefer_final_locals, always_put_control_body_on_new_line

import 'dart:typed_data';

class Base64u {
  final String _charset =
      'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789-_';
  final Uint8List _lookupTable = Uint8List(256);

  Base64u() {
    _buildLookupTable();
  }

  void _buildLookupTable() {
    for (var i = 0; i < 64; i++) {
      _lookupTable[_charset.codeUnitAt(i)] = i;
    }
  }

  String encode(Uint8List data) {
    var byteLength = data.length;
    var byteRemainder = byteLength % 3;
    var mainLength = byteLength - byteRemainder;

    var parts = '';
    int a;
    int b;
    int c;
    int d;
    int chunk;

    for (var i = 0; i < mainLength; i += 3) {
      chunk = (data[i] << 16) | (data[i + 1] << 8) | data[i + 2];

      a = (chunk & 16515072) >> 18;
      b = (chunk & 258048) >> 12;
      c = (chunk & 4032) >> 6;
      d = chunk & 63;

      parts += (_charset[a] + _charset[b] + _charset[c] + _charset[d]);
    }

    if (byteRemainder == 1) {
      chunk = data[mainLength];

      a = (chunk & 252) >> 2;
      b = (chunk & 3) << 4;

      parts += (_charset[a] + _charset[b]);
    } else if (byteRemainder == 2) {
      chunk = (data[mainLength] << 8) | data[mainLength + 1];

      a = (chunk & 64512) >> 10;
      b = (chunk & 1008) >> 4;

      c = (chunk & 15) << 2;

      parts += (_charset[a] + _charset[b] + _charset[c]);
    }

    return parts;
  }

  Uint8List decode(String input) {
    var byteLength = input.length;
    var data = Uint8List((byteLength * 0.75).floor());

    int a;
    int b;
    int c;
    int d;
    var p = 0;

    for (var i = 0; i < input.length; i += 4) {
      a = _lookupTable[input.codeUnitAt(i)];
      b = byteLength > i + 1 ? _lookupTable[input.codeUnitAt(i + 1)] : 0;
      c = byteLength > i + 2 ? _lookupTable[input.codeUnitAt(i + 2)] : 0;
      d = byteLength > i + 3 ? _lookupTable[input.codeUnitAt(i + 3)] : 0;

      if (data.length > p) data[p] = (a << 2) | (b >> 4);
      if (data.length > p + 1) data[p + 1] = ((b & 15) << 4) | (c >> 2);
      if (data.length > p + 2) data[p + 2] = ((c & 3) << 6) | (d & 63);
      p += 3;
    }

    return data;
  }
}
