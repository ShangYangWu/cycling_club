import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:twitter_clone/providers/user_provider.dart';

import '../models/post.dart';

final feedProvider = StreamProvider.autoDispose<List<Post>>((ref) {
  return FirebaseFirestore.instance
      .collection("tweets")
      .orderBy('postTime', descending: true)
      .snapshots()
      .map((event) {
    List<Post> tweets = []; // 用來把每一個新貼文加到list中
    for (int i = 0; i < event.docs.length; i++) {
      tweets.add(Post.fromMap(event.docs[i].data()));
    }
    return tweets;
  });
});

final TweetProvider = Provider<TwitterApi>((ref) {
  return TwitterApi(
      ref); // 用ref reference userProvider 取得 userId userName userProfilePic
});

class TwitterApi {
  // give access to our apps
  TwitterApi(this.ref);
  final Ref ref;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> postTweet(String tweet) async {
    LocalUser currentUser = ref.read(userProvider);
    String location = "error";

    DocumentReference newTweetRef = await _firestore.collection('tweets').add(
          Post(
            uid: currentUser.id,
            profilePic: currentUser.user.profilePic,
            name: currentUser.user.name,
            tweet: tweet,
            postTime: Timestamp.now(), // cloud_firestore.dart
            userPrivacy: currentUser.user.userPrivacy,
            location: location,
            tweetId: "",
          ).toMap(), // firestore只接收map
        );
    String newTweetId = newTweetRef.id; // 獲取新文檔的 ID
    await newTweetRef.update({'tweetId': newTweetId}); // 更新文檔中的 ID
  }
}
