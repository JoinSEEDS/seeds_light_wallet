class ReferredAccounts {
  final List<String> accounts;

  ReferredAccounts({required this.accounts});

  factory ReferredAccounts.fromJson(Map<String, dynamic> json) {
    return ReferredAccounts(
      accounts: List<String>.from(json["rows"].map((i) => i['invited']) as List),
    );
  }
}
