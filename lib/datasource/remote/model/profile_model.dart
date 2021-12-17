import 'package:equatable/equatable.dart';
import 'package:seeds/datasource/remote/model/serialization_helpers.dart';

enum ProfileStatus { visitor, resident, citizen }

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
      account: json['account'],
      status: enumFromString<ProfileStatus>(ProfileStatus.values, json['status']),
      type: json['type'],
      nickname: json['nickname'],
      image: json['image'],
      story: json['story'],
      roles: json['roles'],
      skills: json['skills'],
      interests: json['interests'],
      reputation: json['reputation'],
      timestamp: json['timestamp'],
    );
  }
}
