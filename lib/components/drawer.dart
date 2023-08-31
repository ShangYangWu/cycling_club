import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../pages/home_page.dart';
import '../pages/settings.dart';
import '../providers/user_provider.dart';

class PageDrawer extends ConsumerWidget {
  const PageDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    LocalUser currentUser = ref.watch(userProvider); // 常用項設爲變數
    return Drawer(
      child: Column(
        children: [
          Container(
            height: 430,
            child: Image.network(
              currentUser.user.profilePic,
              fit: BoxFit.fitHeight,
            ),
          ),
          ListTile(
            title: Text(
              "${currentUser.user.name}，您好",
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
          ),
          ListTile(
            title: const Text("個人首頁"),
            onTap: () {
              Navigator.pop(context);
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (context) => HomePage()));
            },
          ),
          ListTile(
            title: const Text("設定"),
            onTap: () {
              Navigator.pop(context);
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (context) => Settings()));
            },
          ),
          ListTile(
            title: const Text('登出'),
            onTap: () {
              FirebaseAuth.instance.signOut();
              ref.read(userProvider.notifier).logout();
            },
          ),
        ],
      ),
    );
  }
}
