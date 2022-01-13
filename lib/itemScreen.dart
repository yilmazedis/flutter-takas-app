
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'auth.dart';

class ItemScreen extends StatefulWidget {

  const ItemScreen({Key? key, required this.user}) : super(key: key);

  final User user;

  @override
  _ListPageState createState() => _ListPageState();
}

class _ListPageState extends State<ItemScreen> {

  var authHandler = Auth();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(58, 66, 86, 1.0),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          onPressed: () {
            authHandler.signOut();
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back_ios, size: 20, color: Colors.black,),
        ), systemOverlayStyle: SystemUiOverlayStyle.dark,
      ),
      body: Text(widget.user.uid,),

    );
  }

}