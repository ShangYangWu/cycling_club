import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/user_provider.dart';
import 'SignUp.dart';

class SignIn extends ConsumerStatefulWidget {
  const SignIn({Key? key}) : super(key: key);

  @override
  ConsumerState<SignIn> createState() => _SignInState();
}

class _SignInState extends ConsumerState<SignIn> {
  FirebaseAuth _auth = FirebaseAuth.instance;
  final GlobalKey<FormState> _signInKey = GlobalKey();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  final RegExp emailValid = RegExp(
      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_1{|}-]+@[a-zA-Z0-9]+\.[a-zA-Z]+");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: const Text('歡迎，請先登入'),
      // ),
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
              Container(
                child: const Text(
                  //登入頁標題
                  '歡迎，請先登入',
                  style: TextStyle(
                    color: Colors.blue,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.fromLTRB(15, 30, 15, 0),
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
                    hintText: "password",
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
                        await _auth.signInWithEmailAndPassword(
                            email: _emailController.text,
                            password: _passwordController.text);
                        ref
                            .read(userProvider.notifier)
                            .login(_emailController.text);
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(e.toString())));
                      }
                    }
                  },
                  child: const Text(
                    '登入',
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
                  Navigator.of(context)
                      .push(MaterialPageRoute(builder: (context) => SignUp()));
                },
                child: const Text("新建帳號"),
              )
            ],
          ),
        ),
      ),
    );
  }
}
