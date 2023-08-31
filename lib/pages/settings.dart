import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:twitter_clone/providers/user_provider.dart';

class Settings extends ConsumerStatefulWidget {
  const Settings({super.key});

  @override
  ConsumerState<Settings> createState() => _SettingsState();
}

class _SettingsState extends ConsumerState<Settings> {
  TextEditingController _nameController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    LocalUser currentUser = ref.watch(userProvider);
    _nameController.text = currentUser.user.name;
    bool isPrivate = currentUser.user.userPrivacy;
    return Scaffold(
      appBar: AppBar(
        title: const Text('設定'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              GestureDetector(
                // 使可點擊
                onTap: () async {
                  final ImagePicker _picker = ImagePicker();
                  final XFile? pickedImage = await _picker.pickImage(
                    source: ImageSource.gallery,
                    requestFullMetadata: false,
                  );
                  if (pickedImage != null) {
                    ref
                        .read(userProvider.notifier)
                        .updateImage(File(pickedImage.path));
                  }
                },
                child: CircleAvatar(
                  radius: 100,
                  foregroundImage: NetworkImage(currentUser.user.profilePic),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              const Center(
                child: Text("點擊更新圖片"),
              ),
              TextFormField(
                decoration: InputDecoration(labelText: "請輸入姓名"),
                controller: _nameController,
              ),
              TextButton(
                onPressed: () {
                  ref
                      .read(userProvider.notifier)
                      .updateName(_nameController.text);
                },
                child: const Text("更新"),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('隱私權設定 : '),
                  Text(isPrivate ? '公開貼文' : '隱藏貼文'),
                  Switch(
                    value: isPrivate,
                    onChanged: (value) {
                      ref.read(userProvider.notifier).updatePrivacy(value);
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
