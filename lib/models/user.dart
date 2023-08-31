// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class FirebaseUser {
  final String email;
  final String name;
  final String profilePic;
  final bool userPrivacy;

  const FirebaseUser({
    required this.email,
    required this.name,
    required this.profilePic,
    required this.userPrivacy,
  });
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'email': email,
      'name': name,
      'profilePic': profilePic,
      'userPrivacy': userPrivacy,
    };
  }

  FirebaseUser copyWith({
    String? email,
    String? name,
    String? profilePic,
    bool? userPrivacy,
  }) {
    return FirebaseUser(
      email: email ?? this.email,
      name: name ?? this.name,
      profilePic: profilePic ?? this.profilePic,
      userPrivacy: userPrivacy ?? this.userPrivacy,
    );
  }

  factory FirebaseUser.fromMap(Map<String, dynamic> map) {
    return FirebaseUser(
      email: map['email'] as String,
      name: map['name'] as String,
      profilePic: map['profilePic'] as String,
      userPrivacy: map['userPrivacy'] as bool,
    );
  }

  String toJson() => json.encode(toMap());

  factory FirebaseUser.fromJson(String source) =>
      FirebaseUser.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'FirebaseUser(email: $email, name: $name, profilePic: $profilePic, userPrivacy: $userPrivacy)';
  }

  @override
  bool operator ==(covariant FirebaseUser other) {
    if (identical(this, other)) return true;

    return other.email == email &&
        other.name == name &&
        other.profilePic == profilePic &&
        other.userPrivacy == userPrivacy;
  }

  @override
  int get hashCode {
    return email.hashCode ^
        name.hashCode ^
        profilePic.hashCode ^
        userPrivacy.hashCode;
  }
} // User在firebase中的資料樣態

// 用extension: Dart data class generator把map轉換成樣態資料( cmd+. )