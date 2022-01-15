import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:takas_app/Utils/addAvatar.dart';
import 'package:takas_app/auth.dart';
import 'package:takas_app/models/message.dart';
import 'package:takas_app/models/user.dart';
import 'package:takas_app/screens/chat.dart';
import 'package:takas_app/screens/home.dart';

// command to run flutter web:   flutter run -d chrome --web-renderer html
// command to build flutter web for release: flutter build web --web-renderer html --release

class MyItems extends StatefulWidget {
  const MyItems({Key? key}) : super(key: key);
  @override
  _MyItemsState createState() => _MyItemsState();
}

class _MyItemsState extends  State<MyItems> with WidgetsBindingObserver {

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
            'My Items',
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
                title: const Text('Chat Menu'),
                onTap: () {
                  // Update the state of the app.
                  // ...
                  Navigator.of(context).pushNamedAndRemoveUntil('/HomeScreen', (route) => false);
                },
              ),
              ListTile(
                title: const Text("Log Out"),
                onTap: () {
                  Auth().signOut();
                  // TODO: pushNamedAndRemoveUntil
                  Navigator.pushReplacementNamed(context, '/');
                  //Navigator.pop(context);
                },
              ),
            ],
          ),
        ),
        body: Container(),
      ),
    );
  }
}
