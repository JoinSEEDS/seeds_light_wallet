/// Check if a value is present or null.
T hasValue<T>(String mapKey, Map<String, dynamic> json) {
  return json.containsKey(mapKey) ? json[mapKey] as T : throw Exception("Key $mapKey is required.");
}

/// Check if a value is present and not empty.
T? hasEmptyValue<T>(String mapKey, Map<String, dynamic> json) {
  if (json.containsKey(mapKey)) {
    if (T == String) {
      return (json[mapKey] as String).isEmpty ? null : json[mapKey];
    } else if (T == int) {
      return (json[mapKey] as int) == 0 ? null : json[mapKey];
    }
  } else {
    return null;
  }
}

/// Convert a string that matches one of the values ​​of the enum of type [T].
T enumFromString<T>(Iterable<T> values, String value) {
  return values.singleWhere((i) => i.toString().split(".").last == value, orElse: () {
    print('Not value found in enum: $T for string: $value');
    return values.first;
  });
}
