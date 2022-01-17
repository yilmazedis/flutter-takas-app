import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:takas_app/auth.dart';
import 'package:takas_app/itemScreen.dart';

import '../Utils/common.dart';

class LoginPage extends StatelessWidget {
  LoginPage({Key? key}) : super(key: key);

  final email = TextEditingController();
  final password = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back_ios, size: 20, color: Colors.black,),
        ), systemOverlayStyle: SystemUiOverlayStyle.dark,
      ),
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      const Text("Giriş Yap", style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold
                      ),),
                      const SizedBox(height: 20,),
                       Text("Hesabınıza Giriş Yapın", style: TextStyle(
                        fontSize: 15,
                        color: Colors.grey[700]
                      ),),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40),
                    child: Column(
                      children: <Widget>[
                         makeInput(label: "Email", userController: email),
                        makeInput(label: "Şifre", userController: password, obscureText: true),
                      ],
                    ),
                  ),
                   Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40),
                    child: Container(
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
                        onPressed: () {
                          Auth().signIn(email.text,  password.text).then((user) {
                            authStatus(context, user);
                          });
                        },
                        color: Colors.greenAccent,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50)
                        ),
                        child: const Text("Giriş Yap", style: TextStyle(
                          fontWeight: FontWeight.w600, 
                          fontSize: 18
                        ),),
                      ),
                    ),
                  ),
                   Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const <Widget>[
                      Text("Hesabınız Yoksa mu?"),
                      Text(" Kaydol", style: TextStyle(
                        fontWeight: FontWeight.w600, fontSize: 18
                      ),),
                    ],
                  )
                ],
              ),
            ),
             Container(
              height: MediaQuery.of(context).size.height / 3,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/background.png'),
                  fit: BoxFit.cover
                )
              ),
            )
          ],
        ),
      ),
    );
  }
}