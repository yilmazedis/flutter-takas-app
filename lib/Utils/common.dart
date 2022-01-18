import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:takas_app/screens/DrawerScreen.dart';

Future<Widget?> authStatus(BuildContext context, User? user) async {
  Timer? timer = Timer(const Duration(milliseconds: 3000), (){
    Navigator.of(context, rootNavigator: true).pop();
  });

  if (user != null) {
    showDialog(
        context: context,
        builder: (context) {
          return const AlertDialog(
            title: Text('Başarılı Erişim'),
          );
        }).then((value){

      Navigator.push(context, MaterialPageRoute(builder: (context) => const DrawerScreen()));

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
            title: Text('Hatalı Erişim'),
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

Widget makeButton(String text, f) {
  return Container(
    padding: const EdgeInsets.only(top: 3, left: 3),
    decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(50),
        border: const Border(
          bottom: BorderSide(color: Colors.black),
          top: BorderSide(color: Colors.black),
          left: BorderSide(color: Colors.black),
          right: BorderSide(color: Colors.black),
        )
    ),
    child: MaterialButton(
      minWidth: double.infinity,
      height: 60,
      onPressed: f,
      color: Colors.greenAccent,
      elevation: 0,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50)
      ),
      child: Text(text, style: const TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 18
      ),),
    ),
  );
}

Widget makeInput({label, userController, obscureText = false, validate = false, message}) {
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
          errorText: validate ? message : null,
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
