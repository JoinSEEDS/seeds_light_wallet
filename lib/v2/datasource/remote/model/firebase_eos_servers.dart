class FirebaseEosServer {
  final String url;
  final bool isDefault;

  FirebaseEosServer({this.url, this.isDefault});

  factory FirebaseEosServer.fromJson(Map<String, dynamic> json) {
    return FirebaseEosServer(
      url: json['url'] as String,
      isDefault: json['isDefault'] as bool
    );
  }
}