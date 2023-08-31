import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/user_provider.dart';

class SignUp extends ConsumerStatefulWidget {
  const SignUp({super.key});

  @override
  ConsumerState<SignUp> createState() => _SignUp();
}

class _SignUp extends ConsumerState<SignUp> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  // final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final GlobalKey<FormState> _signInKey = GlobalKey();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final RegExp emailValid = RegExp(
      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_1{|}-]+@[a-zA-Z0-9]+\.[a-zA-Z]+");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        //可以檢查輸入內容是否valid
        key: _signInKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const SizedBox(height: 100),
              Image.network(
                  'https://firebasestorage.googleapis.com/v0/b/wus-bike-blog.appspot.com/o/Bike.GIF?alt=media&token=50ddf486-780d-4308-bcb1-0bd20d6cea80'),
              const SizedBox(
                height: 10,
              ),
              const Text(
                //登錄頁標題
                '歡迎加入，請填寫電子郵箱和密碼',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Container(
                margin: const EdgeInsets.fromLTRB(15, 15, 15, 0),
                padding: const EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: TextFormField(
                  //email 需要使用validator
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    hintText: 'example@gmail.com',
                    border: InputBorder.none, //拿掉輸入框底線
                    contentPadding: EdgeInsets.symmetric(
                      vertical: 15,
                      horizontal: 20,
                    ),
                  ),
                  // Regexr.com 密碼符合regular expression
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "請輸入電子信箱";
                    } else if (!emailValid.hasMatch(value)) {
                      return "請輸入完整電子信箱 ex. example@gmail.com";
                    }
                    return null;
                  },
                ),
              ),
              Container(
                margin: const EdgeInsets.all(15),
                padding: const EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: TextFormField(
                  //password 需要使用validator
                  controller: _passwordController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    hintText: "請填入六位以上密碼",
                    border: InputBorder.none, //拿掉輸入框底線
                    contentPadding: EdgeInsets.symmetric(
                      vertical: 15,
                      horizontal: 20,
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      //沒輸入直接送出爲null，輸入後刪除則爲Empty
                      return "請輸入六位以上密碼";
                    } else if (value.length < 6) {
                      return "密碼需六位以上";
                    }
                    return null; //沒有問題
                  },
                ),
              ),
              Container(
                width: 250,
                height: 50,
                decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: TextButton(
                  onPressed: () async {
                    if (_signInKey.currentState!.validate()) {
                      try {
                        await _auth.createUserWithEmailAndPassword(
                          email: _emailController.text,
                          password: _passwordController.text,
                        );

                        // await _firestore.collection("users").add(
                        //       FirebaseUser(email: _emailController.text).toMap(),
                        //     );

                        await ref
                            .read(userProvider.notifier)
                            .signUp(_emailController.text);

                        if (!mounted) return;

                        Navigator.pop(context);
                      } on Exception catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(e.toString())));
                      }
                    }
                  },
                  child: const Text(
                    '新建帳號',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w100,
                    ),
                  ),
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text("取消"),
              )
            ],
          ),
        ),
      ),
    );
  }
}
