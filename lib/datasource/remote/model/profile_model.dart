import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:seeds/datasource/remote/model/serialization_helpers.dart';

enum ProfileStatus { visitor, resident, citizen, unknown }

class ProfileModel extends Equatable {
  final String account;
  final ProfileStatus status;
  final String type;
  final String nickname;
  final String image;
  final String story;
  final String roles;
  final String skills;
  final String interests;
  final int reputation;
  final int timestamp;

  @override
  List<Object?> get props => [
        account,
        status,
        type,
        nickname,
        image,
        story,
        roles,
        skills,
        interests,
        reputation,
        timestamp,
      ];

  const ProfileModel({
    required this.account,
    required this.status,
    required this.type,
    required this.nickname,
    required this.image,
    required this.story,
    required this.roles,
    required this.skills,
    required this.interests,
    required this.reputation,
    required this.timestamp,
  });

  /// Returns the status as a capitalized String.
  String get statusString {
    if(ProfileStatus.unknown == status) {
      return '';
    }
    final str = status.name;
    return '${str[0].toUpperCase()}${str.substring(1)}';
  }

  /// Returns the account age in days.
  int get accountAge {
    final creationDate = DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
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
      account: json['account'] as String,
      status: enumFromString<ProfileStatus>(ProfileStatus.values, json['status'] as String),
      type: json['type'] as String,
      nickname: json['nickname'] as String,
      image: json['image'] as String,
      story: json['story'] as String,
      roles: json['roles'] as String,
      skills: json['skills'] as String,
      interests: json['interests'] as String,
      reputation: json['reputation'] as int,
      timestamp: json['timestamp'] as int,
    );
  }

  factory ProfileModel.usingDefaultValues({
    required String account,
    String nickName = '',
    String image = '',
    ProfileStatus status = ProfileStatus.unknown,
    String interests = '',
    int reputation = 0,
    String roles = '',
    String skills = '',
    String story = '',
    int timestamp = 0,
    String type = '',
  }) {
    return ProfileModel(
      account: account,
      nickname: nickName,
      image: image,
      status: status,
      interests: interests,
      reputation: reputation,
      roles: roles,
      skills: skills,
      story: story,
      timestamp: timestamp == 0 ? Timestamp.now().microsecondsSinceEpoch : timestamp,
      type: type,
    );
  }
}
