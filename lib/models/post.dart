// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

class Post {
  final String uid;
  final String profilePic;
  final String name;
  final String tweet;
  final Timestamp postTime;
  final bool userPrivacy;
  final String location;
  final String tweetId;

  Post({
    required this.uid,
    required this.profilePic,
    required this.name,
    required this.tweet,
    required this.postTime,
    required this.userPrivacy,
    required this.location,
    required this.tweetId,
  });

  Post copyWith({
    String? uid,
    String? profilePic,
    String? name,
    String? tweet,
    Timestamp? postTime,
    bool? userPrivacy,
    String? location,
    String? tweetId,
  }) {
    return Post(
      uid: uid ?? this.uid,
      profilePic: profilePic ?? this.profilePic,
      name: name ?? this.name,
      tweet: tweet ?? this.tweet,
      postTime: postTime ?? this.postTime,
      userPrivacy: userPrivacy ?? this.userPrivacy,
      location: location ?? this.location,
      tweetId: tweetId ?? this.tweetId,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'uid': uid,
      'profilePic': profilePic,
      'name': name,
      'tweet': tweet,
      'postTime': postTime,
      'userPrivacy': userPrivacy,
      'location': location,
      'tweetId': tweetId,
    };
  }

  factory Post.fromMap(Map<String, dynamic> map) {
    return Post(
      uid: map['uid'] as String,
      profilePic: map['profilePic'] as String,
      name: map['name'] as String,
      tweet: map['tweet'] as String,
      postTime: map['postTime'],
      userPrivacy: map['userPrivacy'] as bool,
      location: map['location'] as String,
      tweetId: map['tweetId'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory Post.fromJson(String source) =>
      Post.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Post(uid: $uid, profilePic: $profilePic, name: $name, tweet: $tweet, postTime: $postTime, userPrivacy: $userPrivacy, location: $location, tweetId: $tweetId)';
  }

  @override
  bool operator ==(covariant Post other) {
    if (identical(this, other)) return true;

    return other.uid == uid &&
        other.profilePic == profilePic &&
        other.name == name &&
        other.tweet == tweet &&
        other.postTime == postTime &&
        other.userPrivacy == userPrivacy &&
        other.location == location &&
        other.tweetId == tweetId;
  }

  @override
  int get hashCode {
    return uid.hashCode ^
        profilePic.hashCode ^
        name.hashCode ^
        tweet.hashCode ^
        postTime.hashCode ^
        userPrivacy.hashCode ^
        location.hashCode ^
        tweetId.hashCode;
  }
}
