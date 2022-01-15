import 'dart:io' as i;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:takas_app/auth.dart';
import '../Utils/common.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class SignupPage extends StatefulWidget {
  const SignupPage({Key? key}) : super(key: key);

  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {

  final name = TextEditingController();
  final email = TextEditingController();
  final password = TextEditingController();
  final confirmPassword = TextEditingController();

  var webImage;
  var imageName;

  _imgFromGallery() async {

    var image = await ImagePicker().pickImage(
        source: ImageSource.gallery);

    imageName = image?.name;
    var f = await image?.readAsBytes();

    setState(() {
     /* if (kIsWeb) {
        webImage = f;
      } else {
        _image = i.File((image?.path)!);
      }*/

      webImage = f;
    });
  }

  getAvatar() {
    return GestureDetector(
      onTap: () {
        _imgFromGallery();
      },
      child: CircleAvatar(
        radius: 55,
        backgroundColor: const Color(0xffFDCF09),
        child:
            (webImage != null)
            ? ClipRRect(
          borderRadius: BorderRadius.circular(50),
          child:
          Image.memory(
                webImage,
                fit: BoxFit.fitHeight,
              )
        )
            : Container(
          decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(50)),
          width: 100,
          height: 100,
          child: Icon(
            Icons.camera_alt,
            color: Colors.grey[800],
          ),
        ),
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back_ios, size: 20, color: Colors.black,),
        ), systemOverlayStyle: SystemUiOverlayStyle.dark,
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 40),
          height: MediaQuery
              .of(context)
              .size
              .height - 50,
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Column(
                children: <Widget>[
                  const Text("Sign up", style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold
                  ),),
                  const SizedBox(height: 20,),
                  Text("Create an account, It's free", style: TextStyle(
                      fontSize: 15,
                      color: Colors.grey[700]
                  ),),
                ],
              ),
              Column(
                children: <Widget>[
                  getAvatar(),
                  makeInput(label: "Name", userController: name),
                  makeInput(label: "Email", userController: email),
                  makeInput(label: "Password",
                      userController: password,
                      obscureText: true),
                  makeInput(label: "Confirm Password",
                      userController: confirmPassword,
                      obscureText: true),
                ],
              ),
              Container(
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

                    Auth().uploadData(webImage, imageName);
                    // Auth()
                    //     .signUp(name.text, email.text, confirmPassword.text)
                    //     .then((user) {
                    //
                    //   authStatus(context, user);
                    //
                    // });
                  },
                  color: Colors.greenAccent,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50)
                  ),
                  child: const Text("Sign up", style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 18
                  ),),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const <Widget>[
                  Text("Already have an account?"),
                  Text(" Login", style: TextStyle(
                      fontWeight: FontWeight.w600, fontSize: 18
                  ),),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}