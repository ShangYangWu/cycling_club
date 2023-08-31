import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:twitter_clone/providers/post_provider.dart';

class CreateTweet extends ConsumerWidget {
  const CreateTweet({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    TextEditingController _tweetController = TextEditingController();
    // String? location = "台北";

    return Scaffold(
      appBar: AppBar(
        title: const Text("貼文"),
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min, //將輸入框置中
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                // 可使用TextField因爲只有一個輸入介面，不用使用TextFormField
                maxLines: 4, // 讓輸入框爲四行
                decoration: const InputDecoration(border: OutlineInputBorder()),
                controller: _tweetController,
                maxLength: 280, // 爲tweeter的設定字數上限
              ),
            ),
            // DropdownButton<String>(
            //   value: location,
            //   onChanged: (String? newValue) {
            //     location = newValue;
            //   },
            //   items: <String>['台北', '台中', '高雄']
            //       .map<DropdownMenuItem<String>>((String value) {
            //     return DropdownMenuItem<String>(
            //       value: location,
            //       child: Text(location!),
            //     );
            //   }).toList(),
            // ),
            TextButton(
              onPressed: () {
                ref.read(TweetProvider).postTweet(_tweetController.text);
                Navigator.pop(context);
              },
              child: const Text("發佈貼文"),
            ),
          ],
        ),
      ),
    );
  }
}
