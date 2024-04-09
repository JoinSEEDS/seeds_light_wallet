/// Response from EOS library when user profile is updated
class TransactionResponse {
  String transactionId;
  Processed? processed;

  TransactionResponse({required this.transactionId, this.processed});

  Data? get data => processed!.actionTraces[1].act!.data;

  TransactionResponse.fromJson(Map<String, dynamic> json)
      : this(
          transactionId: json['transaction_id'] as String? ?? '',
          processed: json['processed'] != null ? Processed.fromJson(json['processed'] as Map<String, dynamic>) : null,
        );
}

class Processed {
  late List<ActionTraces> actionTraces;
  int? errorCode;

  Processed.fromJson(Map<String, dynamic> json) {
    if (json['action_traces'] != null) {
      actionTraces = <ActionTraces>[];
      json['action_traces'].forEach((v) {
        actionTraces.add(ActionTraces.fromJson(v as Map<String, dynamic>));
      });
    }
    errorCode = json['error_code'] as int?;
  }
}

class ActionTraces {
  Act? act;

  ActionTraces.fromJson(Map<String, dynamic> json) {
    act = json['act'] != null ? Act.fromJson(json['act'] as Map<String, dynamic>) : null;
  }
}

class Act {
  Data? data;

  Act.fromJson(Map<String, dynamic> json) {
    data = json['data'] != null ? Data.fromJson(json['data'] as Map<String, dynamic>) : null;
  }
}

class Data {
  String? account;
  String? user;
  String? type;
  String? nickname;
  String? image;
  String? story;
  String? roles;
  String? skills;
  String? interests;

  Data.fromJson(Map<String, dynamic> json) {
    account = json['account'] as String?;
    user = json['user'] as String?;
    type = json['type'] as String?;
    nickname = json['nickname'] as String?;
    image = json['image'] as String?;
    story = json['story'] as String?;
    roles = json['roles'] as String?;
    skills = json['skills'] as String?;
    interests = json['interests'] as String?;
  }
}
