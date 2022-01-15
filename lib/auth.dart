import 'dart:convert';
import 'dart:io' as i;
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'models/user.dart';
import 'package:firebase_storage/firebase_storage.dart';

class Auth {
  final FirebaseAuth auth = FirebaseAuth.instance;
  static final Auth _singleton = Auth._internal();

  factory Auth() {
    return _singleton;
  }

  Auth._internal();

  FirebaseFirestore db = FirebaseFirestore.instance;

  List<UserData> users = [];

  Future<Uint8List?> downloadData(String name) async {

    FirebaseStorage storage =
    FirebaseStorage.instanceFor(
        bucket: 'gs://takas-e8b2b.appspot.com/');

    final ref = storage.refFromURL('gs://takas-e8b2b.appspot.com/' + name);

    try {

      // Get raw data.
      var downloadedData = await ref.getData();
      // prints -> Hello World!
      print("downloaded data" + utf8.decode(downloadedData!));

      return downloadedData;

    } catch (e) {
      print("error while downloading  $e");
      return null;
    }
  }

  Future<void> uploadFile(String filePath) async {
    i.File file = i.File(filePath);

    try {
      FirebaseStorage storage = FirebaseStorage.instanceFor(
          bucket: 'gs://takas-e8b2b.appspot.com/');

      final ref = storage.refFromURL('gs://takas-e8b2b.appspot.com/');

      await ref.putFile(file);
    }  catch (e) {
      // e.g, e.code == 'canceled'
      print("error while uploading file");
    }
  }

  Future<void> uploadData(Uint8List data, String name) async {

    FirebaseStorage storage =
    FirebaseStorage.instanceFor(
        bucket: 'gs://takas-e8b2b.appspot.com/');

    final ref = storage.refFromURL('gs://takas-e8b2b.appspot.com/' + name);

    try {
      // Upload raw data.
      // await ref.putData(data);
      // // Get raw data.
      // Uint8List? downloadedData = await ref.getData();
      // // prints -> Hello World!
      // print(utf8.decode(downloadedData!));


      ref.putData(data, SettableMetadata(contentType: 'image/png'));
    } catch (e) {
      // e.g, e.code == 'canceled'
      print("error while uploading data");
    }
  }

  Future<void> uploadString() async {

    FirebaseStorage storage =
    FirebaseStorage.instanceFor(
        bucket: 'gs://takas-e8b2b.appspot.com/');

    final ref = storage.refFromURL('gs://takas-e8b2b.appspot.com/');

    final task = ref.child('web_3_text').putString("hello again!");

    try {
      // Storage tasks function as a Delegating Future so we can await them.
      TaskSnapshot snapshot = await task;
      print('Uploaded ${snapshot.bytesTransferred} bytes.');
    }  catch (e) {
      // The final snapshot is also available on the task via `.snapshot`,
      // this can include 2 additional states, `TaskState.error` & `TaskState.canceled`
      print(task.snapshot);

      if (e == 'permission-denied') {
        print('User does not have permission to upload to this reference.');
      }
      // ...
    }
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

      //uploadString();
      //print(downloadURL());

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

  clearAll() {
    users.clear();
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