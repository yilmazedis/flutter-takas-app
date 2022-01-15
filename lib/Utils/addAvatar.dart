import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../auth.dart';

class addAvatar extends StatefulWidget {
  const addAvatar({Key? key, this.imagePath}) : super(key: key);

  final imagePath;

  @override
  _addAvatarState createState() => _addAvatarState();
}

class _addAvatarState extends State<addAvatar> {

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
      future: Auth().downloadUrl(widget.imagePath), // function where you call your api
      builder: (BuildContext context, AsyncSnapshot<String> snapshot) {  // AsyncSnapshot<Your object type>
        if( snapshot.connectionState == ConnectionState.waiting){
          return  const Center(child: Text('Please wait its loading...'));
        }else{
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {

            print(snapshot.data!);

            return CircleAvatar(
              radius: 25,
              backgroundColor: const Color(0xffFDCF09),
              child: snapshot.data != null
                  ? ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child:
                  Image.network(
                    snapshot.data!,
                    fit: BoxFit.fill,
                  )
              )
                  : Container(
                decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(20)),
                child: Icon(
                  Icons.account_circle,
                  color: Colors.grey[800],
                ),
              ),
            );
            //return Center(child: Text('${snapshot.data}'));
          }  // snapshot.data  :- get your object which is pass from your downloadData() function
        }
      },
    );
  }
}