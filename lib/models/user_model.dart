import 'dart:convert';

import 'package:flutter/foundation.dart';

class UserModel {
  final String email;
  final String name;
  final List<String> followers;
  final List<String> follwing;
  final String profilePic;
  final String bannerPic;
  final String uid;
  final String bio;
  final bool isTwitterblue;
  UserModel({
    required this.email,
    required this.name,
    required this.followers,
    required this.follwing,
    required this.profilePic,
    required this.bannerPic,
    required this.uid,
    required this.bio,
    required this.isTwitterblue,
  });

  UserModel copyWith({
    String? email,
    String? name,
    List<String>? followers,
    List<String>? follwing,
    String? profilePic,
    String? bannerPic,
    String? uid,
    String? bio,
    bool? isTwitterblue,
  }) {
    return UserModel(
      email: email ?? this.email,
      name: name ?? this.name,
      followers: followers ?? this.followers,
      follwing: follwing ?? this.follwing,
      profilePic: profilePic ?? this.profilePic,
      bannerPic: bannerPic ?? this.bannerPic,
      uid: uid ?? this.uid,
      bio: bio ?? this.bio,
      isTwitterblue: isTwitterblue ?? this.isTwitterblue,
    );
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};
  
    result.addAll({'email': email});
    result.addAll({'name': name});
    result.addAll({'followers': followers});
    result.addAll({'follwing': follwing});
    result.addAll({'profilePic': profilePic});
    result.addAll({'bannerPic': bannerPic});
    result.addAll({'uid': uid});
    result.addAll({'bio': bio});
    result.addAll({'isTwitterblue': isTwitterblue});
  
    return result;
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      email: map['email'] ?? '',
      name: map['name'] ?? '',
      followers: List<String>.from(map['followers']),
      follwing: List<String>.from(map['follwing']),
      profilePic: map['profilePic'] ?? '',
      bannerPic: map['bannerPic'] ?? '',
      uid: map['uid'] ?? '',
      bio: map['bio'] ?? '',
      isTwitterblue: map['isTwitterblue'] ?? false,
    );
  }

  String toJson() => json.encode(toMap());

  factory UserModel.fromJson(String source) => UserModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'UserModel(email: $email, name: $name, followers: $followers, follwing: $follwing, profilePic: $profilePic, bannerPic: $bannerPic, uid: $uid, bio: $bio, isTwitterblue: $isTwitterblue)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is UserModel &&
      other.email == email &&
      other.name == name &&
      listEquals(other.followers, followers) &&
      listEquals(other.follwing, follwing) &&
      other.profilePic == profilePic &&
      other.bannerPic == bannerPic &&
      other.uid == uid &&
      other.bio == bio &&
      other.isTwitterblue == isTwitterblue;
  }

  @override
  int get hashCode {
    return email.hashCode ^
      name.hashCode ^
      followers.hashCode ^
      follwing.hashCode ^
      profilePic.hashCode ^
      bannerPic.hashCode ^
      uid.hashCode ^
      bio.hashCode ^
      isTwitterblue.hashCode;
  }
}
