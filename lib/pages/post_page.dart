import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:twitter_clone/providers/post_provider.dart';

import '../components/drawer.dart';
import '../models/post.dart';
import '../providers/user_provider.dart';
import 'create_post.dart';

class PostPage extends ConsumerWidget {
  const PostPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    LocalUser currentUser = ref.watch(userProvider); // 常用項設爲變數
    return Scaffold(
      appBar: AppBar(
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(4.0),
          child: Container(
            color: Colors.grey,
            height: 1,
          ),
        ),
        title: Container(
          height: 70,
          child: Image.network(
              'https://firebasestorage.googleapis.com/v0/b/wus-bike-blog.appspot.com/o/Bike.GIF?alt=media&token=50ddf486-780d-4308-bcb1-0bd20d6cea80'),
        ),
        leading: Builder(builder: (context) {
          // 建立 context 讓 onTap()取用
          return GestureDetector(
            onTap: () => Scaffold.of(context).openDrawer(),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: CircleAvatar(
                backgroundImage: NetworkImage(currentUser.user.profilePic),
              ),
            ),
          );
        }),
      ),
      body: ref.watch(feedProvider).when(
            data: (List<Post> tweets) {
              return ListView.separated(
                separatorBuilder: (context, index) => const Divider(
                  color: Colors.black,
                ),
                itemCount: tweets.length,
                itemBuilder: (BuildContext context, int count) {
                  return ListTile(
                      leading: CircleAvatar(
                        foregroundImage: NetworkImage(
                          tweets[count].profilePic,
                        ),
                      ),
                      title: Text(
                        tweets[count].name,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Text(
                        tweets[count].tweet,
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                        ),
                      ));
                },
              );
            },
            error: (error, StackTrace) => const Center(
              child: Text("error"),
            ),
            loading: () {
              return const CircularProgressIndicator();
            },
          ),
      drawer: const PageDrawer(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => CreateTweet()));
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
