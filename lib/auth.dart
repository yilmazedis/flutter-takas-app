import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'models/user.dart';

class Auth {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore store = FirebaseFirestore.instance;

  static final Auth _singleton = Auth._internal();

  factory Auth() {
    return _singleton;
  }

  Auth._internal();

  FirebaseFirestore db = FirebaseFirestore.instance;

  List<UserData> users = [];

  clearAll() {
    users.clear();
  }

  Future<void> addUser(Map<String, dynamic> userDataMap) {
    // Call the user's CollectionReference to add a new user
    return db
        .collection('users')
        .doc(currentUser())
        .set(userDataMap)
        .then((value) => print("User Added"))
        .catchError((error) => print("Failed to add user: $error"));
  }

  Future<void> updateUserStatus(bool isOnline) {
    // Call the user's CollectionReference to add a new user

    print('User Status is $isOnline');

    return db
        .collection('users')
        .doc(currentUser())
        .update({'isOnline': isOnline})
        .then((value) => print("Updated User Status"))
        .catchError((error) => print("Failed to add user: $error"));
  }

  Future<void> sendMessage(Map<String, dynamic> messageDataMap) {
    // Call the user's CollectionReference to add a new user
    return db
        .collection('messages')
        .add(messageDataMap)
        .then((value) => print("Message added"))
        .catchError((error) => print("Failed to add user: $error"));
  }

  Future<void> fetchUsers() {

    // Call the user's CollectionReference to add a new user
    return db
        .collection('users')
        .get()
        .then((QuerySnapshot querySnapshot) {
      for (var doc in querySnapshot.docs) {
        users.add(
            UserData(
                id: doc["id"],
                name: doc["name"],
                email: doc["email"],
                imageUrl: doc["imageUrl"],
                isOnline: doc["isOnline"])
        );
      }
    });
  }

  String currentUser() {
    var user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      return user.uid;
    }
    return "";
    // here you write the codes to input the data into firestore
  }

  Future<User?> signIn(String email, String password) async {

    UserCredential result;

    try {
      result =
      await auth.signInWithEmailAndPassword(email: email, password: password);
      print('sign in is successful');
      updateUserStatus(true);

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

  Future<User?> signUp(name, email, password) async {

    try {
      UserCredential result = await auth.createUserWithEmailAndPassword(
          email: email, password: password);

      addUser(
          {
            "id": result.user?.uid,
            "name": name,
            "email": email,
            "imageUrl": "",
            "isOnline": true,
          }
      );

      return result.user;
    } on FirebaseAuthException catch (e) {
      print("Could not sign up");
    }

    return null;
  }

  Future<bool> signOut() async {

    clearAll();

    try {
      updateUserStatus(false);
      await auth.signOut();
    } on FirebaseAuthException catch (e) {

      print(e.code + ' Could not signOut');
    }
    return true;
  }
}