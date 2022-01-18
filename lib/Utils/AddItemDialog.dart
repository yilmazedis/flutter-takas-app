
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../auth.dart';
import 'common.dart';

class AddItemDialog extends StatefulWidget {
  @override
  _AddItemDialogState createState() => _AddItemDialogState();
}

class _AddItemDialogState extends State<AddItemDialog> {

  final itemName = TextEditingController();
  final itemFeature_1 = TextEditingController();
  final itemFeature_2 = TextEditingController();
  final itemFeature_3 = TextEditingController();

  var webImage;
  var imageName;
  var extension;

  _imgFromGallery() async {

    var image = await ImagePicker().pickImage(
        source: ImageSource.gallery);

    var f = await image?.readAsBytes();

    setState(() {
      webImage = f;
      imageName = image?.name;
      extension = imageName.split('.').last;
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
                webImage!,
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

  addFireBase() {

    var imagePath = Auth().currentUserEmail() + "/items/" + imageName;

    Auth().uploadData(webImage!, imagePath, extension).then((url) {
      Auth().addItem({
        "name": itemName.text,
        "time": DateTime.now(),
        "userId": Auth().currentUserId(),
        "imageUrl": url,
        "feature_1": itemFeature_1.text,
        "feature_2": itemFeature_2.text,
        "feature_3": itemFeature_3.text
      });
    });

    print("hello man!");
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add Item'),
      content: SingleChildScrollView(
        child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              getAvatar(),
              makeInput(label: "İsim", userController: itemName),
              makeInput(label: "Yazar", userController: itemFeature_1),
              makeInput(label: "Yayın", userController: itemFeature_2),
              makeInput(label: "Sayfa Sayısı", userController: itemFeature_3),
              makeButton("Kitap Ekle", addFireBase),
            ]
        ),
      ),
    );
  }
}