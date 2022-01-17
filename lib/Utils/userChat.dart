

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:takas_app/models/user.dart';
import 'package:takas_app/screens/chat.dart';

import '../auth.dart';
import 'addAvatar.dart';

userChat() {
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

          print(data["isOnline"].runtimeType);

          print(data["id"]);

          var imagePath = data["email"] + "/profile/" + data["imageUrl"];

          print("imagePath $imagePath");

          return GestureDetector(
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => ChatScreen(userData: userData,),
              ),
            ),
            child: ListTile(
              title: Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Row(
                  children: [
                    addAvatar(imagePath: imagePath),
                    Expanded(
                      child: Card(
                        semanticContainer: true,
                        clipBehavior: Clip.antiAlias,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        elevation: 5,
                        margin: EdgeInsets.all(7),
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