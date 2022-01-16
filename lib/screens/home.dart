import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:takas_app/Utils/addAvatar.dart';
import 'package:takas_app/auth.dart';
import 'package:takas_app/models/message.dart';
import 'package:takas_app/models/user.dart';
import 'package:takas_app/screens/chat.dart';

// command to run flutter web:   flutter run -d chrome --web-renderer html
// command to build flutter web for release: flutter build web --web-renderer html --release



class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends  State<HomeScreen> with WidgetsBindingObserver {

  List<Message> users = [];

  @override
  Future<void> didChangeAppLifecycleState(AppLifecycleState state) async {
    super.didChangeAppLifecycleState(state);

    switch (state) {
      case AppLifecycleState.paused:
        print("paused");
        break;
      case AppLifecycleState.resumed:
        print("resumed");
        break;
      case AppLifecycleState.inactive:
        print("inactive");
        break;
      case AppLifecycleState.detached:
        print("detached");
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // Do something here
        Auth().signOut();
        Navigator.pop(context);
        return false;
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          elevation: 8,
          title: const Text(
            'Inbox',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
          actions: <Widget>[
            IconButton(
              icon: const Icon(Icons.search),
              color: Colors.white,
              onPressed: () {},
            ),
          ], systemOverlayStyle: SystemUiOverlayStyle.light,
        ),
        drawer: Drawer(
          // Add a ListView to the drawer. This ensures the user can scroll
          // through the options in the drawer if there isn't enough vertical
          // space to fit everything.
          child: ListView(
            // Important: Remove any padding from the ListView.
            padding: EdgeInsets.zero,
            children: [
              const DrawerHeader(
                decoration: BoxDecoration(
                  color: Colors.blue,
                ),
                child: Text("Takas App"),
              ),
              ListTile(
                title: const Text('My Items'),
                onTap: () {
                  Navigator.of(context).pushNamedAndRemoveUntil('/MyItems', (route) => false);
                },
              ),
              ListTile(
                title: const Text('All Items'),
                onTap: () {
                  Navigator.of(context).pushNamedAndRemoveUntil('/AllItems', (route) => false);
                },
              ),
              ListTile(
                title: const Text("Log Out"),
                onTap: () {
                  Auth().signOut();
                  Navigator.pushReplacementNamed(context, '/');
                  //Navigator.pop(context);
                },
              ),
            ],
          ),
        ),
        body: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance.collection('users').where(
            "id", isNotEqualTo: Auth().currentUserId()
          ).snapshots(),
          builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {

            if (snapshot.hasError) {
              return Text('Something went wrong');
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return Text("Loading");
            }

            return ListView(
              children: snapshot.data!.docs.map((DocumentSnapshot document) {
                Map<String, dynamic> data = document.data()! as Map<String, dynamic>;

                UserData userData = UserData(
                    id: data["id"],
                    name: data["name"],
                    email: data["email"],
                    imageUrl: data["imageUrl"],
                    isOnline: data["isOnline"]);

                    print(data["isOnline"].runtimeType);

                    print(data["id"]);

                   var imagePath = data["email"] + "/profile/" + data["imageUrl"];

                   print("imagePath $imagePath");

                return GestureDetector(
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ChatScreen(userData: userData,),
                    ),
                  ),
                  child: ListTile(
                    title: Row(
                      children: [

                        addAvatar(imagePath: imagePath),

                        const SizedBox(width: 50),
                        Text(data['name']),
                        const SizedBox(width: 50),
                        Text(data['isOnline'] == true ? "Online" : "Offline"),
                        const SizedBox(width: 50),
                        Text(data['email'])
                      ],
                    ),
                    //subtitle: Text(data['email']),
                  ),
                );
              }).toList(),
            );
          },
        ),
      ),
    );
  }
}
