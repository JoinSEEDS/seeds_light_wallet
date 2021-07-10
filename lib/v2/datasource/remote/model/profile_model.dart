import 'package:equatable/equatable.dart';
import 'package:seeds/v2/datasource/remote/model/serialization_helpers.dart';

enum ProfileStatus { visitor, resident, citizen }

class ProfileModel extends Equatable {
  final String account;
  final ProfileStatus? status;
  final String? type;
  final String? nickname;
  final String? image;
  final String? story;
  final String? roles;
  final String? skills;
  final String? interests;
  final int? reputation;
  final int timestamp;

  @override
  List<Object?> get props => [account, status, type, nickname, image, story, roles, skills, interests, reputation, timestamp];

  ProfileModel({
    required this.account,
    this.status,
    this.type,
    this.nickname,
    this.image,
    this.story,
    this.roles,
    this.skills,
    this.interests,
    this.reputation,
    required this.timestamp,
  });

  /// Returns the status String value.
  String get statusString {
    if (status == null) {
      return '';
    } else {
      var str = status.toString().split('.').last;
      return '${str[0].toUpperCase()}${str.substring(1)}';
    }
  }

  /// Returns the account age in days.
  int get accountAge {
    var creationDate = DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
    return DateTime.now().difference(creationDate).inDays;
  }

  ProfileModel copyWith({
    String? account,
    ProfileStatus? status,
    String? type,
    String? nickname,
    String? image,
    String? story,
    String? roles,
    String? skills,
    String? interests,
    int? reputation,
    int? timestamp,
  }) {
    return ProfileModel(
      account: account ?? this.account,
      status: status ?? this.status,
      type: type ?? this.type,
      nickname: nickname ?? this.nickname,
      image: image ?? this.image,
      story: story ?? this.story,
      roles: roles ?? this.roles,
      skills: skills ?? this.skills,
      interests: interests ?? this.interests,
      reputation: reputation ?? this.reputation,
      timestamp: timestamp ?? this.timestamp,
    );
  }

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    return ProfileModel(
      account: hasValue<String>(_account, json),
      status: enumFromString<ProfileStatus>(ProfileStatus.values, hasEmptyValue<String>(_status, json)),
      type: hasEmptyValue<String>(_type, json),
      nickname: hasEmptyValue<String>(_nickname, json),
      image: hasEmptyValue<String>(_image, json),
      story: hasEmptyValue<String>(_story, json),
      roles: hasEmptyValue<String>(_roles, json),
      skills: hasEmptyValue<String>(_skills, json),
      interests: hasEmptyValue<String>(_interests, json),
      reputation: hasEmptyValue<int>(_reputation, json),
      timestamp: hasValue<int>(_timestamp, json),
    );
  }

  static final String _account = 'account';
  static final String _status = 'status';
  static final String _type = 'type';
  static final String _nickname = 'nickname';
  static final String _image = 'image';
  static final String _story = 'story';
  static final String _roles = 'roles';
  static final String _skills = 'skills';
  static final String _interests = 'interests';
  static final String _reputation = 'reputation';
  static final String _timestamp = 'timestamp';

}
