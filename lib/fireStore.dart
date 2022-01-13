import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FireStore {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore store = FirebaseFirestore.instance;

  static final FireStore _singleton = FireStore._internal();

  factory FireStore() {
    return _singleton;
  }

  FireStore._internal();

  CollectionReference users = FirebaseFirestore.instance.collection('users');


  Future<User?> signIn(String email, String password) async {

    UserCredential result;

    try {
      result =
      await auth.signInWithEmailAndPassword(email: email, password: password);
      print('sign in is successful');

      return result.user;

    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
      }

    }
    return null;
  }

}