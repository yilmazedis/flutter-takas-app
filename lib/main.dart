import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:takas_app/screens/mainPage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (kIsWeb) {
    await Firebase.initializeApp(
        options: const FirebaseOptions(apiKey: "AIzaSyDrjI51sfTGbDT7mld9PR_Zbsu39jt7kxc",
            appId: "1:192869734379:web:296b926eb5b8eea9dbabae",
            messagingSenderId: "192869734379", projectId: "takas-e8b2b")
    );
  } else {
    await Firebase.initializeApp();
  }
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => const MainPage(),
        // When navigating to the "/" route, build the FirstScreen widget.
        // When navigating to the "/second" route, build the SecondScreen widget.
        // '/HomeScreen': (context) => const HomeScreen(),
        // '/MyItems': (context) => const MyItems(),
        // '/AllItems': (context) => const AllItems(),
      },
    )
  );
}
