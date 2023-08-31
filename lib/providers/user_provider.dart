// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/user.dart';

final userProvider = StateNotifierProvider<UserNotifier, LocalUser>((ref) {
  return UserNotifier();
});

class LocalUser {
  // 定義 state object
  const LocalUser({required this.id, required this.user});

  final String id; // Local base
  final FirebaseUser user; // interface to firebase

  // LocalUser -(cmd .)-> copy with
  LocalUser copyWith({
    // 另外建一個LocalUser 存放所有不會改變的變數
    String? id,
    FirebaseUser? user,
  }) {
    return LocalUser(
      id: id ?? this.id,
      user: user ?? this.user,
    );
  }
}

class UserNotifier extends StateNotifier<LocalUser> {
  // 定義 state function
  UserNotifier()
      : super(
          const LocalUser(
            id: "error",
            user: FirebaseUser(
              email: "error",
              name: "error",
              profilePic: "error",
              userPrivacy: false,
            ),
          ),
        );

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  /// log in 要從資料庫撈資料
  Future<void> login(String email) async {
    QuerySnapshot response = await _firestore
        .collection("users")
        .where('email', isEqualTo: email)
        .get();

    // 不知道為什麼中間加了 print("response = ${response.docs[0][email]}"); 就讀不到資料
    if (response.docs.isEmpty) {
      print("firestore user 中沒有此授權email: $email");
      return;
    }
    if (response.docs.length != 1) {
      print("firestore user 中有多於一組授權email: $email");
      return;
    }
    state = LocalUser(
        id: response.docs[0].id,
        user: FirebaseUser.fromMap(
            response.docs[0].data() as Map<String, dynamic>));
  }

  /// 在 database 新增 User
  Future<void> signUp(String email) async {
    DocumentReference response = await _firestore.collection("users").add(
          FirebaseUser(
            email: email,
            name: "No Name",
            profilePic:
                "https://en.gravatar.com/avatar/205e460b479e2e5b48aec07710c08d50?s=200",
            // profilePic: "https://www.gravatar.com/avatar/?d=mp",
            userPrivacy: false, //預設不公開0
          ).toMap(),
        );
    DocumentSnapshot snapshot = await response.get();
    state = LocalUser(
      id: response.id,
      user: FirebaseUser.fromMap(snapshot.data() as Map<String, dynamic>),
    );
  }

  Future<void> updateName(String newName) async {
    await _firestore
        .collection("users")
        .doc(state.id)
        .update({'name': newName});
    state = state.copyWith(user: state.user.copyWith(name: newName));
  }

  Future<void> updateImage(File newPic) async {
    Reference ref = _storage.ref().child("users").child(state.id);
    TaskSnapshot snapshot = await ref.putFile(newPic);
    String profilePicURL = await snapshot.ref.getDownloadURL();

    await _firestore
        .collection("users")
        .doc(state.id)
        .update({'profilePic': profilePicURL});
    state =
        state.copyWith(user: state.user.copyWith(profilePic: profilePicURL));
  }

  Future<void> updatePrivacy(bool private) async {
    await _firestore
        .collection("users")
        .doc(state.id)
        .update({'userPrivacy': private});
    state = state.copyWith(user: state.user.copyWith(userPrivacy: private));
  }

  // state = oldLocalUser.copywithi(); // state = state + 1 => state 必須被完全更新
  /// 清除 UserState
  void logout() {
    state = const LocalUser(
      id: "error",
      user: FirebaseUser(
        email: "error",
        name: "error",
        profilePic: "error",
        userPrivacy: false,
      ),
      // user: FirebaseUser(email: "error", name: "error", profilePic: "error"),
    );
  }
}
