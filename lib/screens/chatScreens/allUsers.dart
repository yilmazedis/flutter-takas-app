

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:takas_app/Utils/common.dart';
import 'package:takas_app/models/user.dart';
import 'package:takas_app/screens/chatScreens/chat.dart';
import '../../auth.dart';

allUsers() {

  return StreamBuilder<QuerySnapshot>(
    stream: FirebaseFirestore.instance.collection('users').where(
        "id", isNotEqualTo: Auth().currentUserId()
    ).snapshots(),
    builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {

      if (snapshot.hasError) {
        return Text('Something went wrong');
      }

      if (snapshot.connectionState == ConnectionState.waiting) {
        return Text("yükleniyor");
      }

      return ListView(
        children: snapshot.data!.docs.map((DocumentSnapshot document) {
          Map<String, dynamic> data = document.data()! as Map<String, dynamic>;

          UserData userData = UserData(
              id: data["id"],
              name: data["name"],
              email: data["email"],
              imageUrl: data["imageUrl"],
              isOnline: data["isOnline"]);

          var imagePath = data["imageUrl"];

          return GestureDetector(
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => ChatScreen(id: userData.id,
                  name: userData.name,
                  isOnline: userData.isOnline,
                  imageUrl: userData.imageUrl),
              ),
            ),
            child: ListTile(
              title: Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Row(
                  children: [
                    buildProfileImage(userData.imageUrl, 50),
                    Expanded(
                      child: Card(
                        semanticContainer: true,
                        clipBehavior: Clip.antiAlias,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        elevation: 5,
                        margin: const EdgeInsets.all(7),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(data['name']),
                            const SizedBox(width: 50),
                            Text(data['isOnline'] == true ? "Online" : "Offline"),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
              //subtitle: Text(data['email']),

            ),
          );
        }).toList(),
      );
    },
  );
}

//
//
// return GestureDetector(
// onTap: () => Navigator.push(
// context,
// MaterialPageRoute(
// builder: (_) => ChatScreen(userData: userData,),
// ),
// ),
// child:
// Padding(
// padding: const EdgeInsets.all(8.0),
// child: Row(
// children: <Widget>[
// const Icon(
// Icons.account_circle,
// size: 64.0,
// ),
// Expanded(
// child: Padding(
// padding: const EdgeInsets.all(8.0),
// child: Column(
// crossAxisAlignment: CrossAxisAlignment.start,
// children: <Widget>[
// Row(
// mainAxisAlignment:
// MainAxisAlignment.spaceBetween,
// children: <Widget>[
// Text(
// data['name'],
// overflow: TextOverflow.ellipsis,
// style: const TextStyle(
// fontWeight: FontWeight.w500,
// fontSize: 18.0),
// ),
// Text(
// d24,
// overflow: TextOverflow.ellipsis,
// style: const TextStyle(color: Colors.black45, fontSize: 10),
// ),
// ],
// ),
// Padding(
// padding: const EdgeInsets.only(top: 2.0),
// child: Text(
// data['currentMessage']["text"],
// overflow: TextOverflow.ellipsis,
// style: const TextStyle(
// color: Colors.black45, fontSize: 16.0),
// ),
// )
// ],
// ),
// ),
// )
// ],
// ),
// ),
//
// );