import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:twitter_clone/pages/post_page.dart';
import 'package:twitter_clone/providers/post_provider.dart';

import '../components/drawer.dart';
import '../models/post.dart';
import '../providers/user_provider.dart';

class HomePage extends ConsumerWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    LocalUser currentUser = ref.watch(userProvider); // 常用項設爲變數
    TextEditingController _tweetController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(4.0),
          child: Container(
            color: Colors.grey,
            height: 1,
          ),
        ),
        title: Column(
          children: [
            Container(
              height: 40,
              child: Image.network(
                  'https://firebasestorage.googleapis.com/v0/b/wus-bike-blog.appspot.com/o/Bike.GIF?alt=media&token=50ddf486-780d-4308-bcb1-0bd20d6cea80'),
            ),
            Text(
              '個人首頁',
              style: const TextStyle(fontWeight: FontWeight.w100, fontSize: 12),
            ),
          ],
        ),
        actions: [
          Row(
            children: [
              IconButton(
                color: Colors.grey,
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => PostPage()));
                },
                icon: Icon(Icons.search),
              ),
            ],
          ),
        ],
        leading: Builder(
          builder: (context) {
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
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    height: 100,
                    width: 100,
                    child: Image.network(
                      currentUser.user.profilePic,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Container(
                    height: 100,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end, // 垂直方向對齊方式設置
                      crossAxisAlignment:
                          CrossAxisAlignment.start, // 水平方向對齊方式設置
                      children: [
                        Text(
                          "${currentUser.user.name}",
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 36,
                          ),
                        ),
                        Text(
                          "${currentUser.user.email}",
                          style: const TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 18,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Center(
              child: Column(
                mainAxisSize: MainAxisSize.min, //將輸入框置中
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                      // 可使用TextField因爲只有一個輸入介面，不用使用TextFormField
                      maxLines: 4, // 讓輸入框爲四行
                      decoration:
                          const InputDecoration(border: OutlineInputBorder()),
                      controller: _tweetController,
                      maxLength: 280, // 爲tweeter的設定字數上限
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      ref.read(TweetProvider).postTweet(_tweetController.text);
                    },
                    child: const Text("發佈貼文"),
                  ),
                ],
              ),
            ),
            Column(
              children: ref.watch(feedProvider).when(
                    data: (List<Post> tweets) {
                      return tweets
                          .where((tweet) => tweet.uid == currentUser.id)
                          .map((tweet) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CircleAvatar(
                                foregroundImage: NetworkImage(tweet.profilePic),
                              ),
                              SizedBox(width: 16),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    tweet.name,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    tweet.tweet,
                                    style: const TextStyle(
                                      color: Colors.black,
                                      fontSize: 16,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        );
                      }).toList();
                    },
                    error: (error, StackTrace) => [Text("error")],
                    loading: () {
                      return const [CircularProgressIndicator()];
                    },
                  ),
            ),
          ],
        ),
      ),
      drawer: const PageDrawer(),
    );
  }
}
