import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:takas_app/Utils/AddItemDialog.dart';
import 'package:takas_app/screens/chatScreens/activeChat.dart';
import 'package:takas_app/screens/itemScreens/subScreens/AllItems.dart';
import 'package:takas_app/screens/itemScreens/subScreens/MyItems.dart';
import 'package:takas_app/screens/chatScreens/allUsers.dart';
import 'package:takas_app/auth.dart';

// command to run flutter web:   flutter run -d chrome --web-renderer html
// command to build flutter web for release: flutter build web --web-renderer html --release

//StreamController<Map<String, dynamic>> phobiasStream = StreamController<Map<String, dynamic>>();

class DrawerScreen extends StatefulWidget {
  const DrawerScreen({Key? key}) : super(key: key);

  @override
  _DrawerScreenState createState() => _DrawerScreenState();
}

class _DrawerScreenState extends State<DrawerScreen>
    with WidgetsBindingObserver {



  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addObserver(this);

    //
    //
    // Auth().fetchUser().then((value) {
    //   // for (var user in Auth().users) {
    //   //   Auth().fetchLastMessage(user.id);
    //   //   print("sdsd");
    //   // }
    // });

    Auth().fetchMe();

    screen = allUsersStream;
  }

  @override
  void dispose() {
    WidgetsBinding.instance!.removeObserver(this);
    super.dispose();
  }

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
        Auth().signOut();
        break;
    }
  }

  Widget myItemsStream = myItems();
  Widget allItemsStream = allItems();
  Widget allUsersStream = allUsers();
  Widget activeChatStream = activeChat();

  int selectedScreen = 0;
  String menuName = "Konuşmalar";
  late Widget screen;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {


        showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title:
                const Text('Çıkış Yapmak istiyor musunuz!'),
                content: SingleChildScrollView(
                  child: Column(
                    children: [
                      const ListTile(
                        leading: Icon(
                            Icons.clear),
                        title: Text("Çıkış yap"),
                      ),

                      MaterialButton(
                        minWidth: double.infinity,
                        height: 60,
                        onPressed: () {
                          // Do something here
                          Auth().signOut();
                          Navigator.of(context).pushNamedAndRemoveUntil('/', (route) => false);
                        },
                        color: Colors.red,
                        shape: RoundedRectangleBorder(
                            side: const BorderSide(
                                color: Colors.black
                            ),
                            borderRadius: BorderRadius.circular(50)
                        ),
                        child: const Text("Tamam", style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 18
                        ),),
                      ),
                      const SizedBox(height: 20,),

                      MaterialButton(
                        minWidth: double.infinity,
                        height: 60,
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        shape: RoundedRectangleBorder(
                            side: const BorderSide(
                                color: Colors.black
                            ),
                            borderRadius: BorderRadius.circular(50)
                        ),
                        child: const Text("İptal", style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 18
                        ),),
                      ),

                    ],
                  ),
                ),
              );
            });
        return false;
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          elevation: 8,
          title: Text(
            menuName,
            style: const TextStyle(
              color: Colors.white,
            ),
          ),
          actions: <Widget>[
              selectedScreen == 2 ? IconButton(
              icon: const Icon(Icons.add),
              color: Colors.white,
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (_) {
                      return AddItemDialog();
                    });
              },
            ):
            IconButton(
              icon: const Icon(Icons.search),
              color: Colors.white,
              onPressed: () {
                setState(() {

                });
              },
            )
          ],
          systemOverlayStyle: SystemUiOverlayStyle.light,
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
                child: Text("Kitap Dönüşüm"),
              ),
              ListTile(
                title: const Text("Kullanıcılar"),
                onTap: () {
                  if (selectedScreen != 0) {
                    setState(() {
                      menuName = "Kullanıcılar";
                      selectedScreen = 0;
                      screen = allUsersStream;
                    });
                  }
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: const Text("Konuşmalar"),
                onTap: () {
                  if (selectedScreen != 1) {
                    setState(() {
                      menuName = "Konuşmalar";
                      selectedScreen = 1;
                      screen = activeChatStream;
                    });
                  }
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: const Text("Kitaplarım"),
                onTap: () {
                  if (selectedScreen != 2) {
                    setState(() {
                      menuName = "Kitaplarım";
                      selectedScreen = 2;
                      screen = myItemsStream;
                    });
                  }
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: const Text("Tüm Kitaplar"),
                onTap: () {
                  if (selectedScreen != 3) {
                    setState(() {
                      menuName = "Tüm Kitaplar";
                      selectedScreen = 3;
                      screen = allItemsStream;
                    });
                  }
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: const Text("Çıkış Yap"),
                onTap: () {
                  Auth().signOut();
                  Navigator.of(context)
                      .pushNamedAndRemoveUntil('/', (route) => false);
                },
              ),
            ],
          ),
        ),
        body: screen,
      ),
    );
  }
}
