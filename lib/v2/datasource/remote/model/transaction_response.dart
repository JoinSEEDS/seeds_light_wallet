/// Response from EOS library when user profile is updated
class TransactionResponse {
  Processed processed;

  TransactionResponse.fromJson(Map<String, dynamic> json) {
    processed = json['processed'] != null ? Processed.fromJson(json['processed']) : null;
  }
}

class Processed {
  List<ActionTraces> actionTraces;
  int errorCode;

  Processed.fromJson(Map<String, dynamic> json) {
    if (json['action_traces'] != null) {
      actionTraces = <ActionTraces>[];
      json['action_traces'].forEach((v) {
        actionTraces.add(ActionTraces.fromJson(v));
      });
    }
    errorCode = json['error_code'];
  }
}

class ActionTraces {
  Act act;

  ActionTraces.fromJson(Map<String, dynamic> json) {
    act = json['act'] != null ? Act.fromJson(json['act']) : null;
  }
}

class Act {
  Data data;

  Act.fromJson(Map<String, dynamic> json) {
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }
}

class Data {
  String account;
  String user;
  String type;
  String nickname;
  String image;
  String story;
  String roles;
  String skills;
  String interests;

  Data.fromJson(Map<String, dynamic> json) {
    account = json['account'];
    user = json['user'];
    type = json['type'];
    nickname = json['nickname'];
    image = json['image'];
    story = json['story'];
    roles = json['roles'];
    skills = json['skills'];
    interests = json['interests'];
  }
}
