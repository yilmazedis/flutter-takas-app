import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:takas_app/screens/home.dart';
import '../auth.dart';
import '../itemScreen.dart';


Future<Widget?> authStatus(BuildContext context, User? user) async {
  Timer? timer = Timer(const Duration(milliseconds: 3000), (){
    Navigator.of(context, rootNavigator: true).pop();
  });

  if (user != null) {
    showDialog(
        context: context,
        builder: (context) {
          return const AlertDialog(
            title: Text('Success'),
          );
        }).then((value){

      Navigator.push(context, MaterialPageRoute(builder: (context) => const HomeScreen()));

      // dispose the timer in case something else has triggered the dismiss.
      timer?.cancel();
      timer = null;
    });
    print('Logged in successfully.');
  } else {
    showDialog(
        context: context,
        builder: (context) {
          return const AlertDialog(
            title: Text('Fail'),
          );
        }).then((value){
      // dispose the timer in case something else has triggered the dismiss.
      timer?.cancel();
      timer = null;
    });
    print('Error while Login.');
  }
  return null;
}

Widget makeInput({label, userController, obscureText = false}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
      Text(label, style: const TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w400,
          color: Colors.black87
      ),),
      const SizedBox(height: 5,),
      TextField(
        controller: userController,
        obscureText: obscureText,
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 10),
          enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color:  Colors.grey.shade400)
          ),
          border: OutlineInputBorder(
              borderSide: BorderSide(color:  Colors.grey.shade400)
          ),
        ),
      ),
      const SizedBox(height: 30,),
    ],
  );
}