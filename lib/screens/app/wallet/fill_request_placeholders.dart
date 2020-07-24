Map<String, dynamic> fillRequestPlaceholders(
    Map<String, dynamic> request, String accountName) {
  Map<String, dynamic> result = {};
  
  request.forEach((key, value) {
    if (value == '............1') {
      result[key] = accountName;
    } else {
      result[key] = value;
    }
  });

  return result;
}
