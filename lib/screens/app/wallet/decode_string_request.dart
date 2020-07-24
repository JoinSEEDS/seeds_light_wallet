import 'dart:typed_data';

List<int> _createCharsetLookup() {
  var charset =
      'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789-_';

  var lookup = List.filled(256, -1);

  for (var i = 0; i < charset.length; ++i) {
    lookup[charset.codeUnitAt(i)] = i;
  }

  return lookup;
}

final _lookup = _createCharsetLookup();

Uint8List decodeStringRequest(String s) {
  int byteLength = (s.length * 0.75).toInt();

  var data = new Uint8List(byteLength);

  var a, b, c, d;
  var p = 0;

  for (var i = 0; i < s.length; i += 4) {
    try {
      a = _lookup[s.codeUnitAt(i)];
      b = _lookup[s.codeUnitAt(i + 1)];
      c = _lookup[s.codeUnitAt(i + 2)];
      d = _lookup[s.codeUnitAt(i + 3)];

      data[p++] = (a << 2) | (b >> 4);
      data[p++] = ((b & 15) << 4) | (c >> 2);
      data[p++] = ((c & 3) << 6) | (d & 63);
    } catch (e) {}
  }

  return data;
}
