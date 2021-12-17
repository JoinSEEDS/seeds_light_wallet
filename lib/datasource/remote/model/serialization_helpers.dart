/// Convert a string that matches one of the values ​​of the enum of type [T].
T enumFromString<T>(Iterable<T> values, String value) {
  return values.singleWhere((i) => i.toString().split(".").last == value, orElse: () {
    print('Not value found in enum: $T for string: $value');
    return values.first;
  });
}
