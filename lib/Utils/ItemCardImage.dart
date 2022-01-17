import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../auth.dart';

class ItemCardImage extends StatefulWidget {
  ItemCardImage({Key? key, required this.imageUrl}) : super(key: key);

  String imageUrl;

  @override
  _ItemCardImageState createState() => _ItemCardImageState();
}

class _ItemCardImageState extends State<ItemCardImage> {

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
      future: Auth().downloadUrl(widget.imageUrl), // function where you call your api
      builder: (BuildContext context, AsyncSnapshot<String> snapshot) {  // AsyncSnapshot<Your object type>
        if( snapshot.connectionState == ConnectionState.waiting){
          return  Icon(
            Icons.account_circle,
            color: Colors.grey[800],
          );
        }else{
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {

            print(snapshot.data!);

            return snapshot.data != null
                ? Image.network(
                  snapshot.data!,
                  fit: BoxFit.fill,
                )
                : Icon(
                  Icons.account_circle,
                  color: Colors.grey[800],
                );
          }  // snapshot.data  :- get your object which is pass from your downloadData() function
        }
      },
    );
  }
}