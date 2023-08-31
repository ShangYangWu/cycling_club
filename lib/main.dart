import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'firebase_options.dart';

import 'pages/signin.dart';
import 'pages/post_page.dart';
import './providers/user_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: StreamBuilder<User?>(
          // Stream 會回傳 User type
          stream: FirebaseAuth.instance
              .authStateChanges(), // 等串流，這裡是firebase回傳的_auth state)
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              // snapshot裡面是否有User
              ref.read(userProvider.notifier).login(snapshot.data!.email!);
              return PostPage();
            }
            return SignIn();
          }),
      theme: ThemeData(
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          titleTextStyle: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
          centerTitle: true,
        ),
      ),
    );
  }
}
